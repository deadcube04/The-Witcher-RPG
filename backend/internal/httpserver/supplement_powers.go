package httpserver

import (
	"RPG-manager/backend/internal/domain"
	"github.com/gin-gonic/gin"
)

func (a *API) powerAccess(c *gin.Context) (string, domain.OrdemData, bool, bool, error) {
	id := c.Param("id")
	character, err := a.characters.Get(c.Request.Context(), id)
	if err != nil {
		return "", domain.OrdemData{}, false, false, err
	}
	supplementID, powers, err := a.characters.CatalogVisibility(c.Request.Context(), id, "powers")
	if err != nil {
		return "", domain.OrdemData{}, false, false, err
	}
	_, trails, err := a.characters.CatalogVisibility(c.Request.Context(), id, "trails")
	return supplementID, character.SystemData, powers, trails, err
}

func (a *API) listPowers(c *gin.Context) {
	if !validID(c.Param("id")) {
		writeError(c, 400, "INVALID_REQUEST")
		return
	}
	sid, data, powers, trails, err := a.powerAccess(c)
	if err != nil {
		a.failure(c, err, "CHARACTER_NOT_FOUND")
		return
	}
	items, err := a.supplements.Powers(c.Request.Context(), sid, c.Param("id"), data, powers, trails)
	if err != nil {
		a.failure(c, err, "CONTENT_NOT_FOUND")
		return
	}
	c.JSON(200, items)
}

func (a *API) setPower(c *gin.Context) {
	if !validID(c.Param("id")) || !validID(c.Param("powerId")) {
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
	sid, data, powers, trails, err := a.powerAccess(c)
	if err != nil {
		a.failure(c, err, "CHARACTER_NOT_FOUND")
		return
	}
	if err := a.supplements.SetPower(c.Request.Context(), sid, c.Param("id"), data, powers, trails, c.Param("powerId"), *input.Selected); err != nil {
		a.failure(c, err, "CONTENT_NOT_FOUND")
		return
	}
	c.Status(204)
}
