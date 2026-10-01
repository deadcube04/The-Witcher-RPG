package characters

import (
	"RPG-manager/backend/internal/apperr"
	"context"
	"errors"
	"fmt"
	"time"

	"RPG-manager/backend/internal/domain"

	"gorm.io/gorm"
)

type characterRow struct {
	ID          string
	Name        string
	RpgSystemID string
	CampaignID  *string
	Description *string
	ImageURL    *string
	Appearance  *string
	Personality *string
	Background  *string
	Objective   *string
	CreatedAt   time.Time
	UpdatedAt   time.Time
}

func (s *Repository) CharacterIDs(ctx context.Context) ([]string, error) {
	var ids []string
	err := s.DB.WithContext(ctx).Table("core.rpg_character AS c").Select("c.id").Joins("JOIN core.character_sheet AS sh ON sh.character_id = c.id").Where("sh.owner_user_id = ? AND c.character_type = 'PLAYER'", s.UserID).Order("c.updated_at DESC").Scan(&ids).Error
	return ids, err
}

func (s *Repository) Character(ctx context.Context, id string) (domain.Character, error) {
	var row characterRow
	err := s.DB.WithContext(ctx).Table("core.rpg_character AS c").Select("c.id, c.name, c.rpg_system_id, c.campaign_id, c.image_url, c.description, c.appearance, c.personality, c.background, c.objective, c.created_at, c.updated_at").Joins("JOIN core.character_sheet AS sh ON sh.character_id = c.id").Where("c.id = ? AND sh.owner_user_id = ? AND c.character_type = 'PLAYER'", id, s.UserID).Take(&row).Error
	if errors.Is(err, gorm.ErrRecordNotFound) {
		return domain.Character{}, apperr.ErrNotFound
	}
	if err != nil {
		return domain.Character{}, fmt.Errorf("read character: %w", err)
	}
	c := domain.Character{ID: row.ID, OwnerID: s.UserID, Name: row.Name, SystemID: row.RpgSystemID, CampaignID: row.CampaignID, ImageURL: deref(row.ImageURL), Description: deref(row.Description), Appearance: deref(row.Appearance), Personality: deref(row.Personality), Background: deref(row.Background), Objective: deref(row.Objective), CreatedAt: utcTime(row.CreatedAt), UpdatedAt: utcTime(row.UpdatedAt)}
	c.SystemData.Kind = "ordem-paranormal"
	c.SystemData.ProgressionMode = "nex"
	c.SupplementRuleIDs = []string{}
	if row.CampaignID == nil {
		var supplementID string
		if err := s.DB.WithContext(ctx).Table("ordem.character_supplement").Select("supplement_id").Where("character_id=?", id).Scan(&supplementID).Error; err != nil {
			return domain.Character{}, err
		}
		if supplementID != "" {
			c.SupplementID = &supplementID
		}
		if err := s.DB.WithContext(ctx).Table("ordem.character_supplement_rule").Select("rule_id").Where("character_id=?", id).Scan(&c.SupplementRuleIDs).Error; err != nil {
			return domain.Character{}, err
		}
	}
	var progression struct {
		Mode            string
		Level           *int
		Patent          *string
		SurvivorClassID *string
		SurvivorStage   *int
		SurvivorTrailID *string
	}
	if err := s.DB.WithContext(ctx).Table("ordem.character_progression_runtime").Select("mode, level, patent, survivor_class_id, survivor_stage, survivor_trail_id").Where("character_id=?", id).Scan(&progression).Error; err != nil {
		return domain.Character{}, err
	}
	if progression.Mode != "" {
		c.SystemData.ProgressionMode, c.SystemData.Level, c.SystemData.Patent = progression.Mode, progression.Level, progression.Patent
		c.SystemData.SurvivorClassID, c.SystemData.SurvivorStage, c.SystemData.SurvivorTrailID = progression.SurvivorClassID, progression.SurvivorStage, progression.SurvivorTrailID
	}
	var detail struct{ CreditLimit *string }
	if err := s.DB.WithContext(ctx).Table("ordem.character_detail").Select("credit_limit").Where("character_id = ?", id).Take(&detail).Error; err != nil && !errors.Is(err, gorm.ErrRecordNotFound) {
		return domain.Character{}, err
	}
	c.SystemData.CreditLimit = detail.CreditLimit
	var classID string
	if err := s.DB.WithContext(ctx).Table("core.character_class").Select("class_id").Where("character_id = ? AND primary_class = true", id).Scan(&classID).Error; err != nil {
		return domain.Character{}, err
	}
	c.SystemData.ClassID = classID
	var trailID string
	if err := s.DB.WithContext(ctx).Table("ordem.character_supplement_trail").Select("archetype_id").Where("character_id=?", id).Scan(&trailID).Error; err != nil {
		return domain.Character{}, err
	}
	if trailID != "" {
		c.SystemData.TrailID = &trailID
	}
	var originID string
	if err := s.DB.WithContext(ctx).Table("core.character_origin").Select("origin_id").Where("character_id = ?", id).Scan(&originID).Error; err != nil {
		return domain.Character{}, err
	}
	if originID != "" {
		c.SystemData.OriginID = &originID
	}
	var nex int
	if err := s.DB.WithContext(ctx).Table("core.character_progression AS cp").Select("cp.value::int").Joins("JOIN core.progression_definition AS p ON p.id = cp.progression_id").Where("cp.character_id = ? AND p.slug = 'nex'", id).Scan(&nex).Error; err != nil {
		return domain.Character{}, err
	}
	c.SystemData.NEX = nex
	var peLimit int
	limitNEX := nex
	if c.SystemData.ProgressionMode == "level-nex" && c.SystemData.Level != nil {
		limitNEX = *c.SystemData.Level * 5
		if limitNEX >= 100 {
			limitNEX = 99
		}
	}
	if err := s.DB.WithContext(ctx).Table("ordem.nex_rule").Select("pe_limit").Where("nex = ?", limitNEX).Scan(&peLimit).Error; err != nil {
		return domain.Character{}, err
	}
	if c.SystemData.ProgressionMode == "survivor" {
		peLimit = 1
	}
	if c.SystemData.ProgressionMode == "patent" && c.SystemData.Patent != nil {
		limits := map[string]int{"recruta": 1, "operador": 3, "agente-especial": 6, "oficial-de-operacoes": 10, "agente-de-elite": 15}
		peLimit = limits[*c.SystemData.Patent]
	}
	c.SystemData.PELimit = peLimit
	var attrs []struct {
		Slug  string
		Value int
	}
	if err := s.DB.WithContext(ctx).Table("core.character_attribute AS ca").Select("d.slug, ca.value::int AS value").Joins("JOIN core.attribute_definition AS d ON d.id=ca.attribute_id").Where("ca.character_id = ?", id).Scan(&attrs).Error; err != nil {
		return domain.Character{}, err
	}
	for _, a := range attrs {
		switch a.Slug {
		case "agilidade":
			c.SystemData.Attributes.Agility = a.Value
		case "forca":
			c.SystemData.Attributes.Strength = a.Value
		case "intelecto":
			c.SystemData.Attributes.Intellect = a.Value
		case "presenca":
			c.SystemData.Attributes.Presence = a.Value
		case "vigor":
			c.SystemData.Attributes.Vigor = a.Value
		}
	}
	var resources []struct {
		Slug           string
		CurrentValue   int
		MaxValue       int
		TemporaryValue int
		MaxAdjustment  int
	}
	if err := s.DB.WithContext(ctx).Table("core.character_resource AS cr").Select("d.slug, cr.current_value::int AS current_value, cr.max_value::int AS max_value, cr.temporary_value::int AS temporary_value, cr.max_adjustment::int AS max_adjustment").Joins("JOIN core.resource_definition AS d ON d.id=cr.resource_id").Where("cr.character_id = ?", id).Scan(&resources).Error; err != nil {
		return domain.Character{}, err
	}
	for _, r := range resources {
		value := domain.Resource{Current: r.CurrentValue, Temporary: r.TemporaryValue, Maximum: r.MaxValue, MaxAdjustment: r.MaxAdjustment, BaseMaximum: r.MaxValue - r.MaxAdjustment}
		switch r.Slug {
		case "pontos-de-vida":
			c.SystemData.Resources.Health = value
		case "pontos-de-esforco":
			c.SystemData.Resources.Effort = value
		case "sanidade":
			c.SystemData.Resources.Sanity = value
		}
	}
	var determination struct{ CurrentValue, MaxValue, TemporaryValue, MaxAdjustment int }
	if err := s.DB.WithContext(ctx).Table("ordem.character_determination").Select("current_value, max_value, temporary_value, max_adjustment").Where("character_id=?", id).Scan(&determination).Error; err != nil {
		return domain.Character{}, err
	}
	if determination.MaxValue > 0 {
		c.SystemData.Resources.Determination = &domain.Resource{Current: determination.CurrentValue, Maximum: determination.MaxValue, Temporary: determination.TemporaryValue, MaxAdjustment: determination.MaxAdjustment, BaseMaximum: determination.MaxValue - determination.MaxAdjustment}
	}
	return c, nil
}

