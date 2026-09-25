package service

import (
	"RPG-manager/backend/internal/repository"
	"context"
)

type Catalog struct{ store *repository.Store }

func NewCatalog(store *repository.Store) *Catalog { return &Catalog{store: store} }
func (s *Catalog) Inventory(ctx context.Context, query, kind string) ([]repository.InventoryDefinition, error) {
	id, err := s.store.OrdemSystemID(ctx)
	if err != nil {
		return nil, err
	}
	return s.store.InventoryCatalog(ctx, id, query, kind)
}
func (s *Catalog) Rituals(ctx context.Context, query, element string) ([]repository.RitualDefinition, error) {
	id, err := s.store.OrdemSystemID(ctx)
	if err != nil {
		return nil, err
	}
	return s.store.RitualCatalog(ctx, id, query, element)
}
func (s *Catalog) Attacks(ctx context.Context, query, source string) ([]repository.AttackDefinition, error) {
	id, err := s.store.OrdemSystemID(ctx)
	if err != nil {
		return nil, err
	}
	return s.store.AttackCatalog(ctx, id, query, source)
}
