package httpserver

import (
	"errors"
	"net/http"
	"strconv"
	"time"

	"RPG-manager/backend/internal/observability"
	"github.com/gin-gonic/gin"
)

func (a *API) adminRequired(c *gin.Context) {
	allowed, err := a.account.IsAdmin(c.Request.Context())
	if err != nil {
		requestID, _ := c.Get("request_id")
		a.logger.Error("admin role lookup failed", "request_id", requestID, "error_type", "database")
		writeError(c, http.StatusInternalServerError, "INTERNAL_ERROR")
		c.Abort()
		return
	}
	if !allowed {
		writeError(c, http.StatusForbidden, "FORBIDDEN")
		c.Abort()
		return
	}
	c.Next()
}

func (a *API) registerErrorAdmin(r *gin.RouterGroup) {
	r.GET("/groups", a.listErrorGroups)
	r.GET("/occurrences", a.listErrorOccurrences)
	r.GET("/occurrences/:id", a.getErrorOccurrence)
	r.PATCH("/groups/:id", a.updateErrorGroup)
	r.PATCH("/occurrences", a.updateErrorOccurrences)
	r.DELETE("/occurrences", a.deleteErrorOccurrences)
	r.GET("/retention", a.getErrorRetention)
	r.PUT("/retention", a.putErrorRetention)
}

func errorFilter(c *gin.Context) (observability.Filter, bool) {
	filter := observability.Filter{}
	var err error
	if raw := c.Query("page"); raw != "" {
		filter.Page, err = strconv.Atoi(raw)
		if err != nil || filter.Page < 1 {
			writeError(c, http.StatusBadRequest, "INVALID_REQUEST")
			return filter, false
		}
	}
	if raw := c.Query("status"); raw != "" {
		filter.Status, err = strconv.Atoi(raw)
		if err != nil || filter.Status < 400 || filter.Status > 599 {
			writeError(c, http.StatusBadRequest, "INVALID_REQUEST")
			return filter, false
		}
	}
	filter.State = c.Query("state")
	if filter.State != "" && filter.State != "open" && filter.State != "resolved" {
		writeError(c, http.StatusBadRequest, "INVALID_REQUEST")
		return filter, false
	}
	filter.Route, filter.RequestID = c.Query("route"), c.Query("requestId")
	if len(filter.Route) > 200 || len(filter.RequestID) > 64 {
		writeError(c, http.StatusBadRequest, "INVALID_REQUEST")
		return filter, false
	}
	if raw := c.Query("since"); raw != "" {
		parsed, parseErr := time.Parse(time.RFC3339, raw)
		if parseErr != nil {
			writeError(c, http.StatusBadRequest, "INVALID_REQUEST")
			return filter, false
		}
		filter.Since = &parsed
	}
	if raw := c.Query("until"); raw != "" {
		parsed, parseErr := time.Parse(time.RFC3339, raw)
		if parseErr != nil {
			writeError(c, http.StatusBadRequest, "INVALID_REQUEST")
			return filter, false
		}
		filter.Until = &parsed
	}
	return filter, true
}

func (a *API) listErrorGroups(c *gin.Context) {
	filter, ok := errorFilter(c)
	if !ok {
		return
	}
	page, err := a.errors.Groups(c.Request.Context(), filter)
	if err != nil {
		a.failure(c, err, "ERROR_LOG_NOT_FOUND")
		return
	}
	c.JSON(http.StatusOK, page)
}

func (a *API) listErrorOccurrences(c *gin.Context) {
	filter, ok := errorFilter(c)
	if !ok {
		return
	}
	page, err := a.errors.Occurrences(c.Request.Context(), filter)
	if err != nil {
		a.failure(c, err, "ERROR_LOG_NOT_FOUND")
		return
	}
	c.JSON(http.StatusOK, page)
}

func (a *API) getErrorOccurrence(c *gin.Context) {
	id := c.Param("id")
	if !validID(id) {
		writeError(c, http.StatusBadRequest, "INVALID_REQUEST")
		return
	}
	item, err := a.errors.Occurrence(c.Request.Context(), id)
	if errors.Is(err, observability.ErrNotFound) {
		writeError(c, http.StatusNotFound, "ERROR_LOG_NOT_FOUND")
		return
	}
	if err != nil {
		a.failure(c, err, "ERROR_LOG_NOT_FOUND")
		return
	}
	c.JSON(http.StatusOK, item)
}

