package httpserver

import (
	"net/http"
	"strconv"

	"RPG-manager/backend/internal/bestiary"

	"github.com/gin-gonic/gin"
)

func (a *API) bestiaryOptions(c *gin.Context) {
	value, err := a.bestiary.Options(c.Request.Context())
	if err != nil {
		a.failure(c, err, "CONTENT_NOT_FOUND")
		return
	}
	c.JSON(http.StatusOK, value)
}

func (a *API) listBestiary(c *gin.Context) {
	filter, ok := parseBestiaryFilters(c, true)
	if !ok {
		return
	}
	value, err := a.bestiary.List(c.Request.Context(), filter)
	if err != nil {
		a.failure(c, err, "CONTENT_NOT_FOUND")
		return
	}
	c.JSON(http.StatusOK, value)
}

func (a *API) getBestiaryEntry(c *gin.Context) {
	id := c.Param("id")
	if !validID(id) {
		writeError(c, http.StatusBadRequest, "INVALID_REQUEST")
		return
	}
	filter, ok := parseBestiaryFilters(c, false)
	if !ok {
		return
	}
	value, err := a.bestiary.Get(c.Request.Context(), id, filter)
	if err != nil {
		a.failure(c, err, "CONTENT_NOT_FOUND")
		return
	}
	c.JSON(http.StatusOK, value)
}

func parseBestiaryFilters(c *gin.Context, pagination bool) (bestiary.Filters, bool) {
	query := c.Query("query")
	if len(query) > 100 {
		writeError(c, http.StatusBadRequest, "INVALID_REQUEST")
		return bestiary.Filters{}, false
	}
	filter := bestiary.Filters{Query: query, Sort: c.DefaultQuery("sort", "name"), Page: 1, PageSize: bestiary.PageSize}
	if filter.Sort != "name" && filter.Sort != "vd-asc" && filter.Sort != "vd-desc" && filter.Sort != "relevance" {
		writeError(c, http.StatusBadRequest, "INVALID_REQUEST")
		return bestiary.Filters{}, false
	}
	filter.ElementID = c.Query("elementId")
	filter.BeingTypeID = c.Query("beingTypeId")
	filter.SizeID = c.Query("sizeId")
	if (filter.ElementID != "" && filter.ElementID != "none" && !validID(filter.ElementID)) ||
		(filter.BeingTypeID != "" && !validID(filter.BeingTypeID)) ||
		(filter.SizeID != "" && !validID(filter.SizeID)) {
		writeError(c, http.StatusBadRequest, "INVALID_REQUEST")
		return bestiary.Filters{}, false
	}
	var ok bool
	if filter.VDMin, ok = parseBestiaryInteger(c, "vdMin"); !ok {
		return bestiary.Filters{}, false
	}
	if filter.VDMax, ok = parseBestiaryInteger(c, "vdMax"); !ok {
		return bestiary.Filters{}, false
	}
	if filter.VDMin != nil && filter.VDMax != nil && *filter.VDMin > *filter.VDMax {
		writeError(c, http.StatusBadRequest, "INVALID_REQUEST")
		return bestiary.Filters{}, false
	}
	if pagination {
		if filter.Page, ok = parsePositiveQueryInt(c, "page", 1); !ok {
			return bestiary.Filters{}, false
		}
		if filter.Page > bestiary.MaxPageNumber {
			writeError(c, http.StatusBadRequest, "INVALID_REQUEST")
			return bestiary.Filters{}, false
		}
		if filter.PageSize, ok = parsePositiveQueryInt(c, "pageSize", bestiary.PageSize); !ok || filter.PageSize > bestiary.MaxPageSize {
			writeError(c, http.StatusBadRequest, "INVALID_REQUEST")
			return bestiary.Filters{}, false
		}
	}
	return filter, true
}

func parsePositiveQueryInt(c *gin.Context, key string, fallback int) (int, bool) {
	value := c.Query(key)
	if value == "" {
		return fallback, true
	}
	parsed, err := strconv.Atoi(value)
	if err != nil || parsed < 1 {
		writeError(c, http.StatusBadRequest, "INVALID_REQUEST")
		return 0, false
	}
	return parsed, true
}

func parseBestiaryInteger(c *gin.Context, key string) (*int, bool) {
	value := c.Query(key)
	if value == "" {
		return nil, true
	}
	parsed, err := strconv.Atoi(value)
	if err != nil || parsed < 0 || parsed > 100000 {
		writeError(c, http.StatusBadRequest, "INVALID_REQUEST")
		return nil, false
	}
	return &parsed, true
}
