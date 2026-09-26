package content

import (
	"context"
	"encoding/json"
	"fmt"
	"time"

	"RPG-manager/backend/internal/apperr"
)

type InventoryDefinition struct {
	ID                 string            `json:"id"`
	SystemID           string            `json:"systemId"`
	Source             map[string]string `json:"source"`
	Name               string            `json:"name"`
	Description        string            `json:"description"`
	Kind               string            `json:"kind"`
	Category           *int              `json:"category"`
	Spaces             *int              `json:"spaces"`
	DamageExpression   *string           `json:"damageExpression,omitempty"`
	CriticalThreshold  *int              `json:"criticalThreshold,omitempty"`
	CriticalMultiplier *int              `json:"criticalMultiplier,omitempty"`
	RangeText          *string           `json:"rangeText,omitempty"`
	DamageType         *string           `json:"damageType,omitempty"`
	CreatedAt          *time.Time        `json:"createdAt"`
	UpdatedAt          *time.Time        `json:"updatedAt"`
}

func (d InventoryDefinition) MarshalJSON() ([]byte, error) {
	value := map[string]any{"id": d.ID, "systemId": d.SystemID, "source": d.Source, "name": d.Name, "description": d.Description, "kind": d.Kind, "category": d.Category, "spaces": d.Spaces, "createdAt": d.CreatedAt, "updatedAt": d.UpdatedAt}
	if d.Kind == "weapon" {
		value["damageExpression"] = d.DamageExpression
		value["criticalThreshold"] = d.CriticalThreshold
		value["criticalMultiplier"] = d.CriticalMultiplier
		value["rangeText"] = d.RangeText
		value["damageType"] = d.DamageType
	}
	return json.Marshal(value)
}

type inventoryRow struct {
	ID          string
	SystemID    string
	OwnerUserID *string
	Name        string
	Description *string
	TypeSlug    *string
	Category    *int
	Spaces      *int
	Damage      *string
	Critical    *string
	RangeText   *string
	DamageType  *string
	CreatedAt   *time.Time
	UpdatedAt   *time.Time
}

func contentSource(owner *string) map[string]string {
	if owner == nil {
		return map[string]string{"kind": "official"}
	}
	return map[string]string{"kind": "homebrew", "ownerId": *owner}
}

func mapKind(slug *string) string {
	if slug == nil {
		return "other"
	}
	switch *slug {
	case "arma":
		return "weapon"
	case "protecao":
		return "protection"
	case "municao":
		return "ammunition"
	case "acessorio":
		return "accessory"
	case "item-operacional", "explosivo":
		return "equipment"
	case "item-paranormal", "item-amaldicoado-especial":
		return "paranormal"
	default:
		return "other"
	}
}
func critical(raw *string) (*int, *int) {
	if raw == nil {
		return nil, nil
	}
	values := map[string][2]int{
		"18": {18, 2}, "19": {19, 2}, "20": {20, 2},
		"18/x2": {18, 2}, "18/x3": {18, 3}, "18/x4": {18, 4},
		"19/x2": {19, 2}, "19/x3": {19, 3}, "19/x4": {19, 4},
		"20/x2": {20, 2}, "20/x3": {20, 3}, "20/x4": {20, 4},
		"x2": {20, 2}, "x3": {20, 3}, "x4": {20, 4},
	}
	v, ok := values[*raw]
	if !ok {
		return nil, nil
	}
	return &v[0], &v[1]
}
func mapInventory(r inventoryRow) InventoryDefinition {
	source := contentSource(r.OwnerUserID)
	out := InventoryDefinition{ID: r.ID, SystemID: r.SystemID, Source: source, Name: r.Name, Description: deref(r.Description), Kind: mapKind(r.TypeSlug), Category: r.Category, Spaces: r.Spaces, CreatedAt: utcTimePtr(r.CreatedAt), UpdatedAt: utcTimePtr(r.UpdatedAt)}
	if r.Damage != nil {
		out.Kind = "weapon"
	}
	if out.Kind == "weapon" {
		out.DamageExpression = r.Damage
		out.CriticalThreshold, out.CriticalMultiplier = critical(r.Critical)
		out.RangeText = r.RangeText
		out.DamageType = r.DamageType
	}
	return out
}
func (s *Repository) InventoryCatalog(ctx context.Context, systemID, query, kind string) ([]InventoryDefinition, error) {
	var rows []inventoryRow
	db := s.DB.WithContext(ctx).Table("core.item_definition AS i").Select(`i.id, i.rpg_system_id AS system_id, i.owner_user_id, i.name, i.description, t.slug AS type_slug,
		r.inventory_category AS category, r.spaces, w.damage, w.critical, w.range_text, w.damage_type, i.created_at, i.updated_at`).
		Joins("LEFT JOIN core.item_type AS t ON t.id=i.item_type_id").Joins("LEFT JOIN ordem.item_rule AS r ON r.item_id=i.id").Joins("LEFT JOIN ordem.weapon AS w ON w.item_id=i.id").
		Where("i.rpg_system_id=? AND (i.owner_user_id IS NULL OR i.owner_user_id=?)", systemID, s.UserID)
	if query != "" {
		db = db.Where("i.name ILIKE ?", "%"+query+"%")
	}
	if err := db.Order("i.name").Limit(300).Scan(&rows).Error; err != nil {
		return nil, fmt.Errorf("inventory catalog: %w", err)
	}
	out := make([]InventoryDefinition, 0, len(rows))
	for _, r := range rows {
		v := mapInventory(r)
		if kind == "" || v.Kind == kind {
			out = append(out, v)
		}
	}
	return out, nil
}