func deref(p *string) string {
	if p == nil {
		return ""
	}
	return *p
}

func (s *Repository) ClassRule(ctx context.Context, classID, systemID string) (domain.ClassRule, error) {
	var rule domain.ClassRule
	err := s.DB.WithContext(ctx).Table("ordem.class_rule AS r").Select("r.initial_pv_base, r.pv_per_nex_base, r.initial_pe_base, r.pe_per_nex_base, r.initial_san, r.san_per_nex, r.initial_pv_attribute, r.pv_per_nex_attribute, r.initial_pe_attribute, r.pe_per_nex_attribute").Joins("JOIN core.class_definition AS c ON c.id=r.class_id").Where("c.id = ? AND c.rpg_system_id = ?", classID, systemID).Take(&rule).Error
	if errors.Is(err, gorm.ErrRecordNotFound) {
		return rule, apperr.ErrNotFound
	}
	return rule, err
}

func (s *Repository) NEXLimit(ctx context.Context, nex int) (int, error) {
	var row struct{ PELimit int }
	err := s.DB.WithContext(ctx).Table("ordem.nex_rule").Select("pe_limit").Where("nex = ?", nex).Take(&row).Error
	if errors.Is(err, gorm.ErrRecordNotFound) {
		return 0, apperr.ErrNotFound
	}
	return row.PELimit, err
}

