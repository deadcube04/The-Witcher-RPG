package httpapi

import (
	"crypto/rand"
	"encoding/hex"
	"errors"
	"log/slog"
	"net/http"
	"strings"
	"time"

	"RPG-manager/backend/internal/repository"

	"github.com/gin-contrib/cors"
	"github.com/gin-gonic/gin"
)

type API struct {
	store  *repository.Store
	logger *slog.Logger
}

func New(store *repository.Store, logger *slog.Logger, origins []string) (http.Handler, error) {
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
	r.Use(gin.Recovery(), requestLog(logger), localRequest(allow), bodyLimit(1<<20))
	r.Use(cors.New(cors.Config{AllowOrigins: keys(allow), AllowMethods: []string{"GET", "POST", "PATCH", "PUT", "DELETE", "OPTIONS"}, AllowHeaders: []string{"Accept", "Content-Type"}, MaxAge: 12 * time.Hour}))
	a := &API{store: store, logger: logger}
	r.GET("/api/health", func(c *gin.Context) { c.JSON(http.StatusOK, gin.H{"status": "ok"}) })
	r.GET("/api/ready", a.ready)
	v1 := r.Group("/api/v1")
	a.register(v1)
	return r, nil
}

func keys(m map[string]bool) []string {
	out := make([]string, 0, len(m))
	for k := range m {
		out = append(out, k)
	}
	return out
}

func requestLog(logger *slog.Logger) gin.HandlerFunc {
	return func(c *gin.Context) {
		b := make([]byte, 12)
		if _, err := rand.Read(b); err != nil {
			c.AbortWithStatus(http.StatusInternalServerError)
			return
		}
		id := hex.EncodeToString(b)
		c.Header("X-Request-ID", id)
		start := time.Now()
		c.Next()
		logger.Info("http request", "request_id", id, "method", c.Request.Method, "path", c.FullPath(), "status", c.Writer.Status(), "duration_ms", time.Since(start).Milliseconds())
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
