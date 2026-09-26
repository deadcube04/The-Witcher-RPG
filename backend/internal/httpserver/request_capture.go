package httpserver

import (
	"bytes"
	"context"
	"encoding/json"
	"errors"
	"fmt"
	"io"
	"net/http"
	"regexp"
	"strings"

	"github.com/gin-gonic/gin"
	"github.com/jackc/pgx/v5/pgconn"
)

const bodyCaptureLimit = 64 * 1024

var (
	credentialTextPattern = regexp.MustCompile(`(?i)\b(?:bearer|token)\s+[A-Za-z0-9._~+/=-]+`)
	jwtTextPattern        = regexp.MustCompile(`\beyJ[A-Za-z0-9_-]{10,}\.[A-Za-z0-9_-]{10,}\.[A-Za-z0-9_-]{10,}\b`)
	emailTextPattern      = regexp.MustCompile(`(?i)\b[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}\b`)
)

type requestBodyCapture struct {
	io.ReadCloser
	body      bytes.Buffer
	truncated bool
}

func (capture *requestBodyCapture) Read(p []byte) (int, error) {
	n, err := capture.ReadCloser.Read(p)
	if n > 0 {
		remaining := bodyCaptureLimit - capture.body.Len()
		if remaining > n {
			remaining = n
		}
		if remaining > 0 {
			_, _ = capture.body.Write(p[:remaining])
		}
		if remaining < n {
			capture.truncated = true
		}
	}
	return n, err
}

type captureWriter struct {
	gin.ResponseWriter
	body      bytes.Buffer
	truncated bool
}

func (writer *captureWriter) Write(data []byte) (int, error) {
	writer.capture(data)
	return writer.ResponseWriter.Write(data)
}

func (writer *captureWriter) WriteString(data string) (int, error) {
	writer.capture([]byte(data))
	return writer.ResponseWriter.WriteString(data)
}

func (writer *captureWriter) capture(data []byte) {
	remaining := bodyCaptureLimit - writer.body.Len()
	if remaining > len(data) {
		remaining = len(data)
	}
	if remaining > 0 {
		_, _ = writer.body.Write(data[:remaining])
	}
	if remaining < len(data) {
		writer.truncated = true
	}
}

func captureJSONBytes(raw []byte, truncated bool) (map[string]any, error) {
	if truncated {
		return nil, errors.New("over_64_kib")
	}
	if len(raw) == 0 {
		return map[string]any{}, nil
	}
	decoder := json.NewDecoder(bytes.NewReader(raw))
	decoder.UseNumber()
	var value any
	if err := decoder.Decode(&value); err != nil {
		return nil, errors.New("invalid_or_non_json")
	}
	if decoder.Decode(new(any)) != io.EOF {
		return nil, errors.New("invalid_or_non_json")
	}
	sanitized := sanitizeJSON(value)
	if object, ok := sanitized.(map[string]any); ok {
		return object, nil
	}
	return map[string]any{"value": sanitized}, nil
}

func omittedBody(reason string) map[string]any {
	return map[string]any{"omitted": true, "reason": reason}
}

func sanitizeJSON(value any) any {
	switch typed := value.(type) {
	case map[string]any:
		clean := make(map[string]any, len(typed))
		for key, item := range typed {
			if sensitiveField(key) {
				clean[key] = "[REDACTED]"
				continue
			}
			clean[key] = sanitizeJSON(item)
		}
		return clean
	case []any:
		clean := make([]any, len(typed))
		for index, item := range typed {
			clean[index] = sanitizeJSON(item)
		}
		return clean
	case string:
		clean := credentialTextPattern.ReplaceAllString(typed, "[REDACTED]")
		clean = jwtTextPattern.ReplaceAllString(clean, "[REDACTED]")
		return emailTextPattern.ReplaceAllString(clean, "[REDACTED]")
	default:
		return value
	}
}

func sensitiveField(key string) bool {
	key = strings.ToLower(strings.NewReplacer("_", "", "-", "").Replace(key))
	for _, token := range []string{"password", "passwd", "secret", "token", "authorization", "cookie", "apikey", "email", "phone", "telephone", "cpf", "ssn", "username", "avatarurl"} {
		if strings.Contains(key, token) {
			return true
		}
	}
	return key == "name" || key == "displayname"
}

func safeRequestHeaders(source http.Header) map[string]string {
	result := make(map[string]string)
	allowed := map[string]bool{"accept": true, "content-type": true, "origin": true, "user-agent": true, "x-request-id": true}
	for key, values := range source {
		lower := strings.ToLower(key)
		if !allowed[lower] || sensitiveField(lower) {
			continue
		}
		if len(values) > 0 {
			result[http.CanonicalHeaderKey(key)] = values[0]
		}
	}
	return result
}

func safeResponseHeaders(source http.Header) map[string]string {
	result := make(map[string]string)
	for _, key := range []string{"Content-Type", "X-Request-Id", "Access-Control-Allow-Origin"} {
		if value := source.Get(key); value != "" {
			result[key] = value
		}
	}
	return result
}

func responseErrorCode(body map[string]any, status int) string {
	if envelope, ok := body["error"].(map[string]any); ok {
		if code, ok := envelope["code"].(string); ok && code != "" {
			return code
		}
	}
	return fmt.Sprintf("HTTP_%d", status)
}

func failureDetails(c *gin.Context, status int) (string, string, string) {
	if stack, ok := c.Get("panic_stack"); ok {
		panicStack, _ := stack.(string)
		message, _ := c.Get("failure_message")
		return "panic", fmt.Sprint(message), panicStack
	}
	if status < 500 {
		return "client_request", "HTTP client error", ""
	}
	if value, ok := c.Get("failure_error"); ok {
		if failure, isError := value.(error); isError {
			if errors.Is(failure, context.DeadlineExceeded) {
				return "timeout", "Request processing timed out", ""
			}
			var databaseError *pgconn.PgError
			if errors.As(failure, &databaseError) {
				return "postgres_sqlstate_" + databaseError.Code, "Database operation failed (SQLSTATE " + databaseError.Code + ")", ""
			}
			failureType := rootErrorType(failure)
			return failureType, "Request processing failed (" + failureType + ")", ""
		}
	}
	return "http_server_error", "HTTP server error", ""
}

func rootErrorType(err error) string {
	var root error
	for current := err; current != nil; current = errors.Unwrap(current) {
		root = current
	}
	return fmt.Sprintf("%T", root)
}