func (s *Repository) ReferenceID(ctx context.Context, table, slug, systemID string) (string, error) {
	allowed := map[string]bool{"core.attribute_definition": true, "core.resource_definition": true, "core.progression_definition": true, "core.origin_definition": true}
	if !allowed[table] {
		return "", apperr.ErrNotFound
	}
	var id string
	if err := s.DB.WithContext(ctx).Table(table).Select("id").Where("slug = ? AND rpg_system_id = ?", slug, systemID).Scan(&id).Error; err != nil {
		return "", err
	}
	if id == "" {
		return "", apperr.ErrNotFound
	}
	return id, nil
}

func (s *Repository) OriginExists(ctx context.Context, id, systemID string) (bool, error) {
	var count int64
	err := s.DB.WithContext(ctx).Table("core.origin_definition").Where("id = ? AND rpg_system_id = ?", id, systemID).Count(&count).Error
	return count == 1, err
}

func (s *Repository) CampaignMatches(ctx context.Context, id, systemID string) (bool, error) {
	var count int64
	err := s.DB.WithContext(ctx).Table("core.campaign").Where("id = ? AND owner_user_id = ? AND rpg_system_id = ?", id, s.UserID, systemID).Count(&count).Error
	return count == 1, err
}

func (s *Repository) CampaignAllows(ctx context.Context, campaignID, classID string, originID *string) (bool, error) {
	var settings struct{ ClassMode, OriginMode string }
	if err := s.DB.WithContext(ctx).Table("ordem.campaign_settings").Select("class_mode, origin_mode").Where("campaign_id = ?", campaignID).Take(&settings).Error; err != nil {
		return false, err
	}
	if settings.ClassMode == "selected" && classID != "" {
		var count int64
		if err := s.DB.WithContext(ctx).Table("ordem.campaign_allowed_class").Where("campaign_id = ? AND class_id = ?", campaignID, classID).Count(&count).Error; err != nil {
			return false, err
		}
		if count == 0 {
			return false, nil
		}
	}
	if settings.OriginMode == "selected" && originID != nil {
		var count int64
		if err := s.DB.WithContext(ctx).Table("ordem.campaign_allowed_origin").Where("campaign_id = ? AND origin_id = ?", campaignID, *originID).Count(&count).Error; err != nil {
			return false, err
		}
		if count == 0 {
			return false, nil
		}
	}
	return true, nil
}

