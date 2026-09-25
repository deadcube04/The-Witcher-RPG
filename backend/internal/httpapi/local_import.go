package httpapi

import (
	"RPG-manager/backend/internal/domain"
	"RPG-manager/backend/internal/service"
	"net/http"

	"github.com/gin-gonic/gin"
)

func importRequest(c *gin.Context) (domain.ImportRequest, bool) {
	var in domain.ImportRequest
	if c.ShouldBindJSON(&in) != nil || len(in.Items) > 500 {
		writeError(c, 400, "INVALID_REQUEST")
		return in, false
	}
	for _, item := range in.Items {
		if !validID(item.SourceID) {
			writeError(c, 400, "INVALID_REQUEST")
			return in, false
		}
	}
	return in, true
}
func (a *API) previewImport(c *gin.Context) {
	in, ok := importRequest(c)
	if !ok {
		return
	}
	v, err := service.NewImporter(a.store).Preview(c.Request.Context(), in)
	if err != nil {
		a.failure(c, err, "CONTENT_NOT_FOUND")
		return
	}
	c.JSON(http.StatusOK, v)
}
func (a *API) applyImport(c *gin.Context) {
	in, ok := importRequest(c)
	if !ok {
		return
	}
	v, err := service.NewImporter(a.store).Apply(c.Request.Context(), in)
	if err != nil {
		if len(v.Issues) > 0 {
			c.JSON(http.StatusConflict, v)
			return
		}
		a.failure(c, err, "CONTENT_NOT_FOUND")
		return
	}
	c.JSON(http.StatusOK, v)
}
