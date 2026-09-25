package service

import (
	"RPG-manager/backend/internal/repository"
	"context"
)

type InventoryEntries struct{ store *repository.Store }

func NewInventoryEntries(store *repository.Store) *InventoryEntries {
	return &InventoryEntries{store: store}
}
func (s *InventoryEntries) List(ctx context.Context, characterID string) ([]repository.InventoryItem, error) {
	return s.store.InventoryEntries(ctx, characterID)
}
func (s *InventoryEntries) Add(ctx context.Context, characterID, definitionID string, quantity int) (repository.InventoryEntry, error) {
	if quantity < 1 || quantity > 999 {
		return repository.InventoryEntry{}, ErrInvalid
	}
	return s.store.AddInventory(ctx, characterID, definitionID, quantity)
}
func (s *InventoryEntries) Update(ctx context.Context, characterID, entryID string, fields map[string]any) (repository.InventoryEntry, error) {
	if len(fields) == 0 {
		return repository.InventoryEntry{}, ErrInvalid
	}
	return s.store.UpdateInventoryEntry(ctx, characterID, entryID, fields)
}
func (s *InventoryEntries) Delete(ctx context.Context, characterID, entryID, policy string) error {
	if policy != "" && policy != "detach" && policy != "remove" {
		return ErrInvalid
	}
	return s.store.DeleteInventoryEntry(ctx, characterID, entryID, policy)
}
