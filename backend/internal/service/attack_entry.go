package service

import (
	"RPG-manager/backend/internal/repository"
	"context"
)

type AttackEntries struct{ store *repository.Store }

func NewAttackEntries(store *repository.Store) *AttackEntries { return &AttackEntries{store: store} }
func (s *AttackEntries) List(ctx context.Context, characterID string) ([]repository.CharacterAttack, error) {
	return s.store.AttackEntries(ctx, characterID)
}
func (s *AttackEntries) Add(ctx context.Context, characterID, definitionID string, inventoryID *string) (repository.AttackEntry, error) {
	return s.store.AddAttack(ctx, characterID, definitionID, inventoryID)
}
func (s *AttackEntries) AddFromInventory(ctx context.Context, characterID, inventoryID string) (repository.AttackEntry, error) {
	return s.store.AddAttackFromInventory(ctx, characterID, inventoryID)
}
func (s *AttackEntries) Update(ctx context.Context, characterID, entryID string, fields map[string]any) (repository.AttackEntry, error) {
	if len(fields) == 0 {
		return repository.AttackEntry{}, ErrInvalid
	}
	return s.store.UpdateAttackEntry(ctx, characterID, entryID, fields)
}
func (s *AttackEntries) Delete(ctx context.Context, characterID, entryID string) error {
	return s.store.DeleteAttackEntry(ctx, characterID, entryID)
}
