package httpapi

import (
	"bytes"
	"encoding/json"
	"errors"
	"net/http"
	"regexp"

	"RPG-manager/backend/internal/domain"
	"RPG-manager/backend/internal/repository"
	"RPG-manager/backend/internal/service"

	"github.com/gin-gonic/gin"
	"gorm.io/gorm"
)

var usernamePattern = regexp.MustCompile(`^[a-zA-Z0-9_.-]+$`)
var uuidPattern = regexp.MustCompile(`^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$`)

func validID(id string) bool { return uuidPattern.MatchString(id) }

func (a *API) register(r *gin.RouterGroup) {
	r.GET("/me", a.getProfile)
	r.PATCH("/me", a.patchProfile)
	r.GET("/me/preferences", a.getPreferences)
	r.PATCH("/me/preferences", a.patchPreferences)
	r.GET("/rpg-systems", a.getSystems)
	r.GET("/campaigns", a.listCampaigns)
	r.POST("/campaigns", a.createCampaign)
	r.GET("/campaigns/:id", a.getCampaign)
	r.PATCH("/campaigns/:id", a.patchCampaign)
	r.DELETE("/campaigns/:id", a.deleteCampaign)
	r.GET("/ordem/character-options", a.characterOptions)
	r.GET("/character-sheets", a.listCharacters)
	r.POST("/character-sheets", a.createCharacter)
	r.GET("/character-sheets/:id", a.getCharacter)
	r.PATCH("/character-sheets/:id", a.patchCharacter)
	r.DELETE("/character-sheets/:id", a.deleteCharacter)
	r.GET("/character-sheets/:id/skills", a.listSkills)
	r.PUT("/character-sheets/:id/skills", a.updateSkills)
	r.GET("/ordem/catalog/inventory", a.inventoryCatalog)
	r.GET("/ordem/catalog/rituals", a.ritualCatalog)
	r.GET("/ordem/catalog/attacks", a.attackCatalog)
	r.POST("/ordem/homebrew/inventory", a.createHomebrewInventory)
	r.PATCH("/ordem/homebrew/inventory/:id", a.updateHomebrewInventory)
	r.DELETE("/ordem/homebrew/inventory/:id", a.deleteHomebrewInventory)
	r.POST("/ordem/homebrew/rituals", a.createHomebrewRitual)
	r.PATCH("/ordem/homebrew/rituals/:id", a.updateHomebrewRitual)
	r.DELETE("/ordem/homebrew/rituals/:id", a.deleteHomebrewRitual)
	r.POST("/ordem/homebrew/attacks", a.createHomebrewAttack)
	r.PATCH("/ordem/homebrew/attacks/:id", a.updateHomebrewAttack)
	r.DELETE("/ordem/homebrew/attacks/:id", a.deleteHomebrewAttack)
	r.GET("/character-sheets/:id/inventory", a.listInventory)
	r.POST("/character-sheets/:id/inventory", a.addInventory)
	r.PATCH("/character-sheets/:id/inventory/:entryId", a.updateInventory)
	r.DELETE("/character-sheets/:id/inventory/:entryId", a.deleteInventory)
	r.GET("/character-sheets/:id/rituals", a.listRituals)
	r.POST("/character-sheets/:id/rituals", a.addRitual)
	r.PATCH("/character-sheets/:id/rituals/:entryId", a.updateRitual)
	r.DELETE("/character-sheets/:id/rituals/:entryId", a.deleteRitual)
	r.GET("/character-sheets/:id/attacks", a.listAttacks)
	r.POST("/character-sheets/:id/attacks", a.addAttack)
	r.POST("/character-sheets/:id/attacks/from-inventory", a.addAttackFromInventory)
	r.PATCH("/character-sheets/:id/attacks/:entryId", a.updateAttack)
	r.DELETE("/character-sheets/:id/attacks/:entryId", a.deleteAttack)
	r.POST("/local-import/preview", a.previewImport)
	r.POST("/local-import/apply", a.applyImport)
}

func (a *API) failure(c *gin.Context, err error, missing string) {
	switch {
	case errors.Is(err, repository.ErrNotFound):
		writeError(c, http.StatusNotFound, missing)
	case errors.Is(err, service.ErrInvalid):
		writeError(c, http.StatusBadRequest, "INVALID_REQUEST")
	case errors.Is(err, service.ErrPreview):
		writeError(c, http.StatusConflict, "CONFLICT")
	case errors.Is(err, service.ErrSystemMismatch):
		writeError(c, http.StatusBadRequest, "SYSTEM_MISMATCH")
	case errors.Is(err, repository.ErrConflict):
		writeError(c, http.StatusConflict, "CONFLICT")
	case errors.Is(err, gorm.ErrDuplicatedKey):
		writeError(c, http.StatusConflict, "CONFLICT")
	case errors.Is(err, repository.ErrInUse):
		writeError(c, http.StatusConflict, "CONTENT_IN_USE")
	case errors.Is(err, repository.ErrAlreadyAdded):
		writeError(c, http.StatusConflict, "CONTENT_ALREADY_ADDED")
	default:
		a.logger.Error("request failed", "error", err)
		writeError(c, http.StatusInternalServerError, "INTERNAL_ERROR")
	}
}

