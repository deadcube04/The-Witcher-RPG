package characters

import (
	"RPG-manager/backend/internal/apperr"
	"context"
	"errors"
	"fmt"
	"time"

	"gorm.io/gorm"
)

type RitualEntry struct {
	ID           string    `json:"id"`
	CharacterID  string    `json:"characterId"`
	DefinitionID string    `json:"definitionId"`
	Notes        string    `json:"notes"`
	CreatedAt    time.Time `json:"createdAt"`
	UpdatedAt    time.Time `json:"updatedAt"`
}
type CharacterRitual struct {
	Entry      RitualEntry      `json:"entry"`
	Definition RitualDefinition `json:"definition"`
}

func (s *Repository) RitualEntries(ctx context.Context, characterID string) ([]CharacterRitual, error) {
	c, err := s.Character(ctx, characterID)
	if err != nil {
		return nil, err
	}
	var rows []struct {
		ID           string
		CharacterID  string
		DefinitionID string
		Notes        *string
		CreatedAt    time.Time
		UpdatedAt    time.Time
	}
	if err := s.DB.WithContext(ctx).Table("core.character_ability").Select("id,character_id,ability_id AS definition_id,notes,created_at,updated_at").Where("character_id=?", characterID).Order("created_at,id").Scan(&rows).Error; err != nil {
		return nil, fmt.Errorf("list rituals: %w", err)
	}
	defs, err := s.RitualCatalog(ctx, c.SystemID, "", "")
	if err != nil {
		return nil, err
	}
	byID := make(map[string]RitualDefinition)
	for _, d := range defs {
		byID[d.ID] = d
	}
	out := make([]CharacterRitual, 0, len(rows))
	for _, r := range rows {
		d, ok := byID[r.DefinitionID]
		if !ok {
			continue
		}
		out = append(out, CharacterRitual{Entry: RitualEntry{ID: r.ID, CharacterID: r.CharacterID, DefinitionID: r.DefinitionID, Notes: deref(r.Notes), CreatedAt: utcTime(r.CreatedAt), UpdatedAt: utcTime(r.UpdatedAt)}, Definition: d})
	}
	return out, nil
}
func (s *Repository) RitualEntry(ctx context.Context, characterID, entryID string) (RitualEntry, error) {
	if _, err := s.Character(ctx, characterID); err != nil {
		return RitualEntry{}, err
	}
	var row struct {
		ID           string
		CharacterID  string
		DefinitionID string
		Notes        *string
		CreatedAt    time.Time
		UpdatedAt    time.Time
	}
	err := s.DB.WithContext(ctx).Table("core.character_ability").Select("id,character_id,ability_id AS definition_id,notes,created_at,updated_at").Where("id=? AND character_id=?", entryID, characterID).Take(&row).Error
	if errors.Is(err, gorm.ErrRecordNotFound) {
		return RitualEntry{}, apperr.ErrNotFound
	}
	if err != nil {
		return RitualEntry{}, err
	}
	return RitualEntry{ID: row.ID, CharacterID: row.CharacterID, DefinitionID: row.DefinitionID, Notes: deref(row.Notes), CreatedAt: utcTime(row.CreatedAt), UpdatedAt: utcTime(row.UpdatedAt)}, nil
}
func (s *Repository) AddRitual(ctx context.Context, characterID, definitionID string) (RitualEntry, error) {
	c, err := s.Character(ctx, characterID)
	if err != nil {
		return RitualEntry{}, err
	}
	d, err := s.homebrewRitual(ctx, definitionID)
	if err != nil {
		return RitualEntry{}, err
	}
	if d.SystemID != c.SystemID {
		return RitualEntry{}, apperr.ErrNotFound
	}
	var count int64
	if err := s.DB.WithContext(ctx).Table("core.character_ability").Where("character_id=? AND ability_id=?", characterID, definitionID).Count(&count).Error; err != nil {
		return RitualEntry{}, err
	}
	if count > 0 {
		return RitualEntry{}, apperr.ErrAlreadyAdded
	}
	var id string
	err = s.DB.WithContext(ctx).Raw("INSERT INTO core.character_ability(character_id,ability_id,rpg_system_id) VALUES (?,?,?) RETURNING id", characterID, definitionID, c.SystemID).Scan(&id).Error
	if err != nil {
		return RitualEntry{}, fmt.Errorf("add ritual: %w", err)
	}
	return s.RitualEntry(ctx, characterID, id)
}
func (s *Repository) UpdateRitualEntry(ctx context.Context, characterID, entryID string, fields map[string]any) (RitualEntry, error) {
	c, err := s.Character(ctx, characterID)
	if err != nil {
		return RitualEntry{}, err
	}
	if id, ok := fields["ability_id"]; ok {
		d, err := s.homebrewRitual(ctx, id.(string))
		if err != nil {
			return RitualEntry{}, err
		}
		if d.SystemID != c.SystemID {
			return RitualEntry{}, apperr.ErrNotFound
		}
	}
	fields["updated_at"] = time.Now()
	result := s.DB.WithContext(ctx).Table("core.character_ability").Where("id=? AND character_id=?", entryID, characterID).Updates(fields)
	if result.Error != nil {
		return RitualEntry{}, fmt.Errorf("update ritual entry: %w", result.Error)
	}
	if result.RowsAffected == 0 {
		return RitualEntry{}, apperr.ErrNotFound
	}
	return s.RitualEntry(ctx, characterID, entryID)
}
func (s *Repository) DeleteRitualEntry(ctx context.Context, characterID, entryID string) error {
	if _, err := s.Character(ctx, characterID); err != nil {
		return err
	}
	result := s.DB.WithContext(ctx).Exec("DELETE FROM core.character_ability WHERE id=? AND character_id=?", entryID, characterID)
	if result.Error != nil {
		return result.Error
	}
	if result.RowsAffected == 0 {
		return apperr.ErrNotFound
	}
	return nil
}
