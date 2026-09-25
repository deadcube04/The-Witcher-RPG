package repository

import (
	"context"
	"errors"
	"fmt"
	"time"

	"RPG-manager/backend/internal/domain"

	"gorm.io/gorm"
)

var ErrNotFound = errors.New("not found")
var ErrConflict = errors.New("conflict")
var ErrInUse = errors.New("content in use")
var ErrAlreadyAdded = errors.New("content already added")

type profileRow struct {
	ID          string
	DisplayName string
	Username    string
	AvatarURL   *string
}
type systemRow struct {
	ID          string
	Slug        string
	Name        string
	Description *string
	IsActive    bool
}
type campaignRow struct {
	ID          string
	RpgSystemID string
	Name        string
	Description string
	Status      string
	CreatedAt   time.Time
	UpdatedAt   time.Time
}

func (s *Store) Profile(ctx context.Context) (domain.Profile, error) {
	var row profileRow
	err := s.DB.WithContext(ctx).Table("core.users").Select("id, display_name, username, avatar_url").Where("id = ? AND deleted_at IS NULL", s.UserID).Take(&row).Error
	if errors.Is(err, gorm.ErrRecordNotFound) {
		return domain.Profile{}, ErrNotFound
	}
	if err != nil {
		return domain.Profile{}, fmt.Errorf("read profile: %w", err)
	}
	avatar := ""
	if row.AvatarURL != nil {
		avatar = *row.AvatarURL
	}
	return domain.Profile{ID: row.ID, Name: row.DisplayName, Username: row.Username, AvatarURL: avatar}, nil
}

func (s *Store) UpdateProfile(ctx context.Context, name, username, avatar string) (domain.Profile, error) {
	var nullable any
	if avatar != "" {
		nullable = avatar
	}
	err := s.DB.WithContext(ctx).Table("core.users").Where("id = ? AND deleted_at IS NULL", s.UserID).Updates(map[string]any{"display_name": name, "username": username, "avatar_url": nullable, "updated_at": time.Now()}).Error
	if err != nil {
		return domain.Profile{}, fmt.Errorf("update profile: %w", err)
	}
	return s.Profile(ctx)
}

func (s *Store) Systems(ctx context.Context) ([]domain.System, error) {
	var rows []systemRow
	if err := s.DB.WithContext(ctx).Table("core.rpg_system").Select("id, slug, name, description, is_active").Where("slug IN ?", []string{"ordem-paranormal", "dungeons-and-dragons", "witcher"}).Order("CASE slug WHEN 'ordem-paranormal' THEN 0 WHEN 'dungeons-and-dragons' THEN 1 ELSE 2 END").Find(&rows).Error; err != nil {
		return nil, fmt.Errorf("list systems: %w", err)
	}
	var themes []struct {
		RpgSystemID string
		ThemeID     string
	}
	if err := s.DB.WithContext(ctx).Table("core.rpg_theme").Select("rpg_system_id, theme_id").Order("theme_id").Find(&themes).Error; err != nil {
		return nil, fmt.Errorf("list themes: %w", err)
	}
	out := make([]domain.System, 0, len(rows))
	for _, row := range rows {
		status := "preview"
		if row.Slug == "ordem-paranormal" && row.IsActive {
			status = "available"
		}
		desc := ""
		if row.Description != nil {
			desc = *row.Description
		}
		item := domain.System{ID: row.ID, Slug: row.Slug, Name: row.Name, Description: desc, Status: status, AvailableThemes: []string{}}
		for _, theme := range themes {
			if theme.RpgSystemID == row.ID {
				item.AvailableThemes = append(item.AvailableThemes, theme.ThemeID)
			}
		}
		out = append(out, item)
	}
	return out, nil
}

func (s *Store) Preferences(ctx context.Context) (domain.Preferences, error) {
	var row struct {
		ActiveRpgSystemID *string
		ActiveThemeID     *string
		SidebarMode       *string
	}
	err := s.DB.WithContext(ctx).Table("core.user_preferences").Select("active_rpg_system_id, active_theme_id, sidebar_mode").Where("user_id = ?", s.UserID).Take(&row).Error
	if err != nil && !errors.Is(err, gorm.ErrRecordNotFound) {
		return domain.Preferences{}, fmt.Errorf("read preferences: %w", err)
	}
	if row.ActiveRpgSystemID == nil {
		var id string
		if err := s.DB.WithContext(ctx).Table("core.rpg_system").Select("id").Where("slug = 'ordem-paranormal'").Scan(&id).Error; err != nil {
			return domain.Preferences{}, fmt.Errorf("default system: %w", err)
		}
		row.ActiveRpgSystemID = &id
	}
	mode := "collapsed"
	if row.SidebarMode != nil {
		mode = *row.SidebarMode
	}
	return domain.Preferences{ActiveSystemID: *row.ActiveRpgSystemID, ActiveThemeID: row.ActiveThemeID, SidebarMode: mode}, nil
}

