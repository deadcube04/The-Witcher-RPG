package content

import (
	"RPG-manager/backend/internal/dbscope"
	"context"
)

type Catalog struct{ repo *Repository }

func NewCatalog(store *dbscope.Scope) *Catalog {
	return &Catalog{repo: NewRepository(store.DB, store.UserID)}
}
func (s *Catalog) Inventory(ctx context.Context, query, kind string) ([]InventoryDefinition, error) {
	id, err := s.repo.OrdemSystemID(ctx)
	if err != nil {
		return nil, err
	}
	return s.repo.InventoryCatalog(ctx, id, query, kind)
}
func (s *Catalog) Rituals(ctx context.Context, query, element string) ([]RitualDefinition, error) {
	id, err := s.repo.OrdemSystemID(ctx)
	if err != nil {
		return nil, err
	}
	return s.repo.RitualCatalog(ctx, id, query, element)
}
func (s *Catalog) Attacks(ctx context.Context, query, source string) ([]AttackDefinition, error) {
	id, err := s.repo.OrdemSystemID(ctx)
	if err != nil {
		return nil, err
	}
	return s.repo.AttackCatalog(ctx, id, query, source)
}
