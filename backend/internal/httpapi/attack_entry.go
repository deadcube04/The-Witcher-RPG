package httpapi

import (
	"RPG-manager/backend/internal/service"
	"bytes"
	"encoding/json"
	"net/http"

	"github.com/gin-gonic/gin"
)

func (a *API) listAttacks(c *gin.Context) {
	id := c.Param("id")
	if !validID(id) {
		writeError(c, 400, "INVALID_REQUEST")
		return
	}
	v, err := service.NewAttackEntries(a.store).List(c.Request.Context(), id)
	if err != nil {
		a.failure(c, err, "CHARACTER_NOT_FOUND")
		return
	}
	c.JSON(200, v)
}
func (a *API) addAttack(c *gin.Context) {
	id := c.Param("id")
	if !validID(id) {
		writeError(c, 400, "INVALID_REQUEST")
		return
	}
	var in struct {
		DefinitionID           string  `json:"definitionId" binding:"required,uuid"`
		SourceInventoryEntryID *string `json:"sourceInventoryEntryId"`
	}
	if c.ShouldBindJSON(&in) != nil || (in.SourceInventoryEntryID != nil && !validID(*in.SourceInventoryEntryID)) {
		writeError(c, 400, "INVALID_REQUEST")
		return
	}
	v, err := service.NewAttackEntries(a.store).Add(c.Request.Context(), id, in.DefinitionID, in.SourceInventoryEntryID)
	if err != nil {
		a.failure(c, err, "CONTENT_NOT_FOUND")
		return
	}
	c.JSON(http.StatusCreated, v)
}
func (a *API) addAttackFromInventory(c *gin.Context) {
	id := c.Param("id")
	if !validID(id) {
		writeError(c, 400, "INVALID_REQUEST")
		return
	}
	var in struct {
		InventoryEntryID string `json:"inventoryEntryId" binding:"required,uuid"`
	}
	if c.ShouldBindJSON(&in) != nil {
		writeError(c, 400, "INVALID_REQUEST")
		return
	}
	v, err := service.NewAttackEntries(a.store).AddFromInventory(c.Request.Context(), id, in.InventoryEntryID)
	if err != nil {
		a.failure(c, err, "CONTENT_NOT_FOUND")
		return
	}
	c.JSON(http.StatusCreated, v)
}
func (a *API) updateAttack(c *gin.Context) {
	id, entryID := c.Param("id"), c.Param("entryId")
	if !validID(id) || !validID(entryID) {
		writeError(c, 400, "INVALID_REQUEST")
		return
	}
	var in map[string]json.RawMessage
	if c.ShouldBindJSON(&in) != nil || len(in) == 0 {
		writeError(c, 400, "INVALID_REQUEST")
		return
	}
	fields := make(map[string]any)
	for key, raw := range in {
		if key == "sourceInventoryEntryId" && bytes.Equal(raw, []byte("null")) {
			fields["source_inventory_entry_id"] = nil
			continue
		}
		var value string
		if json.Unmarshal(raw, &value) != nil {
			writeError(c, 400, "INVALID_REQUEST")
			return
		}
		switch key {
		case "definitionId":
			if !validID(value) {
				writeError(c, 400, "INVALID_REQUEST")
				return
			}
			fields["definition_id"] = value
		case "sourceInventoryEntryId":
			if !validID(value) {
				writeError(c, 400, "INVALID_REQUEST")
				return
			}
			fields["source_inventory_entry_id"] = &value
		case "notes":
			fields["notes"] = value
		default:
			writeError(c, 400, "INVALID_REQUEST")
			return
		}
	}
	v, err := service.NewAttackEntries(a.store).Update(c.Request.Context(), id, entryID, fields)
	if err != nil {
		a.failure(c, err, "CONTENT_NOT_FOUND")
		return
	}
	c.JSON(200, v)
}
func (a *API) deleteAttack(c *gin.Context) {
	id, entryID := c.Param("id"), c.Param("entryId")
	if !validID(id) || !validID(entryID) {
		writeError(c, 400, "INVALID_REQUEST")
		return
	}
	if err := service.NewAttackEntries(a.store).Delete(c.Request.Context(), id, entryID); err != nil {
		a.failure(c, err, "CONTENT_NOT_FOUND")
		return
	}
	c.Status(204)
}
