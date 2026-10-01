package supplements

import (
	"context"
	"errors"
	"fmt"
	"strconv"
	"strings"

	"RPG-manager/backend/internal/apperr"
	"gorm.io/gorm"
	"gorm.io/gorm/clause"
)

var ErrIssueResolved = errors.New("supplement review issue already resolved")
var ErrValueChanged = errors.New("supplement value changed")

var Categories = []string{"survivor", "trails", "powers", "rituals", "items", "modifications", "threats"}

type Rule struct {
	ID         string  `json:"id"`
	ParentID   *string `json:"parentId"`
	Slug       string  `json:"slug"`
	Name       string  `json:"name"`
	Optional   bool    `json:"optional" gorm:"column:is_optional"`
	SourcePage int     `json:"sourcePage" gorm:"column:source_page_start"`
	Text       string  `json:"text" gorm:"column:rule_text"`
}

type Survivor struct {
	ID                string          `json:"id"`
	Name              string          `json:"name"`
	InitialPV         int             `json:"initialPv"`
	InitialPE         int             `json:"initialPe"`
	InitialSAN        int             `json:"initialSan"`
	PVPerStage        int             `json:"pvPerStage"`
	PEPerStage        int             `json:"pePerStage"`
	SANPerStage       int             `json:"sanPerStage"`
	TrainedSkillsRule string          `json:"trainedSkillsRule"`
	ProficiencyRule   string          `json:"proficiencyRule"`
	Stages            []SurvivorStage `json:"stages" gorm:"-"`
	Trails            []SurvivorTrail `json:"trails" gorm:"-"`
}

type SurvivorStage struct {
	Stage       int    `json:"stage"`
	FeatureName string `json:"featureName"`
	EffectText  string `json:"effectText"`
}
type SurvivorTrail struct {
	ID        string                 `json:"id"`
	Name      string                 `json:"name"`
	Abilities []SurvivorTrailAbility `json:"abilities" gorm:"-"`
}
type SurvivorTrailAbility struct {
	Stage      int    `json:"stage"`
	Name       string `json:"name"`
	EffectText string `json:"effectText"`
}

type Catalog struct {
	ID         string    `json:"id"`
	SystemID   string    `json:"systemId"`
	Slug       string    `json:"slug"`
	Name       string    `json:"name"`
	Categories []string  `json:"categories"`
	Rules      []Rule    `json:"rules"`
	Survivor   *Survivor `json:"survivor"`
}

type Issue struct {
	ID         string  `json:"id"`
	SourcePage int     `json:"sourcePage"`
	Kind       string  `json:"kind" gorm:"column:issue_kind"`
	SourceText string  `json:"sourceText"`
	Handling   string  `json:"handling"`
	Resolved   bool    `json:"resolved"`
	TargetKind *string `json:"targetKind"`
	TargetID   *string `json:"targetId"`
	FieldName  *string `json:"fieldName"`
}

type Candidate struct {
	ID   string `json:"id"`
	Kind string `json:"kind"`
	Name string `json:"name"`
}
type SourcePage struct {
	PDFPage    int    `json:"pdfPage"`
	SourceFile string `json:"sourceFile"`
	RawText    string `json:"rawText"`
	SHA256     string `json:"sha256"`
}

func (s *Service) IssueSource(ctx context.Context, supplementID, issueID string) (SourcePage, error) {
	var row SourcePage
	err := s.db.WithContext(ctx).Table("ordem.supplement_review_issue AS i").Select("p.pdf_page, p.source_file, p.raw_text, p.sha256").Joins("JOIN core.supplement_page AS p ON p.supplement_id=i.supplement_id AND p.pdf_page=i.source_page").Where("i.id=? AND i.supplement_id=?", issueID, supplementID).Take(&row).Error
	if errors.Is(err, gorm.ErrRecordNotFound) {
		return row, apperr.ErrNotFound
	}
	return row, err
}

type Correction struct {
	TargetKind    string `json:"targetKind" binding:"required"`
	TargetID      string `json:"targetId" binding:"required,uuid"`
	FieldName     string `json:"fieldName" binding:"required"`
	ExpectedValue string `json:"expectedValue"`
	NewValue      string `json:"newValue" binding:"required"`
	Justification string `json:"justification" binding:"required,min=10"`
}

type Service struct {
	db     *gorm.DB
	userID string
}

func NewService(db *gorm.DB, userID string) *Service { return &Service{db: db, userID: userID} }

