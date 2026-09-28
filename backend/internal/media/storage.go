package media

import (
	"bytes"
	"context"
	"crypto/sha256"
	"encoding/hex"
	"encoding/json"
	"errors"
	"fmt"
	"net/url"
	"os"
	"strings"
	"time"

	"RPG-manager/backend/internal/apperr"

	"github.com/aws/aws-sdk-go-v2/aws"
	"github.com/aws/aws-sdk-go-v2/config"
	"github.com/aws/aws-sdk-go-v2/credentials"
	"github.com/aws/aws-sdk-go-v2/service/s3"
	"github.com/aws/smithy-go"
)

type Storage struct {
	client            *s3.Client
	bucket, publicURL string
}

func New(ctx context.Context) (*Storage, error) {
	endpoint, public := os.Getenv("S3_ENDPOINT"), strings.TrimRight(os.Getenv("S3_PUBLIC_URL"), "/")
	bucket, access, secret := os.Getenv("S3_BUCKET"), os.Getenv("S3_ACCESS_KEY"), os.Getenv("S3_SECRET_KEY")
	for _, raw := range []string{endpoint, public} {
		u, err := url.Parse(raw)
		if err != nil || u.Host == "" || u.User != nil || u.RawQuery != "" || u.Fragment != "" || (u.Scheme != "https" && u.Scheme != "http") {
			return nil, errors.New("invalid S3 endpoint configuration")
		}
	}
	if bucket == "" || access == "" || secret == "" {
		return nil, errors.New("S3 bucket and credentials are required")
	}
	region := os.Getenv("S3_REGION")
	if region == "" {
		region = "us-east-1"
	}
	cfg, err := config.LoadDefaultConfig(ctx, config.WithRegion(region), config.WithCredentialsProvider(credentials.NewStaticCredentialsProvider(access, secret, "")), config.WithRetryMaxAttempts(3))
	if err != nil {
		return nil, fmt.Errorf("configure storage: %w", err)
	}
	client := s3.NewFromConfig(cfg, func(o *s3.Options) { o.BaseEndpoint = aws.String(endpoint); o.UsePathStyle = true })
	return &Storage{client: client, bucket: bucket, publicURL: public}, nil
}

// Provision grants anonymous GetObject only; bucket listing and writes require credentials.
func (s *Storage) Provision(ctx context.Context) error {
	_, err := s.client.HeadBucket(ctx, &s3.HeadBucketInput{Bucket: &s.bucket})
	if err != nil {
		var api smithy.APIError
		if !errors.As(err, &api) || (api.ErrorCode() != "NotFound" && api.ErrorCode() != "NoSuchBucket") {
			return fmt.Errorf("inspect bucket: %w", err)
		}
		if _, err = s.client.CreateBucket(ctx, &s3.CreateBucketInput{Bucket: &s.bucket}); err != nil {
			return fmt.Errorf("create bucket: %w", err)
		}
	}
	policy, err := json.Marshal(map[string]any{"Version": "2012-10-17", "Statement": []any{map[string]any{"Effect": "Allow", "Principal": map[string]string{"AWS": "*"}, "Action": []string{"s3:GetObject"}, "Resource": []string{"arn:aws:s3:::" + s.bucket + "/*"}}}})
	if err != nil {
		return fmt.Errorf("encode bucket policy: %w", err)
	}
	_, err = s.client.PutBucketPolicy(ctx, &s3.PutBucketPolicyInput{Bucket: &s.bucket, Policy: aws.String(string(policy))})
	if err != nil {
		return fmt.Errorf("configure bucket access: %w", err)
	}
	return nil
}

func (s *Storage) PutImage(ctx context.Context, prefix string, data []byte) (string, string, error) {
	format, err := ValidateImage(data)
	if err != nil {
		return "", "", err
	}
	sum := sha256.Sum256(data)
	hash := hex.EncodeToString(sum[:])
	key := prefix + "/" + hash + "." + format
	ctx, cancel := context.WithTimeout(ctx, 20*time.Second)
	defer cancel()
	_, err = s.client.PutObject(ctx, &s3.PutObjectInput{Bucket: &s.bucket, Key: &key, Body: bytes.NewReader(data), ContentType: aws.String("image/" + format), CacheControl: aws.String("public, max-age=31536000, immutable")})
	if err != nil {
		return "", "", fmt.Errorf("store image: %w", err)
	}
	return s.publicURL + "/" + key, hash, nil
}

// ValidateAssociation accepts only existing uploads owned by this user and purpose.
func (s *Storage) ValidateAssociation(ctx context.Context, raw, userID, purpose string) error {
	if raw == "" {
		return nil
	}
	prefix := s.publicURL + "/users/" + userID + "/" + purpose + "/"
	if !strings.HasPrefix(raw, prefix) {
		return apperr.ErrInvalid
	}
	leaf := strings.TrimPrefix(raw, prefix)
	parts := strings.Split(leaf, ".")
	if len(parts) != 2 || len(parts[0]) != 64 || (parts[1] != "png" && parts[1] != "jpeg" && parts[1] != "webp") {
		return apperr.ErrInvalid
	}
	if _, err := hex.DecodeString(parts[0]); err != nil {
		return apperr.ErrInvalid
	}
	key := strings.TrimPrefix(raw, s.publicURL+"/")
	ctx, cancel := context.WithTimeout(ctx, 5*time.Second)
	defer cancel()
	if _, err := s.client.HeadObject(ctx, &s3.HeadObjectInput{Bucket: &s.bucket, Key: &key}); err != nil {
		return fmt.Errorf("verify uploaded image: %w", err)
	}
	return nil
}
