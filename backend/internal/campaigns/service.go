package campaigns

import (
	"context"
	"regexp"
	"strings"

	"RPG-manager/backend/internal/apperr"
	"RPG-manager/backend/internal/domain"
)

var campaignIDPattern = regexp.MustCompile(`^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$`)

type ImageValidator interface {
	ValidateAssociation(context.Context, string, string, string) error
}

type Service struct {
	repo    *Repository
	systems SystemLookup
	images  ImageValidator
}

func NewService(repo *Repository, systems SystemLookup, images ...ImageValidator) *Service {
	var validator ImageValidator
	if len(images) > 0 {
		validator = images[0]
	}
	return &Service{repo: repo, systems: systems, images: validator}
}

func (s *Service) List(ctx context.Context) ([]domain.Campaign, error) { return s.repo.Campaigns(ctx) }
func (s *Service) Get(ctx context.Context, id string) (domain.Campaign, error) {
	return s.repo.Campaign(ctx, id)
}

func (s *Service) Create(ctx context.Context, in domain.CampaignInput) (domain.Campaign, error) {
	systems, err := s.systems.List(ctx)
	if err != nil {
		return domain.Campaign{}, err
	}
	available := false
	for _, system := range systems {
		if system.ID == in.SystemID {
			if system.Slug != "ordem-paranormal" || system.Status != "available" {
				return domain.Campaign{}, apperr.ErrPreview
			}
			available = true
			break
		}
	}
	if !available {
		return domain.Campaign{}, apperr.ErrNotFound
	}
	in.Name = strings.TrimSpace(in.Name)
	if in.Name == "" || len(in.Name) > 160 || len(in.Description) > 10000 || len(in.CoverImageURL) > 2048 {
		return domain.Campaign{}, apperr.ErrInvalid
	}
	// Local import payloads predate campaign settings. The HTTP handler requires
	// explicit choices; only the legacy importer takes these defaults.
	if in.Settings == nil {
		in.Settings = &domain.CampaignSettings{
			Kind:    "ordem-paranormal",
			Classes: domain.CampaignSelection{Mode: "all", AllowedIDs: []string{}},
			Origins: domain.CampaignSelection{Mode: "all", AllowedIDs: []string{}},
		}
		in.SheetMode = "free"
	}
	if in.SheetMode != "guided" && in.SheetMode != "free" {
		return domain.Campaign{}, apperr.ErrInvalid
	}
	if in.ImportStatus != "" && in.ImportStatus != "active" && in.ImportStatus != "archived" {
		return domain.Campaign{}, apperr.ErrInvalid
	}
	if in.Settings.Kind != "ordem-paranormal" {
		return domain.Campaign{}, apperr.ErrInvalid
	}
	if err := s.validateSelection(ctx, in.SystemID, in.Settings.Classes, "core.class_definition"); err != nil {
		return domain.Campaign{}, err
	}
	if err := s.validateSelection(ctx, in.SystemID, in.Settings.Origins, "core.origin_definition"); err != nil {
		return domain.Campaign{}, err
	}
	if err := s.validateSupplement(ctx, in.SystemID, in.Settings.Supplement); err != nil {
		return domain.Campaign{}, err
	}
	if err := s.validateSupplementOrigins(ctx, in.Settings.Origins, in.Settings.Supplement); err != nil {
		return domain.Campaign{}, err
	}
	if in.CoverImageURL != "" {
		if s.images == nil {
			return domain.Campaign{}, apperr.ErrInvalid
		}
		if err := s.images.ValidateAssociation(ctx, in.CoverImageURL, s.repo.UserID, "campaign"); err != nil {
			return domain.Campaign{}, err
		}
	}
	return s.repo.CreateCampaign(ctx, in)
}

