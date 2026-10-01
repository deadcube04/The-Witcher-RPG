package supplements

import (
	"context"
	"errors"

	"RPG-manager/backend/internal/apperr"
	"gorm.io/gorm"
)

type ThreatReference struct {
	ID          string `json:"id"`
	Name        string `json:"name"`
	Description string `json:"description"`
	SourcePage  int    `json:"sourcePage" gorm:"column:supplement_page_start"`
}
type Reference struct {
	SupplementID *string           `json:"supplementId"`
	Rules        []Rule            `json:"rules"`
	Threats      []ThreatReference `json:"threats"`
}

func (s *Service) Reference(ctx context.Context, characterID string) (Reference, error) {
	out := Reference{Rules: []Rule{}, Threats: []ThreatReference{}}
	var character struct{ CampaignID *string }
	err := s.db.WithContext(ctx).Table("core.rpg_character AS c").Select("c.campaign_id").Joins("JOIN core.character_sheet AS sh ON sh.character_id=c.id").Where("c.id=? AND sh.owner_user_id=?", characterID, s.userID).Take(&character).Error
	if errors.Is(err, gorm.ErrRecordNotFound) {
		return out, apperr.ErrNotFound
	}
	if err != nil {
		return out, err
	}
	var supplementID string
	var ruleIDs []string
	threatsEnabled := false
	if character.CampaignID != nil {
		if err := s.db.WithContext(ctx).Table("ordem.campaign_supplement").Select("supplement_id").Where("campaign_id=?", *character.CampaignID).Scan(&supplementID).Error; err != nil {
			return out, err
		}
		if err := s.db.WithContext(ctx).Table("ordem.campaign_supplement_rule").Select("rule_id").Where("campaign_id=?", *character.CampaignID).Scan(&ruleIDs).Error; err != nil {
			return out, err
		}
		var count int64
		if err := s.db.WithContext(ctx).Table("ordem.campaign_supplement_category").Where("campaign_id=? AND category='threats'", *character.CampaignID).Count(&count).Error; err != nil {
			return out, err
		}
		threatsEnabled = count > 0
	} else {
		if err := s.db.WithContext(ctx).Table("ordem.character_supplement").Select("supplement_id").Where("character_id=?", characterID).Scan(&supplementID).Error; err != nil {
			return out, err
		}
		if err := s.db.WithContext(ctx).Table("ordem.character_supplement_rule").Select("rule_id").Where("character_id=?", characterID).Scan(&ruleIDs).Error; err != nil {
			return out, err
		}
		threatsEnabled = supplementID != ""
	}
	if supplementID == "" {
		return out, nil
	}
	out.SupplementID = &supplementID
	if err := s.db.WithContext(ctx).Table("ordem.supplement_rule").Select("id, parent_id, slug, name, is_optional, source_page_start, rule_text").Where("supplement_id=? AND (is_optional=false OR id IN ?)", supplementID, ruleIDs).Order("source_page_start, name").Scan(&out.Rules).Error; err != nil {
		return out, err
	}
	hiddenRules, err := s.HiddenTargets(ctx, supplementID, []string{"rule"})
	if err != nil {
		return out, err
	}
	visibleRules := out.Rules[:0]
	for _, rule := range out.Rules {
		if !hiddenRules[rule.ID] {
			visibleRules = append(visibleRules, rule)
		}
	}
	out.Rules = visibleRules
	if threatsEnabled {
		if err := s.db.WithContext(ctx).Table("core.rpg_character").Select("id, name, LEFT(COALESCE(description,''),240) AS description, supplement_page_start").Where("supplement_id=? AND character_type='THREAT'", supplementID).Order("name").Scan(&out.Threats).Error; err != nil {
			return out, err
		}
		hiddenThreats, err := s.HiddenTargets(ctx, supplementID, []string{"threat"})
		if err != nil {
			return out, err
		}
		visibleThreats := out.Threats[:0]
		for _, threat := range out.Threats {
			if !hiddenThreats[threat.ID] {
				visibleThreats = append(visibleThreats, threat)
			}
		}
		out.Threats = visibleThreats
	}
	return out, nil
}
