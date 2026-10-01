package httpserver

import "github.com/gin-gonic/gin"

func (a *API) listItemModifications(c *gin.Context) {
	characterID, entryID := c.Param("id"), c.Param("entryId")
	if !validID(characterID) || !validID(entryID) {
		writeError(c, 400, "INVALID_REQUEST")
		return
	}
	sid, enabled, err := a.characters.CatalogVisibility(c.Request.Context(), characterID, "modifications")
	if err != nil {
		a.failure(c, err, "CHARACTER_NOT_FOUND")
		return
	}
	items, err := a.supplements.Modifications(c.Request.Context(), characterID, entryID, sid, enabled)
	if err != nil {
		a.failure(c, err, "CONTENT_NOT_FOUND")
		return
	}
	c.JSON(200, items)
}

func (a *API) setItemModification(c *gin.Context) {
	characterID, entryID, modificationID := c.Param("id"), c.Param("entryId"), c.Param("modificationId")
	if !validID(characterID) || !validID(entryID) || !validID(modificationID) {
		writeError(c, 400, "INVALID_REQUEST")
		return
	}
	var input struct {
		Selected *bool `json:"selected" binding:"required"`
	}
	if c.ShouldBindJSON(&input) != nil || input.Selected == nil {
		writeError(c, 400, "INVALID_REQUEST")
		return
	}
	sid, enabled, err := a.characters.CatalogVisibility(c.Request.Context(), characterID, "modifications")
	if err != nil {
		a.failure(c, err, "CHARACTER_NOT_FOUND")
		return
	}
	if err := a.supplements.SetModification(c.Request.Context(), characterID, entryID, sid, enabled, modificationID, *input.Selected); err != nil {
		a.failure(c, err, "CONTENT_NOT_FOUND")
		return
	}
	c.Status(204)
}