func (s *Service) Catalog(ctx context.Context) ([]Catalog, error) {
	var rows []struct{ ID, SystemID, Slug, Name string }
	if err := s.db.WithContext(ctx).Table("core.rpg_supplement AS s").Select("s.id, s.rpg_system_id AS system_id, s.slug, s.name").Order("s.name").Scan(&rows).Error; err != nil {
		return nil, fmt.Errorf("supplement catalog: %w", err)
	}
	out := make([]Catalog, 0, len(rows))
	for _, row := range rows {
		item := Catalog{ID: row.ID, SystemID: row.SystemID, Slug: row.Slug, Name: row.Name, Categories: append([]string{}, Categories...), Rules: []Rule{}}
		if err := s.db.WithContext(ctx).Table("ordem.supplement_rule").Select("id, parent_id, slug, name, is_optional, source_page_start, rule_text").Where("supplement_id = ?", row.ID).Order("source_page_start, name").Scan(&item.Rules).Error; err != nil {
			return nil, fmt.Errorf("supplement rules: %w", err)
		}
		var survivor Survivor
		err := s.db.WithContext(ctx).Table("ordem.supplement_survivor_class").Select("id, name, initial_pv, initial_pe, initial_san, pv_per_stage, pe_per_stage, san_per_stage, trained_skills_rule, proficiency_rule").Where("supplement_id = ?", row.ID).Take(&survivor).Error
		if err != nil && !errors.Is(err, gorm.ErrRecordNotFound) {
			return nil, fmt.Errorf("survivor class: %w", err)
		}
		if err == nil {
			survivor.Stages = []SurvivorStage{}
			survivor.Trails = []SurvivorTrail{}
			if err := s.db.WithContext(ctx).Table("ordem.supplement_survivor_stage").Select("stage, feature_name, effect_text").Where("class_id=?", survivor.ID).Order("stage").Scan(&survivor.Stages).Error; err != nil {
				return nil, err
			}
			if err := s.db.WithContext(ctx).Table("ordem.supplement_survivor_trail").Select("id, name").Where("class_id=?", survivor.ID).Order("name").Scan(&survivor.Trails).Error; err != nil {
				return nil, err
			}
			for i := range survivor.Trails {
				survivor.Trails[i].Abilities = []SurvivorTrailAbility{}
				if err := s.db.WithContext(ctx).Table("ordem.supplement_survivor_trail_ability").Select("stage, name, effect_text").Where("trail_id=?", survivor.Trails[i].ID).Order("stage").Scan(&survivor.Trails[i].Abilities).Error; err != nil {
					return nil, err
				}
			}
			item.Survivor = &survivor
		}
		out = append(out, item)
	}
	return out, nil
}

func (s *Service) Issues(ctx context.Context, supplementID, state string) ([]Issue, error) {
	if state != "" && state != "open" && state != "resolved" {
		return nil, apperr.ErrInvalid
	}
	query := s.db.WithContext(ctx).Table("ordem.supplement_review_issue AS i").Select("i.id, i.source_page, i.issue_kind, i.source_text, i.handling, i.resolved, t.target_kind, t.target_id, t.field_name").Joins("LEFT JOIN ordem.supplement_review_target AS t ON t.issue_id=i.id").Where("i.supplement_id=?", supplementID)
	if state != "" {
		query = query.Where("i.resolved=?", state == "resolved")
	}
	var items []Issue
	if err := query.Order("i.resolved, i.source_page, i.issue_kind, i.id").Scan(&items).Error; err != nil {
		return nil, fmt.Errorf("review issues: %w", err)
	}
	return items, nil
}

func (s *Service) Candidates(ctx context.Context, supplementID, issueID string) ([]Candidate, error) {
	var issue struct{ SourcePage int }
	err := s.db.WithContext(ctx).Table("ordem.supplement_review_issue").Select("source_page").Where("id=? AND supplement_id=?", issueID, supplementID).Take(&issue).Error
	if errors.Is(err, gorm.ErrRecordNotFound) {
		return nil, apperr.ErrNotFound
	}
	if err != nil {
		return nil, err
	}
	var out []Candidate
	for _, spec := range []struct{ table, kind string }{{"core.origin_definition", "origin"}, {"core.archetype_definition", "trail"}, {"core.ability_definition", "ability"}, {"core.item_definition", "item"}, {"ordem.item_modification", "modification"}, {"ordem.supplement_rule", "rule"}, {"core.rpg_character", "threat"}} {
		var rows []struct{ ID, Name string }
		start, end := "supplement_page_start", "supplement_page_end"
		if spec.kind == "rule" {
			start, end = "source_page_start", "source_page_end"
		}
		if err := s.db.WithContext(ctx).Table(spec.table).Select("id, name").Where("supplement_id=? AND "+start+" <= ? AND "+end+" >= ?", supplementID, issue.SourcePage, issue.SourcePage).Scan(&rows).Error; err != nil {
			return nil, err
		}
		for _, row := range rows {
			out = append(out, Candidate{ID: row.ID, Kind: spec.kind, Name: row.Name})
		}
	}
	return out, nil
}

