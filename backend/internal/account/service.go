package account

import (
	"context"
	"strings"

	"RPG-manager/backend/internal/apperr"
	"RPG-manager/backend/internal/domain"
)

type ProfilePreferencesRepository interface {
	Profile(context.Context) (domain.Profile, error)
	IsAdmin(context.Context) (bool, error)
	UpdateProfile(context.Context, string, string, string) (domain.Profile, error)
	Preferences(context.Context) (domain.Preferences, error)
	UpdatePreferences(context.Context, domain.Preferences) (domain.Preferences, error)
}

type Systems interface {
	List(context.Context) ([]domain.System, error)
}

type Service struct {
	repo    ProfilePreferencesRepository
	systems Systems
}

func NewService(repo ProfilePreferencesRepository, systems Systems) *Service {
	return &Service{repo: repo, systems: systems}
}

func (s *Service) Profile(ctx context.Context) (domain.Profile, error) { return s.repo.Profile(ctx) }

func (s *Service) IsAdmin(ctx context.Context) (bool, error) { return s.repo.IsAdmin(ctx) }

func (s *Service) UpdateProfile(ctx context.Context, name, username, avatar string) (domain.Profile, error) {
	name, username, avatar = strings.TrimSpace(name), strings.TrimSpace(username), strings.TrimSpace(avatar)
	if len(name) == 0 || len(name) > 160 || len(username) < 2 || len(username) > 40 {
		return domain.Profile{}, apperr.ErrInvalid
	}
	return s.repo.UpdateProfile(ctx, name, username, avatar)
}

func (s *Service) Preferences(ctx context.Context) (domain.Preferences, error) {
	return s.repo.Preferences(ctx)
}

func (s *Service) UpdatePreferences(ctx context.Context, p domain.Preferences, allowThemeFallback bool) (domain.Preferences, error) {
	systems, err := s.systems.List(ctx)
	if err != nil {
		return domain.Preferences{}, err
	}
	valid := false
	for _, system := range systems {
		if system.ID != p.ActiveSystemID {
			continue
		}
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
				if !allowThemeFallback {
					return domain.Preferences{}, apperr.ErrInvalid
				}
				nexusAvailable := false
				for _, theme := range system.AvailableThemes {
					if theme == "nexus" {
						nexusAvailable = true
						break
					}
				}
				if !nexusAvailable {
					return domain.Preferences{}, apperr.ErrInvalid
				}
				theme := "nexus"
				p.ActiveThemeID = &theme
			}
		}
		break
	}
	if !valid {
		return domain.Preferences{}, apperr.ErrNotFound
	}
	if p.SidebarMode != "collapsed" && p.SidebarMode != "expanded" && p.SidebarMode != "always-collapsed" {
		return domain.Preferences{}, apperr.ErrInvalid
	}
	if p.ColorMode != "system" && p.ColorMode != "light" && p.ColorMode != "dark" {
		return domain.Preferences{}, apperr.ErrInvalid
	}
	return s.repo.UpdatePreferences(ctx, p)
}
