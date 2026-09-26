package content

import (
	"context"
	"encoding/json"
	"strings"

	"RPG-manager/backend/internal/domain"
	"RPG-manager/backend/internal/dbscope"
)

type Homebrew struct{ repo *Repository }

func NewHomebrew(store *dbscope.Scope) *Homebrew {
	return &Homebrew{repo: NewRepository(store.DB, store.UserID)}
}

func validName(s string) bool { return len(strings.TrimSpace(s)) > 0 && len(s) <= 160 }
func validInventory(in domain.InventoryInput) bool {
	if !validName(in.Name) || len(in.Description) > 10000 || in.Spaces < 0 || in.Spaces > 99 {
		return false
	}
	if in.Category != nil && (*in.Category < 0 || *in.Category > 4) {
		return false
	}
	switch in.Kind {
	case "weapon":
		return in.DamageExpression != "" && in.CriticalThreshold >= 2 && in.CriticalThreshold <= 20 && in.CriticalMultiplier >= 2 && in.CriticalMultiplier <= 10
	case "protection", "ammunition", "accessory", "equipment", "paranormal", "other":
		return true
	default:
		return false
	}
}
func (s *Homebrew) CreateInventory(ctx context.Context, in domain.InventoryInput) (InventoryDefinition, error) {
	if !validInventory(in) {
		return InventoryDefinition{}, ErrInvalid
	}
	return s.repo.CreateInventoryHomebrew(ctx, in)
}
func (s *Homebrew) UpdateInventory(ctx context.Context, id string, in domain.InventoryInput) (InventoryDefinition, error) {
	if !validInventory(in) {
		return InventoryDefinition{}, ErrInvalid
	}
	return s.repo.UpdateInventoryHomebrew(ctx, id, in)
}
func (s *Homebrew) DeleteInventory(ctx context.Context, id string) error {
	return s.repo.DeleteInventoryHomebrew(ctx, id)
}

func validRitual(in domain.RitualInput) bool {
	if !validName(in.Name) || in.Circle < 1 || in.Circle > 4 || len(in.Description) > 10000 {
		return false
	}
	switch in.Element {
	case "blood", "death", "knowledge", "energy", "fear":
	default:
		return false
	}
	if len(in.Tiers) != 3 {
		return false
	}
	for _, key := range []string{"normal", "discente", "verdadeiro"} {
		tier, ok := in.Tiers[key]
		if !ok || tier.PECost < 0 || tier.PECost > 99 || strings.TrimSpace(tier.Effect) == "" || !json.Valid(tier.Rolls) {
			return false
		}
	}
	return true
}
func (s *Homebrew) CreateRitual(ctx context.Context, in domain.RitualInput) (RitualDefinition, error) {
	if !validRitual(in) {
		return RitualDefinition{}, ErrInvalid
	}
	return s.repo.CreateRitualHomebrew(ctx, in)
}
func (s *Homebrew) UpdateRitual(ctx context.Context, id string, in domain.RitualInput) (RitualDefinition, error) {
	if !validRitual(in) {
		return RitualDefinition{}, ErrInvalid
	}
	return s.repo.UpdateRitualHomebrew(ctx, id, in)
}
func (s *Homebrew) DeleteRitual(ctx context.Context, id string) error {
	return s.repo.DeleteRitualHomebrew(ctx, id)
}

func validAttack(in domain.AttackInput) bool {
	return validName(in.Name) && len(in.Description) <= 10000 && in.DamageExpression != "" && in.CriticalThreshold >= 2 && in.CriticalThreshold <= 20 && in.CriticalMultiplier >= 2 && in.CriticalMultiplier <= 10 && (in.SkillID != nil || strings.TrimSpace(in.SkillName) != "")
}
func (s *Homebrew) CreateAttack(ctx context.Context, in domain.AttackInput) (AttackDefinition, error) {
	if !validAttack(in) {
		return AttackDefinition{}, ErrInvalid
	}
	return s.repo.CreateAttackHomebrew(ctx, in)
}
func (s *Homebrew) UpdateAttack(ctx context.Context, id string, in domain.AttackInput) (AttackDefinition, error) {
	if !validAttack(in) {
		return AttackDefinition{}, ErrInvalid
	}
	return s.repo.UpdateAttackHomebrew(ctx, id, in)
}
func (s *Homebrew) DeleteAttack(ctx context.Context, id string) error {
	return s.repo.DeleteAttackHomebrew(ctx, id)
}
