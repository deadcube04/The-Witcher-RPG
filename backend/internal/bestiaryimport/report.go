package bestiaryimport

import (
	"archive/zip"
	"crypto/sha256"
	"encoding/hex"
	"encoding/json"
	"errors"
	"fmt"
	"os"
	"path/filepath"
	"strings"
	"time"
)

func md(text string) string {
	return strings.NewReplacer("[", "\\[", "]", "\\]", "<", "&lt;", ">", "&gt;", "#", "\\#").Replace(text)
}
func Report(m Manifest, dir, reportPath, backupDir string) (string, error) {
	var report strings.Builder
	fmt.Fprintf(&report, "# Criaturas ausentes no banco\n\nColeta: %s. Fonte: %s.\n\n", m.CollectedAt, m.IndexURL)
	if !m.IndexComplete {
		report.WriteString("**Coleta incompleta. Nenhuma ausência pode ser concluída.**\n\n")
	}
	absent := 0
	for _, e := range m.Entries {
		if !m.IndexComplete || !e.Reviewed || e.Decision != "absent" {
			continue
		}
		conflict := false
		for _, t := range m.Catalog {
			if normalize(t.Name) == normalize(e.Name) || normalize(t.Slug) == normalize(e.Name) {
				conflict = true
			}
		}
		if conflict {
			continue
		}
		absent++
		fmt.Fprintf(&report, "## %s\n\n%s\n\n- Fonte: %s\n- Origem: %s\n- Não canônica: %t\n- Imagem no ZIP: `%s`\n- Imagem no MinIO: %s\n- Evidência de ausência: %s\n\n", md(e.Name), md(e.Description), e.URL, md(strings.Join(e.Sections, "; ")), e.NonCanonical, e.ImageFile, e.ImageURL, md(e.Evidence))
	}
	if absent == 0 {
		report.WriteString("Nenhuma criatura foi confirmada como ausente nesta execução.\n")
	}
	if err := os.MkdirAll(filepath.Dir(reportPath), 0755); err != nil {
		return "", err
	}
	if err := os.WriteFile(reportPath, []byte(report.String()), 0644); err != nil {
		return "", err
	}
	var problems strings.Builder
	problems.WriteString("# Estado da coleta e revisão\n\n")
	for _, p := range m.Problems {
		fmt.Fprintf(&problems, "- %s\n", md(p))
	}
	for _, e := range m.Entries {
		if len(e.Problems) > 0 || !e.Reviewed {
			fmt.Fprintf(&problems, "\n## %s\n\nFonte: %s\n\nDecisão: %s; revisada: %t.\n", md(e.Name), e.URL, e.Decision, e.Reviewed)
			for _, p := range e.Problems {
				fmt.Fprintf(&problems, "- %s\n", md(p))
			}
			for _, candidate := range e.Candidates {
				fmt.Fprintf(&problems, "- Candidato: %s (`%s`); %s; %s.\n", md(candidate.Name), candidate.ID, md(candidate.Elements), md(candidate.Source))
			}
		}
	}
	if err := os.WriteFile(filepath.Join(filepath.Dir(reportPath), "bestiario-pendencias.md"), []byte(problems.String()), 0644); err != nil {
		return "", err
	}
	if err := os.MkdirAll(backupDir, 0755); err != nil {
		return "", err
	}
	incomplete := !m.IndexComplete || len(m.Problems) > 0
	for _, e := range m.Entries {
		if e.ImageFile == "" || len(e.Problems) > 0 {
			incomplete = true
		}
	}
	suffix := ""
	if incomplete {
		suffix = "-incompleto"
	}
	archive := filepath.Join(backupDir, "bestiario-"+time.Now().Format("20060102-150405.000")+suffix+".zip")
	f, err := os.OpenFile(archive, os.O_CREATE|os.O_EXCL|os.O_WRONLY, 0600)
	if err != nil {
		return "", err
	}
	writer := zip.NewWriter(f)
	writeErr := writeArchive(writer, m, dir)
	zipErr := writer.Close()
	fileErr := f.Close()
	if writeErr != nil {
		return "", writeErr
	}
	if zipErr != nil {
		return "", zipErr
	}
	if fileErr != nil {
		return "", fileErr
	}
	return archive, nil
}
func writeArchive(writer *zip.Writer, m Manifest, dir string) error {
	data, err := json.MarshalIndent(m, "", "  ")
	if err != nil {
		return err
	}
	entry, err := writer.Create("manifest.json")
	if err != nil {
		return err
	}
	if _, err = entry.Write(data); err != nil {
		return err
	}
	seen := map[string]bool{}
	for _, e := range m.Entries {
		if e.ImageFile == "" || seen[e.ImageFile] {
			continue
		}
		seen[e.ImageFile] = true
		path, err := safeImagePath(dir, e.ImageFile)
		if err != nil {
			return err
		}
		data, err := os.ReadFile(path)
		if err != nil {
			return err
		}
		sum := sha256.Sum256(data)
		if hex.EncodeToString(sum[:]) != e.ImageHash {
			return fmt.Errorf("backup hash mismatch: %s", e.Name)
		}
		entry, err := writer.Create(e.ImageFile)
		if err != nil {
			return err
		}
		if _, err = entry.Write(data); err != nil {
			return err
		}
	}
	// Keep the original database values in every later backup, too.
	beforeDir := filepath.Join(dir, "before")
	backups, err := os.ReadDir(beforeDir)
	if err != nil && !errors.Is(err, os.ErrNotExist) {
		return err
	}
	for _, backup := range backups {
		if backup.IsDir() || !strings.HasSuffix(backup.Name(), ".json") {
			continue
		}
		data, err := os.ReadFile(filepath.Join(beforeDir, backup.Name()))
		if err != nil {
			return err
		}
		var old previousValues
		if err := json.Unmarshal(data, &old); err != nil {
			return fmt.Errorf("invalid previous-values backup: %w", err)
		}
		entry, err := writer.Create("before/" + backup.Name())
		if err != nil {
			return err
		}
		if _, err := entry.Write(data); err != nil {
			return err
		}
	}
	return nil
}