type correctionTarget struct {
	table, idColumn, supplementColumn, field string
	numeric                                  bool
}

func targetFor(kind, field string) (correctionTarget, bool) {
	allowed := map[string]struct {
		table, idColumn, supplementColumn string
		fields                            map[string]bool
	}{
		"origin":         {"core.origin_definition", "id", "supplement_id", map[string]bool{"name": false, "description": false}},
		"trail":          {"core.archetype_definition", "id", "supplement_id", map[string]bool{"name": false, "description": false}},
		"ability":        {"core.ability_definition", "id", "supplement_id", map[string]bool{"name": false, "description": false}},
		"ability_detail": {"ordem.supplement_ability_detail", "ability_id", "supplement_id", map[string]bool{"effect_text": false, "prerequisite_text": false}},
		"item":           {"core.item_definition", "id", "supplement_id", map[string]bool{"name": false, "description": false}},
		"item_detail":    {"ordem.supplement_item_detail", "item_id", "supplement_id", map[string]bool{"special_rule": false, "exact_spaces": true, "printed_category": false}},
		"modification":   {"ordem.item_modification", "id", "supplement_id", map[string]bool{"name": false, "effect_summary": false, "category_increase": true}},
		"ritual":         {"ordem.ritual", "ability_id", "", map[string]bool{"execution": false, "range_text": false, "target_text": false, "area_text": false, "duration_text": false, "resistance_text": false}},
		"rule":           {"ordem.supplement_rule", "id", "supplement_id", map[string]bool{"name": false, "rule_text": false}},
		"threat":         {"core.rpg_character", "id", "supplement_id", map[string]bool{"name": false, "description": false}},
	}
	spec, ok := allowed[kind]
	if !ok {
		return correctionTarget{}, false
	}
	numeric, ok := spec.fields[field]
	return correctionTarget{table: spec.table, idColumn: spec.idColumn, supplementColumn: spec.supplementColumn, field: field, numeric: numeric}, ok
}

func (s *Service) Resolve(ctx context.Context, supplementID, issueID string, change Correction) error {
	target, ok := targetFor(change.TargetKind, change.FieldName)
	if !ok || strings.TrimSpace(change.NewValue) == "" || len(strings.TrimSpace(change.Justification)) < 10 {
		return apperr.ErrInvalid
	}
	if target.numeric {
		if _, err := strconv.ParseFloat(strings.TrimSpace(change.NewValue), 64); err != nil {
			return apperr.ErrInvalid
		}
	}
	return s.db.WithContext(ctx).Transaction(func(tx *gorm.DB) error {
		var issue struct {
			Resolved   bool
			SourcePage int
		}
		err := tx.Table("ordem.supplement_review_issue").Clauses(clause.Locking{Strength: "UPDATE"}).Select("resolved, source_page").Where("id=? AND supplement_id=?", issueID, supplementID).Take(&issue).Error
		if errors.Is(err, gorm.ErrRecordNotFound) {
			return apperr.ErrNotFound
		}
		if err != nil {
			return err
		}
		if issue.Resolved {
			return ErrIssueResolved
		}
		if err := candidateOnPage(tx, supplementID, change.TargetKind, change.TargetID, issue.SourcePage); err != nil {
			return err
		}
		var current struct{ Value *string }
		where := target.idColumn + "=? AND " + target.supplementColumn + "=?"
		if change.TargetKind == "ritual" {
			where = "ability_id=? AND ability_id IN (SELECT id FROM core.ability_definition WHERE supplement_id=?)"
		}
		err = tx.Table(target.table).Select(target.field+"::text AS value").Where(where, change.TargetID, supplementID).Take(&current).Error
		if errors.Is(err, gorm.ErrRecordNotFound) {
			return apperr.ErrNotFound
		}
		if err != nil {
			return err
		}
		before := ""
		if current.Value != nil {
			before = *current.Value
		}
		if before != change.ExpectedValue {
			return ErrValueChanged
		}
		value := any(change.NewValue)
		if target.numeric {
			value = strings.TrimSpace(change.NewValue)
		}
		if err := tx.Table(target.table).Where(where, change.TargetID, supplementID).Update(target.field, value).Error; err != nil {
			return fmt.Errorf("correct supplement value: %w", err)
		}
		if err := tx.Exec("INSERT INTO ordem.supplement_review_target(issue_id,target_kind,target_id,field_name) VALUES (?,?,?,?) ON CONFLICT (issue_id) DO UPDATE SET target_kind=EXCLUDED.target_kind,target_id=EXCLUDED.target_id,field_name=EXCLUDED.field_name", issueID, change.TargetKind, change.TargetID, change.FieldName).Error; err != nil {
			return err
		}
		if err := tx.Exec("INSERT INTO ordem.supplement_review_audit(issue_id,actor_user_id,target_kind,target_id,field_name,previous_value,new_value,justification) VALUES (?,?,?,?,?,?,?,?)", issueID, s.userID, change.TargetKind, change.TargetID, change.FieldName, before, change.NewValue, strings.TrimSpace(change.Justification)).Error; err != nil {
			return err
		}
		if err := tx.Table("ordem.supplement_review_issue").Where("id=?", issueID).Update("resolved", true).Error; err != nil {
			return err
		}
		return nil
	})
}

