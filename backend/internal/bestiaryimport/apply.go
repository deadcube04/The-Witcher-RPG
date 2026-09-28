package bestiaryimport

import (
	"RPG-manager/backend/internal/media"
	"context"
	"crypto/sha256"
	"encoding/hex"
	"errors"
	"fmt"
	"os"
	"path/filepath"
	"strings"
	"time"

	"gorm.io/gorm"
	"gorm.io/gorm/clause"
)

func Review(ctx context.Context, db *gorm.DB, dir, name, decision, id, description, evidence string) error {
	m, err := Load(dir)
	if err != nil {
		return err
	}
	if !m.IndexComplete {
		return fmt.Errorf("index collection incomplete")
	}
	if decision != "match" && decision != "absent" && decision != "skip" {
		return fmt.Errorf("decision must be match, absent or skip")
	}
	if len(strings.TrimSpace(evidence)) < 20 {
		return fmt.Errorf("record the evidence supporting this decision (at least 20 characters)")
	}
	catalog, err := Catalog(ctx, db)
	if err != nil {
		return err
	}
	found := -1
	for i, e := range m.Entries {
		if e.Name == name || e.URL == name {
			if found >= 0 {
				return fmt.Errorf("name is ambiguous; use source URL")
			}
			found = i
		}
	}
	if found < 0 {
		return fmt.Errorf("entry not found")
	}
	e := &m.Entries[found]
	if decision != "skip" && (e.SourceText == "" || len(strings.TrimSpace(description)) < 30 || len([]rune(description)) > 2000) {
		return fmt.Errorf("a collected source and reviewed description (30–2000 characters) are required")
	}
	if decision == "match" {
		exists := false
		for _, t := range catalog {
			if t.ID == id {
				exists = true
			}
		}
		if !exists {
			return fmt.Errorf("selected threat is not in current catalog")
		}
		for i, other := range m.Entries {
			if i != found && other.Reviewed && other.Decision == "match" && other.ThreatID == id {
				return fmt.Errorf("another article already maps to this threat; resolve duplicate explicitly")
			}
		}
	} else {
		id = ""
	}
	if decision == "absent" {
		for _, t := range catalog {
			if normalize(t.Name) == normalize(e.Name) || normalize(t.Slug) == normalize(e.Name) {
				return fmt.Errorf("exact candidate exists in current catalog; cannot mark absent")
			}
		}
	}
	e.Decision = decision
	e.ThreatID = id
	e.Description = strings.TrimSpace(description)
	e.Evidence = strings.TrimSpace(evidence)
	e.Reviewed = true
	m.Catalog = catalog
	return saveJSON(filepath.Join(dir, "manifest.json"), m)
}

type previousValues struct {
	ID          string  `json:"id"`
	Name        string  `json:"name"`
	Description *string `json:"description"`
	ImageURL    *string `json:"imageUrl"`
}

func Apply(ctx context.Context, db *gorm.DB, storage *media.Storage, dir string) (Manifest, error) {
	m, err := Load(dir)
	if err != nil {
		return m, err
	}
	if !m.IndexComplete {
		return m, fmt.Errorf("index collection incomplete; nothing applied")
	}
	catalog, err := Catalog(ctx, db)
	if err != nil {
		return m, err
	}
	m.Catalog = catalog
	seen := map[string]bool{}
	for i := range m.Entries {
		e := &m.Entries[i]
		if !e.Reviewed || e.Decision == "pending" || e.Decision == "skip" {
			continue
		}
		if e.Decision != "match" && e.Decision != "absent" {
			return m, fmt.Errorf("invalid decision for %s", e.Name)
		}
		if strings.TrimSpace(e.SourceText) == "" || len(strings.TrimSpace(e.Description)) < 30 || len([]rune(e.Description)) > 2000 || len(strings.TrimSpace(e.Evidence)) < 20 {
			return m, fmt.Errorf("incomplete reviewed evidence: %s", e.Name)
		}
		if e.Decision == "absent" {
			for _, t := range catalog {
				if normalize(t.Name) == normalize(e.Name) || normalize(t.Slug) == normalize(e.Name) {
					return m, fmt.Errorf("catalog changed; review absence again: %s", e.Name)
				}
			}
		}
		if e.Decision == "match" {
			if seen[e.ThreatID] {
				return m, fmt.Errorf("duplicate target: %s", e.ThreatID)
			}
			seen[e.ThreatID] = true
			exists := false
			for _, t := range catalog {
				if t.ID == e.ThreatID {
					exists = true
				}
			}
			if !exists {
				return m, fmt.Errorf("target no longer in catalog: %s", e.Name)
			}
		}
	}
	// Upload and save the durable URLs before the DB phase; retries reuse content hashes.
	for i := range m.Entries {
		e := &m.Entries[i]
		if e.ImageFile == "" {
			continue
		}
		path, err := safeImagePath(dir, e.ImageFile)
		if err != nil {
			return m, err
		}
		data, err := os.ReadFile(path)
		if err != nil {
			return m, err
		}
		hash := sha256.Sum256(data)
		if hex.EncodeToString(hash[:]) != e.ImageHash {
			return m, fmt.Errorf("image hash mismatch: %s", e.Name)
		}
		imageURL, _, err := storage.PutImage(ctx, "bestiary", data)
		if err != nil {
			return m, err
		}
		e.ImageURL = imageURL
		if err := saveJSON(filepath.Join(dir, "manifest.json"), m); err != nil {
			return m, err
		}
	}
	appliedBefore := make([]bool, len(m.Entries))
	for i := range m.Entries {
		appliedBefore[i] = m.Entries[i].Applied
	}
	err = db.WithContext(ctx).Transaction(func(tx *gorm.DB) error {
		for i := range m.Entries {
			e := &m.Entries[i]
			if !e.Reviewed || e.Decision != "match" {
				continue
			}
			var old previousValues
			if err := tx.Table("core.rpg_character").Clauses(clause.Locking{Strength: "UPDATE"}).Select("id,name,description,image_url").Where("id=? AND character_type='THREAT' AND rpg_system_id=(SELECT id FROM core.rpg_system WHERE slug='ordem-paranormal')", e.ThreatID).Take(&old).Error; err != nil {
				return fmt.Errorf("lock target: %w", err)
			}
			updates := map[string]any{}
			if old.Description == nil || strings.TrimSpace(*old.Description) == "" {
				updates["description"] = e.Description
			}
			if (old.ImageURL == nil || strings.TrimSpace(*old.ImageURL) == "") && e.ImageURL != "" {
				updates["image_url"] = e.ImageURL
			}
			if len(updates) == 0 {
				e.Applied = true
				continue
			}
			backup := filepath.Join(dir, "before", e.ThreatID+".json")
			if _, err := os.Stat(backup); errors.Is(err, os.ErrNotExist) {
				if err := saveJSON(backup, old); err != nil {
					return err
				}
			} else if err != nil {
				return err
			}
			updates["updated_at"] = time.Now()
			result := tx.Table("core.rpg_character").Where("id=?", e.ThreatID).Updates(updates)
			if result.Error != nil {
				return result.Error
			}
			if result.RowsAffected != 1 {
				return fmt.Errorf("target changed while applying %s", e.Name)
			}
			e.Applied = true
		}
		return nil
	})
	if err != nil {
		for i := range m.Entries {
			m.Entries[i].Applied = appliedBefore[i]
		}
		return m, fmt.Errorf("apply rolled back: %w", err)
	}
	return m, saveJSON(filepath.Join(dir, "manifest.json"), m)
}
