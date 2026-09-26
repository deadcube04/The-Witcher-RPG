package httpserver

import (
	"net/http"

	"github.com/gin-gonic/gin"
)

func (a *API) listInventory(c *gin.Context) {
	id := c.Param("id")
	if !validID(id) {
		writeError(c, 400, "INVALID_REQUEST")
		return
	}
	v, err := a.inventoryEntries.List(c.Request.Context(), id)
	if err != nil {
		a.failure(c, err, "CHARACTER_NOT_FOUND")
		return
	}
	c.JSON(200, v)
}
func (a *API) addInventory(c *gin.Context) {
	id := c.Param("id")
	if !validID(id) {
		writeError(c, 400, "INVALID_REQUEST")
		return
	}
	var in struct {
		DefinitionID string `json:"definitionId" binding:"required,uuid"`
		Quantity     int    `json:"quantity" binding:"required,min=1,max=999"`
	}
	if c.ShouldBindJSON(&in) != nil {
		writeError(c, 400, "INVALID_REQUEST")
		return
	}
	v, err := a.inventoryEntries.Add(c.Request.Context(), id, in.DefinitionID, in.Quantity)
	if err != nil {
		a.failure(c, err, "CONTENT_NOT_FOUND")
		return
	}
	c.JSON(http.StatusCreated, v)
}
func (a *API) updateInventory(c *gin.Context) {
	id, entryID := c.Param("id"), c.Param("entryId")
	if !validID(id) || !validID(entryID) {
		writeError(c, 400, "INVALID_REQUEST")
		return
	}
	var in struct {
		DefinitionID *string `json:"definitionId"`
		Quantity     *int    `json:"quantity"`
		Equipped     *bool   `json:"equipped"`
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
		fields["item_id"] = *in.DefinitionID
	}
	if in.Quantity != nil {
		if *in.Quantity < 1 || *in.Quantity > 999 {
			writeError(c, 400, "INVALID_REQUEST")
			return
		}
		fields["quantity"] = *in.Quantity
	}
	if in.Equipped != nil {
		fields["equipped"] = *in.Equipped
	}
	if in.Notes != nil {
		fields["notes"] = *in.Notes
	}
	v, err := a.inventoryEntries.Update(c.Request.Context(), id, entryID, fields)
	if err != nil {
		a.failure(c, err, "CONTENT_NOT_FOUND")
		return
	}
	c.JSON(200, v)
}
func (a *API) deleteInventory(c *gin.Context) {
	id, entryID := c.Param("id"), c.Param("entryId")
	if !validID(id) || !validID(entryID) {
		writeError(c, 400, "INVALID_REQUEST")
		return
	}
	err := a.inventoryEntries.Delete(c.Request.Context(), id, entryID, c.Query("attackPolicy"))
	if err != nil {
		a.failure(c, err, "CONTENT_NOT_FOUND")
		return
	}
	c.Status(204)
}
