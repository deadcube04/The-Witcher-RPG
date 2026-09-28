package main

import (
	"RPG-manager/backend/internal/bestiaryimport"
	"RPG-manager/backend/internal/media"
	"context"
	"errors"
	"flag"
	"fmt"
	"os"
	"os/signal"
	"path/filepath"
	"syscall"

	"github.com/joho/godotenv"
	"gorm.io/driver/postgres"
	"gorm.io/gorm"
	"gorm.io/gorm/logger"
)

func main() {
	if err := run(); err != nil {
		fmt.Fprintln(os.Stderr, err)
		os.Exit(1)
	}
}
func run() error {
	mode := flag.String("mode", "collect", "collect, review, apply or report")
	dir := flag.String("dir", "../local/bestiary-import", "collection directory")
	report := flag.String("report", "../docs/importacoes/bestiario-criaturas-ausentes.md", "absence report")
	backups := flag.String("backups", "../local/backups", "ZIP directory")
	entry := flag.String("entry", "", "exact article name or URL for review")
	decision := flag.String("decision", "", "match, absent or skip")
	id := flag.String("id", "", "confirmed threat UUID for match")
	description := flag.String("description", "", "reviewed descriptive summary")
	evidence := flag.String("evidence", "", "evidence supporting the decision")
	flag.Parse()
	if err := godotenv.Load(); err != nil && !errors.Is(err, os.ErrNotExist) {
		return err
	}
	ctx, stop := signal.NotifyContext(context.Background(), os.Interrupt, syscall.SIGTERM)
	defer stop()
	db, err := gorm.Open(postgres.Open(os.Getenv("DATABASE_URL")), &gorm.Config{TranslateError: true, Logger: logger.Default.LogMode(logger.Silent)})
	if err != nil {
		return errors.New("database connection failed")
	}
	sqlDB, err := db.DB()
	if err != nil {
		return err
	}
	defer func() {
		if err := sqlDB.Close(); err != nil {
			fmt.Fprintln(os.Stderr, "database close failed")
		}
	}()
	sqlDB.SetMaxOpenConns(2)
	sqlDB.SetMaxIdleConns(1)
	var m bestiaryimport.Manifest
	var operationErr error
	switch *mode {
	case "collect":
		m, operationErr = bestiaryimport.NewCollector().Collect(ctx, db, *dir)
	case "review":
		return bestiaryimport.Review(ctx, db, *dir, *entry, *decision, *id, *description, *evidence)
	case "apply":
		storage, err := media.New(ctx)
		if err != nil {
			return err
		}
		m, operationErr = bestiaryimport.Apply(ctx, db, storage, *dir)
	case "report":
		m, operationErr = bestiaryimport.Load(*dir)
		if operationErr == nil {
			m.Catalog, operationErr = bestiaryimport.Catalog(ctx, db)
		}
	default:
		return errors.New("unknown mode")
	}
	if m.Version == 1 {
		archive, err := bestiaryimport.Report(m, *dir, *report, *backups)
		if err != nil {
			return err
		}
		fmt.Printf("Manifest: %s\nReport: %s\nBackup: %s\nCatalog: %d threats; collected: %d articles; complete index: %t\n", filepath.Join(*dir, "manifest.json"), *report, archive, len(m.Catalog), len(m.Entries), m.IndexComplete)
	}
	return operationErr
}
