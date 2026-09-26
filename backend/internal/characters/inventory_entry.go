package characters

import (
	"RPG-manager/backend/internal/dbscope"
	"context"
)

type InventoryEntries struct{ repo *Repository }

func NewInventoryEntries(store *dbscope.Scope) *InventoryEntries {
	return &InventoryEntries{repo: NewRepository(store.DB, store.UserID)}
}
func (s *InventoryEntries) List(ctx context.Context, characterID string) ([]InventoryItem, error) {
	return s.repo.InventoryEntries(ctx, characterID)
}
func (s *InventoryEntries) Add(ctx context.Context, characterID, definitionID string, quantity int) (InventoryEntry, error) {
	if quantity < 1 || quantity > 999 {
		return InventoryEntry{}, ErrInvalid
	}
	return s.repo.AddInventory(ctx, characterID, definitionID, quantity)
}
func (s *InventoryEntries) Update(ctx context.Context, characterID, entryID string, fields map[string]any) (InventoryEntry, error) {
	if len(fields) == 0 {
		return InventoryEntry{}, ErrInvalid
	}
	return s.repo.UpdateInventoryEntry(ctx, characterID, entryID, fields)
}
func (s *InventoryEntries) Delete(ctx context.Context, characterID, entryID, policy string) error {
	if policy != "" && policy != "detach" && policy != "remove" {
		return ErrInvalid
	}
	return s.repo.DeleteInventoryEntry(ctx, characterID, entryID, policy)
}
