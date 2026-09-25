package service

import (
	"RPG-manager/backend/internal/domain"
	"RPG-manager/backend/internal/repository"
	"context"
)

type Skills struct{ store *repository.Store }

func NewSkills(store *repository.Store) *Skills { return &Skills{store: store} }
func (s *Skills) List(ctx context.Context, id string) ([]domain.Skill, error) {
	c, err := s.store.Character(ctx, id)
	if err != nil {
		return nil, err
	}
	return s.store.Skills(ctx, id, c.SystemID, c.SystemData.Attributes)
}
func (s *Skills) Update(ctx context.Context, id string, updates []domain.SkillUpdate) ([]domain.Skill, error) {
	c, err := s.store.Character(ctx, id)
	if err != nil {
		return nil, err
	}
	seen := make(map[string]bool)
	for _, u := range updates {
		if seen[u.ID] || u.OtherBonus < -100 || u.OtherBonus > 100 {
			return nil, ErrInvalid
		}
		seen[u.ID] = true
	}
	if err := s.store.UpdateSkills(ctx, id, c.SystemID, updates); err != nil {
		return nil, err
	}
	return s.store.Skills(ctx, id, c.SystemID, c.SystemData.Attributes)
}
