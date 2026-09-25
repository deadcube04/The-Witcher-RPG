package service

import (
	"RPG-manager/backend/internal/repository"
	"context"
)

type RitualEntries struct{ store *repository.Store }

func NewRitualEntries(store *repository.Store) *RitualEntries { return &RitualEntries{store: store} }
func (s *RitualEntries) List(ctx context.Context, characterID string) ([]repository.CharacterRitual, error) {
	return s.store.RitualEntries(ctx, characterID)
}
func (s *RitualEntries) Add(ctx context.Context, characterID, definitionID string) (repository.RitualEntry, error) {
	return s.store.AddRitual(ctx, characterID, definitionID)
}
func (s *RitualEntries) Update(ctx context.Context, characterID, entryID string, fields map[string]any) (repository.RitualEntry, error) {
	if len(fields) == 0 {
		return repository.RitualEntry{}, ErrInvalid
	}
	return s.store.UpdateRitualEntry(ctx, characterID, entryID, fields)
}
func (s *RitualEntries) Delete(ctx context.Context, characterID, entryID string) error {
	return s.store.DeleteRitualEntry(ctx, characterID, entryID)
}
