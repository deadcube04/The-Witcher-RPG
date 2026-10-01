package httpserver

import (
	"bytes"
	"encoding/json"
	"net/http"

	"RPG-manager/backend/internal/domain"

	"github.com/gin-gonic/gin"
)

func (a *API) characterOptions(c *gin.Context) {
	value, err := a.characters.Options(c.Request.Context())
	if err != nil {
		a.failure(c, err, "RPG_SYSTEM_NOT_FOUND")
		return
	}
	c.JSON(200, value)
}
func (a *API) listCharacters(c *gin.Context) {
	value, err := a.characters.List(c.Request.Context())
	if err != nil {
		a.failure(c, err, "CHARACTER_NOT_FOUND")
		return
	}
	c.JSON(200, value)
}
func (a *API) getCharacter(c *gin.Context) {
	id := c.Param("id")
	if !validID(id) {
		writeError(c, 400, "INVALID_REQUEST")
		return
	}
	value, err := a.characters.Get(c.Request.Context(), id)
	if err != nil {
		a.failure(c, err, "CHARACTER_NOT_FOUND")
		return
	}
	c.JSON(200, value)
}
func (a *API) createCharacter(c *gin.Context) {
	var in domain.CharacterInput
	if c.ShouldBindJSON(&in) != nil || !validCharacterInputIDs(in) {
		writeError(c, 400, "INVALID_REQUEST")
		return
	}
	value, err := a.characters.Create(c.Request.Context(), in)
	if err != nil {
		a.failure(c, err, "CHARACTER_NOT_FOUND")
		return
	}
	c.JSON(http.StatusCreated, value)
}
func (a *API) patchCharacter(c *gin.Context) {
	id := c.Param("id")
	if !validID(id) {
		writeError(c, 400, "INVALID_REQUEST")
		return
	}
	current, err := a.characters.Get(c.Request.Context(), id)
	if err != nil {
		a.failure(c, err, "CHARACTER_NOT_FOUND")
		return
	}
	var fields map[string]json.RawMessage
	if c.ShouldBindJSON(&fields) != nil || len(fields) == 0 {
		writeError(c, 400, "INVALID_REQUEST")
		return
	}
	in := domain.CharacterInput{Name: current.Name, SystemID: current.SystemID, CampaignID: current.CampaignID, SupplementID: current.SupplementID, SupplementRuleIDs: current.SupplementRuleIDs, ImageURL: current.ImageURL, Description: current.Description, Appearance: current.Appearance, Personality: current.Personality, Background: current.Background, Objective: current.Objective, SystemData: current.SystemData}
	for key, raw := range fields {
		var target any
		switch key {
		case "imageUrl":
			target = &in.ImageURL
		case "name":
			target = &in.Name
		case "systemId":
			target = &in.SystemID
		case "campaignId":
			target = &in.CampaignID
		case "supplementId":
			target = &in.SupplementID
		case "supplementRuleIds":
			target = &in.SupplementRuleIDs
		case "description":
			target = &in.Description
		case "appearance":
			target = &in.Appearance
		case "personality":
			target = &in.Personality
		case "background":
			target = &in.Background
		case "objective":
			target = &in.Objective
		case "systemData":
			target = &in.SystemData
		default:
			writeError(c, 400, "INVALID_REQUEST")
			return
		}
		decoder := json.NewDecoder(bytes.NewReader(raw))
		decoder.DisallowUnknownFields()
		if err := decoder.Decode(target); err != nil {
			writeError(c, 400, "INVALID_REQUEST")
			return
		}
	}
	if !validCharacterInputIDs(in) {
		writeError(c, 400, "INVALID_REQUEST")
		return
	}
	value, err := a.characters.Update(c.Request.Context(), id, in)
	if err != nil {
		a.failure(c, err, "CHARACTER_NOT_FOUND")
		return
	}
	c.JSON(200, value)
}

func validCharacterInputIDs(in domain.CharacterInput) bool {
	if !validID(in.SystemID) || (in.CampaignID != nil && !validID(*in.CampaignID)) || (in.SupplementID != nil && !validID(*in.SupplementID)) {
		return false
	}
	if in.SystemData.ProgressionMode != "survivor" && !validID(in.SystemData.ClassID) {
		return false
	}
	for _, id := range in.SupplementRuleIDs {
		if !validID(id) {
			return false
		}
	}
	for _, id := range []*string{in.SystemData.OriginID, in.SystemData.TrailID, in.SystemData.SurvivorClassID, in.SystemData.SurvivorTrailID} {
		if id != nil && !validID(*id) {
			return false
		}
	}
	return true
}
func (a *API) deleteCharacter(c *gin.Context) {
	id := c.Param("id")
	if !validID(id) {
		writeError(c, 400, "INVALID_REQUEST")
		return
	}
	if err := a.characters.Delete(c.Request.Context(), id); err != nil {
		a.failure(c, err, "CHARACTER_NOT_FOUND")
		return
	}
	c.Status(204)
}
