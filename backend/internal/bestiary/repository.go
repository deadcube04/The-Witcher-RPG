package bestiary

import (
	"context"
	"errors"
	"fmt"
	"strings"

	"gorm.io/gorm"
)

type GORMRepository struct{ db *gorm.DB }

func NewRepository(db *gorm.DB) *GORMRepository { return &GORMRepository{db: db} }

type catalogRow struct {
	ID          string
	Name        string
	Description *string
	ImageURL    *string
	BeingTypeID *string
	BeingType   *string
	Challenge   *int `gorm:"column:challenge_value"`
	SizeID      *string
	Size        *string
}

func (r *GORMRepository) Options(ctx context.Context) (Options, error) {
	out := Options{Elements: []Option{}, Types: []Option{}, Sizes: []Option{}}
	if err := r.db.WithContext(ctx).Table("ordem.element AS e").
		Select("e.id, e.name").
		Joins("JOIN ordem.threat_element AS te ON te.element_id = e.id").
		Joins("JOIN ordem.threat AS t ON t.character_id = te.threat_id").
		Joins("JOIN core.rpg_character AS c ON c.id = t.character_id").
		Where("c.character_type = ? AND c.rpg_system_id = (SELECT id FROM core.rpg_system WHERE slug = ?)", "THREAT", "ordem-paranormal").
		Group("e.id, e.name").Order("e.name ASC").Scan(&out.Elements).Error; err != nil {
		return Options{}, fmt.Errorf("list bestiary elements: %w", err)
	}
	out.Elements = append([]Option{{ID: "none", Name: "Sem elemento"}}, out.Elements...)
	if err := r.db.WithContext(ctx).Table("ordem.being_type AS bt").
		Select("bt.id, bt.name").
		Joins("JOIN ordem.threat AS t ON t.being_type_id = bt.id").
		Joins("JOIN core.rpg_character AS c ON c.id = t.character_id").
		Where("c.character_type = ? AND c.rpg_system_id = (SELECT id FROM core.rpg_system WHERE slug = ?)", "THREAT", "ordem-paranormal").
		Group("bt.id, bt.name").Order("bt.name ASC").Scan(&out.Types).Error; err != nil {
		return Options{}, fmt.Errorf("list bestiary types: %w", err)
	}
	if err := r.db.WithContext(ctx).Table("ordem.threat_size AS ts").
		Select("ts.id, ts.name").
		Joins("JOIN ordem.threat AS t ON t.size_id = ts.id").
		Joins("JOIN core.rpg_character AS c ON c.id = t.character_id").
		Where("c.character_type = ? AND c.rpg_system_id = (SELECT id FROM core.rpg_system WHERE slug = ?)", "THREAT", "ordem-paranormal").
		Group("ts.id, ts.name, ts.sort_order").Order("ts.sort_order ASC").Scan(&out.Sizes).Error; err != nil {
		return Options{}, fmt.Errorf("list bestiary sizes: %w", err)
	}
	var limits struct {
		MinVD *int
		MaxVD *int
	}
	if err := r.db.WithContext(ctx).Table("ordem.threat AS t").
		Select("MIN(t.challenge_value) AS min_vd, MAX(t.challenge_value) AS max_vd").
		Joins("JOIN core.rpg_character AS c ON c.id = t.character_id").
		Where("c.character_type = ? AND c.rpg_system_id = (SELECT id FROM core.rpg_system WHERE slug = ?)", "THREAT", "ordem-paranormal").
		Scan(&limits).Error; err != nil {
		return Options{}, fmt.Errorf("read bestiary challenge range: %w", err)
	}
	if limits.MinVD != nil {
		out.MinVD = *limits.MinVD
	}
	if limits.MaxVD != nil {
		out.MaxVD = *limits.MaxVD
	}
	return out, nil
}