func (s *Repository) CharacterOptions(ctx context.Context, systemID string) (domain.CharacterOptions, error) {
	out := domain.CharacterOptions{Classes: []domain.Option{}, Origins: []domain.Option{}, Trails: []domain.TrailOption{}, Attributes: []domain.Option{}, Resources: []domain.Option{}, Skills: []domain.Option{}, NEX: []domain.NEXOption{}, TrainingLevels: []domain.TrainingOption{}}
	for _, pair := range []struct {
		table  string
		target *[]domain.Option
	}{{"core.class_definition", &out.Classes}, {"core.origin_definition", &out.Origins}, {"core.attribute_definition", &out.Attributes}, {"core.resource_definition", &out.Resources}, {"core.skill_definition", &out.Skills}} {
		columns := "id, slug, name, supplement_id"
		if pair.table != "core.origin_definition" {
			columns = "id, slug, name, NULL::uuid AS supplement_id"
		}
		if err := s.DB.WithContext(ctx).Table(pair.table).Select(columns).Where("rpg_system_id = ?", systemID).Order("name").Find(pair.target).Error; err != nil {
			return out, err
		}
	}
	if err := s.DB.WithContext(ctx).Table("core.archetype_definition").Select("id, name, class_id, supplement_id").Where("rpg_system_id=?", systemID).Order("name").Scan(&out.Trails).Error; err != nil {
		return out, err
	}
	if err := s.DB.WithContext(ctx).Table("ordem.nex_rule").Select("nex AS value, pe_limit").Order("nex").Find(&out.NEX).Error; err != nil {
		return out, err
	}
	if err := s.DB.WithContext(ctx).Table("core.skill_training_level").Select("id, name, bonus::int AS bonus").Where("rpg_system_id = ?", systemID).Order("sort_order").Find(&out.TrainingLevels).Error; err != nil {
		return out, err
	}
	return out, nil
}

func (s *Repository) CreateCharacter(ctx context.Context, in domain.CharacterInput) (domain.Character, error) {
	var id string
	err := s.DB.WithContext(ctx).Transaction(func(tx *gorm.DB) error {
		if err := tx.Raw(`INSERT INTO core.rpg_character(rpg_system_id, name, character_type, campaign_id, description, appearance, personality, background, objective, image_url)
			VALUES (?, ?, 'PLAYER', ?, ?, ?, ?, ?, ?, ?) RETURNING id`, in.SystemID, in.Name, in.CampaignID, in.Description, in.Appearance, in.Personality, in.Background, in.Objective, in.ImageURL).Scan(&id).Error; err != nil {
			return err
		}
		if err := tx.Exec("INSERT INTO core.character_sheet(character_id, owner_user_id) VALUES (?, ?)", id, s.UserID).Error; err != nil {
			return err
		}
		if err := writeStandaloneSupplement(tx, id, in.CampaignID, in.SupplementID, in.SupplementRuleIDs); err != nil {
			return err
		}
		return s.writeCharacterData(tx, id, in.SystemID, in.SystemData)
	})
	if err != nil {
		return domain.Character{}, fmt.Errorf("create character: %w", err)
	}
	return s.Character(ctx, id)
}

