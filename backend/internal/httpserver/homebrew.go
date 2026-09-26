package httpserver

import (
	"RPG-manager/backend/internal/domain"
	"net/http"

	"github.com/gin-gonic/gin"
)

func (a *API) createHomebrewInventory(c *gin.Context) {
	var in domain.InventoryInput
	if c.ShouldBindJSON(&in) != nil {
		writeError(c, 400, "INVALID_REQUEST")
		return
	}
	v, err := a.homebrew.CreateInventory(c.Request.Context(), in)
	if err != nil {
		a.failure(c, err, "CONTENT_NOT_FOUND")
		return
	}
	c.JSON(http.StatusCreated, v)
}
func (a *API) updateHomebrewInventory(c *gin.Context) {
	id := c.Param("id")
	if !validID(id) {
		writeError(c, 400, "INVALID_REQUEST")
		return
	}
	var in domain.InventoryInput
	if c.ShouldBindJSON(&in) != nil {
		writeError(c, 400, "INVALID_REQUEST")
		return
	}
	v, err := a.homebrew.UpdateInventory(c.Request.Context(), id, in)
	if err != nil {
		a.failure(c, err, "CONTENT_NOT_FOUND")
		return
	}
	c.JSON(200, v)
}
func (a *API) deleteHomebrewInventory(c *gin.Context) {
	id := c.Param("id")
	if !validID(id) {
		writeError(c, 400, "INVALID_REQUEST")
		return
	}
	if err := a.homebrew.DeleteInventory(c.Request.Context(), id); err != nil {
		a.failure(c, err, "CONTENT_NOT_FOUND")
		return
	}
	c.Status(204)
}
func (a *API) createHomebrewRitual(c *gin.Context) {
	var in domain.RitualInput
	if c.ShouldBindJSON(&in) != nil {
		writeError(c, 400, "INVALID_REQUEST")
		return
	}
	v, err := a.homebrew.CreateRitual(c.Request.Context(), in)
	if err != nil {
		a.failure(c, err, "CONTENT_NOT_FOUND")
		return
	}
	c.JSON(http.StatusCreated, v)
}
func (a *API) updateHomebrewRitual(c *gin.Context) {
	id := c.Param("id")
	if !validID(id) {
		writeError(c, 400, "INVALID_REQUEST")
		return
	}
	var in domain.RitualInput
	if c.ShouldBindJSON(&in) != nil {
		writeError(c, 400, "INVALID_REQUEST")
		return
	}
	v, err := a.homebrew.UpdateRitual(c.Request.Context(), id, in)
	if err != nil {
		a.failure(c, err, "CONTENT_NOT_FOUND")
		return
	}
	c.JSON(200, v)
}
func (a *API) deleteHomebrewRitual(c *gin.Context) {
	id := c.Param("id")
	if !validID(id) {
		writeError(c, 400, "INVALID_REQUEST")
		return
	}
	if err := a.homebrew.DeleteRitual(c.Request.Context(), id); err != nil {
		a.failure(c, err, "CONTENT_NOT_FOUND")
		return
	}
	c.Status(204)
}
func (a *API) createHomebrewAttack(c *gin.Context) {
	var in domain.AttackInput
	if c.ShouldBindJSON(&in) != nil {
		writeError(c, 400, "INVALID_REQUEST")
		return
	}
	v, err := a.homebrew.CreateAttack(c.Request.Context(), in)
	if err != nil {
		a.failure(c, err, "CONTENT_NOT_FOUND")
		return
	}
	c.JSON(http.StatusCreated, v)
}
func (a *API) updateHomebrewAttack(c *gin.Context) {
	id := c.Param("id")
	if !validID(id) {
		writeError(c, 400, "INVALID_REQUEST")
		return
	}
	var in domain.AttackInput
	if c.ShouldBindJSON(&in) != nil {
		writeError(c, 400, "INVALID_REQUEST")
		return
	}
	v, err := a.homebrew.UpdateAttack(c.Request.Context(), id, in)
	if err != nil {
		a.failure(c, err, "CONTENT_NOT_FOUND")
		return
	}
	c.JSON(200, v)
}
func (a *API) deleteHomebrewAttack(c *gin.Context) {
	id := c.Param("id")
	if !validID(id) {
		writeError(c, 400, "INVALID_REQUEST")
		return
	}
	if err := a.homebrew.DeleteAttack(c.Request.Context(), id); err != nil {
		a.failure(c, err, "CONTENT_NOT_FOUND")
		return
	}
	c.Status(204)
}