func (r *GORMRepository) List(ctx context.Context, filter Filters) (Page, error) {
	query := r.filteredQuery(ctx, filter)
	var total int64
	if err := query.Count(&total).Error; err != nil {
		return Page{}, fmt.Errorf("count bestiary entries: %w", err)
	}
	page := Page{Items: []ThreatSummary{}, Total: total, Page: filter.Page, PageSize: filter.PageSize}
	if total == 0 {
		return page, nil
	}
	var rows []catalogRow
	if err := r.filteredQuery(ctx, filter).
		Select("c.id, c.name, c.description, c.image_url, bt.id AS being_type_id, bt.name AS being_type, t.challenge_value, ts.id AS size_id, ts.name AS size").
		Joins("LEFT JOIN ordem.being_type AS bt ON bt.id = t.being_type_id").
		Joins("LEFT JOIN ordem.threat_size AS ts ON ts.id = t.size_id").
		Order(orderBy(filter)).
		Limit(filter.PageSize).Offset((filter.Page - 1) * filter.PageSize).
		Scan(&rows).Error; err != nil {
		return Page{}, fmt.Errorf("list bestiary entries: %w", err)
	}
	items := make([]ThreatSummary, 0, len(rows))
	ids := make([]string, 0, len(rows))
	for _, row := range rows {
		items = append(items, ThreatSummary{ID: row.ID, Name: row.Name, Description: row.Description, ImageURL: row.ImageURL, BeingTypeID: row.BeingTypeID, BeingType: row.BeingType, Challenge: row.Challenge, SizeID: row.SizeID, Size: row.Size, Elements: []Element{}})
		ids = append(ids, row.ID)
	}
	elements, err := r.elementsByThreatID(ctx, ids)
	if err != nil {
		return Page{}, err
	}
	for index := range items {
		items[index].Elements = elements[items[index].ID]
	}
	page.Items = items
	if offset := filter.Page * filter.PageSize; int64(offset) < total {
		next := filter.Page + 1
		page.NextPage = &next
	}
	return page, nil
}

func (r *GORMRepository) Get(ctx context.Context, id string, filter Filters) (Threat, Navigation, error) {
	var row struct {
		ID                   string
		Name                 string
		Description          *string
		ImageURL             *string
		Appearance           *string
		Behavior             *string
		History              *string
		BeingTypeID          *string
		BeingType            *string
		BeingTypeDescription *string
		Challenge            *int `gorm:"column:challenge_value"`
		SizeID               *string
		Size                 *string
		SourceRef            *string
		Defense              *int
		HitPoints            *int
		WoundedAt            *int
		Agility              *int
		Strength             *int
		Intellect            *int
		Presence             *int
		Vigor                *int
		PerceptionTest       *string
		InitiativeTest       *string
		FortitudeTest        *string
		ReflexesTest         *string
		WillTest             *string
		Senses               *string
		MovementText         *string
		DisturbingPresence   *string
		PresenceDT           *int
		PresenceDamage       *string
		PresenceImmuneNEX    *int
		FearEnigmaSummary    *string
		Group                *string `gorm:"column:element_group"`
		ResistancesText      *string
		ImmunitiesText       *string
		VulnerabilitiesText  *string
	}
	err := r.db.WithContext(ctx).Table("core.rpg_character AS c").
		Select("c.id, c.name, c.description, c.image_url, c.appearance, c.personality AS behavior, c.background AS history, bt.id AS being_type_id, bt.name AS being_type, bt.description AS being_type_description, t.challenge_value, ts.id AS size_id, ts.name AS size, t.source_ref, t.defense, t.hit_points, t.wounded_at, t.agility, t.strength, t.intellect, t.presence, t.vigor, t.perception_test, t.initiative_test, t.fortitude_test, t.reflexes_test, t.will_test, t.senses, t.movement_text, t.disturbing_presence, t.presence_dt, t.presence_damage, t.presence_immune_nex, t.fear_enigma_summary, t.statblock_data ->> 'group' AS element_group, t.statblock_data ->> 'resistances_text' AS resistances_text, t.statblock_data ->> 'immunities_text' AS immunities_text, t.statblock_data ->> 'vulnerabilities_text' AS vulnerabilities_text").
		Joins("JOIN ordem.threat AS t ON t.character_id = c.id").
		Joins("LEFT JOIN ordem.being_type AS bt ON bt.id = t.being_type_id").
		Joins("LEFT JOIN ordem.threat_size AS ts ON ts.id = t.size_id").
		Where("c.id = ? AND c.character_type = ? AND c.rpg_system_id = (SELECT id FROM core.rpg_system WHERE slug = ?)", id, "THREAT", "ordem-paranormal").Take(&row).Error
	if err != nil {
		if errors.Is(err, gorm.ErrRecordNotFound) {
			return Threat{}, Navigation{}, gorm.ErrRecordNotFound
		}
		return Threat{}, Navigation{}, fmt.Errorf("get bestiary entry: %w", err)
	}
	item := Threat{
		ThreatSummary: ThreatSummary{ID: row.ID, Name: row.Name, Description: row.Description, ImageURL: row.ImageURL, BeingTypeID: row.BeingTypeID, BeingType: row.BeingType, Challenge: row.Challenge, SizeID: row.SizeID, Size: row.Size, Elements: []Element{}},
		Appearance:    row.Appearance, Behavior: row.Behavior, History: row.History,
		BeingTypeDescription: row.BeingTypeDescription, SourceRef: row.SourceRef,
		MainStats: MainStats{Defense: row.Defense, HitPoints: row.HitPoints, WoundedAt: row.WoundedAt, Agility: row.Agility, Strength: row.Strength, Intellect: row.Intellect, Presence: row.Presence, Vigor: row.Vigor},
		Tests:     Tests{Perception: row.PerceptionTest, Initiative: row.InitiativeTest, Fortitude: row.FortitudeTest, Reflexes: row.ReflexesTest, Will: row.WillTest},
		Senses:    row.Senses, Movement: row.MovementText, DisturbingPresence: row.DisturbingPresence,
		Presence:          Presence{Difficulty: row.PresenceDT, Damage: row.PresenceDamage, ImmuneNEX: row.PresenceImmuneNEX},
		FearEnigmaSummary: row.FearEnigmaSummary, Group: row.Group, ResistancesText: row.ResistancesText, ImmunitiesText: row.ImmunitiesText, VulnerabilitiesText: row.VulnerabilitiesText,
		Descriptors: []string{}, Actions: []Action{}, Abilities: []Ability{}, DefenseTraits: []DefenseTrait{}, Skills: []Skill{},
	}
	item.Elements, err = r.elementsFor(ctx, id)
	if err != nil {
		return Threat{}, Navigation{}, err
	}
	if err := r.loadDetails(ctx, id, &item); err != nil {
		return Threat{}, Navigation{}, err
	}
	navigation, err := r.navigation(ctx, id, filter)
	if err != nil {
		return Threat{}, Navigation{}, err
	}
	return item, navigation, nil
}

