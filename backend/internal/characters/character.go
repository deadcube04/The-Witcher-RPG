package characters

import (
	"context"
	"strings"

	"RPG-manager/backend/internal/apperr"
	"RPG-manager/backend/internal/dbscope"
	"RPG-manager/backend/internal/domain"
)

var ErrSystemMismatch = apperr.ErrSystemMismatch

type ImageValidator interface {
	ValidateAssociation(context.Context, string, string, string) error
}

type Character struct {
	repo   *Repository
	images ImageValidator
}

func NewCharacter(store *dbscope.Scope, images ...ImageValidator) *Character {
	var validator ImageValidator
	if len(images) > 0 {
		validator = images[0]
	}
	return &Character{repo: NewRepository(store.DB, store.UserID), images: validator}
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
func (s *Character) CatalogVisibility(ctx context.Context, characterID, category string) (string, bool, error) {
	character, err := s.repo.Character(ctx, characterID)
	if err != nil {
		return "", false, err
	}
	access, err := s.repo.SupplementAccess(ctx, character.SystemID, character.CampaignID, character.SupplementID, character.SupplementRuleIDs)
	if err != nil {
		return "", false, err
	}
	return access.ID, access.Categories[category], nil
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
	if in.ImageURL != "" && (old == nil || old.ImageURL != in.ImageURL) {
		if s.images == nil {
			return ErrInvalid
		}
		if err := s.images.ValidateAssociation(ctx, in.ImageURL, s.repo.UserID, "character"); err != nil {
			return err
		}
	}
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
	d := &in.SystemData
	if d.ProgressionMode == "" {
		d.ProgressionMode = "nex"
	}
	if old != nil && old.SystemData.ProgressionMode == "survivor" && d.ProgressionMode != "survivor" && (old.SystemData.SurvivorStage == nil || *old.SystemData.SurvivorStage < 5) {
		return ErrInvalid
	}
	if in.CampaignID != nil {
		ok, err := s.repo.CampaignMatches(ctx, *in.CampaignID, in.SystemID)
		if err != nil {
			return err
		}
		if !ok {
			return ErrSystemMismatch
		}
		allowed, err := s.repo.CampaignAllows(ctx, *in.CampaignID, d.ClassID, d.OriginID)
		if err != nil {
			return err
		}
		if !allowed {
			return apperr.ErrCampaignRestriction
		}
	}
	if in.CampaignID == nil && in.SupplementID != nil {
		expanded, err := s.repo.ExpandRuleIDs(ctx, *in.SupplementID, in.SupplementRuleIDs)
		if err != nil {
			return err
		}
		in.SupplementRuleIDs = expanded
	}
	access, err := s.repo.SupplementAccess(ctx, in.SystemID, in.CampaignID, in.SupplementID, in.SupplementRuleIDs)
	if err != nil {
		return err
	}
	if old != nil {
		if err := s.repo.ExistingSupplementContentAllowed(ctx, old.ID, access); err != nil {
			return err
		}
	}
	if d.ProgressionMode != "survivor" && d.ClassID == "" {
		return ErrInvalid
	}
	attrs := []int{d.Attributes.Agility, d.Attributes.Strength, d.Attributes.Intellect, d.Attributes.Presence, d.Attributes.Vigor}
	for _, value := range attrs {
		if value < 0 || value > 5 {
			return ErrInvalid
		}
	}
	var rule domain.ClassRule
	var survivor survivorRule
	steps := 0
	switch d.ProgressionMode {
	case "nex":
		if d.Level != nil || d.Patent != nil || d.SurvivorClassID != nil || d.SurvivorStage != nil {
			return ErrInvalid
		}
		steps = d.NEX/5 - 1
		if d.NEX == 99 {
			steps = 19
		}
		limit, err := s.repo.NEXLimit(ctx, d.NEX)
		if err != nil {
			return ErrInvalid
		}
		d.PELimit = limit
	case "level-nex":
		if access.ID == "" || !access.Rules["nex-experiencia-p100-separando-nivel-e-nex"] || d.Level == nil || *d.Level < 1 || *d.Level > 20 || d.NEX < 0 || d.NEX > 99 || d.Patent != nil || d.SurvivorClassID != nil {
			return ErrInvalid
		}
		steps = *d.Level - 1
		equivalent := *d.Level * 5
		if equivalent >= 100 {
			equivalent = 99
		}
		limit, err := s.repo.NEXLimit(ctx, equivalent)
		if err != nil {
			return ErrInvalid
		}
		d.PELimit = limit
	case "patent":
		if access.ID == "" || !access.Rules["evolucao-por-patentes"] || !access.Rules["jogando-sem-sanidade"] || d.Patent == nil || d.Level != nil || d.SurvivorClassID != nil || d.NEX < 0 || d.NEX > 99 {
			return ErrInvalid
		}
		ranks := map[string]int{"recruta": 0, "operador": 1, "agente-especial": 2, "oficial-de-operacoes": 3, "agente-de-elite": 4}
		rank, ok := ranks[*d.Patent]
		if !ok {
			return ErrInvalid
		}
		steps = rank
		d.PELimit = []int{1, 3, 6, 10, 15}[rank]
	case "survivor":
		if access.ID == "" || !access.Categories["survivor"] || d.SurvivorClassID == nil || d.SurvivorStage == nil || *d.SurvivorStage < 1 || *d.SurvivorStage > 5 || d.ClassID != "" || d.NEX != 0 || d.Level != nil || d.Patent != nil {
			return ErrInvalid
		}
		survivor, err = s.repo.SurvivorRule(ctx, *d.SurvivorClassID, access.ID)
		if err != nil {
			return err
		}
		if *d.SurvivorStage >= 2 {
			if d.SurvivorTrailID == nil {
				return ErrInvalid
			}
			valid, err := s.repo.SurvivorTrailValid(ctx, *d.SurvivorTrailID, *d.SurvivorClassID, access.ID)
			if err != nil {
				return err
			}
			if !valid {
				return ErrInvalid
			}
		} else if d.SurvivorTrailID != nil {
			return ErrInvalid
		}
		steps = *d.SurvivorStage - 1
		d.PELimit = 1
	default:
		return ErrInvalid
	}
	if d.ProgressionMode != "survivor" {
		rule, err = s.repo.ClassRule(ctx, d.ClassID, in.SystemID)
		if err != nil {
			return err
		}
		if d.TrailID != nil {
			trailSupplement, err := s.repo.Trail(ctx, *d.TrailID, d.ClassID, in.SystemID)
			if err != nil {
				return ErrInvalid
			}
			if trailSupplement != "" && (trailSupplement != access.ID || !access.Categories["trails"]) {
				return apperr.ErrCampaignRestriction
			}
			if err := s.repo.SupplementDefinitionAllowed(ctx, domain.Character{SystemID: in.SystemID, CampaignID: in.CampaignID, SupplementID: in.SupplementID}, "core.archetype_definition", *d.TrailID, "trails"); err != nil {
				return err
			}
		}
	} else if d.TrailID != nil {
		return ErrInvalid
	}
	if d.OriginID != nil {
		ok, err := s.repo.OriginExists(ctx, *d.OriginID, in.SystemID)
		if err != nil {
			return err
		}
		if !ok {
			return ErrInvalid
		}
		originSupplement, err := s.repo.OriginSupplement(ctx, *d.OriginID)
		if err != nil {
			return err
		}
		if originSupplement != "" && originSupplement != access.ID {
			return apperr.ErrCampaignRestriction
		}
		if err := s.repo.SupplementDefinitionAllowed(ctx, domain.Character{SystemID: in.SystemID, CampaignID: in.CampaignID, SupplementID: in.SupplementID}, "core.origin_definition", *d.OriginID, ""); err != nil {
			return err
		}
	}
	pv := rule.InitialPVBase + attribute(rule.InitialPVAttribute, d.Attributes) + steps*(rule.PVPerNEXBase+attribute(rule.PVPerNEXAttribute, d.Attributes))
	pe := rule.InitialPEBase + attribute(rule.InitialPEAttribute, d.Attributes) + steps*(rule.PEPerNEXBase+attribute(rule.PEPerNEXAttribute, d.Attributes))
	san := rule.InitialSAN + steps*rule.SANPerNEX
	if d.ProgressionMode == "survivor" {
		pv = survivor.InitialPV + d.Attributes.Vigor + steps*(survivor.PVPerStage+d.Attributes.Vigor)
		pe = survivor.InitialPE + d.Attributes.Presence + steps*survivor.PEPerStage
		san = survivor.InitialSAN + steps*survivor.SANPerStage
	}
	if d.ProgressionMode == "patent" {
		slug, err := s.repo.ClassSlug(ctx, d.ClassID)
		if err != nil {
			return err
		}
		switch slug {
		case "combatente":
			pv = 20 + d.Attributes.Vigor + steps*(10+d.Attributes.Vigor)
		case "especialista":
			pv = 16 + d.Attributes.Vigor + steps*(8+d.Attributes.Vigor)
		case "ocultista":
			pv = 12 + d.Attributes.Vigor + steps*(6+d.Attributes.Vigor)
		default:
			return ErrInvalid
		}
	}
	useDetermination := d.ProgressionMode == "patent" || access.Rules["jogando-sem-sanidade"]
	if useDetermination {
		if d.Resources.Determination == nil {
			d.Resources.Determination = &domain.Resource{}
		}
		var base int
		if d.ProgressionMode == "survivor" {
			base = 4 + d.Attributes.Presence + steps*2
		} else {
			slug, err := s.repo.ClassSlug(ctx, d.ClassID)
			if err != nil {
				return err
			}
			if d.ProgressionMode == "patent" {
				switch slug {
				case "combatente":
					base = 8 + d.Attributes.Presence + steps*(4+d.Attributes.Presence)
				case "especialista":
					base = 12 + d.Attributes.Presence + steps*(6+d.Attributes.Presence)
				case "ocultista":
					base = 16 + d.Attributes.Presence + steps*(8+d.Attributes.Presence)
				default:
					return ErrInvalid
				}
			} else {
				switch slug {
				case "combatente":
					base = 6 + d.Attributes.Presence + steps*(3+d.Attributes.Presence)
				case "especialista":
					base = 8 + d.Attributes.Presence + steps*(4+d.Attributes.Presence)
				case "ocultista":
					base = 10 + d.Attributes.Presence + steps*(5+d.Attributes.Presence)
				default:
					return ErrInvalid
				}
			}
		}
		var oldDetermination *domain.Resources
		if old != nil {
			oldDetermination = &old.SystemData.Resources
		}
		if err := calculateResource(d.Resources.Determination, base, oldDetermination, func(r *domain.Resources) *domain.Resource { return r.Determination }); err != nil {
			return err
		}
		pe, san = 0, 0
	} else {
		d.Resources.Determination = nil
	}
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
		if previous == nil {
			previous = &domain.Resource{}
		}
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
