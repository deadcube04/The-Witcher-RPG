package localimport

import (
	"bytes"
	"context"
	"encoding/json"
	"errors"
	"io"
	"strings"

	"RPG-manager/backend/internal/apperr"
	"RPG-manager/backend/internal/domain"
	"RPG-manager/backend/internal/dbscope"
)

type Importer struct{ repo *Repository }

func NewImporter(store *dbscope.Scope) *Importer { return &Importer{repo: NewRepository(store)} }
func (s *Importer) Preview(ctx context.Context, req domain.ImportRequest) (domain.ImportResult, error) {
	return s.process(ctx, req, true)
}
func (s *Importer) Apply(ctx context.Context, req domain.ImportRequest) (domain.ImportResult, error) {
	return s.process(ctx, req, false)
}

func (s *Importer) process(ctx context.Context, req domain.ImportRequest, dry bool) (domain.ImportResult, error) {
	result := domain.ImportResult{Total: len(req.Items), Issues: []domain.ImportIssue{}}
	if len(req.Items) > 500 {
		return result, ErrInvalid
	}
	seen := make(map[string]bool)
	for _, item := range req.Items {
		key := item.Kind + ":" + item.SourceID
		if seen[key] || !validImportKind(item.Kind) || len(item.Payload) == 0 {
			return result, ErrInvalid
		}
		seen[key] = true
	}
	return s.repo.Process(ctx, req, dry, s.applyOne, importErrorCode)
}
func validImportKind(kind string) bool {
	switch kind {
	case "campaign", "character", "inventory-definition", "ritual-definition", "attack-definition", "official-inventory", "official-ritual", "official-attack", "inventory-entry", "ritual-entry", "attack-entry":
		return true
	default:
		return false
	}
}
func importErrorCode(err error) string {
	switch {
	case errors.Is(err, apperr.ErrNotFound):
		return "CONTENT_NOT_FOUND"
	case errors.Is(err, apperr.ErrAlreadyAdded):
		return "CONTENT_ALREADY_ADDED"
	case errors.Is(err, ErrSystemMismatch):
		return "SYSTEM_MISMATCH"
	case errors.Is(err, ErrPreview):
		return "CONFLICT"
	case errors.Is(err, ErrInvalid):
		return "INVALID_REQUEST"
	default:
		return "CONFLICT"
	}
}
func decodeImport[T any](raw json.RawMessage) (T, error) {
	var value T
	dec := json.NewDecoder(bytes.NewReader(raw))
	dec.DisallowUnknownFields()
	if err := dec.Decode(&value); err != nil {
		return value, ErrInvalid
	}
	var extra any
	if err := dec.Decode(&extra); err != io.EOF {
		return value, ErrInvalid
	}
	return value, nil
}
func (s *Importer) applyOne(ctx context.Context, local *Repository, operations *domainSession, item domain.ImportRecord) (string, error) {
	switch item.Kind {
	case "campaign":
		in, err := decodeImport[domain.CampaignInput](item.Payload)
		if err != nil {
			return "", err
		}
		v, err := operations.campaigns.Create(ctx, in)
		return v.ID, err
	case "character":
		in, err := decodeImport[domain.CharacterInput](item.Payload)
		if err != nil {
			return "", err
		}
		if in.CampaignID != nil {
			id, err := local.ImportedID(ctx, "campaign", *in.CampaignID)
			if err != nil {
				return "", err
			}
			in.CampaignID = &id
		}
		v, err := operations.characters.Create(ctx, in)
		if err != nil {
			return "", err
		}
		updated := domain.CharacterInput{Name: v.Name, SystemID: v.SystemID, CampaignID: v.CampaignID, Description: v.Description, Appearance: v.Appearance, Personality: v.Personality, Background: v.Background, Objective: v.Objective, SystemData: v.SystemData}
		updated.SystemData.Resources.Health.Current = in.SystemData.Resources.Health.Current
		updated.SystemData.Resources.Effort.Current = in.SystemData.Resources.Effort.Current
		updated.SystemData.Resources.Sanity.Current = in.SystemData.Resources.Sanity.Current
		updated.SystemData.Resources.Health.Temporary = in.SystemData.Resources.Health.Temporary
		updated.SystemData.Resources.Effort.Temporary = in.SystemData.Resources.Effort.Temporary
		updated.SystemData.Resources.Sanity.Temporary = in.SystemData.Resources.Sanity.Temporary
		if _, err := operations.characters.Update(ctx, v.ID, updated); err != nil {
			return "", err
		}
		return v.ID, nil
	case "inventory-definition":
		in, err := decodeImport[domain.InventoryInput](item.Payload)
		if err != nil {
			return "", err
		}
		v, err := operations.homebrew.CreateInventory(ctx, in)
		return v.ID, err
	case "ritual-definition":
		in, err := decodeImport[domain.RitualInput](item.Payload)
		if err != nil {
			return "", err
		}
		v, err := operations.homebrew.CreateRitual(ctx, in)
		return v.ID, err
	case "attack-definition":
		in, err := decodeImport[domain.AttackInput](item.Payload)
		if err != nil {
			return "", err
		}
		if in.SourceItemDefinitionID != nil {
			id, err := local.ImportedID(ctx, "inventory-definition", *in.SourceItemDefinitionID)
			if err != nil {
				id, err = local.ImportedID(ctx, "official-inventory", *in.SourceItemDefinitionID)
			}
			if err != nil {
				return "", err
			}
			in.SourceItemDefinitionID = &id
		}
		v, err := operations.homebrew.CreateAttack(ctx, in)
		return v.ID, err
	case "official-inventory", "official-ritual", "official-attack":
		in, err := decodeImport[domain.OfficialReference](item.Payload)
		if err != nil {
			return "", err
		}
		return officialID(ctx, operations, item.Kind, in.Name)
	case "inventory-entry":
		in, err := decodeImport[domain.InventoryImportEntry](item.Payload)
		if err != nil {
			return "", err
		}
		charID, err := local.ImportedID(ctx, "character", in.CharacterSourceID)
		if err != nil {
			return "", err
		}
		defID, err := local.ImportedID(ctx, "inventory-definition", in.DefinitionSourceID)
		if err != nil {
			defID, err = local.ImportedID(ctx, "official-inventory", in.DefinitionSourceID)
		}
		if err != nil {
			return "", err
		}
		characterRepository := operations.characterRepository
		v, err := characterRepository.AddInventory(ctx, charID, defID, in.Quantity)
		if err != nil {
			return "", err
		}
		if in.Equipped || in.Notes != "" {
			fields := map[string]any{"equipped": in.Equipped, "notes": in.Notes}
			if _, err := characterRepository.UpdateInventoryEntry(ctx, charID, v.ID, fields); err != nil {
				return "", err
			}
		}
		return v.ID, nil
	case "ritual-entry":
		in, err := decodeImport[domain.RitualImportEntry](item.Payload)
		if err != nil {
			return "", err
		}
		charID, err := local.ImportedID(ctx, "character", in.CharacterSourceID)
		if err != nil {
			return "", err
		}
		defID, err := local.ImportedID(ctx, "ritual-definition", in.DefinitionSourceID)
		if err != nil {
			defID, err = local.ImportedID(ctx, "official-ritual", in.DefinitionSourceID)
		}
		if err != nil {
			return "", err
		}
		characterRepository := operations.characterRepository
		v, err := characterRepository.AddRitual(ctx, charID, defID)
		if err != nil {
			return "", err
		}
		if in.Notes != "" {
			if _, err := characterRepository.UpdateRitualEntry(ctx, charID, v.ID, map[string]any{"notes": in.Notes}); err != nil {
				return "", err
			}
		}
		return v.ID, nil
	case "attack-entry":
		in, err := decodeImport[domain.AttackImportEntry](item.Payload)
		if err != nil {
			return "", err
		}
		charID, err := local.ImportedID(ctx, "character", in.CharacterSourceID)
		if err != nil {
			return "", err
		}
		defID, err := local.ImportedID(ctx, "attack-definition", in.DefinitionSourceID)
		if err != nil {
			defID, err = local.ImportedID(ctx, "official-attack", in.DefinitionSourceID)
		}
		if err != nil {
			return "", err
		}
		var inventoryID *string
		if in.SourceInventoryEntryID != nil {
			id, err := local.ImportedID(ctx, "inventory-entry", *in.SourceInventoryEntryID)
			if err != nil {
				return "", err
			}
			inventoryID = &id
		}
		characterRepository := operations.characterRepository
		v, err := characterRepository.AddAttack(ctx, charID, defID, inventoryID)
		if err != nil {
			return "", err
		}
		if in.Notes != "" {
			if _, err := characterRepository.UpdateAttackEntry(ctx, charID, v.ID, map[string]any{"notes": in.Notes}); err != nil {
				return "", err
			}
		}
		return v.ID, nil
	default:
		return "", ErrInvalid
	}
}
func officialID(ctx context.Context, operations *domainSession, kind, name string) (string, error) {
	id, err := operations.contentRepository.OrdemSystemID(ctx)
	if err != nil {
		return "", err
	}
	if strings.TrimSpace(name) == "" {
		return "", ErrInvalid
	}
	var matches []string
	switch kind {
	case "official-inventory":
		values, err := operations.contentRepository.InventoryCatalog(ctx, id, "", "")
		if err != nil {
			return "", err
		}
		for _, v := range values {
			if v.Source["kind"] == "official" && strings.EqualFold(v.Name, name) {
				matches = append(matches, v.ID)
			}
		}
	case "official-ritual":
		values, err := operations.contentRepository.RitualCatalog(ctx, id, "", "")
		if err != nil {
			return "", err
		}
		for _, v := range values {
			if v.Source["kind"] == "official" && strings.EqualFold(v.Name, name) {
				matches = append(matches, v.ID)
			}
		}
	case "official-attack":
		values, err := operations.contentRepository.AttackCatalog(ctx, id, "", "")
		if err != nil {
			return "", err
		}
		for _, v := range values {
			if v.Source["kind"] == "official" && strings.EqualFold(v.Name, name) {
				matches = append(matches, v.ID)
			}
		}
	}
	if len(matches) != 1 {
		return "", apperr.ErrNotFound
	}
	return matches[0], nil
}