func (r *GORMRepository) filteredQuery(ctx context.Context, filter Filters) *gorm.DB {
	query := r.db.WithContext(ctx).Table("core.rpg_character AS c").
		Joins("JOIN ordem.threat AS t ON t.character_id = c.id").
		Where("c.character_type = ? AND c.rpg_system_id = (SELECT id FROM core.rpg_system WHERE slug = ?)", "THREAT", "ordem-paranormal")
	if text := strings.TrimSpace(filter.Query); text != "" {
		// Reuse the search primitives and ranking from ordem.search_threats.
		// Its internal LIMIT/OFFSET cannot be used here: every match must remain
		// available until filters, totals, navigation and pagination are applied.
		query = query.Joins(`CROSS JOIN (
			SELECT core.expand_search_query(?, 'THREAT') AS fts_query,
				core.normalize_fuzzy_query(?) AS fuzzy_query
			OFFSET 0
		) AS search_params`, text, text).
			Joins(`CROSS JOIN LATERAL (
				SELECT COALESCE(t.search_vector @@ search_params.fts_query, false) AS fts_match,
					CASE WHEN t.search_vector @@ search_params.fts_query
						THEN ts_rank_cd(t.search_vector, search_params.fts_query, 32)
						ELSE 0 END AS fts_rank,
					similarity(COALESCE(t.fuzzy_text, ''), search_params.fuzzy_query) AS fuzzy_rank
			) AS search_scores`).
			Where(`(search_scores.fts_match OR search_scores.fuzzy_rank >= 0.25
				OR strpos(core.normalize_fuzzy_query(c.name), search_params.fuzzy_query) > 0)`)
	}
	if filter.ElementID == "none" {
		query = query.Where("NOT EXISTS (SELECT 1 FROM ordem.threat_element AS te WHERE te.threat_id = t.character_id)")
	} else if filter.ElementID != "" {
		query = query.Where("EXISTS (SELECT 1 FROM ordem.threat_element AS te WHERE te.threat_id = t.character_id AND te.element_id = ?)", filter.ElementID)
	}
	if filter.BeingTypeID != "" {
		query = query.Where("t.being_type_id = ?", filter.BeingTypeID)
	}
	if filter.SizeID != "" {
		query = query.Where("t.size_id = ?", filter.SizeID)
	}
	if filter.VDMin != nil {
		query = query.Where("t.challenge_value >= ?", *filter.VDMin)
	}
	if filter.VDMax != nil {
		query = query.Where("t.challenge_value <= ?", *filter.VDMax)
	}
	return query
}

func orderBy(filter Filters) string {
	if filter.Sort == "relevance" && strings.TrimSpace(filter.Query) != "" {
		return "search_scores.fts_match DESC, (search_scores.fts_rank * 0.85 + search_scores.fuzzy_rank * 0.15) DESC, lower(c.name) ASC, c.id ASC"
	}
	switch filter.Sort {
	case "vd-asc":
		return "t.challenge_value ASC NULLS LAST, lower(c.name) ASC, c.id ASC"
	case "vd-desc":
		return "t.challenge_value DESC NULLS LAST, lower(c.name) ASC, c.id ASC"
	default:
		return "lower(c.name) ASC, c.id ASC"
	}
}

