package characters

import (
	"context"
	"time"

	"RPG-manager/backend/internal/content"
	"RPG-manager/backend/internal/domain"
	"RPG-manager/backend/internal/systems"
	"gorm.io/gorm"
)

type Repository struct {
	DB     *gorm.DB
	UserID string
}

func NewRepository(db *gorm.DB, userID string) *Repository {
	return &Repository{DB: db, UserID: userID}
}

func (r *Repository) Systems(ctx context.Context) ([]domain.System, error) {
	return systems.NewRepository(r.DB).List(ctx)
}

func (r *Repository) SystemSlug(ctx context.Context, id string) (string, error) {
	return systems.NewService(systems.NewRepository(r.DB)).Slug(ctx, id)
}

func (r *Repository) AttackCatalog(ctx context.Context, systemID, query, source string) ([]content.AttackDefinition, error) {
	return content.NewRepository(r.DB, r.UserID).AttackCatalog(ctx, systemID, query, source)
}

func (r *Repository) InventoryCatalog(ctx context.Context, systemID, query, kind string) ([]content.InventoryDefinition, error) {
	return content.NewRepository(r.DB, r.UserID).InventoryCatalog(ctx, systemID, query, kind)
}

func (r *Repository) RitualCatalog(ctx context.Context, systemID, query, element string) ([]content.RitualDefinition, error) {
	return content.NewRepository(r.DB, r.UserID).RitualCatalog(ctx, systemID, query, element)
}

func (r *Repository) homebrewItem(ctx context.Context, id string) (content.InventoryDefinition, error) {
	return content.NewRepository(r.DB, r.UserID).InventoryDefinition(ctx, id)
}

func (r *Repository) homebrewRitual(ctx context.Context, id string) (content.RitualDefinition, error) {
	return content.NewRepository(r.DB, r.UserID).RitualDefinition(ctx, id)
}

func (r *Repository) homebrewAttack(ctx context.Context, id string) (content.AttackDefinition, error) {
	return content.NewRepository(r.DB, r.UserID).AttackDefinition(ctx, id)
}

func utcTime(value time.Time) time.Time { return value.UTC() }
