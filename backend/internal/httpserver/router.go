package httpserver

import (
	"crypto/rand"
	"encoding/hex"
	"errors"
	"fmt"
	"log/slog"
	"net/http"
	"runtime/debug"
	"strings"
	"time"

	"RPG-manager/backend/internal/account"
	"RPG-manager/backend/internal/campaigns"
	"RPG-manager/backend/internal/characters"
	"RPG-manager/backend/internal/content"
	"RPG-manager/backend/internal/dbscope"
	"RPG-manager/backend/internal/localimport"
	"RPG-manager/backend/internal/observability"
	"RPG-manager/backend/internal/systems"

	"github.com/gin-contrib/cors"
	"github.com/gin-gonic/gin"
)

type API struct {
	store            *dbscope.Scope
	logger           *slog.Logger
	account          *account.Service
	systems          *systems.Service
	campaigns        *campaigns.Service
	characters       *characters.Character
	skills           *characters.Skills
	inventoryEntries *characters.InventoryEntries
	ritualEntries    *characters.RitualEntries
	attackEntries    *characters.AttackEntries
	catalog          *content.Catalog
	homebrew         *content.Homebrew
	importer         *localimport.Importer
	errors           *observability.Service
	userID           string
}

type Dependencies struct {
	Store            *dbscope.Scope
	Logger           *slog.Logger
	Account          *account.Service
	Systems          *systems.Service
	Campaigns        *campaigns.Service
	Characters       *characters.Character
	Skills           *characters.Skills
	InventoryEntries *characters.InventoryEntries
	RitualEntries    *characters.RitualEntries
	AttackEntries    *characters.AttackEntries
	Catalog          *content.Catalog
	Homebrew         *content.Homebrew
	Importer         *localimport.Importer
	Errors           *observability.Service
	UserID           string
}

func New(deps Dependencies, origins []string) (http.Handler, error) {
	store, logger := deps.Store, deps.Logger
	if logger == nil || deps.Errors == nil {
		return nil, errors.New("logger and error observability service are required")
	}
	allow := make(map[string]bool)
	for _, raw := range origins {
		origin := strings.TrimSpace(raw)
		if origin == "" {
			continue
		}
		if !strings.HasPrefix(origin, "http://localhost:") && !strings.HasPrefix(origin, "http://127.0.0.1:") {
			return nil, errors.New("CORS origin must be local HTTP")
		}
		allow[origin] = true
	}
	if len(allow) == 0 {
		return nil, errors.New("CORS_ALLOWED_ORIGINS is required")
	}
	gin.SetMode(gin.ReleaseMode)
	gin.EnableJsonDecoderDisallowUnknownFields()
	r := gin.New()
	if err := r.SetTrustedProxies(nil); err != nil {
		return nil, err
	}
	r.Use(bodyLimit(1<<20), requestLog(logger, deps.Errors, deps.UserID), gin.CustomRecovery(recoverRequest(logger)), localRequest(allow))
	r.Use(cors.New(cors.Config{AllowOrigins: keys(allow), AllowMethods: []string{"GET", "POST", "PATCH", "PUT", "DELETE", "OPTIONS"}, AllowHeaders: []string{"Accept", "Content-Type", "X-Request-ID"}, ExposeHeaders: []string{"X-Request-ID"}, MaxAge: 12 * time.Hour}))
	a := &API{store: store, logger: logger, account: deps.Account, systems: deps.Systems, campaigns: deps.Campaigns, characters: deps.Characters, skills: deps.Skills, inventoryEntries: deps.InventoryEntries, ritualEntries: deps.RitualEntries, attackEntries: deps.AttackEntries, catalog: deps.Catalog, homebrew: deps.Homebrew, importer: deps.Importer, errors: deps.Errors, userID: deps.UserID}
	r.GET("/api/health", func(c *gin.Context) { c.JSON(http.StatusOK, gin.H{"status": "ok"}) })
	r.GET("/api/ready", a.ready)
	v1 := r.Group("/api/v1")
	a.register(v1)
	a.registerErrorAdmin(v1.Group("/admin/errors", a.adminRequired))
	return r, nil
}

func keys(m map[string]bool) []string {
	out := make([]string, 0, len(m))
	for k := range m {
		out = append(out, k)
	}
	return out
}

