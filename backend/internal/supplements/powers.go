package supplements

import (
	"context"
	"errors"
	"fmt"

	"RPG-manager/backend/internal/apperr"
	"RPG-manager/backend/internal/domain"
	"gorm.io/gorm"
)

type Power struct {
	ID                  string   `json:"id"`
	Name                string   `json:"name"`
	AbilityType         string   `json:"abilityType"`
	EffectText          string   `json:"effectText"`
	PrerequisiteText    *string  `json:"prerequisiteText"`
	AffinityEffect      *string  `json:"affinityEffect"`
	SourcePage          int      `json:"sourcePage"`
	RequiredProgression *float64 `json:"requiredProgression"`
	Selected            bool     `json:"selected"`
}

func (s *Service) Powers(ctx context.Context, supplementID, characterID string, d domain.OrdemData, allowPowers, allowTrails bool) ([]Power, error) {
	out := []Power{}
	if supplementID == "" || (!allowPowers && !allowTrails) {
		return out, nil
	}
	var rows []Power
	err := s.db.WithContext(ctx).Table("core.ability_definition AS a").Select(`a.id, a.name, a.ability_type, COALESCE(ad.effect_text,a.description,'') AS effect_text,
		ad.prerequisite_text, ad.affinity_effect, COALESCE(a.supplement_page_start, ac.source_page) AS source_page`).
		Joins("LEFT JOIN ordem.supplement_ability_detail AS ad ON ad.ability_id=a.id").
		Joins("LEFT JOIN ordem.supplement_ability_classification AS ac ON ac.ability_id=a.id AND ac.supplement_id=?", supplementID).
		Where("(a.supplement_id=? OR ac.supplement_id=?) AND a.ability_type NOT IN ('RITUAL','ORIGIN_POWER')", supplementID, supplementID).
		Order("a.name").Scan(&rows).Error
	if err != nil {
		return nil, fmt.Errorf("supplement powers: %w", err)
	}
	hidden, err := s.HiddenTargets(ctx, supplementID, []string{"ability", "ability_detail"})
	if err != nil {
		return nil, err
	}
	var selectedIDs []string
	if err := s.db.WithContext(ctx).Table("core.character_ability").Select("ability_id").Where("character_id=?", characterID).Scan(&selectedIDs).Error; err != nil {
		return nil, err
	}
	selected := map[string]bool{}
	for _, id := range selectedIDs {
		selected[id] = true
	}
	for _, row := range rows {
		if hidden[row.ID] {
			continue
		}
		if row.AbilityType == "TRAIL_ABILITY" {
			if !allowTrails || d.TrailID == nil {
				continue
			}
			var unlock struct{ RequiredProgression float64 }
			err := s.db.WithContext(ctx).Table("core.archetype_ability_unlock").Select("required_progression").Where("archetype_id=? AND ability_id=?", *d.TrailID, row.ID).Take(&unlock).Error
			if errors.Is(err, gorm.ErrRecordNotFound) {
				continue
			}
			if err != nil {
				return nil, err
			}
			row.RequiredProgression = &unlock.RequiredProgression
		} else if row.AbilityType == "CLASS_POWER" {
			if !allowPowers || d.ClassID == "" {
				continue
			}
			var unlock struct{ RequiredProgression float64 }
			err := s.db.WithContext(ctx).Table("core.class_ability_unlock").Select("required_progression").Where("class_id=? AND ability_id=?", d.ClassID, row.ID).Take(&unlock).Error
			if errors.Is(err, gorm.ErrRecordNotFound) {
				continue
			}
			if err != nil {
				return nil, err
			}
			row.RequiredProgression = &unlock.RequiredProgression
		} else if !allowPowers {
			continue
		}
		row.Selected = selected[row.ID]
		out = append(out, row)
	}
	return out, nil
}

func (s *Service) SetPower(ctx context.Context, supplementID, characterID string, d domain.OrdemData, allowPowers, allowTrails bool, powerID string, selected bool) error {
	available, err := s.Powers(ctx, supplementID, characterID, d, allowPowers, allowTrails)
	if err != nil {
		return err
	}
	var power *Power
	for i := range available {
		if available[i].ID == powerID {
			power = &available[i]
			break
		}
	}
	if power == nil {
		return apperr.ErrCampaignRestriction
	}
	if selected == power.Selected {
		return nil
	}
	if selected {
		progression := d.NEX
		if d.ProgressionMode == "level-nex" && d.Level != nil {
			progression = *d.Level * 5
		}
		if power.RequiredProgression != nil && float64(progression) < *power.RequiredProgression {
			return apperr.ErrCampaignRestriction
		}
		return s.db.WithContext(ctx).Exec("INSERT INTO core.character_ability(character_id,ability_id,rpg_system_id) SELECT ?,?,c.rpg_system_id FROM core.rpg_character c WHERE c.id=?", characterID, powerID, characterID).Error
	}
	return s.db.WithContext(ctx).Exec("DELETE FROM core.character_ability WHERE character_id=? AND ability_id=?", characterID, powerID).Error
}