type RitualTier struct {
	PECost int    `json:"peCost"`
	Effect string `json:"effect"`
	Rolls  []any  `json:"rolls"`
}
type RitualTiers struct {
	Normal     RitualTier `json:"normal"`
	Discente   RitualTier `json:"discente"`
	Verdadeiro RitualTier `json:"verdadeiro"`
}
type RitualDefinition struct {
	ID             string            `json:"id"`
	SystemID       string            `json:"systemId"`
	Source         map[string]string `json:"source"`
	Name           string            `json:"name"`
	Description    string            `json:"description"`
	Element        string            `json:"element"`
	Circle         int               `json:"circle"`
	Execution      string            `json:"execution"`
	RangeText      string            `json:"rangeText"`
	TargetText     string            `json:"targetText"`
	AreaText       string            `json:"areaText"`
	DurationText   string            `json:"durationText"`
	ResistanceText string            `json:"resistanceText"`
	Tiers          *RitualTiers      `json:"tiers"`
	CreatedAt      *time.Time        `json:"createdAt"`
	UpdatedAt      *time.Time        `json:"updatedAt"`
}
type ritualRow struct {
	ID             string
	SystemID       string
	OwnerUserID    *string
	Name           string
	Description    *string
	Element        string
	Circle         int
	Execution      *string
	RangeText      *string
	TargetText     *string
	AreaText       *string
	DurationText   *string
	ResistanceText *string
	CreatedAt      *time.Time
	UpdatedAt      *time.Time
}

func (s *Repository) RitualCatalog(ctx context.Context, systemID, query, element string) ([]RitualDefinition, error) {
	var rows []ritualRow
	db := s.DB.WithContext(ctx).Table("core.ability_definition AS a").Select(`a.id, a.rpg_system_id AS system_id, a.owner_user_id, a.name, a.description, e.slug AS element,
		r.circle, r.execution, r.range_text, r.target_text, r.area_text, r.duration_text, r.resistance_text, a.created_at, a.updated_at`).
		Joins("JOIN ordem.ritual AS r ON r.ability_id=a.id").Joins("JOIN ordem.element AS e ON e.id=r.element_id").
		Where("a.rpg_system_id=? AND (a.owner_user_id IS NULL OR a.owner_user_id=?)", systemID, s.UserID)
	if query != "" {
		db = db.Where("a.name ILIKE ?", "%"+query+"%")
	}
	if element != "" {
		db = db.Where("e.slug=?", elementToPortuguese(element))
	}
	if err := db.Order("a.name").Limit(300).Scan(&rows).Error; err != nil {
		return nil, fmt.Errorf("ritual catalog: %w", err)
	}
	ids := make([]string, 0, len(rows))
	for _, row := range rows {
		if row.OwnerUserID != nil {
			ids = append(ids, row.ID)
		}
	}
	tiersByID := make(map[string]map[string]RitualTier)
	if len(ids) > 0 {
		var tierRows []struct {
			AbilityID string
			Tier      string
			PECost    int
			Effect    string
			Rolls     []byte
		}
		if err := s.DB.WithContext(ctx).Table("ordem.ritual_tier").Select("ability_id, tier, pe_cost, effect, rolls").Where("ability_id IN ?", ids).Scan(&tierRows).Error; err != nil {
			return nil, fmt.Errorf("ritual tiers: %w", err)
		}
		for _, row := range tierRows {
			var rolls []any
			if err := json.Unmarshal(row.Rolls, &rolls); err != nil {
				return nil, fmt.Errorf("decode ritual rolls: %w", err)
			}
			if tiersByID[row.AbilityID] == nil {
				tiersByID[row.AbilityID] = make(map[string]RitualTier)
			}
			tiersByID[row.AbilityID][row.Tier] = RitualTier{PECost: row.PECost, Effect: row.Effect, Rolls: rolls}
		}
	}
	out := make([]RitualDefinition, 0, len(rows))
	for _, r := range rows {
		source := contentSource(r.OwnerUserID)
		value := RitualDefinition{ID: r.ID, SystemID: r.SystemID, Source: source, Name: r.Name, Description: deref(r.Description), Element: elementToEnglish(r.Element), Circle: r.Circle, Execution: deref(r.Execution), RangeText: deref(r.RangeText), TargetText: deref(r.TargetText), AreaText: deref(r.AreaText), DurationText: deref(r.DurationText), ResistanceText: deref(r.ResistanceText), CreatedAt: utcTimePtr(r.CreatedAt), UpdatedAt: utcTimePtr(r.UpdatedAt)}
		if tiers := tiersByID[r.ID]; len(tiers) == 3 {
			value.Tiers = &RitualTiers{Normal: tiers["normal"], Discente: tiers["discente"], Verdadeiro: tiers["verdadeiro"]}
		}
		out = append(out, value)
	}
	return out, nil
}
func elementToEnglish(s string) string {
	switch s {
	case "sangue":
		return "blood"
	case "morte":
		return "death"
	case "conhecimento":
		return "knowledge"
	case "energia":
		return "energy"
	case "medo":
		return "fear"
	default:
		return s
	}
}
func elementToPortuguese(s string) string {
	switch s {
	case "blood":
		return "sangue"
	case "death":
		return "morte"
	case "knowledge":
		return "conhecimento"
	case "energy":
		return "energia"
	case "fear":
		return "medo"
	default:
		return s
	}
}

