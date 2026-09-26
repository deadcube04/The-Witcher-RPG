package httpserver

import (
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
	c.JSON(200, value)
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
	c.JSON(200, value)
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
	c.JSON(200, value)
}
