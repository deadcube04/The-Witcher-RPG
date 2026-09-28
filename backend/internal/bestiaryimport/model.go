package bestiaryimport

import (
	"encoding/json"
	"fmt"
	"os"
	"path/filepath"
	"strings"
	"unicode"

	"golang.org/x/text/unicode/norm"
)

const IndexURL = "https://ordemparanormal.fandom.com/wiki/Besti%C3%A1rio"

type Threat struct {
	ID          string  `json:"id"`
	Name        string  `json:"name"`
	Slug        string  `json:"slug"`
	Kind        string  `json:"kind"`
	Elements    string  `json:"elements"`
	Source      string  `json:"source"`
	Description *string `json:"description"`
	ImageURL    *string `json:"imageUrl"`
}
type Entry struct {
	Name         string   `json:"name"`
	URL          string   `json:"url"`
	CanonicalURL string   `json:"canonicalUrl"`
	Sections     []string `json:"sections"`
	NonCanonical bool     `json:"nonCanonical"`
	SourceText   string   `json:"sourceText"`
	Description  string   `json:"description"`
	IndexImage   string   `json:"indexImage"`
	ImageSource  string   `json:"imageSource"`
	ImageFile    string   `json:"imageFile"`
	ImageHash    string   `json:"imageHash"`
	ImageURL     string   `json:"imageUrl"`
	Candidates   []Threat `json:"candidates"`
	Decision     string   `json:"decision"` // pending, match, absent, skip
	ThreatID     string   `json:"threatId"`
	Evidence     string   `json:"evidence"`
	Reviewed     bool     `json:"reviewed"`
	Problems     []string `json:"problems"`
	Applied      bool     `json:"applied"`
}
type Manifest struct {
	Version       int      `json:"version"`
	CollectedAt   string   `json:"collectedAt"`
	IndexURL      string   `json:"indexUrl"`
	IndexComplete bool     `json:"indexComplete"`
	Catalog       []Threat `json:"catalog"`
	Entries       []Entry  `json:"entries"`
	Problems      []string `json:"problems"`
}

func normalize(value string) string {
	var b strings.Builder
	for _, r := range norm.NFD.String(strings.ToLower(value)) {
		if unicode.IsLetter(r) || unicode.IsNumber(r) {
			b.WriteRune(r)
		}
	}
	return b.String()
}
func filename(value string) string {
	var b strings.Builder
	for _, r := range norm.NFD.String(strings.ToLower(value)) {
		if unicode.IsLetter(r) || unicode.IsNumber(r) {
			b.WriteRune(r)
		} else if unicode.IsSpace(r) || r == '-' {
			b.WriteByte('-')
		}
	}
	out := strings.Trim(b.String(), "-")
	if out == "" {
		out = "criatura"
	}
	return out
}
func saveJSON(path string, value any) error {
	data, err := json.MarshalIndent(value, "", "  ")
	if err != nil {
		return err
	}
	if err := os.MkdirAll(filepath.Dir(path), 0755); err != nil {
		return err
	}
	if err := os.WriteFile(path+".tmp", append(data, '\n'), 0600); err != nil {
		return err
	}
	return os.Rename(path+".tmp", path)
}
func Load(dir string) (Manifest, error) {
	var m Manifest
	data, err := os.ReadFile(filepath.Join(dir, "manifest.json"))
	if err != nil {
		return m, err
	}
	if err := json.Unmarshal(data, &m); err != nil {
		return m, err
	}
	if m.Version != 1 || m.IndexURL != IndexURL {
		return m, fmt.Errorf("unsupported manifest")
	}
	return m, nil
}
func safeImagePath(dir, relative string) (string, error) {
	clean := filepath.Clean(filepath.FromSlash(relative))
	if filepath.IsAbs(clean) || !strings.HasPrefix(filepath.ToSlash(clean), "images/") || strings.Contains(filepath.ToSlash(clean), "../") {
		return "", fmt.Errorf("invalid image path")
	}
	return filepath.Join(dir, clean), nil
}