func (s *Store) UpdatePreferences(ctx context.Context, p domain.Preferences) (domain.Preferences, error) {
	err := s.DB.WithContext(ctx).Exec(`INSERT INTO core.user_preferences(user_id, active_rpg_system_id, active_theme_id, sidebar_mode)
		VALUES (?, ?, ?, ?) ON CONFLICT (user_id) DO UPDATE SET active_rpg_system_id=EXCLUDED.active_rpg_system_id,
		active_theme_id=EXCLUDED.active_theme_id, sidebar_mode=EXCLUDED.sidebar_mode, updated_at=now()`, s.UserID, p.ActiveSystemID, p.ActiveThemeID, p.SidebarMode).Error
	if err != nil {
		return domain.Preferences{}, fmt.Errorf("update preferences: %w", err)
	}
	return s.Preferences(ctx)
}

func (s *Store) Campaigns(ctx context.Context) ([]domain.Campaign, error) {
	var rows []campaignRow
	if err := s.DB.WithContext(ctx).Table("core.campaign").Select("id, rpg_system_id, name, description, status, created_at, updated_at").Where("owner_user_id = ?", s.UserID).Order("updated_at DESC").Find(&rows).Error; err != nil {
		return nil, fmt.Errorf("list campaigns: %w", err)
	}
	out := make([]domain.Campaign, 0, len(rows))
	for _, row := range rows {
		out = append(out, s.mapCampaign(row))
	}
	return out, nil
}

func (s *Store) mapCampaign(row campaignRow) domain.Campaign {
	return domain.Campaign{ID: row.ID, OwnerID: s.UserID, SystemID: row.RpgSystemID, Name: row.Name, Description: row.Description, Status: row.Status, CreatedAt: utcTime(row.CreatedAt), UpdatedAt: utcTime(row.UpdatedAt)}
}

func (s *Store) Campaign(ctx context.Context, id string) (domain.Campaign, error) {
	var row campaignRow
	err := s.DB.WithContext(ctx).Table("core.campaign").Select("id, rpg_system_id, name, description, status, created_at, updated_at").Where("id = ? AND owner_user_id = ?", id, s.UserID).Take(&row).Error
	if errors.Is(err, gorm.ErrRecordNotFound) {
		return domain.Campaign{}, ErrNotFound
	}
	if err != nil {
		return domain.Campaign{}, fmt.Errorf("read campaign: %w", err)
	}
	return s.mapCampaign(row), nil
}

func (s *Store) CreateCampaign(ctx context.Context, in domain.CampaignInput) (domain.Campaign, error) {
	var id string
	err := s.DB.WithContext(ctx).Raw(`INSERT INTO core.campaign(owner_user_id, rpg_system_id, name, description, status)
		VALUES (?, ?, ?, ?, ?) RETURNING id`, s.UserID, in.SystemID, in.Name, in.Description, in.Status).Scan(&id).Error
	if err != nil {
		return domain.Campaign{}, fmt.Errorf("create campaign: %w", err)
	}
	return s.Campaign(ctx, id)
}

func (s *Store) UpdateCampaign(ctx context.Context, id string, fields map[string]any) (domain.Campaign, error) {
	fields["updated_at"] = time.Now()
	result := s.DB.WithContext(ctx).Table("core.campaign").Where("id = ? AND owner_user_id = ?", id, s.UserID).Updates(fields)
	if result.Error != nil {
		return domain.Campaign{}, fmt.Errorf("update campaign: %w", result.Error)
	}
	if result.RowsAffected == 0 {
		return domain.Campaign{}, ErrNotFound
	}
	return s.Campaign(ctx, id)
}

func (s *Store) DeleteCampaign(ctx context.Context, id string) error {
	return s.DB.WithContext(ctx).Transaction(func(tx *gorm.DB) error {
		var count int64
		if err := tx.Table("core.campaign").Where("id = ? AND owner_user_id = ?", id, s.UserID).Count(&count).Error; err != nil {
			return err
		}
		if count == 0 {
			return ErrNotFound
		}
		if err := tx.Table("core.rpg_character").Where("campaign_id = ?", id).Update("campaign_id", nil).Error; err != nil {
			return err
		}
		return tx.Exec("DELETE FROM core.campaign WHERE id = ? AND owner_user_id = ?", id, s.UserID).Error
	})
}

func (s *Store) SystemSlug(ctx context.Context, id string) (string, error) {
	var slug string
	if err := s.DB.WithContext(ctx).Table("core.rpg_system").Select("slug").Where("id = ?", id).Scan(&slug).Error; err != nil {
		return "", err
	}
	if slug == "" {
		return "", ErrNotFound
	}
	return slug, nil
}
