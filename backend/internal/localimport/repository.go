package localimport

import (
	"context"
	"errors"
	"fmt"

	"RPG-manager/backend/internal/apperr"
	"RPG-manager/backend/internal/campaigns"
	"RPG-manager/backend/internal/characters"
	"RPG-manager/backend/internal/content"
	"RPG-manager/backend/internal/domain"
	"RPG-manager/backend/internal/dbscope"
	"RPG-manager/backend/internal/systems"
	"gorm.io/gorm"
)

var errPreviewRollback = errors.New("preview rollback")

type Repository struct {
	db     *gorm.DB
	userID string
}

type domainSession struct {
	campaigns           *campaigns.Service
	characters          *characters.Character
	homebrew            *content.Homebrew
	characterRepository *characters.Repository
	contentRepository   *content.Repository
}

func NewRepository(store *dbscope.Scope) *Repository {
	return &Repository{db: store.DB, userID: store.UserID}
}

func (r *Repository) ImportedID(ctx context.Context, kind, sourceID string) (string, error) {
	var id string
	err := r.db.WithContext(ctx).Table("public.local_import_map").Select("target_id").Where("owner_user_id=? AND source_kind=? AND source_id=?", r.userID, kind, sourceID).Scan(&id).Error
	if err != nil {
		return "", err
	}
	if id == "" {
		return "", apperr.ErrNotFound
	}
	return id, nil
}

func (r *Repository) Process(ctx context.Context, req domain.ImportRequest, dry bool, apply func(context.Context, *Repository, *domainSession, domain.ImportRecord) (string, error), errorCode func(error) string) (domain.ImportResult, error) {
	result := domain.ImportResult{Total: len(req.Items), Issues: []domain.ImportIssue{}}
	err := r.db.WithContext(ctx).Transaction(func(tx *gorm.DB) error {
		session := &Repository{db: tx, userID: r.userID}
		store := dbscope.New(tx, r.userID)
		systemService := systems.NewService(systems.NewRepository(tx))
		operations := &domainSession{
			campaigns:           campaigns.NewService(campaigns.NewRepository(tx, r.userID), systemService),
			characters:          characters.NewCharacter(store),
			homebrew:            content.NewHomebrew(store),
			characterRepository: characters.NewRepository(tx, r.userID),
			contentRepository:   content.NewRepository(tx, r.userID),
		}
		for index, item := range req.Items {
			var target string
			if err := tx.Table("public.local_import_map").Select("target_id").Where("owner_user_id=? AND source_kind=? AND source_id=?", r.userID, item.Kind, item.SourceID).Scan(&target).Error; err != nil {
				return err
			}
			if target != "" {
				result.AlreadyImported++
				continue
			}
			savepoint := fmt.Sprintf("import_item_%d", index)
			if err := tx.SavePoint(savepoint).Error; err != nil {
				return err
			}
			created, err := apply(ctx, session, operations, item)
			if err != nil {
				if rollbackErr := tx.RollbackTo(savepoint).Error; rollbackErr != nil {
					return rollbackErr
				}
				result.Issues = append(result.Issues, domain.ImportIssue{Kind: item.Kind, SourceID: item.SourceID, Code: errorCode(err)})
				continue
			}
			if err := tx.Exec("INSERT INTO public.local_import_map(owner_user_id,source_kind,source_id,target_id) VALUES (?,?,?,?)", r.userID, item.Kind, item.SourceID, created).Error; err != nil {
				return err
			}
			result.Ready++
		}
		if dry || len(result.Issues) > 0 {
			return errPreviewRollback
		}
		return nil
	})
	if dry && errors.Is(err, errPreviewRollback) {
		return result, nil
	}
	if !dry && errors.Is(err, errPreviewRollback) {
		return result, ErrInvalid
	}
	if err != nil {
		return result, fmt.Errorf("local import: %w", err)
	}
	result.Applied = !dry
	return result, nil
}