func (r *GORMRepository) elementsByThreatID(ctx context.Context, ids []string) (map[string][]Element, error) {
	result := make(map[string][]Element, len(ids))
	for _, id := range ids {
		result[id] = []Element{}
	}
	if len(ids) == 0 {
		return result, nil
	}
	var rows []struct {
		ThreatID  string
		ID        string
		Name      string
		IsPrimary bool
	}
	if err := r.db.WithContext(ctx).Table("ordem.threat_element AS te").
		Select("te.threat_id, e.id, e.name, te.is_primary").
		Joins("JOIN ordem.element AS e ON e.id = te.element_id").
		Where("te.threat_id IN ?", ids).Order("te.sort_order ASC, lower(e.name) ASC").Scan(&rows).Error; err != nil {
		return nil, fmt.Errorf("load bestiary elements: %w", err)
	}
	for _, row := range rows {
		result[row.ThreatID] = append(result[row.ThreatID], Element{ID: row.ID, Name: row.Name, IsPrimary: row.IsPrimary})
	}
	return result, nil
}

func (r *GORMRepository) elementsFor(ctx context.Context, threatID string) ([]Element, error) {
	rows := []Element{}
	err := r.db.WithContext(ctx).Table("ordem.threat_element AS te").
		Select("e.id, e.name, te.is_primary").
		Joins("JOIN ordem.element AS e ON e.id = te.element_id").
		Where("te.threat_id = ?", threatID).Order("te.sort_order ASC, lower(e.name) ASC").Scan(&rows).Error
	if err != nil {
		return nil, fmt.Errorf("load bestiary entry elements: %w", err)
	}
	return rows, nil
}

func (r *GORMRepository) loadDetails(ctx context.Context, id string, item *Threat) error {
	if err := r.db.WithContext(ctx).Table("ordem.threat_action").
		Select("id, name, action_type AS action_kind, description, test_expression, damage_expression, attack_count, range_text AS action_range, critical, damage_type, resistance_text AS resistance, source_ref").
		Where("threat_id = ?", id).Order("sort_order ASC, id ASC").Scan(&item.Actions).Error; err != nil {
		return fmt.Errorf("load bestiary actions: %w", err)
	}
	if err := r.db.WithContext(ctx).Table("ordem.threat_ability").
		Select("id, name, effect_summary, source_ref").
		Where("threat_id = ?", id).Order("sort_order ASC, id ASC").Scan(&item.Abilities).Error; err != nil {
		return fmt.Errorf("load bestiary abilities: %w", err)
	}
	if err := r.db.WithContext(ctx).Table("ordem.threat_defense_trait").
		Select("id, trait_type AS trait_kind, name, value_text, source_ref").
		Where("threat_id = ?", id).Order("sort_order ASC, id ASC").Scan(&item.DefenseTraits).Error; err != nil {
		return fmt.Errorf("load bestiary defense traits: %w", err)
	}
	var descriptors []struct{ Descriptor string }
	if err := r.db.WithContext(ctx).Table("ordem.threat_descriptor").
		Select("descriptor").Where("threat_id = ?", id).Order("sort_order ASC, id ASC").Scan(&descriptors).Error; err != nil {
		return fmt.Errorf("load bestiary descriptors: %w", err)
	}
	for _, row := range descriptors {
		item.Descriptors = append(item.Descriptors, row.Descriptor)
	}
	if err := r.db.WithContext(ctx).Table("ordem.threat_skill").
		Select("id, skill_name AS name, test_expression, source_ref").
		Where("threat_id = ?", id).Order("sort_order ASC, id ASC").Scan(&item.Skills).Error; err != nil {
		return fmt.Errorf("load bestiary skills: %w", err)
	}
	return nil
}

func (r *GORMRepository) navigation(ctx context.Context, id string, filter Filters) (Navigation, error) {
	var rows []NavigationItem
	if err := r.filteredQuery(ctx, filter).
		Select("c.id, c.name").Order(orderBy(filter)).Scan(&rows).Error; err != nil {
		return Navigation{}, fmt.Errorf("load bestiary navigation: %w", err)
	}
	out := Navigation{Total: int64(len(rows))}
	for index, row := range rows {
		if row.ID != id {
			continue
		}
		position := int64(index + 1)
		out.Position = &position
		if index > 0 {
			previous := rows[index-1]
			out.Previous = &previous
		}
		if index+1 < len(rows) {
			next := rows[index+1]
			out.Next = &next
		}
		break
	}
	return out, nil
}