func (s *Repository) UpdateCharacter(ctx context.Context, id string, in domain.CharacterInput) (domain.Character, error) {
	err := s.DB.WithContext(ctx).Transaction(func(tx *gorm.DB) error {
		result := tx.Table("core.rpg_character AS c").Where("c.id = ? AND c.rpg_system_id = ? AND EXISTS (SELECT 1 FROM core.character_sheet sh WHERE sh.character_id=c.id AND sh.owner_user_id=?)", id, in.SystemID, s.UserID).Updates(map[string]any{"image_url": in.ImageURL, "name": in.Name, "campaign_id": in.CampaignID, "description": in.Description, "appearance": in.Appearance, "personality": in.Personality, "background": in.Background, "objective": in.Objective, "updated_at": time.Now()})
		if result.Error != nil {
			return result.Error
		}
		if result.RowsAffected == 0 {
			return apperr.ErrNotFound
		}
		if err := writeStandaloneSupplement(tx, id, in.CampaignID, in.SupplementID, in.SupplementRuleIDs); err != nil {
			return err
		}
		return s.writeCharacterData(tx, id, in.SystemID, in.SystemData)
	})
	if err != nil {
		return domain.Character{}, fmt.Errorf("update character: %w", err)
	}
	return s.Character(ctx, id)
}

func (s *Repository) writeCharacterData(tx *gorm.DB, id, systemID string, d domain.OrdemData) error {
	if err := tx.Exec("DELETE FROM ordem.character_determination WHERE character_id=?", id).Error; err != nil {
		return err
	}
	if err := tx.Exec("DELETE FROM ordem.character_progression_runtime WHERE character_id=?", id).Error; err != nil {
		return err
	}
	if err := tx.Exec("DELETE FROM ordem.character_supplement_trail WHERE character_id=?", id).Error; err != nil {
		return err
	}
	for _, table := range []string{"ordem.character_detail", "core.character_class", "core.character_origin", "core.character_progression", "core.character_attribute", "core.character_resource"} {
		if err := tx.Exec("DELETE FROM "+table+" WHERE character_id = ?", id).Error; err != nil {
			return err
		}
	}
	if err := tx.Exec("INSERT INTO ordem.character_detail(character_id, credit_limit) VALUES (?, ?)", id, d.CreditLimit).Error; err != nil {
		return err
	}
	if d.ProgressionMode != "survivor" {
		if err := tx.Exec("INSERT INTO core.character_class(character_id, class_id, rpg_system_id) VALUES (?, ?, ?)", id, d.ClassID, systemID).Error; err != nil {
			return err
		}
		if d.TrailID != nil {
			if err := tx.Exec("INSERT INTO ordem.character_supplement_trail(character_id,archetype_id) VALUES (?,?)", id, *d.TrailID).Error; err != nil {
				return err
			}
		}
	}
	if d.OriginID != nil {
		if err := tx.Exec("INSERT INTO core.character_origin(character_id, origin_id, rpg_system_id) VALUES (?, ?, ?)", id, *d.OriginID, systemID).Error; err != nil {
			return err
		}
	}
	var progressionID string
	if err := tx.Table("core.progression_definition").Select("id").Where("rpg_system_id = ? AND slug = 'nex'", systemID).Scan(&progressionID).Error; err != nil {
		return err
	}
	if d.ProgressionMode != "survivor" {
		if err := tx.Exec("INSERT INTO core.character_progression(character_id, progression_id, value, rpg_system_id) VALUES (?, ?, ?, ?)", id, progressionID, d.NEX, systemID).Error; err != nil {
			return err
		}
	}
	mode := d.ProgressionMode
	if mode == "" {
		mode = "nex"
	}
	if err := tx.Exec("INSERT INTO ordem.character_progression_runtime(character_id,mode,level,patent,survivor_class_id,survivor_stage,survivor_trail_id) VALUES (?,?,?,?,?,?,?)", id, mode, d.Level, d.Patent, d.SurvivorClassID, d.SurvivorStage, d.SurvivorTrailID).Error; err != nil {
		return err
	}
	attrs := []struct {
		slug  string
		value int
	}{{"agilidade", d.Attributes.Agility}, {"forca", d.Attributes.Strength}, {"intelecto", d.Attributes.Intellect}, {"presenca", d.Attributes.Presence}, {"vigor", d.Attributes.Vigor}}
	for _, item := range attrs {
		var ref string
		if err := tx.Table("core.attribute_definition").Select("id").Where("rpg_system_id = ? AND slug = ?", systemID, item.slug).Scan(&ref).Error; err != nil {
			return err
		}
		if ref == "" {
			return apperr.ErrNotFound
		}
		if err := tx.Exec("INSERT INTO core.character_attribute(character_id, attribute_id, value, rpg_system_id) VALUES (?, ?, ?, ?)", id, ref, item.value, systemID).Error; err != nil {
			return err
		}
	}
	resources := []struct {
		slug  string
		value domain.Resource
	}{{"pontos-de-vida", d.Resources.Health}, {"pontos-de-esforco", d.Resources.Effort}, {"sanidade", d.Resources.Sanity}}
	for _, item := range resources {
		var ref string
		if err := tx.Table("core.resource_definition").Select("id").Where("rpg_system_id = ? AND slug = ?", systemID, item.slug).Scan(&ref).Error; err != nil {
			return err
		}
		if ref == "" {
			return apperr.ErrNotFound
		}
		if err := tx.Exec("INSERT INTO core.character_resource(character_id, resource_id, current_value, max_value, temporary_value, max_adjustment, rpg_system_id) VALUES (?, ?, ?, ?, ?, ?, ?)", id, ref, item.value.Current, item.value.Maximum, item.value.Temporary, item.value.MaxAdjustment, systemID).Error; err != nil {
			return err
		}
	}
	if d.Resources.Determination != nil {
		r := d.Resources.Determination
		if err := tx.Exec("INSERT INTO ordem.character_determination(character_id,current_value,max_value,temporary_value,max_adjustment) VALUES (?,?,?,?,?)", id, r.Current, r.Maximum, r.Temporary, r.MaxAdjustment).Error; err != nil {
			return err
		}
	}
	return nil
}

