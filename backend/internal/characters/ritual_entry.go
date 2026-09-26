package characters

import (
	"RPG-manager/backend/internal/dbscope"
	"context"
)

type RitualEntries struct{ repo *Repository }

func NewRitualEntries(store *dbscope.Scope) *RitualEntries {
	return &RitualEntries{repo: NewRepository(store.DB, store.UserID)}
}
func (s *RitualEntries) List(ctx context.Context, characterID string) ([]CharacterRitual, error) {
	return s.repo.RitualEntries(ctx, characterID)
}
func (s *RitualEntries) Add(ctx context.Context, characterID, definitionID string) (RitualEntry, error) {
	return s.repo.AddRitual(ctx, characterID, definitionID)
}
func (s *RitualEntries) Update(ctx context.Context, characterID, entryID string, fields map[string]any) (RitualEntry, error) {
	if len(fields) == 0 {
		return RitualEntry{}, ErrInvalid
	}
	return s.repo.UpdateRitualEntry(ctx, characterID, entryID, fields)
}
func (s *RitualEntries) Delete(ctx context.Context, characterID, entryID string) error {
	return s.repo.DeleteRitualEntry(ctx, characterID, entryID)
}
