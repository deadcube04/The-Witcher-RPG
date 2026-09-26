package httpserver

import (
	"RPG-manager/backend/internal/domain"

	"github.com/gin-gonic/gin"
)

func (a *API) listSkills(c *gin.Context) {
	id := c.Param("id")
	if !validID(id) {
		writeError(c, 400, "INVALID_REQUEST")
		return
	}
	value, err := a.skills.List(c.Request.Context(), id)
	if err != nil {
		a.failure(c, err, "CHARACTER_NOT_FOUND")
		return
	}
	c.JSON(200, value)
}
func (a *API) updateSkills(c *gin.Context) {
	id := c.Param("id")
	if !validID(id) {
		writeError(c, 400, "INVALID_REQUEST")
		return
	}
	var updates []domain.SkillUpdate
	if c.ShouldBindJSON(&updates) != nil || len(updates) > 28 {
		writeError(c, 400, "INVALID_REQUEST")
		return
	}
	for _, u := range updates {
		if !validID(u.ID) || !validID(u.AttributeID) || (u.TrainingLevelID != nil && !validID(*u.TrainingLevelID)) {
			writeError(c, 400, "INVALID_REQUEST")
			return
		}
	}
	value, err := a.skills.Update(c.Request.Context(), id, updates)
	if err != nil {
		a.failure(c, err, "CONTENT_NOT_FOUND")
		return
	}
	c.JSON(200, value)
}
