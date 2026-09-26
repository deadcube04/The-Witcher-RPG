package httpserver

import (
	"net/http"

	"github.com/gin-gonic/gin"
)

func (a *API) listRituals(c *gin.Context) {
	id := c.Param("id")
	if !validID(id) {
		writeError(c, 400, "INVALID_REQUEST")
		return
	}
	v, err := a.ritualEntries.List(c.Request.Context(), id)
	if err != nil {
		a.failure(c, err, "CHARACTER_NOT_FOUND")
		return
	}
	c.JSON(200, v)
}
func (a *API) addRitual(c *gin.Context) {
	id := c.Param("id")
	if !validID(id) {
		writeError(c, 400, "INVALID_REQUEST")
		return
	}
	var in struct {
		DefinitionID string `json:"definitionId" binding:"required,uuid"`
	}
	if c.ShouldBindJSON(&in) != nil {
		writeError(c, 400, "INVALID_REQUEST")
		return
	}
	v, err := a.ritualEntries.Add(c.Request.Context(), id, in.DefinitionID)
	if err != nil {
		a.failure(c, err, "CONTENT_NOT_FOUND")
		return
	}
	c.JSON(http.StatusCreated, v)
}
func (a *API) updateRitual(c *gin.Context) {
	id, entryID := c.Param("id"), c.Param("entryId")
	if !validID(id) || !validID(entryID) {
		writeError(c, 400, "INVALID_REQUEST")
		return
	}
	var in struct {
		DefinitionID *string `json:"definitionId"`
		Notes        *string `json:"notes"`
	}
	if c.ShouldBindJSON(&in) != nil {
		writeError(c, 400, "INVALID_REQUEST")
		return
	}
	fields := make(map[string]any)
	if in.DefinitionID != nil {
		if !validID(*in.DefinitionID) {
			writeError(c, 400, "INVALID_REQUEST")
			return
		}
		fields["ability_id"] = *in.DefinitionID
	}
	if in.Notes != nil {
		fields["notes"] = *in.Notes
	}
	v, err := a.ritualEntries.Update(c.Request.Context(), id, entryID, fields)
	if err != nil {
		a.failure(c, err, "CONTENT_NOT_FOUND")
		return
	}
	c.JSON(200, v)
}
func (a *API) deleteRitual(c *gin.Context) {
	id, entryID := c.Param("id"), c.Param("entryId")
	if !validID(id) || !validID(entryID) {
		writeError(c, 400, "INVALID_REQUEST")
		return
	}
	if err := a.ritualEntries.Delete(c.Request.Context(), id, entryID); err != nil {
		a.failure(c, err, "CONTENT_NOT_FOUND")
		return
	}
	c.Status(204)
}