func (a *API) getProfile(c *gin.Context) {
	value, err := service.NewCore(a.store).Profile(c.Request.Context())
	if err != nil {
		a.failure(c, err, "USER_NOT_FOUND")
		return
	}
	c.JSON(http.StatusOK, value)
}
func (a *API) patchProfile(c *gin.Context) {
	var in struct {
		Name      string `json:"name" binding:"required"`
		Username  string `json:"username" binding:"required"`
		AvatarURL string `json:"avatarUrl"`
	}
	if c.ShouldBindJSON(&in) != nil || !usernamePattern.MatchString(in.Username) {
		writeError(c, 400, "INVALID_REQUEST")
		return
	}
	value, err := service.NewCore(a.store).UpdateProfile(c.Request.Context(), in.Name, in.Username, in.AvatarURL)
	if err != nil {
		a.failure(c, err, "USER_NOT_FOUND")
		return
	}
	c.JSON(http.StatusOK, value)
}
func (a *API) getPreferences(c *gin.Context) {
	value, err := service.NewCore(a.store).Preferences(c.Request.Context())
	if err != nil {
		a.failure(c, err, "USER_NOT_FOUND")
		return
	}
	c.JSON(http.StatusOK, value)
}
func (a *API) patchPreferences(c *gin.Context) {
	var in map[string]json.RawMessage
	if c.ShouldBindJSON(&in) != nil || len(in) == 0 {
		writeError(c, 400, "INVALID_REQUEST")
		return
	}
	s := service.NewCore(a.store)
	p, err := s.Preferences(c.Request.Context())
	if err != nil {
		a.failure(c, err, "USER_NOT_FOUND")
		return
	}
	for key, raw := range in {
		if bytes.Equal(raw, []byte("null")) && key == "activeThemeId" {
			p.ActiveThemeID = nil
			continue
		}
		var value string
		if json.Unmarshal(raw, &value) != nil || value == "" {
			writeError(c, 400, "INVALID_REQUEST")
			return
		}
		switch key {
		case "activeSystemId":
			if !validID(value) {
				writeError(c, 400, "INVALID_REQUEST")
				return
			}
			p.ActiveSystemID = value
		case "activeThemeId":
			p.ActiveThemeID = &value
		case "sidebarMode":
			p.SidebarMode = value
		default:
			writeError(c, 400, "INVALID_REQUEST")
			return
		}
	}
	p, err = s.UpdatePreferences(c.Request.Context(), p)
	if err != nil {
		a.failure(c, err, "RPG_SYSTEM_NOT_FOUND")
		return
	}
	c.JSON(http.StatusOK, p)
}
func (a *API) getSystems(c *gin.Context) {
	value, err := service.NewCore(a.store).Systems(c.Request.Context())
	if err != nil {
		a.failure(c, err, "RPG_SYSTEM_NOT_FOUND")
		return
	}
	c.JSON(http.StatusOK, value)
}
func (a *API) listCampaigns(c *gin.Context) {
	value, err := service.NewCore(a.store).Campaigns(c.Request.Context())
	if err != nil {
		a.failure(c, err, "CAMPAIGN_NOT_FOUND")
		return
	}
	c.JSON(http.StatusOK, value)
}
func (a *API) getCampaign(c *gin.Context) {
	id := c.Param("id")
	if !validID(id) {
		writeError(c, 400, "INVALID_REQUEST")
		return
	}
	value, err := service.NewCore(a.store).Campaign(c.Request.Context(), id)
	if err != nil {
		a.failure(c, err, "CAMPAIGN_NOT_FOUND")
		return
	}
	c.JSON(http.StatusOK, value)
}
func (a *API) createCampaign(c *gin.Context) {
	var in domain.CampaignInput
	if c.ShouldBindJSON(&in) != nil {
		writeError(c, 400, "INVALID_REQUEST")
		return
	}
	value, err := service.NewCore(a.store).CreateCampaign(c.Request.Context(), in)
	if err != nil {
		a.failure(c, err, "RPG_SYSTEM_NOT_FOUND")
		return
	}
	c.JSON(http.StatusCreated, value)
}
func (a *API) patchCampaign(c *gin.Context) {
	id := c.Param("id")
	if !validID(id) {
		writeError(c, 400, "INVALID_REQUEST")
		return
	}
	var in struct {
		SystemID    *string `json:"systemId"`
		Name        *string `json:"name"`
		Description *string `json:"description"`
		Status      *string `json:"status"`
	}
	if c.ShouldBindJSON(&in) != nil {
		writeError(c, 400, "INVALID_REQUEST")
		return
	}
	fields := make(map[string]any)
	if in.SystemID != nil {
		if !validID(*in.SystemID) {
			writeError(c, 400, "INVALID_REQUEST")
			return
		}
		fields["rpg_system_id"] = *in.SystemID
	}
	if in.Name != nil {
		if len(*in.Name) == 0 || len(*in.Name) > 160 {
			writeError(c, 400, "INVALID_REQUEST")
			return
		}
		fields["name"] = *in.Name
	}
	if in.Description != nil {
		fields["description"] = *in.Description
	}
	if in.Status != nil {
		if *in.Status != "active" && *in.Status != "archived" {
			writeError(c, 400, "INVALID_REQUEST")
			return
		}
		fields["status"] = *in.Status
	}
	if len(fields) == 0 {
		writeError(c, 400, "INVALID_REQUEST")
		return
	}
	value, err := service.NewCore(a.store).UpdateCampaign(c.Request.Context(), id, fields)
	if err != nil {
		a.failure(c, err, "CAMPAIGN_NOT_FOUND")
		return
	}
	c.JSON(http.StatusOK, value)
}
func (a *API) deleteCampaign(c *gin.Context) {
	id := c.Param("id")
	if !validID(id) {
		writeError(c, 400, "INVALID_REQUEST")
		return
	}
	if err := service.NewCore(a.store).DeleteCampaign(c.Request.Context(), id); err != nil {
		a.failure(c, err, "CAMPAIGN_NOT_FOUND")
		return
	}
	c.Status(http.StatusNoContent)
}
