package campaigns

import (
	"context"
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

type campaignRow struct {
	ID, RpgSystemID, Name, Description, Status string
	CreatedAt, UpdatedAt                       time.Time
}

func (r *Repository) Campaigns(ctx context.Context) ([]domain.Campaign, error) {
	var rows []campaignRow
	if err := r.DB.WithContext(ctx).Table("core.campaign").Select("id, rpg_system_id, name, description, status, created_at, updated_at").Where("owner_user_id = ?", r.UserID).Order("updated_at DESC").Find(&rows).Error; err != nil {
		return nil, fmt.Errorf("list campaigns: %w", err)
	}
	out := make([]domain.Campaign, 0, len(rows))
	for _, row := range rows {
		out = append(out, r.mapCampaign(row))
	}
	return out, nil
}

func (r *Repository) mapCampaign(row campaignRow) domain.Campaign {
	return domain.Campaign{ID: row.ID, OwnerID: r.UserID, SystemID: row.RpgSystemID, Name: row.Name, Description: row.Description, Status: row.Status, CreatedAt: row.CreatedAt.UTC(), UpdatedAt: row.UpdatedAt.UTC()}
}

func (r *Repository) Campaign(ctx context.Context, id string) (domain.Campaign, error) {
	var row campaignRow
	err := r.DB.WithContext(ctx).Table("core.campaign").Select("id, rpg_system_id, name, description, status, created_at, updated_at").Where("id = ? AND owner_user_id = ?", id, r.UserID).Take(&row).Error
	if errors.Is(err, gorm.ErrRecordNotFound) {
		return domain.Campaign{}, apperr.ErrNotFound
	}
	if err != nil {
		return domain.Campaign{}, fmt.Errorf("read campaign: %w", err)
	}
	return r.mapCampaign(row), nil
}

func (r *Repository) CreateCampaign(ctx context.Context, in domain.CampaignInput) (domain.Campaign, error) {
	var id string
	err := r.DB.WithContext(ctx).Raw(`INSERT INTO core.campaign(owner_user_id, rpg_system_id, name, description, status)
		VALUES (?, ?, ?, ?, ?) RETURNING id`, r.UserID, in.SystemID, in.Name, in.Description, in.Status).Scan(&id).Error
	if err != nil {
		return domain.Campaign{}, fmt.Errorf("create campaign: %w", err)
	}
	return r.Campaign(ctx, id)
}

func (r *Repository) UpdateCampaign(ctx context.Context, id string, fields map[string]any) (domain.Campaign, error) {
	fields["updated_at"] = time.Now()
	result := r.DB.WithContext(ctx).Table("core.campaign").Where("id = ? AND owner_user_id = ?", id, r.UserID).Updates(fields)
	if result.Error != nil {
		return domain.Campaign{}, fmt.Errorf("update campaign: %w", result.Error)
	}
	if result.RowsAffected == 0 {
		return domain.Campaign{}, apperr.ErrNotFound
	}
	return r.Campaign(ctx, id)
}

func (r *Repository) DeleteCampaign(ctx context.Context, id string) error {
	return r.DB.WithContext(ctx).Transaction(func(tx *gorm.DB) error {
		var count int64
		if err := tx.Table("core.campaign").Where("id = ? AND owner_user_id = ?", id, r.UserID).Count(&count).Error; err != nil {
			return err
		}
		if count == 0 {
			return apperr.ErrNotFound
		}
		if err := tx.Table("core.rpg_character").Where("campaign_id = ?", id).Update("campaign_id", nil).Error; err != nil {
			return err
		}
		return tx.Exec("DELETE FROM core.campaign WHERE id = ? AND owner_user_id = ?", id, r.UserID).Error
	})
}

type SystemLookup interface {
	Slug(ctx context.Context, id string) (string, error)
}
