package httpcommon

import (
	"errors"
	"fmt"
	"log/slog"
	"net/http"
	"regexp"

	"RPG-manager/backend/internal/apperr"
	"github.com/gin-gonic/gin"
	"gorm.io/gorm"
)

var idPattern = regexp.MustCompile(`^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$`)

func ValidID(id string) bool { return idPattern.MatchString(id) }

func WriteError(c *gin.Context, status int, code string) {
	c.JSON(status, gin.H{"error": gin.H{"code": code, "message": ErrorMessage(code)}})
}

func Failure(c *gin.Context, logger *slog.Logger, err error, missing string) {
	switch {
	case errors.Is(err, apperr.ErrNotFound):
		WriteError(c, http.StatusNotFound, missing)
	case errors.Is(err, apperr.ErrInvalid):
		WriteError(c, http.StatusBadRequest, "INVALID_REQUEST")
	case errors.Is(err, apperr.ErrPreview), errors.Is(err, apperr.ErrConflict), errors.Is(err, gorm.ErrDuplicatedKey):
		WriteError(c, http.StatusConflict, "CONFLICT")
	case errors.Is(err, apperr.ErrSystemMismatch):
		WriteError(c, http.StatusBadRequest, "SYSTEM_MISMATCH")
	case errors.Is(err, apperr.ErrInUse):
		WriteError(c, http.StatusConflict, "CONTENT_IN_USE")
	case errors.Is(err, apperr.ErrAlreadyAdded):
		WriteError(c, http.StatusConflict, "CONTENT_ALREADY_ADDED")
	default:
		logger.Error("request failed", "error_type", fmt.Sprintf("%T", err))
		WriteError(c, http.StatusInternalServerError, "INTERNAL_ERROR")
	}
}

func ErrorMessage(code string) string {
	switch code {
	case "INVALID_REQUEST":
		return "Confira os campos informados."
	case "USER_NOT_FOUND":
		return "Perfil não encontrado."
	case "CAMPAIGN_NOT_FOUND":
		return "Campanha não encontrada."
	case "CHARACTER_NOT_FOUND":
		return "Ficha não encontrada."
	case "RPG_SYSTEM_NOT_FOUND":
		return "Sistema não encontrado."
	case "SYSTEM_MISMATCH":
		return "A ficha e a campanha precisam usar o mesmo sistema."
	case "CONTENT_NOT_FOUND":
		return "Este conteúdo não está mais disponível."
	case "CONTENT_IN_USE":
		return "Este conteúdo ainda está em uso por uma ou mais fichas."
	case "CONTENT_ALREADY_ADDED":
		return "Este conteúdo já foi adicionado à ficha."
	default:
		return "Não foi possível concluir a operação."
	}
}
