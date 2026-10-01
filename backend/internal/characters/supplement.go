package characters

import (
	"context"
	"errors"
	"fmt"

	"RPG-manager/backend/internal/apperr"
	"RPG-manager/backend/internal/domain"
	"RPG-manager/backend/internal/supplements"

	"gorm.io/gorm"
)

type supplementAccess struct {
	ID         string
	Categories map[string]bool
	Rules      map[string]bool
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

func (r *Repository) SupplementAccess(ctx context.Context, systemID string, campaignID, standaloneID *string, ruleIDs []string) (supplementAccess, error) {
	out := supplementAccess{Categories: map[string]bool{}, Rules: map[string]bool{}}
	if campaignID != nil {
		if standaloneID != nil || len(ruleIDs) > 0 {
			return out, apperr.ErrInvalid
		}
		if err := r.DB.WithContext(ctx).Table("ordem.campaign_supplement AS cs").Select("cs.supplement_id").Joins("JOIN core.campaign AS c ON c.id=cs.campaign_id").Where("cs.campaign_id=? AND c.owner_user_id=? AND c.rpg_system_id=?", *campaignID, r.UserID, systemID).Scan(&out.ID).Error; err != nil {
			return out, err
		}
		if out.ID == "" {
			return out, nil
		}
		var categories []string
		if err := r.DB.WithContext(ctx).Table("ordem.campaign_supplement_category").Select("category").Where("campaign_id=?", *campaignID).Scan(&categories).Error; err != nil {
			return out, err
		}
		for _, category := range categories {
			out.Categories[category] = true
		}
		var rules []string
		if err := r.DB.WithContext(ctx).Table("ordem.campaign_supplement_rule AS cr").Select("sr.slug").Joins("JOIN ordem.supplement_rule AS sr ON sr.id=cr.rule_id").Where("cr.campaign_id=?", *campaignID).Scan(&rules).Error; err != nil {
			return out, err
		}
		for _, rule := range rules {
			out.Rules[rule] = true
		}
		return out, nil
	}
	if standaloneID == nil {
		if len(ruleIDs) > 0 {
			return out, apperr.ErrInvalid
		}
		return out, nil
	}
	if err := r.DB.WithContext(ctx).Table("core.rpg_supplement").Select("id").Where("id=? AND rpg_system_id=?", *standaloneID, systemID).Scan(&out.ID).Error; err != nil {
		return out, err
	}
	if out.ID == "" {
		return out, apperr.ErrInvalid
	}
	for _, category := range []string{"survivor", "trails", "powers", "rituals", "items", "modifications", "threats"} {
		out.Categories[category] = true
	}
	if len(ruleIDs) > 0 {
		var rows []struct {
			ID       string
			ParentID *string
			Slug     string
			Optional bool `gorm:"column:is_optional"`
		}
		if err := r.DB.WithContext(ctx).Table("ordem.supplement_rule").Select("id, parent_id, slug, is_optional").Where("supplement_id=? AND id IN ? AND is_optional=true", out.ID, ruleIDs).Scan(&rows).Error; err != nil {
			return out, err
		}
		if len(rows) != len(ruleIDs) {
			return out, apperr.ErrInvalid
		}
		chosen := map[string]bool{}
		for _, row := range rows {
			if chosen[row.ID] {
				return out, apperr.ErrInvalid
			}
			chosen[row.ID] = true
			out.Rules[row.Slug] = true
		}
		for _, row := range rows {
			if row.ParentID == nil || chosen[*row.ParentID] {
				continue
			}
			var parent struct {
				Optional bool `gorm:"column:is_optional"`
			}
			if err := r.DB.WithContext(ctx).Table("ordem.supplement_rule").Select("is_optional").Where("id=? AND supplement_id=?", *row.ParentID, out.ID).Take(&parent).Error; err != nil {
				return out, err
			}
			if parent.Optional {
				return out, apperr.ErrInvalid
			}
		}
		if out.Rules["evolucao-por-patentes"] && !out.Rules["jogando-sem-sanidade"] {
			return out, apperr.ErrInvalid
		}
		var dependencies []struct{ SourceRuleID, TargetRuleID string }
		if err := r.DB.WithContext(ctx).Table("ordem.supplement_rule_relation").Select("source_rule_id, target_rule_id").Where("supplement_id=? AND relation_kind='requires' AND source_rule_id IN ?", out.ID, ruleIDs).Scan(&dependencies).Error; err != nil {
			return out, err
		}
		for _, dep := range dependencies {
			if !chosen[dep.TargetRuleID] {
				return out, apperr.ErrInvalid
			}
		}
	}
	return out, nil
}

func (r *Repository) OriginSupplement(ctx context.Context, originID string) (string, error) {
	var id string
	err := r.DB.WithContext(ctx).Table("core.origin_definition").Select("supplement_id").Where("id=?", originID).Scan(&id).Error
	return id, err
}

type survivorRule struct{ InitialPV, InitialPE, InitialSAN, PVPerStage, PEPerStage, SANPerStage int }

func (r *Repository) SurvivorRule(ctx context.Context, classID, supplementID string) (survivorRule, error) {
	var row survivorRule
	err := r.DB.WithContext(ctx).Table("ordem.supplement_survivor_class").Select("initial_pv, initial_pe, initial_san, pv_per_stage, pe_per_stage, san_per_stage").Where("id=? AND supplement_id=?", classID, supplementID).Take(&row).Error
	if errors.Is(err, gorm.ErrRecordNotFound) {
		return row, apperr.ErrNotFound
	}
	return row, err
}

func (r *Repository) SupplementDefinitionAllowed(ctx context.Context, character domain.Character, table, id, category string) error {
	if table != "core.item_definition" && table != "core.ability_definition" && table != "core.origin_definition" && table != "core.archetype_definition" {
		return apperr.ErrInvalid
	}
	var row struct{ SupplementID *string }
	if err := r.DB.WithContext(ctx).Table(table).Select("supplement_id").Where("id=? AND rpg_system_id=?", id, character.SystemID).Take(&row).Error; err != nil {
		return err
	}
	if row.SupplementID == nil {
		return nil
	}
	access, err := r.SupplementAccess(ctx, character.SystemID, character.CampaignID, character.SupplementID, character.SupplementRuleIDs)
	if err != nil {
		return err
	}
	if access.ID != *row.SupplementID || (category != "" && !access.Categories[category]) {
		return apperr.ErrCampaignRestriction
	}
	var unresolved int64
	kinds := []string{category}
	switch table {
	case "core.item_definition":
		kinds = []string{"item", "item_detail"}
	case "core.ability_definition":
		kinds = []string{"ability", "ability_detail", "ritual"}
	case "core.origin_definition":
		kinds = []string{"origin"}
	case "core.archetype_definition":
		kinds = []string{"trail"}
	}
	if err := r.DB.WithContext(ctx).Table("ordem.supplement_review_target AS t").Joins("JOIN ordem.supplement_review_issue AS i ON i.id=t.issue_id").Where("i.resolved=false AND i.supplement_id=? AND t.target_id=? AND t.target_kind IN ?", *row.SupplementID, id, kinds).Count(&unresolved).Error; err != nil {
		return err
	}
	if unresolved > 0 {
		return apperr.ErrCampaignRestriction
	}
	return nil
}

func (r *Repository) ExistingSupplementContentAllowed(ctx context.Context, characterID string, access supplementAccess) error {
	checks := []struct{ query, category string }{
		{"SELECT DISTINCT d.supplement_id FROM core.character_item ci JOIN core.item_definition d ON d.id=ci.item_id WHERE ci.character_id=? AND d.supplement_id IS NOT NULL", "items"},
		{"SELECT DISTINCT d.supplement_id FROM core.character_attack ca JOIN core.item_definition d ON d.id=ca.source_item_id WHERE ca.character_id=? AND d.supplement_id IS NOT NULL", "items"},
		{"SELECT DISTINCT m.supplement_id FROM core.character_item ci JOIN ordem.character_item_modification cm ON cm.inventory_entry_id=ci.id JOIN ordem.item_modification m ON m.id=cm.modification_id WHERE ci.character_id=?", "modifications"},
		{"SELECT DISTINCT d.supplement_id FROM core.character_ability ca JOIN core.ability_definition d ON d.id=ca.ability_id JOIN ordem.ritual rt ON rt.ability_id=d.id WHERE ca.character_id=? AND d.supplement_id IS NOT NULL", "rituals"},
		{"SELECT DISTINCT d.supplement_id FROM core.character_ability ca JOIN core.ability_definition d ON d.id=ca.ability_id WHERE ca.character_id=? AND d.supplement_id IS NOT NULL AND d.ability_type='TRAIL_ABILITY'", "trails"},
		{"SELECT DISTINCT d.supplement_id FROM core.character_ability ca JOIN core.ability_definition d ON d.id=ca.ability_id WHERE ca.character_id=? AND d.supplement_id IS NOT NULL AND d.ability_type NOT IN ('TRAIL_ABILITY','RITUAL')", "powers"},
		{"SELECT DISTINCT sc.supplement_id FROM core.character_ability ca JOIN ordem.supplement_ability_classification sc ON sc.ability_id=ca.ability_id WHERE ca.character_id=?", "powers"},
	}
	for _, check := range checks {
		var ids []string
		if err := r.DB.WithContext(ctx).Raw(check.query, characterID).Scan(&ids).Error; err != nil {
			return err
		}
		for _, id := range ids {
			if id != access.ID || !access.Categories[check.category] {
				return apperr.ErrInUse
			}
		}
	}
	return nil
}

func (r *Repository) SurvivorTrailValid(ctx context.Context, trailID, classID, supplementID string) (bool, error) {
	var count int64
	err := r.DB.WithContext(ctx).Table("ordem.supplement_survivor_trail").Where("id=? AND class_id=? AND supplement_id=?", trailID, classID, supplementID).Count(&count).Error
	return count == 1, err
}

func (r *Repository) ClassSlug(ctx context.Context, classID string) (string, error) {
	var slug string
	if err := r.DB.WithContext(ctx).Table("core.class_definition").Select("slug").Where("id=?", classID).Scan(&slug).Error; err != nil {
		return "", fmt.Errorf("class slug: %w", err)
	}
	if slug == "" {
		return "", apperr.ErrNotFound
	}
	return slug, nil
}

func (r *Repository) Trail(ctx context.Context, trailID, classID, systemID string) (string, error) {
	var row struct{ SupplementID *string }
	err := r.DB.WithContext(ctx).Table("core.archetype_definition").Select("supplement_id").Where("id=? AND class_id=? AND rpg_system_id=?", trailID, classID, systemID).Take(&row).Error
	if err != nil {
		return "", err
	}
	if row.SupplementID == nil {
		return "", nil
	}
	return *row.SupplementID, nil
}
