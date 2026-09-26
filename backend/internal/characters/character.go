package characters

import (
	"context"
	"strings"

	"RPG-manager/backend/internal/apperr"
	"RPG-manager/backend/internal/domain"
	"RPG-manager/backend/internal/dbscope"
)

var ErrSystemMismatch = apperr.ErrSystemMismatch

type Character struct{ repo *Repository }

func NewCharacter(store *dbscope.Scope) *Character {
	return &Character{repo: NewRepository(store.DB, store.UserID)}
}

func (s *Character) List(ctx context.Context) ([]domain.Character, error) {
	ids, err := s.repo.CharacterIDs(ctx)
	if err != nil {
		return nil, err
	}
	out := make([]domain.Character, 0, len(ids))
	for _, id := range ids {
		value, err := s.repo.Character(ctx, id)
		if err != nil {
			return nil, err
		}
		out = append(out, value)
	}
	return out, nil
}
func (s *Character) Get(ctx context.Context, id string) (domain.Character, error) {
	return s.repo.Character(ctx, id)
}
func (s *Character) Options(ctx context.Context) (domain.CharacterOptions, error) {
	systems, err := s.repo.Systems(ctx)
	if err != nil {
		return domain.CharacterOptions{}, err
	}
	for _, system := range systems {
		if system.Slug == "ordem-paranormal" {
			return s.repo.CharacterOptions(ctx, system.ID)
		}
	}
	return domain.CharacterOptions{}, apperr.ErrNotFound
}
func (s *Character) Create(ctx context.Context, in domain.CharacterInput) (domain.Character, error) {
	if err := s.prepare(ctx, &in, nil); err != nil {
		return domain.Character{}, err
	}
	return s.repo.CreateCharacter(ctx, in)
}
func (s *Character) Update(ctx context.Context, id string, in domain.CharacterInput) (domain.Character, error) {
	old, err := s.repo.Character(ctx, id)
	if err != nil {
		return domain.Character{}, err
	}
	if in.SystemID != old.SystemID {
		return domain.Character{}, ErrSystemMismatch
	}
	if err := s.prepare(ctx, &in, &old); err != nil {
		return domain.Character{}, err
	}
	return s.repo.UpdateCharacter(ctx, id, in)
}
func (s *Character) Delete(ctx context.Context, id string) error {
	return s.repo.DeleteCharacter(ctx, id)
}

func (s *Character) prepare(ctx context.Context, in *domain.CharacterInput, old *domain.Character) error {
	in.Name = strings.TrimSpace(in.Name)
	if in.Name == "" || len(in.Name) > 160 {
		return ErrInvalid
	}
	slug, err := s.repo.SystemSlug(ctx, in.SystemID)
	if err != nil {
		return err
	}
	if slug != "ordem-paranormal" || in.SystemData.Kind != "ordem-paranormal" {
		return ErrPreview
	}
	if in.CampaignID != nil {
		ok, err := s.repo.CampaignMatches(ctx, *in.CampaignID, in.SystemID)
		if err != nil {
			return err
		}
		if !ok {
			return ErrSystemMismatch
		}
	}
	d := &in.SystemData
	if d.ClassID == "" {
		return ErrInvalid
	}
	attrs := []int{d.Attributes.Agility, d.Attributes.Strength, d.Attributes.Intellect, d.Attributes.Presence, d.Attributes.Vigor}
	for _, value := range attrs {
		if value < 0 || value > 5 {
			return ErrInvalid
		}
	}
	rule, err := s.repo.ClassRule(ctx, d.ClassID, in.SystemID)
	if err != nil {
		return err
	}
	limit, err := s.repo.NEXLimit(ctx, d.NEX)
	if err != nil {
		return ErrInvalid
	}
	d.PELimit = limit
	if d.OriginID != nil {
		ok, err := s.repo.OriginExists(ctx, *d.OriginID, in.SystemID)
		if err != nil {
			return err
		}
		if !ok {
			return ErrInvalid
		}
	}
	steps := 19
	if d.NEX != 99 {
		steps = d.NEX/5 - 1
	}
	pv := rule.InitialPVBase + attribute(rule.InitialPVAttribute, d.Attributes) + steps*(rule.PVPerNEXBase+attribute(rule.PVPerNEXAttribute, d.Attributes))
	pe := rule.InitialPEBase + attribute(rule.InitialPEAttribute, d.Attributes) + steps*(rule.PEPerNEXBase+attribute(rule.PEPerNEXAttribute, d.Attributes))
	san := rule.InitialSAN + steps*rule.SANPerNEX
	var oldResources *domain.Resources
	if old != nil {
		oldResources = &old.SystemData.Resources
	}
	if err := calculateResource(&d.Resources.Health, pv, oldResources, func(r *domain.Resources) *domain.Resource { return &r.Health }); err != nil {
		return err
	}
	if err := calculateResource(&d.Resources.Effort, pe, oldResources, func(r *domain.Resources) *domain.Resource { return &r.Effort }); err != nil {
		return err
	}
	if err := calculateResource(&d.Resources.Sanity, san, oldResources, func(r *domain.Resources) *domain.Resource { return &r.Sanity }); err != nil {
		return err
	}
	return nil
}

func attribute(code *string, a domain.Attributes) int {
	if code == nil {
		return 0
	}
	switch *code {
	case "AGI":
		return a.Agility
	case "FOR":
		return a.Strength
	case "INT":
		return a.Intellect
	case "PRE":
		return a.Presence
	case "VIG":
		return a.Vigor
	default:
		return 0
	}
}

func calculateResource(r *domain.Resource, base int, old *domain.Resources, pick func(*domain.Resources) *domain.Resource) error {
	maximum := base + r.MaxAdjustment
	if maximum < 0 || r.Temporary < 0 || r.Current < 0 {
		return ErrInvalid
	}
	if old == nil {
		r.Current = maximum
	} else {
		previous := pick(old)
		if r.Current == previous.Current {
			if maximum > previous.Maximum {
				r.Current += maximum - previous.Maximum
			}
		}
		if r.Current > maximum {
			r.Current = maximum
		}
	}
	r.BaseMaximum = base
	r.Maximum = maximum
	return nil
}
