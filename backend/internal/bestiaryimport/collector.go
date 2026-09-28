package bestiaryimport

import (
	"RPG-manager/backend/internal/media"
	"context"
	"crypto/sha256"
	"encoding/hex"
	"fmt"
	"io"
	"net/http"
	"net/url"
	"os"
	"path/filepath"
	"strings"
	"time"

	"gorm.io/gorm"
)

type Collector struct{ client *http.Client }

func NewCollector() *Collector {
	return &Collector{client: &http.Client{Timeout: 30 * time.Second, CheckRedirect: func(req *http.Request, via []*http.Request) error {
		if len(via) >= 5 || !allowedURL(req.URL) {
			return fmt.Errorf("redirect outside source allowlist")
		}
		return nil
	}}}
}
func allowedURL(u *url.URL) bool {
	return u.Scheme == "https" && u.User == nil && (u.Host == "ordemparanormal.fandom.com" || u.Host == "static.wikia.nocookie.net")
}
func (c *Collector) fetch(ctx context.Context, raw string, limit int64) ([]byte, error) {
	u, err := url.Parse(raw)
	if err != nil || !allowedURL(u) {
		return nil, fmt.Errorf("source URL is not allowed")
	}
	var result []byte
	for attempt := 0; attempt < 3; attempt++ {
		req, err := http.NewRequestWithContext(ctx, http.MethodGet, raw, nil)
		if err != nil {
			return nil, err
		}
		req.Header.Set("User-Agent", "RPGManagerLocalBestiary/1.0 (HTML collection; no Fandom API)")
		resp, err := c.client.Do(req)
		if err != nil {
			return nil, fmt.Errorf("fetch source: %w", err)
		}
		result, err = io.ReadAll(io.LimitReader(resp.Body, limit+1))
		closeErr := resp.Body.Close()
		if err != nil {
			return nil, err
		}
		if closeErr != nil {
			return nil, closeErr
		}
		if (resp.StatusCode == 429 || resp.StatusCode >= 500) && attempt < 2 {
			timer := time.NewTimer(time.Duration(attempt+1) * 2 * time.Second)
			select {
			case <-ctx.Done():
				timer.Stop()
				return nil, ctx.Err()
			case <-timer.C:
			}
			continue
		}
		if resp.StatusCode != 200 {
			return nil, fmt.Errorf("HTTP %d from %s", resp.StatusCode, u.Host)
		}
		if int64(len(result)) > limit {
			return nil, fmt.Errorf("source exceeds size limit")
		}
		return result, nil
	}
	return nil, fmt.Errorf("source unavailable after retries")
}
func Catalog(ctx context.Context, db *gorm.DB) ([]Threat, error) {
	result := []Threat{}
	err := db.WithContext(ctx).Raw(`SELECT c.id,c.name,t.slug,COALESCE(bt.name,'') AS kind,COALESCE(t.source_ref,'') AS source,c.description,c.image_url,
 COALESCE((SELECT string_agg(e.name, ', ' ORDER BY e.name) FROM ordem.threat_element te JOIN ordem.element e ON e.id=te.element_id WHERE te.threat_id=c.id),'') AS elements
 FROM core.rpg_character c JOIN ordem.threat t ON t.character_id=c.id LEFT JOIN ordem.being_type bt ON bt.id=t.being_type_id
 WHERE c.character_type='THREAT' AND c.rpg_system_id=(SELECT id FROM core.rpg_system WHERE slug='ordem-paranormal') ORDER BY c.name`).Scan(&result).Error
	if err != nil {
		return nil, fmt.Errorf("read current catalog: %w", err)
	}
	return result, nil
}
func suggest(e *Entry, catalog []Threat) {
	names := []string{normalize(e.Name)}
	if e.CanonicalURL != "" {
		u, err := url.Parse(e.CanonicalURL)
		if err == nil {
			names = append(names, normalize(strings.ReplaceAll(strings.TrimPrefix(u.Path, "/wiki/"), "_", " ")))
		}
	}
	e.Candidates = []Threat{}
	for _, t := range catalog {
		name := normalize(t.Name)
		for _, candidate := range names {
			if name == candidate || normalize(t.Slug) == candidate || strings.Contains(name, candidate) || strings.Contains(candidate, name) {
				e.Candidates = append(e.Candidates, t)
				break
			}
		}
	}
	// A candidate is evidence for review, never permission to overwrite or declare absence.
}
func (c *Collector) Collect(ctx context.Context, db *gorm.DB, dir string) (Manifest, error) {
	catalog, err := Catalog(ctx, db)
	if err != nil {
		return Manifest{}, err
	}
	m, loadErr := Load(dir)
	if loadErr != nil && !os.IsNotExist(loadErr) {
		return m, loadErr
	}
	if os.IsNotExist(loadErr) {
		m = Manifest{Version: 1, CollectedAt: time.Now().UTC().Format(time.RFC3339), IndexURL: IndexURL, Entries: []Entry{}, Problems: []string{}}
	}
	m.Catalog = catalog
	m.Problems = []string{}
	if err := os.MkdirAll(filepath.Join(dir, "images"), 0755); err != nil {
		return m, err
	}
	if err := os.MkdirAll(filepath.Join(dir, "sources"), 0755); err != nil {
		return m, err
	}
	if !m.IndexComplete {
		data, err := c.fetch(ctx, IndexURL, 20<<20)
		if err == nil {
			err = os.WriteFile(filepath.Join(dir, "sources", "index.html"), data, 0600)
		}
		if err == nil {
			m.Entries, err = parseIndex(data)
		}
		if err != nil {
			m.Problems = append(m.Problems, err.Error())
			if saveErr := saveJSON(filepath.Join(dir, "manifest.json"), m); saveErr != nil {
				return m, saveErr
			}
			return m, err
		}
		m.IndexComplete = true
	}
	indexData, err := os.ReadFile(filepath.Join(dir, "sources", "index.html"))
	if err != nil {
		return m, err
	}
	indexEntries, err := parseIndex(indexData)
	if err != nil {
		return m, err
	}
	for i := range m.Entries {
		e := &m.Entries[i]
		for _, indexed := range indexEntries {
			if indexed.Name == e.Name && indexed.URL == e.URL {
				e.IndexImage = indexed.IndexImage
				if e.IndexImage != "" && e.ImageSource != e.IndexImage {
					e.ImageSource = e.IndexImage
					e.ImageFile = ""
					e.ImageHash = ""
					e.ImageURL = ""
				}
			}
		}

		if e.SourceText != "" && e.ImageFile != "" && len(e.Problems) == 0 {
			continue
		}
		e.Problems = []string{}
		sourcePath := filepath.Join(dir, "sources", fmt.Sprintf("%03d.html", i+1))
		data, err := os.ReadFile(sourcePath)
		if os.IsNotExist(err) {
			data, err = c.fetch(ctx, e.URL, 20<<20)
			if err == nil {
				err = os.WriteFile(sourcePath, data, 0600)
			}
		}
		if err == nil {
			err = parseArticle(data, e)
		}
		if err != nil {
			e.Problems = append(e.Problems, err.Error())
		} else if e.ImageSource != "" {
			imageData, imageErr := c.fetch(ctx, e.ImageSource, media.MaxBytes)
			if imageErr == nil {
				format, validateErr := media.ValidateImage(imageData)
				imageErr = validateErr
				if imageErr == nil {
					sum := sha256.Sum256(imageData)
					e.ImageHash = hex.EncodeToString(sum[:])
					e.ImageFile = "images/" + filename(e.Name) + "-" + e.ImageHash[:12] + "." + format
					imageErr = os.WriteFile(filepath.Join(dir, filepath.FromSlash(e.ImageFile)), imageData, 0600)
				}
			}
			if imageErr != nil {
				e.Problems = append(e.Problems, imageErr.Error())
			}
		}
		suggest(e, catalog)
		if err := saveJSON(filepath.Join(dir, "manifest.json"), m); err != nil {
			return m, err
		}
		timer := time.NewTimer(500 * time.Millisecond)
		select {
		case <-ctx.Done():
			timer.Stop()
			return m, ctx.Err()
		case <-timer.C:
		}
	}
	return m, saveJSON(filepath.Join(dir, "manifest.json"), m)
}
