package campaigns

import (
	"context"
	"strings"

	"RPG-manager/backend/internal/apperr"
	"RPG-manager/backend/internal/domain"
)

type Service struct {
	repo    *Repository
	systems SystemLookup
}

func NewService(repo *Repository, systems SystemLookup) *Service {
	return &Service{repo: repo, systems: systems}
}

func (s *Service) List(ctx context.Context) ([]domain.Campaign, error) { return s.repo.Campaigns(ctx) }
func (s *Service) Get(ctx context.Context, id string) (domain.Campaign, error) {
	return s.repo.Campaign(ctx, id)
}
func (s *Service) Create(ctx context.Context, in domain.CampaignInput) (domain.Campaign, error) {
	slug, err := s.systems.Slug(ctx, in.SystemID)
	if err != nil {
		return domain.Campaign{}, err
	}
	if slug != "ordem-paranormal" {
		return domain.Campaign{}, apperr.ErrPreview
	}
	in.Name = strings.TrimSpace(in.Name)
	if in.Name == "" {
		return domain.Campaign{}, apperr.ErrInvalid
	}
	return s.repo.CreateCampaign(ctx, in)
}
func (s *Service) Update(ctx context.Context, id string, fields map[string]any) (domain.Campaign, error) {
	if raw, ok := fields["rpg_system_id"]; ok {
		value, valid := raw.(string)
		if !valid {
			return domain.Campaign{}, apperr.ErrInvalid
		}
		slug, err := s.systems.Slug(ctx, value)
		if err != nil {
			return domain.Campaign{}, err
		}
		if slug != "ordem-paranormal" {
			return domain.Campaign{}, apperr.ErrPreview
		}
	}
	return s.repo.UpdateCampaign(ctx, id, fields)
}
func (s *Service) Delete(ctx context.Context, id string) error { return s.repo.DeleteCampaign(ctx, id) }
