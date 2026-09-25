package repository

import (
	"context"
	"errors"
	"fmt"
	"time"

	"gorm.io/gorm"
	"gorm.io/gorm/clause"
)

type InventoryEntry struct {
	ID           string    `json:"id"`
	CharacterID  string    `json:"characterId"`
	DefinitionID string    `json:"definitionId"`
	Quantity     int       `json:"quantity"`
	Equipped     bool      `json:"equipped"`
	Notes        string    `json:"notes"`
	CreatedAt    time.Time `json:"createdAt"`
	UpdatedAt    time.Time `json:"updatedAt"`
}
type InventoryItem struct {
	Entry             InventoryEntry      `json:"entry"`
	Definition        InventoryDefinition `json:"definition"`
	LinkedAttackCount int                 `json:"linkedAttackCount"`
}

func (s *Store) InventoryEntries(ctx context.Context, characterID string) ([]InventoryItem, error) {
	c, err := s.Character(ctx, characterID)
	if err != nil {
		return nil, err
	}
	var rows []struct {
		ID                string
		CharacterID       string
		DefinitionID      string
		Quantity          int
		Equipped          bool
		Notes             *string
		CreatedAt         time.Time
		UpdatedAt         time.Time
		LinkedAttackCount int
	}
	err = s.DB.WithContext(ctx).Table("core.character_item AS ci").Select(`ci.id,ci.character_id,ci.item_id AS definition_id,ci.quantity,ci.equipped,ci.notes,ci.created_at,ci.updated_at,
		(SELECT count(*) FROM core.character_attack ca WHERE ca.source_inventory_entry_id=ci.id)::int AS linked_attack_count`).Where("ci.character_id=?", characterID).Order("ci.created_at,ci.id").Scan(&rows).Error
	if err != nil {
		return nil, fmt.Errorf("list inventory: %w", err)
	}
	defs, err := s.InventoryCatalog(ctx, c.SystemID, "", "")
	if err != nil {
		return nil, err
	}
	byID := make(map[string]InventoryDefinition, len(defs))
	for _, d := range defs {
		byID[d.ID] = d
	}
	out := make([]InventoryItem, 0, len(rows))
	for _, r := range rows {
		d, ok := byID[r.DefinitionID]
		if !ok {
			continue
		}
		out = append(out, InventoryItem{Entry: InventoryEntry{ID: r.ID, CharacterID: r.CharacterID, DefinitionID: r.DefinitionID, Quantity: r.Quantity, Equipped: r.Equipped, Notes: deref(r.Notes), CreatedAt: utcTime(r.CreatedAt), UpdatedAt: utcTime(r.UpdatedAt)}, Definition: d, LinkedAttackCount: r.LinkedAttackCount})
	}
	return out, nil
}

