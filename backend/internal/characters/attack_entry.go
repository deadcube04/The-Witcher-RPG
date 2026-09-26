package characters

import (
	"RPG-manager/backend/internal/dbscope"
	"context"
)

type AttackEntries struct{ repo *Repository }

func NewAttackEntries(store *dbscope.Scope) *AttackEntries {
	return &AttackEntries{repo: NewRepository(store.DB, store.UserID)}
}
func (s *AttackEntries) List(ctx context.Context, characterID string) ([]CharacterAttack, error) {
	return s.repo.AttackEntries(ctx, characterID)
}
func (s *AttackEntries) Add(ctx context.Context, characterID, definitionID string, inventoryID *string) (AttackEntry, error) {
	return s.repo.AddAttack(ctx, characterID, definitionID, inventoryID)
}
func (s *AttackEntries) AddFromInventory(ctx context.Context, characterID, inventoryID string) (AttackEntry, error) {
	return s.repo.AddAttackFromInventory(ctx, characterID, inventoryID)
}
func (s *AttackEntries) Update(ctx context.Context, characterID, entryID string, fields map[string]any) (AttackEntry, error) {
	if len(fields) == 0 {
		return AttackEntry{}, ErrInvalid
	}
	return s.repo.UpdateAttackEntry(ctx, characterID, entryID, fields)
}
func (s *AttackEntries) Delete(ctx context.Context, characterID, entryID string) error {
	return s.repo.DeleteAttackEntry(ctx, characterID, entryID)
}
