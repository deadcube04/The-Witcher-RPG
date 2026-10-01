package httpserver

import "github.com/gin-gonic/gin"

func (a *API) supplementReference(c *gin.Context) {
	id := c.Param("id")
	if !validID(id) {
		writeError(c, 400, "INVALID_REQUEST")
		return
	}
	value, err := a.supplements.Reference(c.Request.Context(), id)
	if err != nil {
		a.failure(c, err, "CHARACTER_NOT_FOUND")
		return
	}
	c.JSON(200, value)
}