func (s *Store) InventoryEntry(ctx context.Context, characterID, entryID string) (InventoryEntry, error) {
	if _, err := s.Character(ctx, characterID); err != nil {
		return InventoryEntry{}, err
	}
	var row struct {
		ID           string
		CharacterID  string
		DefinitionID string
		Quantity     int
		Equipped     bool
		Notes        *string
		CreatedAt    time.Time
		UpdatedAt    time.Time
	}
	err := s.DB.WithContext(ctx).Table("core.character_item").Select("id,character_id,item_id AS definition_id,quantity,equipped,notes,created_at,updated_at").Where("id=? AND character_id=?", entryID, characterID).Take(&row).Error
	if errors.Is(err, gorm.ErrRecordNotFound) {
		return InventoryEntry{}, ErrNotFound
	}
	if err != nil {
		return InventoryEntry{}, err
	}
	return InventoryEntry{ID: row.ID, CharacterID: row.CharacterID, DefinitionID: row.DefinitionID, Quantity: row.Quantity, Equipped: row.Equipped, Notes: deref(row.Notes), CreatedAt: utcTime(row.CreatedAt), UpdatedAt: utcTime(row.UpdatedAt)}, nil
}
func (s *Store) AddInventory(ctx context.Context, characterID, definitionID string, quantity int) (InventoryEntry, error) {
	c, err := s.Character(ctx, characterID)
	if err != nil {
		return InventoryEntry{}, err
	}
	d, err := s.homebrewItem(ctx, definitionID)
	if err != nil {
		return InventoryEntry{}, err
	}
	if d.SystemID != c.SystemID {
		return InventoryEntry{}, ErrNotFound
	}
	var id string
	err = s.DB.WithContext(ctx).Transaction(func(tx *gorm.DB) error {
		var existing struct {
			ID       string
			Quantity int
		}
		err := tx.Table("core.character_item").Select("id,quantity").Clauses(clause.Locking{Strength: "UPDATE"}).Where("character_id=? AND item_id=?", characterID, definitionID).Take(&existing).Error
		if err != nil && !errors.Is(err, gorm.ErrRecordNotFound) {
			return err
		}
		if existing.ID != "" {
			if existing.Quantity+quantity > 999 {
				return ErrConflict
			}
			id = existing.ID
			return tx.Table("core.character_item").Where("id=?", id).Updates(map[string]any{"quantity": existing.Quantity + quantity, "updated_at": time.Now()}).Error
		}
		return tx.Raw(`INSERT INTO core.character_item(character_id,item_id,quantity,rpg_system_id) VALUES (?,?,?,?) RETURNING id`, characterID, definitionID, quantity, c.SystemID).Scan(&id).Error
	})
	if err != nil {
		return InventoryEntry{}, fmt.Errorf("add inventory: %w", err)
	}
	return s.InventoryEntry(ctx, characterID, id)
}
func (s *Store) UpdateInventoryEntry(ctx context.Context, characterID, entryID string, fields map[string]any) (InventoryEntry, error) {
	c, err := s.Character(ctx, characterID)
	if err != nil {
		return InventoryEntry{}, err
	}
	if id, ok := fields["item_id"]; ok {
		d, err := s.homebrewItem(ctx, id.(string))
		if err != nil {
			return InventoryEntry{}, err
		}
		if d.SystemID != c.SystemID {
			return InventoryEntry{}, ErrNotFound
		}
	}
	fields["updated_at"] = time.Now()
	result := s.DB.WithContext(ctx).Table("core.character_item").Where("id=? AND character_id=?", entryID, characterID).Updates(fields)
	if result.Error != nil {
		return InventoryEntry{}, fmt.Errorf("update inventory: %w", result.Error)
	}
	if result.RowsAffected == 0 {
		return InventoryEntry{}, ErrNotFound
	}
	return s.InventoryEntry(ctx, characterID, entryID)
}
func (s *Store) DeleteInventoryEntry(ctx context.Context, characterID, entryID, policy string) error {
	if _, err := s.Character(ctx, characterID); err != nil {
		return err
	}
	return s.DB.WithContext(ctx).Transaction(func(tx *gorm.DB) error {
		var count int64
		if err := tx.Table("core.character_item").Where("id=? AND character_id=?", entryID, characterID).Count(&count).Error; err != nil {
			return err
		}
		if count == 0 {
			return ErrNotFound
		}
		if err := tx.Table("core.character_attack").Where("source_inventory_entry_id=?", entryID).Count(&count).Error; err != nil {
			return err
		}
		if count > 0 {
			switch policy {
			case "detach":
				if err := tx.Table("core.character_attack").Where("source_inventory_entry_id=?", entryID).Update("source_inventory_entry_id", nil).Error; err != nil {
					return err
				}
			case "remove":
				if err := tx.Exec("DELETE FROM core.character_attack WHERE source_inventory_entry_id=?", entryID).Error; err != nil {
					return err
				}
			default:
				return ErrInUse
			}
		}
		return tx.Exec("DELETE FROM core.character_item WHERE id=? AND character_id=?", entryID, characterID).Error
	})
}
