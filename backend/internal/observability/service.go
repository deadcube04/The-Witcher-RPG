package observability

import (
	"context"
	"errors"
	"fmt"
	"time"
)

var ErrNotFound = errors.New("error log record not found")

type Service struct {
	repo Repository
}

func NewService(repo Repository) *Service { return &Service{repo: repo} }

func (s *Service) Record(ctx context.Context, input OccurrenceInput) error {
	ctx, cancel := context.WithTimeout(context.WithoutCancel(ctx), 500*time.Millisecond)
	defer cancel()
	if err := ctx.Err(); err != nil {
		return err
	}
	return s.repo.Record(ctx, input)
}

func (s *Service) Groups(ctx context.Context, filter Filter) (Page[Group], error) {
	return s.repo.Groups(ctx, filter)
}

func (s *Service) Occurrences(ctx context.Context, filter Filter) (Page[Occurrence], error) {
	return s.repo.Occurrences(ctx, filter)
}

func (s *Service) Occurrence(ctx context.Context, id string) (Occurrence, error) {
	return s.repo.Occurrence(ctx, id)
}

func (s *Service) SetGroupState(ctx context.Context, id, state string) error {
	if state != "open" && state != "resolved" {
		return fmt.Errorf("invalid group state")
	}
	return s.repo.SetGroupState(ctx, id, state)
}

func (s *Service) UpdateOccurrences(ctx context.Context, update OccurrenceUpdate) error {
	if len(update.IDs) == 0 || len(update.IDs) > MaxBatchSize {
		return fmt.Errorf("invalid occurrence selection")
	}
	return s.repo.UpdateOccurrences(ctx, update)
}

func (s *Service) RetentionRules(ctx context.Context) ([]RetentionRule, error) {
	return s.repo.RetentionRules(ctx)
}

func (s *Service) UpdateRetentionRules(ctx context.Context, rules []RetentionRule) error {
	if len(rules) != 3 {
		return fmt.Errorf("exactly three retention rules are required")
	}
	seen := map[string]bool{}
	for _, rule := range rules {
		if rule.Category != "http_4xx" && rule.Category != "http_500" && rule.Category != "http_other_5xx" {
			return fmt.Errorf("unknown retention category")
		}
		if seen[rule.Category] {
			return fmt.Errorf("duplicate retention category")
		}
		seen[rule.Category] = true
		if rule.Days != nil && (*rule.Days < 1 || *rule.Days > 36500) {
			return fmt.Errorf("retention days out of range")
		}
		if rule.Category == "http_4xx" && rule.Days == nil {
			return fmt.Errorf("4xx retention must have a deadline")
		}
	}
	return s.repo.UpdateRetentionRules(ctx, rules)
}

func (s *Service) CleanupExpired(ctx context.Context, batchSize int) (int64, error) {
	if batchSize < 1 || batchSize > 1000 {
		return 0, fmt.Errorf("invalid cleanup batch size")
	}
	return s.repo.CleanupExpired(ctx, batchSize)
}
