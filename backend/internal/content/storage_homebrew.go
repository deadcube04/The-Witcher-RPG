package content

import (
	"RPG-manager/backend/internal/apperr"
	"context"
	"encoding/json"
	"fmt"
	"strings"

	"RPG-manager/backend/internal/domain"

	"gorm.io/gorm"
)

func itemTypeSlug(kind string) string {
	switch kind {
	case "weapon":
		return "arma"
	case "protection":
		return "protecao"
	case "ammunition":
		return "municao"
	case "accessory":
		return "acessorio"
	case "equipment":
		return "item-operacional"
	case "paranormal":
		return "item-paranormal"
	default:
		return "equipamento-geral"
	}
}
func (s *Repository) homebrewItem(ctx context.Context, id string) (InventoryDefinition, error) {
	systemID, err := s.OrdemSystemID(ctx)
	if err != nil {
		return InventoryDefinition{}, err
	}
	items, err := s.InventoryCatalog(ctx, systemID, "", "")
	if err != nil {
		return InventoryDefinition{}, err
	}
	for _, item := range items {
		if item.ID == id {
			return item, nil
		}
	}
	return InventoryDefinition{}, apperr.ErrNotFound
}

func (s *Repository) InventoryDefinition(ctx context.Context, id string) (InventoryDefinition, error) {
	return s.homebrewItem(ctx, id)
}
func (s *Repository) CreateInventoryHomebrew(ctx context.Context, in domain.InventoryInput) (InventoryDefinition, error) {
	systemID, err := s.OrdemSystemID(ctx)
	if err != nil {
		return InventoryDefinition{}, err
	}
	var id string
	err = s.DB.WithContext(ctx).Transaction(func(tx *gorm.DB) error {
		var typeID string
		if err := tx.Table("core.item_type").Select("id").Where("rpg_system_id=? AND slug=?", systemID, itemTypeSlug(in.Kind)).Scan(&typeID).Error; err != nil {
			return err
		}
		if typeID == "" {
			return apperr.ErrNotFound
		}
		if err := tx.Raw(`INSERT INTO core.item_definition(rpg_system_id,item_type_id,name,slug,description,owner_user_id,created_at,updated_at)
			VALUES (?,?,?,'homebrew-'||gen_random_uuid()::text,?,?,now(),now()) RETURNING id`, systemID, typeID, in.Name, in.Description, s.UserID).Scan(&id).Error; err != nil {
			return err
		}
		return writeItemDetails(tx, id, in)
	})
	if err != nil {
		return InventoryDefinition{}, fmt.Errorf("create inventory homebrew: %w", err)
	}
	return s.homebrewItem(ctx, id)
}
func writeItemDetails(tx *gorm.DB, id string, in domain.InventoryInput) error {
	if err := tx.Exec("INSERT INTO ordem.item_rule(item_id,inventory_category,spaces) VALUES (?,?,?)", id, in.Category, in.Spaces).Error; err != nil {
		return err
	}
	if in.Kind == "weapon" {
		critical := fmt.Sprintf("%d/x%d", in.CriticalThreshold, in.CriticalMultiplier)
		if err := tx.Exec(`INSERT INTO ordem.weapon(item_id,weapon_kind,damage,critical,range_text,damage_type)
			VALUES (?,'MELEE',?,?,?,?)`, id, in.DamageExpression, critical, in.RangeText, in.DamageType).Error; err != nil {
			return err
		}
	}
	return nil
}
func (s *Repository) UpdateInventoryHomebrew(ctx context.Context, id string, in domain.InventoryInput) (InventoryDefinition, error) {
	systemID, err := s.OrdemSystemID(ctx)
	if err != nil {
		return InventoryDefinition{}, err
	}
	err = s.DB.WithContext(ctx).Transaction(func(tx *gorm.DB) error {
		var count int64
		if err := tx.Table("core.item_definition").Where("id=? AND owner_user_id=?", id, s.UserID).Count(&count).Error; err != nil {
			return err
		}
		if count != 1 {
			return apperr.ErrNotFound
		}
		var typeID string
		if err := tx.Table("core.item_type").Select("id").Where("rpg_system_id=? AND slug=?", systemID, itemTypeSlug(in.Kind)).Scan(&typeID).Error; err != nil {
			return err
		}
		if err := tx.Table("core.item_definition").Where("id=?", id).Updates(map[string]any{"name": in.Name, "description": in.Description, "item_type_id": typeID, "updated_at": gorm.Expr("now()")}).Error; err != nil {
			return err
		}
		if err := tx.Exec("DELETE FROM ordem.weapon WHERE item_id=?", id).Error; err != nil {
			return err
		}
		if err := tx.Exec("DELETE FROM ordem.item_rule WHERE item_id=?", id).Error; err != nil {
			return err
		}
		return writeItemDetails(tx, id, in)
	})
	if err != nil {
		return InventoryDefinition{}, fmt.Errorf("update inventory homebrew: %w", err)
	}
	return s.homebrewItem(ctx, id)
}
func (s *Repository) DeleteInventoryHomebrew(ctx context.Context, id string) error {
	return s.DB.WithContext(ctx).Transaction(func(tx *gorm.DB) error {
		var count int64
		if err := tx.Table("core.item_definition").Where("id=? AND owner_user_id=?", id, s.UserID).Count(&count).Error; err != nil {
			return err
		}
		if count != 1 {
			return apperr.ErrNotFound
		}
		if err := tx.Table("core.character_item").Where("item_id=?", id).Count(&count).Error; err != nil {
			return err
		}
		if count > 0 {
			return apperr.ErrInUse
		}
		if err := tx.Table("ordem.attack_definition").Where("source_item_id=?", id).Count(&count).Error; err != nil {
			return err
		}
		if count > 0 {
			return apperr.ErrInUse
		}
		if err := tx.Exec("DELETE FROM ordem.weapon WHERE item_id=?", id).Error; err != nil {
			return err
		}
		if err := tx.Exec("DELETE FROM ordem.item_rule WHERE item_id=?", id).Error; err != nil {
			return err
		}
		return tx.Exec("DELETE FROM core.item_definition WHERE id=? AND owner_user_id=?", id, s.UserID).Error
	})
}

