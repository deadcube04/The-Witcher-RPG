package systems

import (
	"context"
	"errors"

	"RPG-manager/backend/internal/apperr"
	"RPG-manager/backend/internal/domain"
	"gorm.io/gorm"
)

type Service struct{ repo *Repository }

func NewService(repo *Repository) *Service { return &Service{repo: repo} }

func (s *Service) List(ctx context.Context) ([]domain.System, error) { return s.repo.List(ctx) }

func (s *Service) Slug(ctx context.Context, id string) (string, error) {
	slug, err := s.repo.Slug(ctx, id)
	if errors.Is(err, gorm.ErrRecordNotFound) {
		return "", apperr.ErrNotFound
	}
	return slug, err
}

func (s *Service) OrdemID(ctx context.Context) (string, error) {
	id, err := s.repo.OrdemID(ctx)
	if errors.Is(err, gorm.ErrRecordNotFound) {
		return "", apperr.ErrNotFound
	}
	return id, err
}
