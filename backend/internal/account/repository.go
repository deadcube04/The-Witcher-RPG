package account

import (
	"context"
	"database/sql"
	"errors"
	"fmt"
	"time"

	"RPG-manager/backend/internal/apperr"
	"RPG-manager/backend/internal/domain"

	"gorm.io/gorm"
)

type Repository struct {
	DB     *gorm.DB
	UserID string
}

func NewRepository(db *gorm.DB, userID string) *Repository {
	return &Repository{DB: db, UserID: userID}
}

func (r *Repository) ValidateLocalUser(ctx context.Context) error {
	var count int64
	if err := r.DB.WithContext(ctx).Table("public.users").Where("id = ? AND status = 'ACTIVE' AND deleted_at IS NULL", r.UserID).Count(&count).Error; err != nil {
		return fmt.Errorf("validate local user: %w", err)
	}
	if count != 1 {
		return errors.New("LOCAL_USER_ID must identify one active user")
	}
	return nil
}

func (r *Repository) Profile(ctx context.Context) (domain.Profile, error) {
	var row struct {
		ID, Name, Username string
		AvatarURL          sql.NullString
		Role               string
	}
	err := r.DB.WithContext(ctx).Table("public.users").Select("id, display_name AS name, username, avatar_url, role").Where("id = ? AND deleted_at IS NULL", r.UserID).Take(&row).Error
	if errors.Is(err, gorm.ErrRecordNotFound) {
		return domain.Profile{}, apperr.ErrNotFound
	}
	if err != nil {
		return domain.Profile{}, fmt.Errorf("read profile: %w", err)
	}
	return domain.Profile{ID: row.ID, Name: row.Name, Username: row.Username, AvatarURL: row.AvatarURL.String, Role: row.Role}, nil
}

func (r *Repository) IsAdmin(ctx context.Context) (bool, error) {
	var count int64
	err := r.DB.WithContext(ctx).Table("public.users").Where("id = ? AND role = 'ADMIN' AND status = 'ACTIVE' AND deleted_at IS NULL", r.UserID).Count(&count).Error
	if err != nil {
		return false, fmt.Errorf("check local admin role: %w", err)
	}
	return count == 1, nil
}

func (r *Repository) UpdateProfile(ctx context.Context, name, username, avatar string) (domain.Profile, error) {
	var nullable any
	if avatar != "" {
		nullable = avatar
	}
	err := r.DB.WithContext(ctx).Table("public.users").Where("id = ? AND deleted_at IS NULL", r.UserID).Updates(map[string]any{"display_name": name, "username": username, "avatar_url": nullable, "updated_at": time.Now()}).Error
	if err != nil {
		return domain.Profile{}, fmt.Errorf("update profile: %w", err)
	}
	return r.Profile(ctx)
}

func (r *Repository) Preferences(ctx context.Context) (domain.Preferences, error) {
	var row struct {
		ActiveRpgSystemID *string
		ActiveThemeID     *string
		SidebarMode       *string
		ColorMode         string
	}
	err := r.DB.WithContext(ctx).Table("public.user_preferences").Select("active_rpg_system_id, active_theme_id, sidebar_mode, color_mode").Where("user_id = ?", r.UserID).Take(&row).Error
	if err != nil && !errors.Is(err, gorm.ErrRecordNotFound) {
		return domain.Preferences{}, fmt.Errorf("read preferences: %w", err)
	}
	if errors.Is(err, gorm.ErrRecordNotFound) {
		theme := "nexus"
		row.ActiveThemeID = &theme
		row.ColorMode = "system"
	}
	if row.ActiveRpgSystemID == nil {
		var id string
		if err := r.DB.WithContext(ctx).Table("core.rpg_system").Select("id").Where("slug = 'ordem-paranormal'").Scan(&id).Error; err != nil {
			return domain.Preferences{}, fmt.Errorf("default system: %w", err)
		}
		row.ActiveRpgSystemID = &id
	}
	mode := "collapsed"
	if row.SidebarMode != nil {
		mode = *row.SidebarMode
	}
	return domain.Preferences{ActiveSystemID: *row.ActiveRpgSystemID, ActiveThemeID: row.ActiveThemeID, SidebarMode: mode, ColorMode: row.ColorMode}, nil
}

func (r *Repository) UpdatePreferences(ctx context.Context, p domain.Preferences) (domain.Preferences, error) {
	err := r.DB.WithContext(ctx).Exec(`INSERT INTO public.user_preferences(user_id, active_rpg_system_id, active_theme_id, sidebar_mode, color_mode)
		VALUES (?, ?, ?, ?, ?) ON CONFLICT (user_id) DO UPDATE SET active_rpg_system_id=EXCLUDED.active_rpg_system_id,
		active_theme_id=EXCLUDED.active_theme_id, sidebar_mode=EXCLUDED.sidebar_mode, color_mode=EXCLUDED.color_mode, updated_at=now()`, r.UserID, p.ActiveSystemID, p.ActiveThemeID, p.SidebarMode, p.ColorMode).Error
	if err != nil {
		return domain.Preferences{}, fmt.Errorf("update preferences: %w", err)
	}
	return r.Preferences(ctx)
}
