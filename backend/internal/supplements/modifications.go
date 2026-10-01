package supplements

import (
	"context"
	"errors"
	"fmt"

	"RPG-manager/backend/internal/apperr"
	"gorm.io/gorm"
)

type Modification struct {
	ID               string   `json:"id"`
	Name             string   `json:"name"`
	EffectSummary    string   `json:"effectSummary"`
	CategoryIncrease int      `json:"categoryIncrease"`
	SourcePage       int      `json:"sourcePage" gorm:"column:supplement_page_start"`
	AppliesTo        []string `json:"appliesTo" gorm:"-"`
	Selected         bool     `json:"selected"`
	Applicable       bool     `json:"applicable"`
}

func (s *Service) Modifications(ctx context.Context, characterID, entryID, supplementID string, enabled bool) ([]Modification, error) {
	var item struct {
		TypeSlug   *string
		WeaponKind *string
	}
	err := s.db.WithContext(ctx).Table("core.character_item AS ci").Select("t.slug AS type_slug, w.weapon_kind").Joins("JOIN core.character_sheet AS sh ON sh.character_id=ci.character_id").Joins("JOIN core.item_definition AS d ON d.id=ci.item_id").Joins("LEFT JOIN core.item_type AS t ON t.id=d.item_type_id").Joins("LEFT JOIN ordem.weapon AS w ON w.item_id=d.id").Where("ci.id=? AND ci.character_id=? AND sh.owner_user_id=?", entryID, characterID, s.userID).Take(&item).Error
	if errors.Is(err, gorm.ErrRecordNotFound) {
		return nil, apperr.ErrNotFound
	}
	if err != nil {
		return nil, err
	}
	out := []Modification{}
	if supplementID == "" || !enabled {
		return out, nil
	}
	var rows []Modification
	if err := s.db.WithContext(ctx).Table("ordem.item_modification").Select("id, name, effect_summary, category_increase, supplement_page_start").Where("supplement_id=?", supplementID).Order("name").Scan(&rows).Error; err != nil {
		return nil, fmt.Errorf("modifications: %w", err)
	}
	hidden, err := s.HiddenTargets(ctx, supplementID, []string{"modification"})
	if err != nil {
		return nil, err
	}
	var chosen []string
	if err := s.db.WithContext(ctx).Table("ordem.character_item_modification").Select("modification_id").Where("inventory_entry_id=?", entryID).Scan(&chosen).Error; err != nil {
		return nil, err
	}
	selected := map[string]bool{}
	for _, id := range chosen {
		selected[id] = true
	}
	for _, row := range rows {
		if hidden[row.ID] {
			continue
		}
		row.AppliesTo = []string{}
		if err := s.db.WithContext(ctx).Table("ordem.supplement_modification_applicability").Select("applies_to").Where("modification_id=?", row.ID).Scan(&row.AppliesTo).Error; err != nil {
			return nil, err
		}
		for _, kind := range row.AppliesTo {
			if kind == "ACCESSORY" && item.TypeSlug != nil && *item.TypeSlug == "acessorio" {
				row.Applicable = true
			}
			if kind == "FIREARM" && item.WeaponKind != nil && *item.WeaponKind == "FIREARM" {
				row.Applicable = true
			}
			if kind == "MELEE_PROJECTILE" && item.WeaponKind != nil && (*item.WeaponKind == "MELEE" || *item.WeaponKind == "PROJECTILE") {
				row.Applicable = true
			}
		}
		row.Selected = selected[row.ID]
		out = append(out, row)
	}
	return out, nil
}

func (s *Service) SetModification(ctx context.Context, characterID, entryID, supplementID string, enabled bool, modificationID string, selected bool) error {
	options, err := s.Modifications(ctx, characterID, entryID, supplementID, enabled)
	if err != nil {
		return err
	}
	var option *Modification
	for i := range options {
		if options[i].ID == modificationID {
			option = &options[i]
			break
		}
	}
	if option == nil || !option.Applicable {
		return apperr.ErrCampaignRestriction
	}
	if selected == option.Selected {
		return nil
	}
	if selected {
		return s.db.WithContext(ctx).Exec("INSERT INTO ordem.character_item_modification(inventory_entry_id,modification_id) VALUES (?,?)", entryID, modificationID).Error
	}
	return s.db.WithContext(ctx).Exec("DELETE FROM ordem.character_item_modification WHERE inventory_entry_id=? AND modification_id=?", entryID, modificationID).Error
}
