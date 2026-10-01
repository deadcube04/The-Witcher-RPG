package campaigns

import (
	"context"
	"errors"
	"fmt"
	"time"

	"RPG-manager/backend/internal/apperr"
	"RPG-manager/backend/internal/domain"
	"RPG-manager/backend/internal/supplements"

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
		if err := r.writeSupplement(tx, id, settings.Supplement); err != nil {
			return err
		}
		return nil
	})
	if err != nil {
		return domain.Campaign{}, fmt.Errorf("create campaign: %w", err)
	}
	return r.Campaign(ctx, id)
}

func (r *Repository) SupplementMatches(ctx context.Context, supplementID, systemID string) (bool, error) {
	var count int64
	err := r.DB.WithContext(ctx).Table("core.rpg_supplement").Where("id=? AND rpg_system_id=?", supplementID, systemID).Count(&count).Error
	return count == 1, err
}

func (r *Repository) ExpandRuleIDs(ctx context.Context, supplementID string, ruleIDs []string) ([]string, error) {
	if len(ruleIDs) == 0 {
		return []string{}, nil
	}
	var rules []supplements.Rule
	if err := r.DB.WithContext(ctx).Table("ordem.supplement_rule").
		Select("id, parent_id, slug, is_optional").Where("supplement_id=? AND is_optional=true", supplementID).
		Order("source_page_start, slug").Scan(&rules).Error; err != nil {
		return nil, fmt.Errorf("load supplement rule families: %w", err)
	}
	return supplements.ExpandRuleIDs(rules, ruleIDs)
}

func (r *Repository) ValidateRules(ctx context.Context, supplementID string, ruleIDs []string) error {
	if len(ruleIDs) == 0 {
		return nil
	}
	var rows []struct {
		ID       string
		ParentID *string
		Slug     string
	}
	if err := r.DB.WithContext(ctx).Table("ordem.supplement_rule").Select("id, parent_id, slug").Where("supplement_id=? AND id IN ? AND is_optional=true", supplementID, ruleIDs).Scan(&rows).Error; err != nil {
		return err
	}
	if len(rows) != len(ruleIDs) {
		return apperr.ErrInvalid
	}
	chosen := make(map[string]bool, len(rows))
	for _, row := range rows {
		chosen[row.ID] = true
	}
	for _, row := range rows {
		if row.ParentID == nil || chosen[*row.ParentID] {
			continue
		}
		var parent struct {
			Optional bool `gorm:"column:is_optional"`
		}
		if err := r.DB.WithContext(ctx).Table("ordem.supplement_rule").Select("is_optional").Where("id=? AND supplement_id=?", *row.ParentID, supplementID).Take(&parent).Error; err != nil {
			return err
		}
		if parent.Optional {
			return apperr.ErrInvalid
		}
	}
	patent, sanity := false, false
	for _, row := range rows {
		if row.Slug == "evolucao-por-patentes" {
			patent = true
		}
		if row.Slug == "jogando-sem-sanidade" {
			sanity = true
		}
	}
	if patent && !sanity {
		return apperr.ErrInvalid
	}
	var dependencies []struct{ SourceRuleID, TargetRuleID string }
	if err := r.DB.WithContext(ctx).Table("ordem.supplement_rule_relation").Select("source_rule_id, target_rule_id").Where("supplement_id=? AND relation_kind='requires' AND source_rule_id IN ?", supplementID, ruleIDs).Scan(&dependencies).Error; err != nil {
		return err
	}
	for _, dep := range dependencies {
		if !chosen[dep.TargetRuleID] {
			return apperr.ErrInvalid
		}
	}
	return nil
}

func (r *Repository) writeSupplement(tx *gorm.DB, campaignID string, setting *domain.SupplementSettings) error {
	if setting == nil {
		return nil
	}
	if err := tx.Exec("INSERT INTO ordem.campaign_supplement(campaign_id,supplement_id) VALUES (?,?)", campaignID, setting.ID).Error; err != nil {
		return err
	}
	for _, category := range setting.Categories {
		if err := tx.Exec("INSERT INTO ordem.campaign_supplement_category(campaign_id,category) VALUES (?,?)", campaignID, category).Error; err != nil {
			return err
		}
	}
	for _, ruleID := range setting.RuleIDs {
		if err := tx.Exec("INSERT INTO ordem.campaign_supplement_rule(campaign_id,rule_id) VALUES (?,?)", campaignID, ruleID).Error; err != nil {
			return err
		}
	}
	return nil
}

