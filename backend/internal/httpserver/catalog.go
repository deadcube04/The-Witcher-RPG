package httpserver

import (
	"RPG-manager/backend/internal/apperr"
	"github.com/gin-gonic/gin"
)

func (a *API) inventoryCatalog(c *gin.Context) {
	query, kind := c.Query("query"), c.Query("kind")
	if len(query) > 100 || len(kind) > 30 {
		writeError(c, 400, "INVALID_REQUEST")
		return
	}
	value, err := a.catalog.Inventory(c.Request.Context(), query, kind)
	if err != nil {
		a.failure(c, err, "CONTENT_NOT_FOUND")
		return
	}
	supplementID, enabled, err := a.catalogAccess(c, "items")
	if err != nil {
		a.failure(c, err, "CHARACTER_NOT_FOUND")
		return
	}
	hidden, err := a.supplements.HiddenTargets(c.Request.Context(), supplementID, []string{"item", "item_detail"})
	if err != nil {
		a.failure(c, err, "CONTENT_NOT_FOUND")
		return
	}
	visible := value[:0]
	for _, item := range value {
		if item.SupplementID == nil || (enabled && *item.SupplementID == supplementID && !hidden[item.ID]) {
			visible = append(visible, item)
		}
	}
	c.JSON(200, visible)
}
func (a *API) ritualCatalog(c *gin.Context) {
	query, element := c.Query("query"), c.Query("element")
	if len(query) > 100 || len(element) > 30 {
		writeError(c, 400, "INVALID_REQUEST")
		return
	}
	value, err := a.catalog.Rituals(c.Request.Context(), query, element)
	if err != nil {
		a.failure(c, err, "CONTENT_NOT_FOUND")
		return
	}
	supplementID, enabled, err := a.catalogAccess(c, "rituals")
	if err != nil {
		a.failure(c, err, "CHARACTER_NOT_FOUND")
		return
	}
	hidden, err := a.supplements.HiddenTargets(c.Request.Context(), supplementID, []string{"ability", "ability_detail", "ritual"})
	if err != nil {
		a.failure(c, err, "CONTENT_NOT_FOUND")
		return
	}
	visible := value[:0]
	for _, item := range value {
		if item.SupplementID == nil || (enabled && *item.SupplementID == supplementID && !hidden[item.ID]) {
			visible = append(visible, item)
		}
	}
	c.JSON(200, visible)
}
func (a *API) catalogAccess(c *gin.Context, category string) (string, bool, error) {
	id := c.Query("characterId")
	if id == "" {
		return "", false, nil
	}
	if !validID(id) {
		return "", false, apperr.ErrInvalid
	}
	return a.characters.CatalogVisibility(c.Request.Context(), id, category)
}
func (a *API) attackCatalog(c *gin.Context) {
	query, source := c.Query("query"), c.Query("source")
	if len(query) > 100 || (source != "" && source != "all" && source != "official" && source != "homebrew" && source != "linked" && source != "independent") {
		writeError(c, 400, "INVALID_REQUEST")
		return
	}
	value, err := a.catalog.Attacks(c.Request.Context(), query, source)
	if err != nil {
		a.failure(c, err, "CONTENT_NOT_FOUND")
		return
	}
	supplementID, enabled, err := a.catalogAccess(c, "items")
	if err != nil {
		a.failure(c, err, "CHARACTER_NOT_FOUND")
		return
	}
	hidden, err := a.supplements.HiddenTargets(c.Request.Context(), supplementID, []string{"item", "item_detail"})
	if err != nil {
		a.failure(c, err, "CONTENT_NOT_FOUND")
		return
	}
	visible := value[:0]
	for _, attack := range value {
		if attack.SupplementID == nil || (enabled && *attack.SupplementID == supplementID && (attack.SourceItemDefinitionID == nil || !hidden[*attack.SourceItemDefinitionID])) {
			visible = append(visible, attack)
		}
	}
	c.JSON(200, visible)
}