func (s *Service) UpdateSettings(ctx context.Context, id string, settings domain.CampaignSettings) (domain.Campaign, error) {
	campaign, err := s.repo.Campaign(ctx, id)
	if err != nil {
		return domain.Campaign{}, err
	}
	if settings.Kind != "ordem-paranormal" {
		return domain.Campaign{}, apperr.ErrInvalid
	}
	if err := s.validateSelection(ctx, campaign.SystemID, settings.Classes, "core.class_definition"); err != nil {
		return domain.Campaign{}, err
	}
	if err := s.validateSelection(ctx, campaign.SystemID, settings.Origins, "core.origin_definition"); err != nil {
		return domain.Campaign{}, err
	}
	if err := s.validateSupplement(ctx, campaign.SystemID, settings.Supplement); err != nil {
		return domain.Campaign{}, err
	}
	if err := s.validateSupplementOrigins(ctx, settings.Origins, settings.Supplement); err != nil {
		return domain.Campaign{}, err
	}
	return s.repo.UpdateSettings(ctx, campaign, settings)
}

func (s *Service) validateSupplementOrigins(ctx context.Context, origins domain.CampaignSelection, supplement *domain.SupplementSettings) error {
	if len(origins.AllowedIDs) == 0 {
		return nil
	}
	var rows []struct{ SupplementID *string }
	if err := s.repo.DB.WithContext(ctx).Table("core.origin_definition").Select("supplement_id").Where("id IN ?", origins.AllowedIDs).Scan(&rows).Error; err != nil {
		return err
	}
	for _, row := range rows {
		if row.SupplementID != nil && (supplement == nil || *row.SupplementID != supplement.ID) {
			return apperr.ErrInvalid
		}
	}
	return nil
}

func (s *Service) validateSupplement(ctx context.Context, systemID string, supplement *domain.SupplementSettings) error {
	if supplement == nil {
		return nil
	}
	if !campaignIDPattern.MatchString(supplement.ID) || supplement.Categories == nil || supplement.RuleIDs == nil {
		return apperr.ErrInvalid
	}
	valid, err := s.repo.SupplementMatches(ctx, supplement.ID, systemID)
	if err != nil {
		return err
	}
	if !valid {
		return apperr.ErrInvalid
	}
	allowed := map[string]bool{"survivor": true, "trails": true, "powers": true, "rituals": true, "items": true, "modifications": true, "threats": true}
	seen := map[string]bool{}
	for _, category := range supplement.Categories {
		if !allowed[category] || seen[category] {
			return apperr.ErrInvalid
		}
		seen[category] = true
	}
	if seen["survivor"] && !seen["trails"] {
		return apperr.ErrInvalid
	}
	seenRules := map[string]bool{}
	for _, id := range supplement.RuleIDs {
		if !campaignIDPattern.MatchString(id) || seenRules[id] {
			return apperr.ErrInvalid
		}
		seenRules[id] = true
	}
	expanded, err := s.repo.ExpandRuleIDs(ctx, supplement.ID, supplement.RuleIDs)
	if err != nil {
		return err
	}
	if err := s.repo.ValidateRules(ctx, supplement.ID, expanded); err != nil {
		return err
	}
	supplement.RuleIDs = expanded
	return nil
}

func (s *Service) validateSelection(ctx context.Context, systemID string, selection domain.CampaignSelection, table string) error {
	if selection.Mode != "all" && selection.Mode != "selected" {
		return apperr.ErrInvalid
	}
	if selection.AllowedIDs == nil {
		return apperr.ErrInvalid
	}
	if selection.Mode == "all" && len(selection.AllowedIDs) != 0 {
		return apperr.ErrInvalid
	}
	seen := make(map[string]bool, len(selection.AllowedIDs))
	for _, id := range selection.AllowedIDs {
		key := strings.ToLower(id)
		if !campaignIDPattern.MatchString(id) || seen[key] {
			return apperr.ErrInvalid
		}
		seen[key] = true
	}
	if selection.Mode == "selected" && len(selection.AllowedIDs) > 0 {
		valid, err := s.repo.DefinitionCount(ctx, table, systemID, selection.AllowedIDs)
		if err != nil {
			return err
		}
		if valid != int64(len(selection.AllowedIDs)) {
			return apperr.ErrInvalid
		}
	}
	return nil
}

func (s *Service) Delete(ctx context.Context, id string) error { return s.repo.DeleteCampaign(ctx, id) }
