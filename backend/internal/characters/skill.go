package characters

import (
	"RPG-manager/backend/internal/domain"
	"RPG-manager/backend/internal/dbscope"
	"context"
)

type Skills struct{ repo *Repository }

func NewSkills(store *dbscope.Scope) *Skills {
	return &Skills{repo: NewRepository(store.DB, store.UserID)}
}
func (s *Skills) List(ctx context.Context, id string) ([]domain.Skill, error) {
	c, err := s.repo.Character(ctx, id)
	if err != nil {
		return nil, err
	}
	return s.repo.Skills(ctx, id, c.SystemID, c.SystemData.Attributes)
}
func (s *Skills) Update(ctx context.Context, id string, updates []domain.SkillUpdate) ([]domain.Skill, error) {
	c, err := s.repo.Character(ctx, id)
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
	if err := s.repo.UpdateSkills(ctx, id, c.SystemID, updates); err != nil {
		return nil, err
	}
	return s.repo.Skills(ctx, id, c.SystemID, c.SystemData.Attributes)
}