func requestLog(logger *slog.Logger, service *observability.Service, userID string) gin.HandlerFunc {
	return func(c *gin.Context) {
		b := make([]byte, 12)
		if _, err := rand.Read(b); err != nil {
			c.AbortWithStatus(http.StatusInternalServerError)
			return
		}
		id := hex.EncodeToString(b)
		c.Set("request_id", id)
		c.Header("X-Request-ID", id)
		start := time.Now()
		requestHeaders := safeRequestHeaders(c.Request.Header)
		bodyCapture := &requestBodyCapture{ReadCloser: c.Request.Body}
		c.Request.Body = bodyCapture
		writer := &captureWriter{ResponseWriter: c.Writer}
		c.Writer = writer
		c.Next()
		status := c.Writer.Status()
		route := c.FullPath()
		if route == "" {
			route = "[unmatched]"
		}
		level := slog.LevelInfo
		if status >= 400 && status < 500 {
			level = slog.LevelWarn
		} else if status >= 500 {
			level = slog.LevelError
		}
		attrs := []any{"request_id", id, "method", c.Request.Method, "route", route, "status", status, "duration_ms", time.Since(start).Milliseconds()}
		logger.Log(c.Request.Context(), level, "http request", attrs...)
		if status < 400 {
			return
		}
		requestBody, requestBodyErr := captureJSONBytes(bodyCapture.body.Bytes(), bodyCapture.truncated)
		responseBody, responseBodyErr := captureJSONBytes(writer.body.Bytes(), writer.truncated)
		code := responseErrorCode(responseBody, status)
		failureKind, message, panicStack := failureDetails(c, status)
		if requestBodyErr != nil {
			requestBody = omittedBody(requestBodyErr.Error())
		}
		if responseBodyErr != nil {
			responseBody = omittedBody(responseBodyErr.Error())
		}
		input := observability.OccurrenceInput{
			RequestID: id, UserID: userID, Method: c.Request.Method, Route: route,
			Status: status, ErrorCode: code, FailureKind: failureKind, ErrorMessage: message,
			PanicStack: panicStack, RequestHeaders: requestHeaders,
			ResponseHeaders: safeResponseHeaders(c.Writer.Header()), RequestBody: requestBody, ResponseBody: responseBody,
		}
		if err := service.Record(c.Request.Context(), input); err != nil {
			logger.Error("http error persistence failed", "request_id", id, "status", status, "error_type", fmt.Sprintf("%T", err))
		}
	}
}

func recoverRequest(logger *slog.Logger) gin.RecoveryFunc {
	return func(c *gin.Context, recovered any) {
		stack := debug.Stack()
		c.Set("panic_stack", string(stack))
		c.Set("failure_kind", "panic")
		c.Set("failure_message", fmt.Sprintf("panic (%T)", recovered))
		requestID, _ := c.Get("request_id")
		logger.Error("http panic recovered", "request_id", requestID, "route", c.FullPath(), "panic_type", fmt.Sprintf("%T", recovered), "stack", string(stack))
		c.AbortWithStatusJSON(http.StatusInternalServerError, gin.H{"error": gin.H{"code": "INTERNAL_ERROR", "message": errorMessage("INTERNAL_ERROR")}})
	}
}

func localRequest(allowed map[string]bool) gin.HandlerFunc {
	return func(c *gin.Context) {
		host := c.Request.Host
		if !strings.HasPrefix(host, "127.0.0.1:") && !strings.HasPrefix(host, "localhost:") {
			writeError(c, http.StatusBadRequest, "INVALID_REQUEST")
			c.Abort()
			return
		}
		origin := c.GetHeader("Origin")
		if origin != "" && !allowed[origin] {
			writeError(c, http.StatusForbidden, "INVALID_REQUEST")
			c.Abort()
			return
		}
		c.Next()
	}
}

func bodyLimit(n int64) gin.HandlerFunc {
	return func(c *gin.Context) { c.Request.Body = http.MaxBytesReader(c.Writer, c.Request.Body, n); c.Next() }
}

func writeError(c *gin.Context, status int, code string) {
	c.JSON(status, gin.H{"error": gin.H{"code": code, "message": errorMessage(code)}})
}

func errorMessage(code string) string {
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
	case "CONFLICT":
		return "Esta alteração conflita com os dados existentes."
	case "FORBIDDEN":
		return "Você não tem permissão para acessar esta área."
	case "ERROR_LOG_NOT_FOUND":
		return "Este registro de erro não está mais disponível."
	default:
		return "Não foi possível concluir a operação."
	}
}

func (a *API) ready(c *gin.Context) {
	ctx := c.Request.Context()
	var n int
	if err := a.store.DB.WithContext(ctx).Raw("SELECT 1").Scan(&n).Error; err != nil {
		writeError(c, http.StatusServiceUnavailable, "INTERNAL_ERROR")
		return
	}
	c.JSON(http.StatusOK, gin.H{"status": "ready"})
}
