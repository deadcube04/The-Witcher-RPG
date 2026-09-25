package repository

import (
	"context"
	"errors"
	"fmt"

	"gorm.io/gorm"
)

type Store struct {
	DB     *gorm.DB
	UserID string
}

func New(db *gorm.DB, userID string) *Store { return &Store{DB: db, UserID: userID} }

func (s *Store) ValidateLocalUser(ctx context.Context) error {
	var count int64
	if err := s.DB.WithContext(ctx).Table("core.users").Where("id = ? AND status = 'ACTIVE' AND deleted_at IS NULL", s.UserID).Count(&count).Error; err != nil {
		return fmt.Errorf("validate local user: %w", err)
	}
	if count != 1 {
		return errors.New("LOCAL_USER_ID must identify one active user")
	}
	return nil
}
