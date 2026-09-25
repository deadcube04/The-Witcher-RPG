package service

import (
	"bytes"
	"context"
	"encoding/json"
	"errors"
	"fmt"
	"io"
	"strings"

	"RPG-manager/backend/internal/domain"
	"RPG-manager/backend/internal/repository"

	"gorm.io/gorm"
)

var errPreviewRollback = errors.New("preview rollback")

type Importer struct{ store *repository.Store }

func NewImporter(store *repository.Store) *Importer { return &Importer{store: store} }
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
	err := s.store.DB.WithContext(ctx).Transaction(func(tx *gorm.DB) error {
		local := repository.New(tx, s.store.UserID)
		for index, item := range req.Items {
			var target string
			if err := tx.Table("core.local_import_map").Select("target_id").Where("owner_user_id=? AND source_kind=? AND source_id=?", s.store.UserID, item.Kind, item.SourceID).Scan(&target).Error; err != nil {
				return err
			}
			if target != "" {
				result.AlreadyImported++
				continue
			}
			savepoint := fmt.Sprintf("import_item_%d", index)
			if err := tx.SavePoint(savepoint).Error; err != nil {
				return err
			}
			created, err := s.applyOne(ctx, local, item)
			if err != nil {
				if rollbackErr := tx.RollbackTo(savepoint).Error; rollbackErr != nil {
					return rollbackErr
				}
				result.Issues = append(result.Issues, domain.ImportIssue{Kind: item.Kind, SourceID: item.SourceID, Code: importErrorCode(err)})
				continue
			}
			if err := tx.Exec("INSERT INTO core.local_import_map(owner_user_id,source_kind,source_id,target_id) VALUES (?,?,?,?)", s.store.UserID, item.Kind, item.SourceID, created).Error; err != nil {
				return err
			}
			result.Ready++
		}
		if dry || len(result.Issues) > 0 {
			return errPreviewRollback
		}
		return nil
	})
	if dry && errors.Is(err, errPreviewRollback) {
		return result, nil
	}
	if !dry && errors.Is(err, errPreviewRollback) {
		return result, ErrInvalid
	}
	if err != nil {
		return result, fmt.Errorf("local import: %w", err)
	}
	result.Applied = !dry
	return result, nil
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
	case errors.Is(err, repository.ErrNotFound):
		return "CONTENT_NOT_FOUND"
	case errors.Is(err, repository.ErrAlreadyAdded):
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
func importedID(ctx context.Context, s *repository.Store, kind, sourceID string) (string, error) {
	var id string
	err := s.DB.WithContext(ctx).Table("core.local_import_map").Select("target_id").Where("owner_user_id=? AND source_kind=? AND source_id=?", s.UserID, kind, sourceID).Scan(&id).Error
	if err != nil {
		return "", err
	}
	if id == "" {
		return "", repository.ErrNotFound
	}
	return id, nil
}
func (s *Importer) applyOne(ctx context.Context, store *repository.Store, item domain.ImportRecord) (string, error) {
	switch item.Kind {
	case "campaign":
		in, err := decodeImport[domain.CampaignInput](item.Payload)
		if err != nil {
			return "", err
		}
		v, err := NewCore(store).CreateCampaign(ctx, in)
		return v.ID, err
	case "character":
		in, err := decodeImport[domain.CharacterInput](item.Payload)
		if err != nil {
			return "", err
		}
		if in.CampaignID != nil {
			id, err := importedID(ctx, store, "campaign", *in.CampaignID)
			if err != nil {
				return "", err
			}
			in.CampaignID = &id
		}
		v, err := NewCharacter(store).Create(ctx, in)
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
		if _, err := NewCharacter(store).Update(ctx, v.ID, updated); err != nil {
			return "", err
		}
		return v.ID, nil
	case "inventory-definition":
		in, err := decodeImport[domain.InventoryInput](item.Payload)
		if err != nil {
			return "", err
		}
		v, err := NewHomebrew(store).CreateInventory(ctx, in)
		return v.ID, err
	case "ritual-definition":
		in, err := decodeImport[domain.RitualInput](item.Payload)
		if err != nil {
			return "", err
		}
		v, err := NewHomebrew(store).CreateRitual(ctx, in)
		return v.ID, err
	case "attack-definition":
		in, err := decodeImport[domain.AttackInput](item.Payload)
		if err != nil {
			return "", err
		}
		if in.SourceItemDefinitionID != nil {
			id, err := importedID(ctx, store, "inventory-definition", *in.SourceItemDefinitionID)
			if err != nil {
				id, err = importedID(ctx, store, "official-inventory", *in.SourceItemDefinitionID)
			}
			if err != nil {
				return "", err
			}
			in.SourceItemDefinitionID = &id
		}
		v, err := NewHomebrew(store).CreateAttack(ctx, in)
		return v.ID, err
	case "official-inventory", "official-ritual", "official-attack":
		in, err := decodeImport[domain.OfficialReference](item.Payload)
		if err != nil {
			return "", err
		}
		return officialID(ctx, store, item.Kind, in.Name)
	case "inventory-entry":
		in, err := decodeImport[domain.InventoryImportEntry](item.Payload)
		if err != nil {
			return "", err
		}
		charID, err := importedID(ctx, store, "character", in.CharacterSourceID)
		if err != nil {
			return "", err
		}
		defID, err := importedID(ctx, store, "inventory-definition", in.DefinitionSourceID)
		if err != nil {
			defID, err = importedID(ctx, store, "official-inventory", in.DefinitionSourceID)
		}
		if err != nil {
			return "", err
		}
		v, err := store.AddInventory(ctx, charID, defID, in.Quantity)
		if err != nil {
			return "", err
		}
		if in.Equipped || in.Notes != "" {
			fields := map[string]any{"equipped": in.Equipped, "notes": in.Notes}
			if _, err := store.UpdateInventoryEntry(ctx, charID, v.ID, fields); err != nil {
				return "", err
			}
		}
		return v.ID, nil
	case "ritual-entry":
		in, err := decodeImport[domain.RitualImportEntry](item.Payload)
		if err != nil {
			return "", err
		}
		charID, err := importedID(ctx, store, "character", in.CharacterSourceID)
		if err != nil {
			return "", err
		}
		defID, err := importedID(ctx, store, "ritual-definition", in.DefinitionSourceID)
		if err != nil {
			defID, err = importedID(ctx, store, "official-ritual", in.DefinitionSourceID)
		}
		if err != nil {
			return "", err
		}
		v, err := store.AddRitual(ctx, charID, defID)
		if err != nil {
			return "", err
		}
		if in.Notes != "" {
			if _, err := store.UpdateRitualEntry(ctx, charID, v.ID, map[string]any{"notes": in.Notes}); err != nil {
				return "", err
			}
		}
		return v.ID, nil
	case "attack-entry":
		in, err := decodeImport[domain.AttackImportEntry](item.Payload)
		if err != nil {
			return "", err
		}
		charID, err := importedID(ctx, store, "character", in.CharacterSourceID)
		if err != nil {
			return "", err
		}
		defID, err := importedID(ctx, store, "attack-definition", in.DefinitionSourceID)
		if err != nil {
			defID, err = importedID(ctx, store, "official-attack", in.DefinitionSourceID)
		}
		if err != nil {
			return "", err
		}
		var inventoryID *string
		if in.SourceInventoryEntryID != nil {
			id, err := importedID(ctx, store, "inventory-entry", *in.SourceInventoryEntryID)
			if err != nil {
				return "", err
			}
			inventoryID = &id
		}
		v, err := store.AddAttack(ctx, charID, defID, inventoryID)
		if err != nil {
			return "", err
		}
		if in.Notes != "" {
			if _, err := store.UpdateAttackEntry(ctx, charID, v.ID, map[string]any{"notes": in.Notes}); err != nil {
				return "", err
			}
		}
		return v.ID, nil
	default:
		return "", ErrInvalid
	}
}
func officialID(ctx context.Context, store *repository.Store, kind, name string) (string, error) {
	id, err := store.OrdemSystemID(ctx)
	if err != nil {
		return "", err
	}
	if strings.TrimSpace(name) == "" {
		return "", ErrInvalid
	}
	var matches []string
	switch kind {
	case "official-inventory":
		values, err := store.InventoryCatalog(ctx, id, "", "")
		if err != nil {
			return "", err
		}
		for _, v := range values {
			if v.Source["kind"] == "official" && strings.EqualFold(v.Name, name) {
				matches = append(matches, v.ID)
			}
		}
	case "official-ritual":
		values, err := store.RitualCatalog(ctx, id, "", "")
		if err != nil {
			return "", err
		}
		for _, v := range values {
			if v.Source["kind"] == "official" && strings.EqualFold(v.Name, name) {
				matches = append(matches, v.ID)
			}
		}
	case "official-attack":
		values, err := store.AttackCatalog(ctx, id, "", "")
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
		return "", repository.ErrNotFound
	}
	return matches[0], nil
}