func (s *Repository) homebrewRitual(ctx context.Context, id string) (RitualDefinition, error) {
	systemID, err := s.OrdemSystemID(ctx)
	if err != nil {
		return RitualDefinition{}, err
	}
	items, err := s.RitualCatalog(ctx, systemID, "", "")
	if err != nil {
		return RitualDefinition{}, err
	}
	for _, item := range items {
		if item.ID == id {
			return item, nil
		}
	}
	return RitualDefinition{}, apperr.ErrNotFound
}

func (s *Repository) RitualDefinition(ctx context.Context, id string) (RitualDefinition, error) {
	return s.homebrewRitual(ctx, id)
}
func (s *Repository) CreateRitualHomebrew(ctx context.Context, in domain.RitualInput) (RitualDefinition, error) {
	systemID, err := s.OrdemSystemID(ctx)
	if err != nil {
		return RitualDefinition{}, err
	}
	var id string
	err = s.DB.WithContext(ctx).Transaction(func(tx *gorm.DB) error {
		if err := tx.Raw(`INSERT INTO core.ability_definition(rpg_system_id,name,slug,ability_type,description,is_active,owner_user_id,created_at,updated_at)
			VALUES (?,?,'homebrew-'||gen_random_uuid()::text,'RITUAL',?,true,?,now(),now()) RETURNING id`, systemID, in.Name, in.Description, s.UserID).Scan(&id).Error; err != nil {
			return err
		}
		return writeRitualDetails(tx, id, in)
	})
	if err != nil {
		return RitualDefinition{}, fmt.Errorf("create ritual homebrew: %w", err)
	}
	return s.homebrewRitual(ctx, id)
}
func writeRitualDetails(tx *gorm.DB, id string, in domain.RitualInput) error {
	var elementID string
	if err := tx.Table("ordem.element").Select("id").Where("slug=?", elementToPortuguese(in.Element)).Scan(&elementID).Error; err != nil {
		return err
	}
	if elementID == "" {
		return apperr.ErrNotFound
	}
	if err := tx.Exec(`INSERT INTO ordem.ritual(ability_id,element_id,circle,pe_cost,execution,range_text,target_text,area_text,duration_text,resistance_text)
		VALUES (?,?,?,?,?,?,?,?,?,?)`, id, elementID, in.Circle, in.Tiers["normal"].PECost, in.Execution, in.RangeText, in.TargetText, in.AreaText, in.DurationText, in.ResistanceText).Error; err != nil {
		return err
	}
	for _, tier := range []string{"normal", "discente", "verdadeiro"} {
		v := in.Tiers[tier]
		rolls := v.Rolls
		if len(rolls) == 0 {
			rolls = json.RawMessage("[]")
		}
		if err := tx.Exec("INSERT INTO ordem.ritual_tier(ability_id,tier,pe_cost,effect,rolls) VALUES (?,?,?,?,?::jsonb)", id, tier, v.PECost, v.Effect, string(rolls)).Error; err != nil {
			return err
		}
	}
	return nil
}
func (s *Repository) UpdateRitualHomebrew(ctx context.Context, id string, in domain.RitualInput) (RitualDefinition, error) {
	err := s.DB.WithContext(ctx).Transaction(func(tx *gorm.DB) error {
		var count int64
		if err := tx.Table("core.ability_definition").Where("id=? AND owner_user_id=?", id, s.UserID).Count(&count).Error; err != nil {
			return err
		}
		if count != 1 {
			return apperr.ErrNotFound
		}
		if err := tx.Table("core.ability_definition").Where("id=?", id).Updates(map[string]any{"name": in.Name, "description": in.Description, "updated_at": gorm.Expr("now()")}).Error; err != nil {
			return err
		}
		if err := tx.Exec("DELETE FROM ordem.ritual_tier WHERE ability_id=?", id).Error; err != nil {
			return err
		}
		if err := tx.Exec("DELETE FROM ordem.ritual WHERE ability_id=?", id).Error; err != nil {
			return err
		}
		return writeRitualDetails(tx, id, in)
	})
	if err != nil {
		return RitualDefinition{}, fmt.Errorf("update ritual homebrew: %w", err)
	}
	return s.homebrewRitual(ctx, id)
}
func (s *Repository) DeleteRitualHomebrew(ctx context.Context, id string) error {
	return s.DB.WithContext(ctx).Transaction(func(tx *gorm.DB) error {
		var count int64
		if err := tx.Table("core.ability_definition").Where("id=? AND owner_user_id=?", id, s.UserID).Count(&count).Error; err != nil {
			return err
		}
		if count != 1 {
			return apperr.ErrNotFound
		}
		if err := tx.Table("core.character_ability").Where("ability_id=?", id).Count(&count).Error; err != nil {
			return err
		}
		if count > 0 {
			return apperr.ErrInUse
		}
		if err := tx.Exec("DELETE FROM ordem.ritual_tier WHERE ability_id=?", id).Error; err != nil {
			return err
		}
		if err := tx.Exec("DELETE FROM ordem.ritual WHERE ability_id=?", id).Error; err != nil {
			return err
		}
		return tx.Exec("DELETE FROM core.ability_definition WHERE id=? AND owner_user_id=?", id, s.UserID).Error
	})
}