type AttackDefinition struct {
	ID                     string            `json:"id"`
	SystemID               string            `json:"systemId"`
	Source                 map[string]string `json:"source"`
	Name                   string            `json:"name"`
	Description            string            `json:"description"`
	SkillID                *string           `json:"skillId"`
	SkillName              string            `json:"skillName"`
	TestExpression         *string           `json:"testExpression"`
	DamageExpression       string            `json:"damageExpression"`
	DamageType             string            `json:"damageType"`
	CriticalThreshold      *int              `json:"criticalThreshold"`
	CriticalMultiplier     *int              `json:"criticalMultiplier"`
	RangeText              string            `json:"rangeText"`
	Special                string            `json:"special"`
	SourceItemDefinitionID *string           `json:"sourceItemDefinitionId"`
	CreatedAt              *time.Time        `json:"createdAt"`
	UpdatedAt              *time.Time        `json:"updatedAt"`
}
type attackRow struct {
	ID                     string
	SystemID               string
	OwnerUserID            *string
	Name                   string
	Description            string
	SkillID                *string
	SkillName              *string
	TestExpression         *string
	DamageExpression       string
	DamageType             string
	CriticalThreshold      *int
	CriticalMultiplier     *int
	RangeText              string
	Special                string
	SourceItemDefinitionID *string
	CreatedAt              *time.Time
	UpdatedAt              *time.Time
}

func (s *Repository) AttackCatalog(ctx context.Context, systemID, query, source string) ([]AttackDefinition, error) {
	var rows []attackRow
	db := s.DB.WithContext(ctx).Table("ordem.attack_definition AS a").Select(`a.id, a.rpg_system_id AS system_id, a.owner_user_id, a.name, a.description, a.skill_id, sk.name AS skill_name,
		a.test_expression, a.damage_expression, a.damage_type, a.critical_threshold, a.critical_multiplier, a.range_text, a.special,
		a.source_item_id AS source_item_definition_id, a.created_at, a.updated_at`).Joins("LEFT JOIN core.skill_definition AS sk ON sk.id=a.skill_id").Where("a.rpg_system_id=? AND (a.owner_user_id IS NULL OR a.owner_user_id=?)", systemID, s.UserID)
	if query != "" {
		db = db.Where("a.name ILIKE ?", "%"+query+"%")
	}
	if source == "official" {
		db = db.Where("a.owner_user_id IS NULL")
	} else if source == "homebrew" {
		db = db.Where("a.owner_user_id=?", s.UserID)
	} else if source == "linked" {
		db = db.Where("a.source_item_id IS NOT NULL")
	} else if source == "independent" {
		db = db.Where("a.source_item_id IS NULL")
	}
	if err := db.Order("a.name").Limit(300).Scan(&rows).Error; err != nil {
		return nil, fmt.Errorf("attack catalog: %w", err)
	}
	out := make([]AttackDefinition, 0, len(rows))
	for _, r := range rows {
		src := contentSource(r.OwnerUserID)
		out = append(out, AttackDefinition{ID: r.ID, SystemID: r.SystemID, Source: src, Name: r.Name, Description: r.Description, SkillID: r.SkillID, SkillName: deref(r.SkillName), TestExpression: r.TestExpression, DamageExpression: r.DamageExpression, DamageType: r.DamageType, CriticalThreshold: r.CriticalThreshold, CriticalMultiplier: r.CriticalMultiplier, RangeText: r.RangeText, Special: r.Special, SourceItemDefinitionID: r.SourceItemDefinitionID, CreatedAt: utcTimePtr(r.CreatedAt), UpdatedAt: utcTimePtr(r.UpdatedAt)})
	}
	return out, nil
}

func (s *Repository) OrdemSystemID(ctx context.Context) (string, error) {
	var id string
	if err := s.DB.WithContext(ctx).Table("core.rpg_system").Select("id").Where("slug='ordem-paranormal'").Scan(&id).Error; err != nil {
		return "", err
	}
	if id == "" {
		return "", apperr.ErrNotFound
	}
	return id, nil
}

func deref(value *string) string {
	if value == nil {
		return ""
	}
	return *value
}

func utcTimePtr(value *time.Time) *time.Time {
	if value == nil {
		return nil
	}
	utc := value.UTC()
	return &utc
}