func (a *API) updateErrorGroup(c *gin.Context) {
	id := c.Param("id")
	if !validID(id) {
		writeError(c, http.StatusBadRequest, "INVALID_REQUEST")
		return
	}
	var body struct {
		State string `json:"state"`
	}
	if c.ShouldBindJSON(&body) != nil || (body.State != "open" && body.State != "resolved") {
		writeError(c, http.StatusBadRequest, "INVALID_REQUEST")
		return
	}
	err := a.errors.SetGroupState(c.Request.Context(), id, body.State)
	if errors.Is(err, observability.ErrNotFound) {
		writeError(c, http.StatusNotFound, "ERROR_LOG_NOT_FOUND")
		return
	}
	if err != nil {
		a.failure(c, err, "ERROR_LOG_NOT_FOUND")
		return
	}
	c.Status(http.StatusNoContent)
}

type occurrenceMutation struct {
	IDs       []string   `json:"ids" binding:"required,min=1,max=100,dive,uuid"`
	ExpiresAt *time.Time `json:"expiresAt"`
}

func (a *API) updateErrorOccurrences(c *gin.Context) {
	var body occurrenceMutation
	if c.ShouldBindJSON(&body) != nil {
		writeError(c, http.StatusBadRequest, "INVALID_REQUEST")
		return
	}
	if duplicateIDs(body.IDs) {
		writeError(c, http.StatusBadRequest, "INVALID_REQUEST")
		return
	}
	if err := a.errors.UpdateOccurrences(c.Request.Context(), observability.OccurrenceUpdate{IDs: body.IDs, ExpiresAt: body.ExpiresAt}); err != nil {
		if errors.Is(err, observability.ErrNotFound) {
			writeError(c, http.StatusNotFound, "ERROR_LOG_NOT_FOUND")
			return
		}
		a.failure(c, err, "ERROR_LOG_NOT_FOUND")
		return
	}
	c.Status(http.StatusNoContent)
}

func (a *API) deleteErrorOccurrences(c *gin.Context) {
	var body occurrenceMutation
	if c.ShouldBindJSON(&body) != nil {
		writeError(c, http.StatusBadRequest, "INVALID_REQUEST")
		return
	}
	if duplicateIDs(body.IDs) {
		writeError(c, http.StatusBadRequest, "INVALID_REQUEST")
		return
	}
	if err := a.errors.UpdateOccurrences(c.Request.Context(), observability.OccurrenceUpdate{IDs: body.IDs, Delete: true}); err != nil {
		if errors.Is(err, observability.ErrNotFound) {
			writeError(c, http.StatusNotFound, "ERROR_LOG_NOT_FOUND")
			return
		}
		a.failure(c, err, "ERROR_LOG_NOT_FOUND")
		return
	}
	c.Status(http.StatusNoContent)
}

func duplicateIDs(ids []string) bool {
	seen := make(map[string]struct{}, len(ids))
	for _, id := range ids {
		if _, exists := seen[id]; exists {
			return true
		}
		seen[id] = struct{}{}
	}
	return false
}

func (a *API) getErrorRetention(c *gin.Context) {
	rules, err := a.errors.RetentionRules(c.Request.Context())
	if err != nil {
		a.failure(c, err, "ERROR_LOG_NOT_FOUND")
		return
	}
	c.JSON(http.StatusOK, gin.H{"rules": rules})
}

func (a *API) putErrorRetention(c *gin.Context) {
	var body struct {
		Rules []observability.RetentionRule `json:"rules" binding:"required,min=3,max=3,dive"`
	}
	if c.ShouldBindJSON(&body) != nil {
		writeError(c, http.StatusBadRequest, "INVALID_REQUEST")
		return
	}
	if err := a.errors.UpdateRetentionRules(c.Request.Context(), body.Rules); err != nil {
		writeError(c, http.StatusBadRequest, "INVALID_REQUEST")
		return
	}
	c.Status(http.StatusNoContent)
}