func (s *Repository) homebrewAttack(ctx context.Context, id string) (AttackDefinition, error) {
	systemID, err := s.OrdemSystemID(ctx)
	if err != nil {
		return AttackDefinition{}, err
	}
	items, err := s.AttackCatalog(ctx, systemID, "", "")
	if err != nil {
		return AttackDefinition{}, err
	}
	for _, item := range items {
		if item.ID == id {
			return item, nil
		}
	}
	return AttackDefinition{}, apperr.ErrNotFound
}

func (s *Repository) AttackDefinition(ctx context.Context, id string) (AttackDefinition, error) {
	return s.homebrewAttack(ctx, id)
}
func (s *Repository) attackSkillID(tx *gorm.DB, in domain.AttackInput, systemID string) (string, error) {
	var id string
	if in.SkillID != nil {
		id = *in.SkillID
		var count int64
		if err := tx.Table("core.skill_definition").Where("id=? AND rpg_system_id=?", id, systemID).Count(&count).Error; err != nil {
			return "", err
		}
		if count != 1 {
			return "", apperr.ErrNotFound
		}
		return id, nil
	}
	if err := tx.Table("core.skill_definition").Select("id").Where("name=? AND rpg_system_id=?", strings.TrimSpace(in.SkillName), systemID).Scan(&id).Error; err != nil {
		return "", err
	}
	if id == "" {
		return "", apperr.ErrNotFound
	}
	return id, nil
}
func (s *Repository) CreateAttackHomebrew(ctx context.Context, in domain.AttackInput) (AttackDefinition, error) {
	systemID, err := s.OrdemSystemID(ctx)
	if err != nil {
		return AttackDefinition{}, err
	}
	var id string
	err = s.DB.WithContext(ctx).Transaction(func(tx *gorm.DB) error {
		skillID, err := s.attackSkillID(tx, in, systemID)
		if err != nil {
			return err
		}
		return tx.Raw(`INSERT INTO ordem.attack_definition(rpg_system_id,owner_user_id,source_item_id,skill_id,name,description,test_expression,damage_expression,damage_type,critical_threshold,critical_multiplier,range_text,special,created_at,updated_at)
			VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,now(),now()) RETURNING id`, systemID, s.UserID, in.SourceItemDefinitionID, skillID, in.Name, in.Description, in.TestExpression, in.DamageExpression, in.DamageType, in.CriticalThreshold, in.CriticalMultiplier, in.RangeText, in.Special).Scan(&id).Error
	})
	if err != nil {
		return AttackDefinition{}, fmt.Errorf("create attack homebrew: %w", err)
	}
	return s.homebrewAttack(ctx, id)
}
func (s *Repository) UpdateAttackHomebrew(ctx context.Context, id string, in domain.AttackInput) (AttackDefinition, error) {
	systemID, err := s.OrdemSystemID(ctx)
	if err != nil {
		return AttackDefinition{}, err
	}
	err = s.DB.WithContext(ctx).Transaction(func(tx *gorm.DB) error {
		var count int64
		if err := tx.Table("ordem.attack_definition").Where("id=? AND owner_user_id=?", id, s.UserID).Count(&count).Error; err != nil {
			return err
		}
		if count != 1 {
			return apperr.ErrNotFound
		}
		skillID, err := s.attackSkillID(tx, in, systemID)
		if err != nil {
			return err
		}
		return tx.Table("ordem.attack_definition").Where("id=?", id).Updates(map[string]any{"source_item_id": in.SourceItemDefinitionID, "skill_id": skillID, "name": in.Name, "description": in.Description, "test_expression": in.TestExpression, "damage_expression": in.DamageExpression, "damage_type": in.DamageType, "critical_threshold": in.CriticalThreshold, "critical_multiplier": in.CriticalMultiplier, "range_text": in.RangeText, "special": in.Special, "updated_at": gorm.Expr("now()")}).Error
	})
	if err != nil {
		return AttackDefinition{}, fmt.Errorf("update attack homebrew: %w", err)
	}
	return s.homebrewAttack(ctx, id)
}
func (s *Repository) DeleteAttackHomebrew(ctx context.Context, id string) error {
	return s.DB.WithContext(ctx).Transaction(func(tx *gorm.DB) error {
		var count int64
		if err := tx.Table("ordem.attack_definition").Where("id=? AND owner_user_id=?", id, s.UserID).Count(&count).Error; err != nil {
			return err
		}
		if count != 1 {
			return apperr.ErrNotFound
		}
		if err := tx.Table("core.character_attack").Where("definition_id=?", id).Count(&count).Error; err != nil {
			return err
		}
		if count > 0 {
			return apperr.ErrInUse
		}
		return tx.Exec("DELETE FROM ordem.attack_definition WHERE id=? AND owner_user_id=?", id, s.UserID).Error
	})
}
