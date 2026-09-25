package httpapi

import (
	"bytes"
	"encoding/json"
	"net/http"

	"RPG-manager/backend/internal/domain"
	"RPG-manager/backend/internal/service"

	"github.com/gin-gonic/gin"
)

func (a *API) characterOptions(c *gin.Context) {
	value, err := service.NewCharacter(a.store).Options(c.Request.Context())
	if err != nil {
		a.failure(c, err, "RPG_SYSTEM_NOT_FOUND")
		return
	}
	c.JSON(200, value)
}
func (a *API) listCharacters(c *gin.Context) {
	value, err := service.NewCharacter(a.store).List(c.Request.Context())
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
	value, err := service.NewCharacter(a.store).Get(c.Request.Context(), id)
	if err != nil {
		a.failure(c, err, "CHARACTER_NOT_FOUND")
		return
	}
	c.JSON(200, value)
}
func (a *API) createCharacter(c *gin.Context) {
	var in domain.CharacterInput
	if c.ShouldBindJSON(&in) != nil || !validID(in.SystemID) || (in.CampaignID != nil && !validID(*in.CampaignID)) || !validID(in.SystemData.ClassID) {
		writeError(c, 400, "INVALID_REQUEST")
		return
	}
	value, err := service.NewCharacter(a.store).Create(c.Request.Context(), in)
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
	current, err := service.NewCharacter(a.store).Get(c.Request.Context(), id)
	if err != nil {
		a.failure(c, err, "CHARACTER_NOT_FOUND")
		return
	}
	var fields map[string]json.RawMessage
	if c.ShouldBindJSON(&fields) != nil || len(fields) == 0 {
		writeError(c, 400, "INVALID_REQUEST")
		return
	}
	in := domain.CharacterInput{Name: current.Name, SystemID: current.SystemID, CampaignID: current.CampaignID, Description: current.Description, Appearance: current.Appearance, Personality: current.Personality, Background: current.Background, Objective: current.Objective, SystemData: current.SystemData}
	for key, raw := range fields {
		var target any
		switch key {
		case "name":
			target = &in.Name
		case "systemId":
			target = &in.SystemID
		case "campaignId":
			target = &in.CampaignID
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
	if !validID(in.SystemID) || !validID(in.SystemData.ClassID) {
		writeError(c, 400, "INVALID_REQUEST")
		return
	}
	value, err := service.NewCharacter(a.store).Update(c.Request.Context(), id, in)
	if err != nil {
		a.failure(c, err, "CHARACTER_NOT_FOUND")
		return
	}
	c.JSON(200, value)
}
func (a *API) deleteCharacter(c *gin.Context) {
	id := c.Param("id")
	if !validID(id) {
		writeError(c, 400, "INVALID_REQUEST")
		return
	}
	if err := service.NewCharacter(a.store).Delete(c.Request.Context(), id); err != nil {
		a.failure(c, err, "CHARACTER_NOT_FOUND")
		return
	}
	c.Status(204)
}
