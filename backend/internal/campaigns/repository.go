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
	ID, RpgSystemID, Name, Description, CoverImageURL, SheetMode, Status string
	ClassMode, OriginMode                                                *string
	CreatedAt, UpdatedAt                                                 time.Time
}

const campaignColumns = "c.id, c.rpg_system_id, c.name, c.description, c.cover_image_url, c.sheet_mode, c.status, c.created_at, c.updated_at, s.class_mode, s.origin_mode"

func (r *Repository) Campaigns(ctx context.Context) ([]domain.Campaign, error) {
	var rows []campaignRow
	if err := r.DB.WithContext(ctx).Table("core.campaign AS c").Select(campaignColumns).Joins("LEFT JOIN ordem.campaign_settings AS s ON s.campaign_id = c.id").Where("c.owner_user_id = ?", r.UserID).Order("c.updated_at DESC").Find(&rows).Error; err != nil {
		return nil, fmt.Errorf("list campaigns: %w", err)
	}
	out := make([]domain.Campaign, 0, len(rows))
	for _, row := range rows {
		out = append(out, r.mapCampaign(row))
	}
	if err := r.loadSelections(ctx, out); err != nil {
		return nil, err
	}
	return out, nil
}

func (r *Repository) mapCampaign(row campaignRow) domain.Campaign {
	settings := domain.CampaignSettings{
		Kind:    "ordem-paranormal",
		Classes: domain.CampaignSelection{Mode: "all", AllowedIDs: []string{}},
		Origins: domain.CampaignSelection{Mode: "all", AllowedIDs: []string{}},
	}
	if row.ClassMode != nil {
		settings.Classes.Mode = *row.ClassMode
	}
	if row.OriginMode != nil {
		settings.Origins.Mode = *row.OriginMode
	}
	return domain.Campaign{ID: row.ID, OwnerID: r.UserID, SystemID: row.RpgSystemID, Name: row.Name, Description: row.Description, CoverImageURL: row.CoverImageURL, SheetMode: row.SheetMode, Settings: settings, Status: row.Status, CreatedAt: row.CreatedAt.UTC(), UpdatedAt: row.UpdatedAt.UTC()}
}

func (r *Repository) Campaign(ctx context.Context, id string) (domain.Campaign, error) {
	var row campaignRow
	err := r.DB.WithContext(ctx).Table("core.campaign AS c").Select(campaignColumns).Joins("LEFT JOIN ordem.campaign_settings AS s ON s.campaign_id = c.id").Where("c.id = ? AND c.owner_user_id = ?", id, r.UserID).Take(&row).Error
	if errors.Is(err, gorm.ErrRecordNotFound) {
		return domain.Campaign{}, apperr.ErrNotFound
	}
	if err != nil {
		return domain.Campaign{}, fmt.Errorf("read campaign: %w", err)
	}
	items := []domain.Campaign{r.mapCampaign(row)}
	if err := r.loadSelections(ctx, items); err != nil {
		return domain.Campaign{}, err
	}
	return items[0], nil
}

func (r *Repository) CreateCampaign(ctx context.Context, in domain.CampaignInput) (domain.Campaign, error) {
	var id string
	status := "active"
	if in.ImportStatus != "" {
		status = in.ImportStatus
	}
	err := r.DB.WithContext(ctx).Transaction(func(tx *gorm.DB) error {
		if err := tx.Raw(`INSERT INTO core.campaign(owner_user_id, rpg_system_id, name, description, cover_image_url, sheet_mode, status)
			VALUES (?, ?, ?, ?, ?, ?, ?) RETURNING id`, r.UserID, in.SystemID, in.Name, in.Description, in.CoverImageURL, in.SheetMode, status).Scan(&id).Error; err != nil {
			return err
		}
		settings := in.Settings
		if err := tx.Exec("INSERT INTO ordem.campaign_settings(campaign_id, rpg_system_id, class_mode, origin_mode) VALUES (?, ?, ?, ?)", id, in.SystemID, settings.Classes.Mode, settings.Origins.Mode).Error; err != nil {
			return err
		}
		for _, classID := range settings.Classes.AllowedIDs {
			if err := tx.Exec("INSERT INTO ordem.campaign_allowed_class(campaign_id, rpg_system_id, class_id) VALUES (?, ?, ?)", id, in.SystemID, classID).Error; err != nil {
				return err
			}
		}
		for _, originID := range settings.Origins.AllowedIDs {
			if err := tx.Exec("INSERT INTO ordem.campaign_allowed_origin(campaign_id, rpg_system_id, origin_id) VALUES (?, ?, ?)", id, in.SystemID, originID).Error; err != nil {
				return err
			}
		}
		return nil
	})
	if err != nil {
		return domain.Campaign{}, fmt.Errorf("create campaign: %w", err)
	}
	return r.Campaign(ctx, id)
}
func (r *Repository) DefinitionCount(ctx context.Context, table, systemID string, ids []string) (int64, error) {
	if table != "core.class_definition" && table != "core.origin_definition" {
		return 0, apperr.ErrInvalid
	}
	var count int64
	err := r.DB.WithContext(ctx).Table(table).Where("rpg_system_id = ? AND id IN ?", systemID, ids).Count(&count).Error
	return count, err
}

func (r *Repository) loadSelections(ctx context.Context, campaigns []domain.Campaign) error {
	if len(campaigns) == 0 {
		return nil
	}
	ids := make([]string, 0, len(campaigns))
	index := make(map[string]int, len(campaigns))
	for i := range campaigns {
		ids = append(ids, campaigns[i].ID)
		index[campaigns[i].ID] = i
	}
	var classes []struct{ CampaignID, ClassID string }
	if err := r.DB.WithContext(ctx).Table("ordem.campaign_allowed_class").Select("campaign_id, class_id").Where("campaign_id IN ?", ids).Find(&classes).Error; err != nil {
		return fmt.Errorf("read campaign classes: %w", err)
	}
	for _, row := range classes {
		campaigns[index[row.CampaignID]].Settings.Classes.AllowedIDs = append(campaigns[index[row.CampaignID]].Settings.Classes.AllowedIDs, row.ClassID)
	}
	var origins []struct{ CampaignID, OriginID string }
	if err := r.DB.WithContext(ctx).Table("ordem.campaign_allowed_origin").Select("campaign_id, origin_id").Where("campaign_id IN ?", ids).Find(&origins).Error; err != nil {
		return fmt.Errorf("read campaign origins: %w", err)
	}
	for _, row := range origins {
		campaigns[index[row.CampaignID]].Settings.Origins.AllowedIDs = append(campaigns[index[row.CampaignID]].Settings.Origins.AllowedIDs, row.OriginID)
	}
	return nil
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
	List(ctx context.Context) ([]domain.System, error)
}
