package characters

import (
	"RPG-manager/backend/internal/apperr"
	"context"
	"errors"
	"fmt"
	"time"

	"gorm.io/gorm"
)

type AttackEntry struct {
	ID                     string    `json:"id"`
	CharacterID            string    `json:"characterId"`
	DefinitionID           string    `json:"definitionId"`
	SourceInventoryEntryID *string   `json:"sourceInventoryEntryId"`
	Notes                  string    `json:"notes"`
	CreatedAt              time.Time `json:"createdAt"`
	UpdatedAt              time.Time `json:"updatedAt"`
}
type AttackTest struct {
	DiceCount int    `json:"diceCount"`
	Keep      string `json:"keep"`
	Bonus     int    `json:"bonus"`
}
type SourceInventory struct {
	EntryID string `json:"entryId"`
	Name    string `json:"name"`
}
type CharacterAttack struct {
	Entry           AttackEntry      `json:"entry"`
	Definition      AttackDefinition `json:"definition"`
	SourceInventory *SourceInventory `json:"sourceInventory"`
	Test            *AttackTest      `json:"test"`
}

func (s *Repository) AttackEntries(ctx context.Context, characterID string) ([]CharacterAttack, error) {
	c, err := s.Character(ctx, characterID)
	if err != nil {
		return nil, err
	}
	var rows []struct {
		ID                     string
		CharacterID            string
		DefinitionID           string
		SourceInventoryEntryID *string
		Notes                  string
		CreatedAt              time.Time
		UpdatedAt              time.Time
		InventoryName          *string
	}
	err = s.DB.WithContext(ctx).Table("core.character_attack AS ca").Select(`ca.id,ca.character_id,ca.definition_id,ca.source_inventory_entry_id,ca.notes,ca.created_at,ca.updated_at,i.name AS inventory_name`).Joins("LEFT JOIN core.character_item AS ci ON ci.id=ca.source_inventory_entry_id").Joins("LEFT JOIN core.item_definition AS i ON i.id=ci.item_id").Where("ca.character_id=? AND ca.definition_id IS NOT NULL", characterID).Order("ca.created_at,ca.id").Scan(&rows).Error
	if err != nil {
		return nil, fmt.Errorf("list attacks: %w", err)
	}
	defs, err := s.AttackCatalog(ctx, c.SystemID, "", "")
	if err != nil {
		return nil, err
	}
	byID := make(map[string]AttackDefinition)
	for _, d := range defs {
		byID[d.ID] = d
	}
	skills, err := s.Skills(ctx, characterID, c.SystemID, c.SystemData.Attributes)
	if err != nil {
		return nil, err
	}
	skillByID := make(map[string]AttackTest)
	for _, sk := range skills {
		skillByID[sk.ID] = AttackTest{DiceCount: sk.DiceCount, Keep: sk.Keep, Bonus: sk.Bonus}
	}
	out := make([]CharacterAttack, 0, len(rows))
	for _, r := range rows {
		d, ok := byID[r.DefinitionID]
		if !ok {
			continue
		}
		v := CharacterAttack{Entry: AttackEntry{ID: r.ID, CharacterID: r.CharacterID, DefinitionID: r.DefinitionID, SourceInventoryEntryID: r.SourceInventoryEntryID, Notes: r.Notes, CreatedAt: utcTime(r.CreatedAt), UpdatedAt: utcTime(r.UpdatedAt)}, Definition: d}
		if r.SourceInventoryEntryID != nil && r.InventoryName != nil {
			v.SourceInventory = &SourceInventory{EntryID: *r.SourceInventoryEntryID, Name: *r.InventoryName}
		}
		if d.SkillID != nil {
			if test, ok := skillByID[*d.SkillID]; ok {
				v.Test = &test
			}
		}
		out = append(out, v)
	}
	return out, nil
}
func (s *Repository) AttackEntry(ctx context.Context, characterID, entryID string) (AttackEntry, error) {
	if _, err := s.Character(ctx, characterID); err != nil {
		return AttackEntry{}, err
	}
	var row AttackEntry
	err := s.DB.WithContext(ctx).Table("core.character_attack").Select("id,character_id,definition_id,source_inventory_entry_id,notes,created_at,updated_at").Where("id=? AND character_id=?", entryID, characterID).Take(&row).Error
	if errors.Is(err, gorm.ErrRecordNotFound) {
		return AttackEntry{}, apperr.ErrNotFound
	}
	row.CreatedAt = utcTime(row.CreatedAt)
	row.UpdatedAt = utcTime(row.UpdatedAt)
	return row, err
}
func (s *Repository) validateAttackLink(ctx context.Context, characterID string, d AttackDefinition, inventoryID *string) error {
	if inventoryID == nil {
		return nil
	}
	if d.SourceItemDefinitionID == nil {
		return apperr.ErrConflict
	}
	var count int64
	err := s.DB.WithContext(ctx).Table("core.character_item").Where("id=? AND character_id=? AND item_id=?", *inventoryID, characterID, *d.SourceItemDefinitionID).Count(&count).Error
	if err != nil {
		return err
	}
	if count != 1 {
		return apperr.ErrConflict
	}
	return nil
}
func (s *Repository) AddAttack(ctx context.Context, characterID, definitionID string, inventoryID *string) (AttackEntry, error) {
	c, err := s.Character(ctx, characterID)
	if err != nil {
		return AttackEntry{}, err
	}
	d, err := s.homebrewAttack(ctx, definitionID)
	if err != nil {
		return AttackEntry{}, err
	}
	if d.SystemID != c.SystemID {
		return AttackEntry{}, apperr.ErrNotFound
	}
	if err := s.validateAttackLink(ctx, characterID, d, inventoryID); err != nil {
		return AttackEntry{}, err
	}
	var count int64
	if err := s.DB.WithContext(ctx).Table("core.character_attack").Where("character_id=? AND definition_id=?", characterID, definitionID).Count(&count).Error; err != nil {
		return AttackEntry{}, err
	}
	if count > 0 {
		return AttackEntry{}, apperr.ErrAlreadyAdded
	}
	var id string
	err = s.DB.WithContext(ctx).Raw(`INSERT INTO core.character_attack(character_id,definition_id,source_item_id,source_inventory_entry_id,skill_id,name,test_expression,damage_expression,damage_type,critical_threshold,critical_multiplier,range_text,special,rpg_system_id)
		VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?) RETURNING id`, characterID, definitionID, d.SourceItemDefinitionID, inventoryID, d.SkillID, d.Name, d.TestExpression, d.DamageExpression, d.DamageType, d.CriticalThreshold, d.CriticalMultiplier, d.RangeText, d.Special, c.SystemID).Scan(&id).Error
	if err != nil {
		return AttackEntry{}, fmt.Errorf("add attack: %w", err)
	}
	return s.AttackEntry(ctx, characterID, id)
}
func (s *Repository) AddAttackFromInventory(ctx context.Context, characterID, inventoryID string) (AttackEntry, error) {
	entry, err := s.InventoryEntry(ctx, characterID, inventoryID)
	if err != nil {
		return AttackEntry{}, err
	}
	var defID string
	err = s.DB.WithContext(ctx).Table("ordem.attack_definition").Select("id").Where("source_item_id=?", entry.DefinitionID).Scan(&defID).Error
	if err != nil {
		return AttackEntry{}, err
	}
	if defID == "" {
		return AttackEntry{}, apperr.ErrNotFound
	}
	return s.AddAttack(ctx, characterID, defID, &inventoryID)
}
func (s *Repository) UpdateAttackEntry(ctx context.Context, characterID, entryID string, fields map[string]any) (AttackEntry, error) {
	c, err := s.Character(ctx, characterID)
	if err != nil {
		return AttackEntry{}, err
	}
	current, err := s.AttackEntry(ctx, characterID, entryID)
	if err != nil {
		return AttackEntry{}, err
	}
	defID := current.DefinitionID
	if v, ok := fields["definition_id"]; ok {
		defID = v.(string)
	}
	d, err := s.homebrewAttack(ctx, defID)
	if err != nil {
		return AttackEntry{}, err
	}
	if d.SystemID != c.SystemID {
		return AttackEntry{}, apperr.ErrNotFound
	}
	inventoryID := current.SourceInventoryEntryID
	if v, ok := fields["source_inventory_entry_id"]; ok {
		inventoryID, _ = v.(*string)
	}
	if err := s.validateAttackLink(ctx, characterID, d, inventoryID); err != nil {
		return AttackEntry{}, err
	}
	if defID != current.DefinitionID {
		var count int64
		if err := s.DB.WithContext(ctx).Table("core.character_attack").Where("character_id=? AND definition_id=?", characterID, defID).Count(&count).Error; err != nil {
			return AttackEntry{}, err
		}
		if count > 0 {
			return AttackEntry{}, apperr.ErrAlreadyAdded
		}
		fields["source_item_id"] = d.SourceItemDefinitionID
		fields["skill_id"] = d.SkillID
		fields["name"] = d.Name
		fields["test_expression"] = d.TestExpression
		fields["damage_expression"] = d.DamageExpression
		fields["damage_type"] = d.DamageType
		fields["critical_threshold"] = d.CriticalThreshold
		fields["critical_multiplier"] = d.CriticalMultiplier
		fields["range_text"] = d.RangeText
		fields["special"] = d.Special
	}
	fields["updated_at"] = time.Now()
	result := s.DB.WithContext(ctx).Table("core.character_attack").Where("id=? AND character_id=?", entryID, characterID).Updates(fields)
	if result.Error != nil {
		return AttackEntry{}, fmt.Errorf("update attack entry: %w", result.Error)
	}
	if result.RowsAffected == 0 {
		return AttackEntry{}, apperr.ErrNotFound
	}
	return s.AttackEntry(ctx, characterID, entryID)
}
func (s *Repository) DeleteAttackEntry(ctx context.Context, characterID, entryID string) error {
	if _, err := s.Character(ctx, characterID); err != nil {
		return err
	}
	result := s.DB.WithContext(ctx).Exec("DELETE FROM core.character_attack WHERE id=? AND character_id=?", entryID, characterID)
	if result.Error != nil {
		return result.Error
	}
	if result.RowsAffected == 0 {
		return apperr.ErrNotFound
	}
	return nil
}
