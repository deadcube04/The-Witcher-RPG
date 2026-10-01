package httpserver

import (
	"errors"
	"net/http"

	"RPG-manager/backend/internal/domain"
	"RPG-manager/backend/internal/supplements"
	"github.com/gin-gonic/gin"
)

func (a *API) listSupplements(c *gin.Context) {
	items, err := a.supplements.Catalog(c.Request.Context())
	if err != nil {
		a.failure(c, err, "CONTENT_NOT_FOUND")
		return
	}
	c.JSON(http.StatusOK, items)
}

func (a *API) patchCampaignSettings(c *gin.Context) {
	id := c.Param("id")
	if !validID(id) {
		writeError(c, http.StatusBadRequest, "INVALID_REQUEST")
		return
	}
	var settings domain.CampaignSettings
	if c.ShouldBindJSON(&settings) != nil {
		writeError(c, http.StatusBadRequest, "INVALID_REQUEST")
		return
	}
	item, err := a.campaigns.UpdateSettings(c.Request.Context(), id, settings)
	if err != nil {
		a.failure(c, err, "CAMPAIGN_NOT_FOUND")
		return
	}
	c.JSON(http.StatusOK, item)
}

func (a *API) registerSupplementAdmin(r *gin.RouterGroup) {
	r.GET("/:id/issues", a.listSupplementIssues)
	r.GET("/:id/issues/:issueId/candidates", a.supplementIssueCandidates)
	r.GET("/:id/issues/:issueId/source", a.supplementIssueSource)
	r.GET("/:id/targets/:kind/:targetId", a.supplementTargetValue)
	r.POST("/:id/issues/:issueId/resolve", a.resolveSupplementIssue)
	r.PUT("/:id/issues/:issueId/target", a.linkSupplementIssue)
}

func (a *API) supplementIssueSource(c *gin.Context) {
	id, issueID := c.Param("id"), c.Param("issueId")
	if !validID(id) || !validID(issueID) {
		writeError(c, http.StatusBadRequest, "INVALID_REQUEST")
		return
	}
	value, err := a.supplements.IssueSource(c.Request.Context(), id, issueID)
	if err != nil {
		a.failure(c, err, "CONTENT_NOT_FOUND")
		return
	}
	c.JSON(http.StatusOK, value)
}

func (a *API) linkSupplementIssue(c *gin.Context) {
	id, issueID := c.Param("id"), c.Param("issueId")
	if !validID(id) || !validID(issueID) {
		writeError(c, http.StatusBadRequest, "INVALID_REQUEST")
		return
	}
	var input struct {
		TargetKind string `json:"targetKind" binding:"required"`
		TargetID   string `json:"targetId" binding:"required,uuid"`
		FieldName  string `json:"fieldName" binding:"required"`
	}
	if c.ShouldBindJSON(&input) != nil {
		writeError(c, http.StatusBadRequest, "INVALID_REQUEST")
		return
	}
	if err := a.supplements.LinkTarget(c.Request.Context(), id, issueID, input.TargetKind, input.TargetID, input.FieldName); err != nil {
		a.failure(c, err, "CONTENT_NOT_FOUND")
		return
	}
	c.Status(http.StatusNoContent)
}

func (a *API) supplementTargetValue(c *gin.Context) {
	id, targetID := c.Param("id"), c.Param("targetId")
	if !validID(id) || !validID(targetID) {
		writeError(c, http.StatusBadRequest, "INVALID_REQUEST")
		return
	}
	value, err := a.supplements.CurrentValue(c.Request.Context(), id, c.Param("kind"), targetID, c.Query("field"))
	if err != nil {
		a.failure(c, err, "CONTENT_NOT_FOUND")
		return
	}
	c.JSON(http.StatusOK, gin.H{"value": value})
}

func (a *API) listSupplementIssues(c *gin.Context) {
	id := c.Param("id")
	if !validID(id) {
		writeError(c, http.StatusBadRequest, "INVALID_REQUEST")
		return
	}
	items, err := a.supplements.Issues(c.Request.Context(), id, c.Query("state"))
	if err != nil {
		a.failure(c, err, "CONTENT_NOT_FOUND")
		return
	}
	c.JSON(http.StatusOK, items)
}

func (a *API) supplementIssueCandidates(c *gin.Context) {
	id, issueID := c.Param("id"), c.Param("issueId")
	if !validID(id) || !validID(issueID) {
		writeError(c, http.StatusBadRequest, "INVALID_REQUEST")
		return
	}
	items, err := a.supplements.Candidates(c.Request.Context(), id, issueID)
	if err != nil {
		a.failure(c, err, "CONTENT_NOT_FOUND")
		return
	}
	c.JSON(http.StatusOK, items)
}

func (a *API) resolveSupplementIssue(c *gin.Context) {
	id, issueID := c.Param("id"), c.Param("issueId")
	if !validID(id) || !validID(issueID) {
		writeError(c, http.StatusBadRequest, "INVALID_REQUEST")
		return
	}
	var change supplements.Correction
	if c.ShouldBindJSON(&change) != nil {
		writeError(c, http.StatusBadRequest, "INVALID_REQUEST")
		return
	}
	err := a.supplements.Resolve(c.Request.Context(), id, issueID, change)
	if errors.Is(err, supplements.ErrIssueResolved) || errors.Is(err, supplements.ErrValueChanged) {
		writeError(c, http.StatusConflict, "CONFLICT")
		return
	}
	if err != nil {
		a.failure(c, err, "CONTENT_NOT_FOUND")
		return
	}
	c.Status(http.StatusNoContent)
}