func candidateOnPage(tx *gorm.DB, supplementID, kind, targetID string, page int) error {
	table, start, end := "", "supplement_page_start", "supplement_page_end"
	switch kind {
	case "origin":
		table = "core.origin_definition"
	case "trail":
		table = "core.archetype_definition"
	case "ability", "ability_detail", "ritual":
		table = "core.ability_definition"
	case "item", "item_detail":
		table = "core.item_definition"
	case "modification":
		table = "ordem.item_modification"
	case "threat":
		table = "core.rpg_character"
	case "rule":
		table, start, end = "ordem.supplement_rule", "source_page_start", "source_page_end"
	default:
		return apperr.ErrInvalid
	}
	var count int64
	if err := tx.Table(table).Where("id=? AND supplement_id=? AND "+start+"<=? AND "+end+">=?", targetID, supplementID, page, page).Count(&count).Error; err != nil {
		return err
	}
	if count != 1 {
		return apperr.ErrInvalid
	}
	return nil
}

func (s *Service) LinkTarget(ctx context.Context, supplementID, issueID, kind, targetID, field string) error {
	if _, ok := targetFor(kind, field); !ok {
		return apperr.ErrInvalid
	}
	return s.db.WithContext(ctx).Transaction(func(tx *gorm.DB) error {
		var issue struct {
			Resolved   bool
			SourcePage int
		}
		err := tx.Table("ordem.supplement_review_issue").Clauses(clause.Locking{Strength: "UPDATE"}).Select("resolved, source_page").Where("id=? AND supplement_id=?", issueID, supplementID).Take(&issue).Error
		if errors.Is(err, gorm.ErrRecordNotFound) {
			return apperr.ErrNotFound
		}
		if err != nil {
			return err
		}
		if issue.Resolved {
			return ErrIssueResolved
		}
		if err := candidateOnPage(tx, supplementID, kind, targetID, issue.SourcePage); err != nil {
			return err
		}
		return tx.Exec("INSERT INTO ordem.supplement_review_target(issue_id,target_kind,target_id,field_name) VALUES (?,?,?,?) ON CONFLICT (issue_id) DO UPDATE SET target_kind=EXCLUDED.target_kind,target_id=EXCLUDED.target_id,field_name=EXCLUDED.field_name", issueID, kind, targetID, field).Error
	})
}

func (s *Service) CurrentValue(ctx context.Context, supplementID, kind, id, field string) (string, error) {
	target, ok := targetFor(kind, field)
	if !ok {
		return "", apperr.ErrInvalid
	}
	where := target.idColumn + "=? AND " + target.supplementColumn + "=?"
	if kind == "ritual" {
		where = "ability_id=? AND ability_id IN (SELECT id FROM core.ability_definition WHERE supplement_id=?)"
	}
	var row struct{ Value *string }
	err := s.db.WithContext(ctx).Table(target.table).Select(target.field+"::text AS value").Where(where, id, supplementID).Take(&row).Error
	if errors.Is(err, gorm.ErrRecordNotFound) {
		return "", apperr.ErrNotFound
	}
	if err != nil {
		return "", err
	}
	if row.Value == nil {
		return "", nil
	}
	return *row.Value, nil
}

func (s *Service) HiddenTargets(ctx context.Context, supplementID string, kinds []string) (map[string]bool, error) {
	result := map[string]bool{}
	if supplementID == "" {
		return result, nil
	}
	var ids []string
	if err := s.db.WithContext(ctx).Table("ordem.supplement_review_target AS t").Select("t.target_id").Joins("JOIN ordem.supplement_review_issue AS i ON i.id=t.issue_id").Where("i.supplement_id=? AND i.resolved=false AND t.target_kind IN ?", supplementID, kinds).Scan(&ids).Error; err != nil {
		return nil, err
	}
	for _, id := range ids {
		result[id] = true
	}
	return result, nil
}
