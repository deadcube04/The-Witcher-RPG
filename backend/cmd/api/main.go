package main

import (
	"context"
	"database/sql"
	"errors"
	"fmt"
	"log/slog"
	"net/http"
	"os"
	"os/signal"
	"strings"
	"syscall"
	"time"

	"github.com/joho/godotenv"
	"gorm.io/driver/postgres"
	"gorm.io/gorm"

	"RPG-manager/backend/internal/account"
	"RPG-manager/backend/internal/campaigns"
	"RPG-manager/backend/internal/characters"
	"RPG-manager/backend/internal/content"
	"RPG-manager/backend/internal/dbscope"
	"RPG-manager/backend/internal/httpserver"
	"RPG-manager/backend/internal/localimport"
	"RPG-manager/backend/internal/observability"
	"RPG-manager/backend/internal/systems"
)

func main() {
	logger := slog.New(slog.NewJSONHandler(os.Stdout, nil))
	if err := run(logger); err != nil {
		logger.Error("api stopped", "error_type", fmt.Sprintf("%T", err))
		os.Exit(1)
	}
}

func run(logger *slog.Logger) error {
	if err := godotenv.Load(); err != nil && !errors.Is(err, os.ErrNotExist) {
		return err
	}
	url := os.Getenv("DATABASE_URL")
	userID := os.Getenv("LOCAL_USER_ID")
	addr := os.Getenv("HTTP_ADDR")
	if addr == "" {
		addr = "127.0.0.1:8080"
	}
	if url == "" || userID == "" || !strings.HasPrefix(addr, "127.0.0.1:") {
		return errors.New("DATABASE_URL, LOCAL_USER_ID and loopback HTTP_ADDR are required")
	}
	db, err := gorm.Open(postgres.Open(url), &gorm.Config{TranslateError: true, Logger: observability.NewGORMLogger(logger)})
	if err != nil {
		return errors.New("database connection failed")
	}
	sqlDB, err := db.DB()
	if err != nil {
		return err
	}
	defer func() { _ = sqlDB.Close() }()
	configurePool(sqlDB)
	ctx, stop := signal.NotifyContext(context.Background(), os.Interrupt, syscall.SIGTERM)
	defer stop()
	store := dbscope.New(db, userID)
	accountRepository := account.NewRepository(db, userID)
	if err := accountRepository.ValidateLocalUser(ctx); err != nil {
		return err
	}
	systemService := systems.NewService(systems.NewRepository(db))
	accountService := account.NewService(accountRepository, systemService)
	campaignService := campaigns.NewService(campaigns.NewRepository(db, userID), systemService)
	characterService := characters.NewCharacter(store)
	skillService := characters.NewSkills(store)
	inventoryEntries := characters.NewInventoryEntries(store)
	ritualEntries := characters.NewRitualEntries(store)
	attackEntries := characters.NewAttackEntries(store)
	catalogService := content.NewCatalog(store)
	homebrewService := content.NewHomebrew(store)
	importService := localimport.NewImporter(store)
	errorRepository := observability.NewGORMRepository(db)
	errorService := observability.NewService(errorRepository)
	if _, err := errorService.CleanupExpired(ctx, 500); err != nil {
		logger.Error("expired error cleanup failed", "error_type", "database")
	}
	maintenanceCtx, stopMaintenance := context.WithCancel(ctx)
	var maintenanceDone = make(chan struct{})
	go func() {
		defer close(maintenanceDone)
		cleanupTicker := time.NewTicker(time.Hour)
		defer cleanupTicker.Stop()
		for {
			select {
			case <-maintenanceCtx.Done():
				return
			case <-cleanupTicker.C:
				if _, err := errorService.CleanupExpired(maintenanceCtx, 500); err != nil && maintenanceCtx.Err() == nil {
					logger.Error("expired error cleanup failed", "error_type", "database")
				}
			}
		}
	}()
	defer func() { stopMaintenance(); <-maintenanceDone }()
	origins := strings.Split(os.Getenv("CORS_ALLOWED_ORIGINS"), ",")
	handler, err := httpserver.New(httpserver.Dependencies{
		Store: store, Logger: logger, Account: accountService, Errors: errorService, UserID: userID, Systems: systemService, Campaigns: campaignService,
		Characters: characterService, Skills: skillService, InventoryEntries: inventoryEntries,
		RitualEntries: ritualEntries, AttackEntries: attackEntries, Catalog: catalogService,
		Homebrew: homebrewService, Importer: importService,
	}, origins)
	if err != nil {
		return err
	}
	server := &http.Server{
		Addr: addr, Handler: handler,
		ReadHeaderTimeout: 5 * time.Second,
		ReadTimeout:       15 * time.Second,
		WriteTimeout:      30 * time.Second,
		IdleTimeout:       60 * time.Second,
		MaxHeaderBytes:    1 << 20,
	}
	serverErr := make(chan error, 1)
	go func() { serverErr <- server.ListenAndServe() }()
	logger.Info("api listening", "address", addr)
	select {
	case err := <-serverErr:
		if errors.Is(err, http.ErrServerClosed) {
			return nil
		}
		return err
	case <-ctx.Done():
		shutdownCtx, cancel := context.WithTimeout(context.Background(), 10*time.Second)
		defer cancel()
		return server.Shutdown(shutdownCtx)
	}
}

func configurePool(db *sql.DB) {
	db.SetMaxOpenConns(10)
	db.SetMaxIdleConns(5)
	db.SetConnMaxLifetime(30 * time.Minute)
	db.SetConnMaxIdleTime(5 * time.Minute)
}