func writeStandaloneSupplement(tx *gorm.DB, id string, campaignID, supplementID *string, ruleIDs []string) error {
	if err := tx.Exec("DELETE FROM ordem.character_supplement WHERE character_id=?", id).Error; err != nil {
		return err
	}
	if campaignID == nil && supplementID != nil {
		if err := tx.Exec("INSERT INTO ordem.character_supplement(character_id,supplement_id) VALUES (?,?)", id, *supplementID).Error; err != nil {
			return err
		}
		for _, ruleID := range ruleIDs {
			if err := tx.Exec("INSERT INTO ordem.character_supplement_rule(character_id,rule_id) VALUES (?,?)", id, ruleID).Error; err != nil {
				return err
			}
		}
	}
	return nil
}

func (s *Repository) DeleteCharacter(ctx context.Context, id string) error {
	return s.DB.WithContext(ctx).Transaction(func(tx *gorm.DB) error {
		var count int64
		if err := tx.Table("core.character_sheet").Where("character_id = ? AND owner_user_id = ?", id, s.UserID).Count(&count).Error; err != nil {
			return err
		}
		if count == 0 {
			return apperr.ErrNotFound
		}
		for _, table := range []string{"core.character_attack", "core.character_item", "core.character_ability", "core.character_skill", "ordem.character_item_modification", "ordem.character_supplement_trail", "ordem.character_determination", "ordem.character_progression_runtime", "ordem.character_supplement_rule", "ordem.character_supplement", "core.character_resource", "core.character_attribute", "core.character_progression", "core.character_origin", "core.character_class", "ordem.character_detail", "core.character_sheet"} {
			if err := tx.Exec("DELETE FROM "+table+" WHERE character_id = ?", id).Error; err != nil {
				return err
			}
		}
		return tx.Exec("DELETE FROM core.rpg_character WHERE id = ?", id).Error
	})
}
