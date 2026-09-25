package repository

import (
	"context"
	"fmt"

	"RPG-manager/backend/internal/domain"

	"gorm.io/gorm"
)

type skillRow struct {
	ID              string
	Name            string
	Slug            string
	AttributeID     string
	AttributeSlug   string
	TrainingLevelID *string
	TrainingName    *string
	TrainingBonus   int
	OtherBonus      int
}

func (s *Store) Skills(ctx context.Context, characterID, systemID string, attrs domain.Attributes) ([]domain.Skill, error) {
	var rows []skillRow
	err := s.DB.WithContext(ctx).Table("core.skill_definition AS sd").Select(`sd.id, sd.name, sd.slug,
		COALESCE(cs.attribute_id, sd.base_attribute_id) AS attribute_id,
		ad.slug AS attribute_slug, cs.training_level_id, tl.name AS training_name,
		COALESCE(tl.bonus, 0)::int AS training_bonus, COALESCE(cs.other_bonus, 0)::int AS other_bonus`).
		Joins("LEFT JOIN core.character_skill AS cs ON cs.skill_id=sd.id AND cs.character_id=?", characterID).
		Joins("LEFT JOIN core.attribute_definition AS ad ON ad.id=COALESCE(cs.attribute_id, sd.base_attribute_id)").
		Joins("LEFT JOIN core.skill_training_level AS tl ON tl.id=cs.training_level_id").
		Where("sd.rpg_system_id = ?", systemID).Order("sd.sort_order, sd.name").Scan(&rows).Error
	if err != nil {
		return nil, fmt.Errorf("list skills: %w", err)
	}
	out := make([]domain.Skill, 0, len(rows))
	for _, row := range rows {
		name := "Leigo"
		if row.TrainingName != nil {
			name = *row.TrainingName
		}
		value := attributeValue(row.AttributeSlug, attrs)
		count, keep := value, "highest"
		if count == 0 {
			count = 2
			keep = "lowest"
		}
		out = append(out, domain.Skill{ID: row.ID, Name: row.Name, Slug: row.Slug, AttributeID: row.AttributeID, AttributeSlug: row.AttributeSlug, TrainingLevelID: row.TrainingLevelID, TrainingName: name, TrainingBonus: row.TrainingBonus, OtherBonus: row.OtherBonus, Bonus: row.TrainingBonus + row.OtherBonus, DiceCount: count, Keep: keep})
	}
	return out, nil
}

func attributeValue(slug string, a domain.Attributes) int {
	switch slug {
	case "agilidade":
		return a.Agility
	case "forca":
		return a.Strength
	case "intelecto":
		return a.Intellect
	case "presenca":
		return a.Presence
	case "vigor":
		return a.Vigor
	default:
		return 0
	}
}

func (s *Store) UpdateSkills(ctx context.Context, characterID, systemID string, updates []domain.SkillUpdate) error {
	return s.DB.WithContext(ctx).Transaction(func(tx *gorm.DB) error {
		for _, u := range updates {
			var skillCount, attrCount, levelCount int64
			if err := tx.Table("core.skill_definition").Where("id=? AND rpg_system_id=?", u.ID, systemID).Count(&skillCount).Error; err != nil {
				return err
			}
			if err := tx.Table("core.attribute_definition").Where("id=? AND rpg_system_id=?", u.AttributeID, systemID).Count(&attrCount).Error; err != nil {
				return err
			}
			if u.TrainingLevelID != nil {
				if err := tx.Table("core.skill_training_level").Where("id=? AND rpg_system_id=?", *u.TrainingLevelID, systemID).Count(&levelCount).Error; err != nil {
					return err
				}
			} else {
				levelCount = 1
			}
			if skillCount != 1 || attrCount != 1 || levelCount != 1 {
				return ErrNotFound
			}
			if err := tx.Exec(`INSERT INTO core.character_skill(character_id, skill_id, training_level_id, other_bonus, attribute_id, rpg_system_id)
				VALUES (?, ?, ?, ?, ?, ?) ON CONFLICT (character_id, skill_id) DO UPDATE
				SET training_level_id=EXCLUDED.training_level_id, other_bonus=EXCLUDED.other_bonus, attribute_id=EXCLUDED.attribute_id`, characterID, u.ID, u.TrainingLevelID, u.OtherBonus, u.AttributeID, systemID).Error; err != nil {
				return err
			}
		}
		return nil
	})
}
