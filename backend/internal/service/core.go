package service

import (
	"context"
	"errors"
	"strings"

	"RPG-manager/backend/internal/domain"
	"RPG-manager/backend/internal/repository"
)

var ErrInvalid = errors.New("invalid request")
var ErrPreview = errors.New("preview system")

type Core struct{ store *repository.Store }

func NewCore(store *repository.Store) *Core { return &Core{store: store} }

func (s *Core) Profile(ctx context.Context) (domain.Profile, error) { return s.store.Profile(ctx) }
func (s *Core) UpdateProfile(ctx context.Context, name, username, avatar string) (domain.Profile, error) {
	name = strings.TrimSpace(name)
	username = strings.TrimSpace(username)
	avatar = strings.TrimSpace(avatar)
	if len(name) == 0 || len(name) > 160 || len(username) < 2 || len(username) > 40 {
		return domain.Profile{}, ErrInvalid
	}
	return s.store.UpdateProfile(ctx, name, username, avatar)
}
func (s *Core) Systems(ctx context.Context) ([]domain.System, error) { return s.store.Systems(ctx) }
func (s *Core) Preferences(ctx context.Context) (domain.Preferences, error) {
	return s.store.Preferences(ctx)
}
func (s *Core) UpdatePreferences(ctx context.Context, p domain.Preferences) (domain.Preferences, error) {
	systems, err := s.store.Systems(ctx)
	if err != nil {
		return domain.Preferences{}, err
	}
	valid := false
	for _, system := range systems {
		if system.ID == p.ActiveSystemID {
			valid = true
			if p.ActiveThemeID != nil {
				found := false
				for _, theme := range system.AvailableThemes {
					if theme == *p.ActiveThemeID {
						found = true
						break
					}
				}
				if !found {
					return domain.Preferences{}, ErrInvalid
				}
			}
			break
		}
	}
	if !valid {
		return domain.Preferences{}, repository.ErrNotFound
	}
	if p.SidebarMode != "collapsed" && p.SidebarMode != "expanded" && p.SidebarMode != "always-collapsed" {
		return domain.Preferences{}, ErrInvalid
	}
	return s.store.UpdatePreferences(ctx, p)
}
func (s *Core) Campaigns(ctx context.Context) ([]domain.Campaign, error) {
	return s.store.Campaigns(ctx)
}
func (s *Core) Campaign(ctx context.Context, id string) (domain.Campaign, error) {
	return s.store.Campaign(ctx, id)
}
func (s *Core) CreateCampaign(ctx context.Context, in domain.CampaignInput) (domain.Campaign, error) {
	slug, err := s.store.SystemSlug(ctx, in.SystemID)
	if err != nil {
		return domain.Campaign{}, err
	}
	if slug != "ordem-paranormal" {
		return domain.Campaign{}, ErrPreview
	}
	in.Name = strings.TrimSpace(in.Name)
	if in.Name == "" {
		return domain.Campaign{}, ErrInvalid
	}
	return s.store.CreateCampaign(ctx, in)
}
func (s *Core) UpdateCampaign(ctx context.Context, id string, fields map[string]any) (domain.Campaign, error) {
	if raw, ok := fields["rpg_system_id"]; ok {
		value, valid := raw.(string)
		if !valid {
			return domain.Campaign{}, ErrInvalid
		}
		slug, err := s.store.SystemSlug(ctx, value)
		if err != nil {
			return domain.Campaign{}, err
		}
		if slug != "ordem-paranormal" {
			return domain.Campaign{}, ErrPreview
		}
	}
	return s.store.UpdateCampaign(ctx, id, fields)
}
func (s *Core) DeleteCampaign(ctx context.Context, id string) error {
	return s.store.DeleteCampaign(ctx, id)
}