func (r *Repository) UpdateSettings(ctx context.Context, campaign domain.Campaign, settings domain.CampaignSettings) (domain.Campaign, error) {
	err := r.DB.WithContext(ctx).Transaction(func(tx *gorm.DB) error {
		var classIDs, originIDs []string
		if err := tx.Table("core.rpg_character AS c").Select("cc.class_id").Joins("JOIN core.character_class AS cc ON cc.character_id=c.id").Where("c.campaign_id=?", campaign.ID).Scan(&classIDs).Error; err != nil {
			return err
		}
		if err := tx.Table("core.rpg_character AS c").Select("co.origin_id").Joins("JOIN core.character_origin AS co ON co.character_id=c.id").Where("c.campaign_id=?", campaign.ID).Scan(&originIDs).Error; err != nil {
			return err
		}
		for _, id := range classIDs {
			if settings.Classes.Mode == "selected" && !contains(settings.Classes.AllowedIDs, id) {
				return apperr.ErrInUse
			}
		}
		for _, id := range originIDs {
			if settings.Origins.Mode == "selected" && !contains(settings.Origins.AllowedIDs, id) {
				return apperr.ErrInUse
			}
		}
		var references int64
		if campaign.Settings.Supplement != nil {
			sid := campaign.Settings.Supplement.ID
			active := settings.Supplement != nil && settings.Supplement.ID == sid
			checks := []struct{ query, category string }{
				{"SELECT count(*) FROM core.rpg_character c JOIN core.character_origin co ON co.character_id=c.id JOIN core.origin_definition d ON d.id=co.origin_id WHERE c.campaign_id=? AND d.supplement_id=?", ""},
				{"SELECT count(*) FROM core.rpg_character c JOIN core.character_item ci ON ci.character_id=c.id JOIN core.item_definition d ON d.id=ci.item_id WHERE c.campaign_id=? AND d.supplement_id=?", "items"},
				{"SELECT count(*) FROM core.rpg_character c JOIN core.character_attack ca ON ca.character_id=c.id JOIN core.item_definition d ON d.id=ca.source_item_id WHERE c.campaign_id=? AND d.supplement_id=?", "items"},
				{"SELECT count(*) FROM core.rpg_character c JOIN core.character_item ci ON ci.character_id=c.id JOIN ordem.character_item_modification cm ON cm.inventory_entry_id=ci.id JOIN ordem.item_modification d ON d.id=cm.modification_id WHERE c.campaign_id=? AND d.supplement_id=?", "modifications"},
				{"SELECT count(*) FROM core.rpg_character c JOIN ordem.character_supplement_trail ct ON ct.character_id=c.id JOIN core.archetype_definition d ON d.id=ct.archetype_id WHERE c.campaign_id=? AND d.supplement_id=?", "trails"},
				{"SELECT count(*) FROM core.rpg_character c JOIN core.character_ability ca ON ca.character_id=c.id JOIN core.ability_definition d ON d.id=ca.ability_id JOIN ordem.ritual rt ON rt.ability_id=d.id WHERE c.campaign_id=? AND d.supplement_id=?", "rituals"},
				{"SELECT count(*) FROM core.rpg_character c JOIN core.character_ability ca ON ca.character_id=c.id JOIN core.ability_definition d ON d.id=ca.ability_id WHERE c.campaign_id=? AND d.supplement_id=? AND d.ability_type='TRAIL_ABILITY'", "trails"},
				{"SELECT count(*) FROM core.rpg_character c JOIN core.character_ability ca ON ca.character_id=c.id JOIN core.ability_definition d ON d.id=ca.ability_id WHERE c.campaign_id=? AND d.supplement_id=? AND d.ability_type NOT IN ('TRAIL_ABILITY','RITUAL')", "powers"},
				{"SELECT count(*) FROM core.rpg_character c JOIN core.character_ability ca ON ca.character_id=c.id JOIN ordem.supplement_ability_classification sc ON sc.ability_id=ca.ability_id WHERE c.campaign_id=? AND sc.supplement_id=?", "powers"},
				{"SELECT count(*) FROM core.rpg_character c JOIN ordem.character_progression_runtime p ON p.character_id=c.id WHERE c.campaign_id=? AND p.mode='survivor' AND ?::uuid IS NOT NULL", "survivor"},
			}
			for _, check := range checks {
				if err := tx.Raw(check.query, campaign.ID, sid).Scan(&references).Error; err != nil {
					return err
				}
				if references > 0 && (!active || (check.category != "" && !contains(settings.Supplement.Categories, check.category))) {
					return apperr.ErrInUse
				}
			}
			for mode, slug := range map[string]string{"level-nex": "nex-experiencia-p100-separando-nivel-e-nex", "patent": "evolucao-por-patentes"} {
				if err := tx.Raw("SELECT count(*) FROM core.rpg_character c JOIN ordem.character_progression_runtime p ON p.character_id=c.id WHERE c.campaign_id=? AND p.mode=?", campaign.ID, mode).Scan(&references).Error; err != nil {
					return err
				}
				if references == 0 {
					continue
				}
				if !active {
					return apperr.ErrInUse
				}
				var selected int64
				if err := tx.Table("ordem.supplement_rule").Where("supplement_id=? AND slug=? AND id IN ?", sid, slug, settings.Supplement.RuleIDs).Count(&selected).Error; err != nil {
					return err
				}
				if selected == 0 {
					return apperr.ErrInUse
				}
			}
			if err := tx.Raw("SELECT count(*) FROM core.rpg_character c JOIN ordem.character_determination d ON d.character_id=c.id WHERE c.campaign_id=?", campaign.ID).Scan(&references).Error; err != nil {
				return err
			}
			if references > 0 {
				if !active {
					return apperr.ErrInUse
				}
				var selected int64
				if err := tx.Table("ordem.supplement_rule").Where("supplement_id=? AND slug='jogando-sem-sanidade' AND id IN ?", sid, settings.Supplement.RuleIDs).Count(&selected).Error; err != nil {
					return err
				}
				if selected == 0 {
					return apperr.ErrInUse
				}
			}
		}
		if err := tx.Exec("DELETE FROM ordem.campaign_allowed_class WHERE campaign_id=?", campaign.ID).Error; err != nil {
			return err
		}
		if err := tx.Exec("DELETE FROM ordem.campaign_allowed_origin WHERE campaign_id=?", campaign.ID).Error; err != nil {
			return err
		}
		if err := tx.Exec("UPDATE ordem.campaign_settings SET class_mode=?, origin_mode=? WHERE campaign_id=?", settings.Classes.Mode, settings.Origins.Mode, campaign.ID).Error; err != nil {
			return err
		}
		for _, id := range settings.Classes.AllowedIDs {
			if err := tx.Exec("INSERT INTO ordem.campaign_allowed_class(campaign_id,rpg_system_id,class_id) VALUES (?,?,?)", campaign.ID, campaign.SystemID, id).Error; err != nil {
				return err
			}
		}
		for _, id := range settings.Origins.AllowedIDs {
			if err := tx.Exec("INSERT INTO ordem.campaign_allowed_origin(campaign_id,rpg_system_id,origin_id) VALUES (?,?,?)", campaign.ID, campaign.SystemID, id).Error; err != nil {
				return err
			}
		}
		if err := tx.Exec("DELETE FROM ordem.campaign_supplement WHERE campaign_id=?", campaign.ID).Error; err != nil {
			return err
		}
		return r.writeSupplement(tx, campaign.ID, settings.Supplement)
	})
	if err != nil {
		return domain.Campaign{}, fmt.Errorf("update campaign settings: %w", err)
	}
	return r.Campaign(ctx, campaign.ID)
}
func contains(values []string, candidate string) bool {
	for _, value := range values {
		if value == candidate {
			return true
		}
	}
	return false
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
	var supplements []struct{ CampaignID, SupplementID string }
	if err := r.DB.WithContext(ctx).Table("ordem.campaign_supplement").Select("campaign_id, supplement_id").Where("campaign_id IN ?", ids).Scan(&supplements).Error; err != nil {
		return fmt.Errorf("read campaign supplements: %w", err)
	}
	for _, row := range supplements {
		campaigns[index[row.CampaignID]].Settings.Supplement = &domain.SupplementSettings{ID: row.SupplementID, Categories: []string{}, RuleIDs: []string{}}
	}
	var categories []struct{ CampaignID, Category string }
	if err := r.DB.WithContext(ctx).Table("ordem.campaign_supplement_category").Select("campaign_id, category").Where("campaign_id IN ?", ids).Scan(&categories).Error; err != nil {
		return fmt.Errorf("read campaign supplement categories: %w", err)
	}
	for _, row := range categories {
		campaigns[index[row.CampaignID]].Settings.Supplement.Categories = append(campaigns[index[row.CampaignID]].Settings.Supplement.Categories, row.Category)
	}
	var rules []struct{ CampaignID, RuleID string }
	if err := r.DB.WithContext(ctx).Table("ordem.campaign_supplement_rule").Select("campaign_id, rule_id").Where("campaign_id IN ?", ids).Scan(&rules).Error; err != nil {
		return fmt.Errorf("read campaign supplement rules: %w", err)
	}
	for _, row := range rules {
		campaigns[index[row.CampaignID]].Settings.Supplement.RuleIDs = append(campaigns[index[row.CampaignID]].Settings.Supplement.RuleIDs, row.RuleID)
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
		if err := tx.Exec("INSERT INTO ordem.character_supplement(character_id,supplement_id) SELECT sh.character_id,cs.supplement_id FROM core.character_sheet sh JOIN core.rpg_character c ON c.id=sh.character_id JOIN ordem.campaign_supplement cs ON cs.campaign_id=c.campaign_id WHERE c.campaign_id=? ON CONFLICT (character_id) DO NOTHING", id).Error; err != nil {
			return err
		}
		if err := tx.Exec("INSERT INTO ordem.character_supplement_rule(character_id,rule_id) SELECT sh.character_id,cr.rule_id FROM core.character_sheet sh JOIN core.rpg_character c ON c.id=sh.character_id JOIN ordem.campaign_supplement_rule cr ON cr.campaign_id=c.campaign_id WHERE c.campaign_id=? ON CONFLICT DO NOTHING", id).Error; err != nil {
			return err
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
