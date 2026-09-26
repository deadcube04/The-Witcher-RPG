package systems

import (
	"context"
	"fmt"

	"RPG-manager/backend/internal/domain"
	"gorm.io/gorm"
)

type Repository struct{ DB *gorm.DB }

func NewRepository(db *gorm.DB) *Repository { return &Repository{DB: db} }

func (r *Repository) List(ctx context.Context) ([]domain.System, error) {
	var rows []struct {
		ID, Slug, Name string
		Description    *string
		IsActive       bool
	}
	if err := r.DB.WithContext(ctx).Table("core.rpg_system").Select("id, slug, name, description, is_active").Where("slug IN ?", []string{"ordem-paranormal", "dungeons-and-dragons", "witcher"}).Order("CASE slug WHEN 'ordem-paranormal' THEN 0 WHEN 'dungeons-and-dragons' THEN 1 ELSE 2 END").Find(&rows).Error; err != nil {
		return nil, fmt.Errorf("list systems: %w", err)
	}
	var themes []struct {
		RpgSystemID string
		ThemeID     string
	}
	if err := r.DB.WithContext(ctx).Table("core.rpg_theme").Select("rpg_system_id, theme_id").Order("theme_id").Find(&themes).Error; err != nil {
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

func (r *Repository) Slug(ctx context.Context, id string) (string, error) {
	var slug string
	if err := r.DB.WithContext(ctx).Table("core.rpg_system").Select("slug").Where("id = ?", id).Scan(&slug).Error; err != nil {
		return "", err
	}
	if slug == "" {
		return "", fmt.Errorf("system: %w", gorm.ErrRecordNotFound)
	}
	return slug, nil
}

func (r *Repository) OrdemID(ctx context.Context) (string, error) {
	var id string
	if err := r.DB.WithContext(ctx).Table("core.rpg_system").Select("id").Where("slug='ordem-paranormal'").Scan(&id).Error; err != nil {
		return "", err
	}
	if id == "" {
		return "", fmt.Errorf("system: %w", gorm.ErrRecordNotFound)
	}
	return id, nil
}
