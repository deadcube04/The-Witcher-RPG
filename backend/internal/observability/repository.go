package observability

import (
	"context"
	"crypto/sha256"
	"encoding/hex"
	"errors"
	"fmt"
	"time"

	"gorm.io/gorm"
	"gorm.io/gorm/clause"
)

type groupRow struct {
	ID               string     `gorm:"column:id;primaryKey"`
	Fingerprint      string     `gorm:"column:fingerprint"`
	Method           string     `gorm:"column:method"`
	Route            string     `gorm:"column:route"`
	Status           int        `gorm:"column:status"`
	ErrorCode        string     `gorm:"column:error_code"`
	FailureKind      string     `gorm:"column:failure_kind"`
	State            string     `gorm:"column:state"`
	FirstOccurredAt  time.Time  `gorm:"column:first_occurred_at"`
	LastOccurredAt   time.Time  `gorm:"column:last_occurred_at"`
	TotalOccurrences int64      `gorm:"column:total_occurrences"`
	ResolvedAt       *time.Time `gorm:"column:resolved_at"`
	AvailableCount   int64      `gorm:"column:available_count;->"`
}

func (groupRow) TableName() string { return "public.application_error_groups" }

type occurrenceRow struct {
	ID              string            `gorm:"column:id;primaryKey"`
	GroupID         string            `gorm:"column:group_id"`
	RequestID       string            `gorm:"column:request_id"`
	UserID          *string           `gorm:"column:user_id"`
	OccurredAt      time.Time         `gorm:"column:occurred_at"`
	Method          string            `gorm:"column:method"`
	Route           string            `gorm:"column:route"`
	Status          int               `gorm:"column:status"`
	ErrorCode       string            `gorm:"column:error_code"`
	FailureKind     string            `gorm:"column:failure_kind"`
	ErrorMessage    string            `gorm:"column:error_message"`
	PanicStack      string            `gorm:"column:panic_stack"`
	RequestHeaders  map[string]string `gorm:"column:request_headers;type:jsonb;serializer:json"`
	ResponseHeaders map[string]string `gorm:"column:response_headers;type:jsonb;serializer:json"`
	RequestBody     map[string]any    `gorm:"column:request_body;type:jsonb;serializer:json"`
	ResponseBody    map[string]any    `gorm:"column:response_body;type:jsonb;serializer:json"`
	ExpiresAt       *time.Time        `gorm:"column:expires_at"`
}

func (occurrenceRow) TableName() string { return "public.application_error_occurrences" }

type retentionRow struct {
	Category string `gorm:"column:category;primaryKey"`
	Days     *int   `gorm:"column:days"`
}

func (retentionRow) TableName() string { return "public.application_error_retention_rules" }

type GORMRepository struct{ db *gorm.DB }

func NewGORMRepository(db *gorm.DB) *GORMRepository { return &GORMRepository{db: db} }

func (r *GORMRepository) Record(ctx context.Context, input OccurrenceInput) error {
	now := time.Now().UTC()
	if input.Route == "" {
		input.Route = "[unmatched]"
	}
	if input.FailureKind == "" {
		input.FailureKind = "http"
	}
	fingerprintInput := fmt.Sprintf("%s\x00%s\x00%d\x00%s\x00%s", input.Method, input.Route, input.Status, input.ErrorCode, input.FailureKind)
	sum := sha256.Sum256([]byte(fingerprintInput))
	fingerprint := hex.EncodeToString(sum[:])
	return r.db.WithContext(ctx).Transaction(func(tx *gorm.DB) error {
		var rules retentionRow
		category := retentionCategory(input.Status)
		if err := tx.Where("category = ?", category).Take(&rules).Error; err != nil {
			return fmt.Errorf("read error retention rule: %w", err)
		}
		var expiresAt *time.Time
		if rules.Days != nil {
			expires := now.Add(time.Duration(*rules.Days) * 24 * time.Hour)
			expiresAt = &expires
		}
		group := groupRow{
			Fingerprint: fingerprint, Method: input.Method, Route: input.Route, Status: input.Status,
			ErrorCode: input.ErrorCode, FailureKind: input.FailureKind, State: "open",
			FirstOccurredAt: now, LastOccurredAt: now, TotalOccurrences: 1,
		}
		result := tx.Clauses(clause.OnConflict{
			Columns: []clause.Column{{Name: "fingerprint"}},
			DoUpdates: clause.Assignments(map[string]any{
				"last_occurred_at": now, "total_occurrences": gorm.Expr("application_error_groups.total_occurrences + 1"),
				"state": "open", "resolved_at": nil,
			}),
		}, clause.Returning{}).Create(&group)
		if result.Error != nil {
			return fmt.Errorf("upsert error group: %w", result.Error)
		}
		var ownerID *string
		if input.UserID != "" {
			ownerID = &input.UserID
		}
		occurrence := occurrenceRow{
			GroupID: group.ID, RequestID: input.RequestID, UserID: ownerID, OccurredAt: now,
			Method: input.Method, Route: input.Route, Status: input.Status, ErrorCode: input.ErrorCode,
			FailureKind: input.FailureKind, ErrorMessage: input.ErrorMessage, PanicStack: input.PanicStack,
			RequestHeaders: input.RequestHeaders, ResponseHeaders: input.ResponseHeaders,
			RequestBody: input.RequestBody, ResponseBody: input.ResponseBody, ExpiresAt: expiresAt,
		}
		if err := tx.Create(&occurrence).Error; err != nil {
			return fmt.Errorf("create error occurrence: %w", err)
		}
		return nil
	})
}

func retentionCategory(status int) string {
	if status >= 400 && status < 500 {
		return "http_4xx"
	}
	if status == 500 {
		return "http_500"
	}
	return "http_other_5xx"
}

func applyFilters(query *gorm.DB, filter Filter, alias string) *gorm.DB {
	if filter.Status > 0 {
		query = query.Where(alias+"status = ?", filter.Status)
	}
	if filter.State != "" {
		query = query.Where(alias+"state = ?", filter.State)
	}
	if filter.Route != "" {
		query = query.Where(alias+"route ILIKE ?", "%"+filter.Route+"%")
	}
	if filter.Since != nil {
		query = query.Where(alias+"last_occurred_at >= ?", *filter.Since)
	}
	if filter.Until != nil {
		query = query.Where(alias+"last_occurred_at < ?", *filter.Until)
	}
	if filter.RequestID != "" {
		query = query.Where("EXISTS (SELECT 1 FROM public.application_error_occurrences eo WHERE eo.group_id = application_error_groups.id AND eo.request_id = ?)", filter.RequestID)
	}
	return query
}

func (r *GORMRepository) Groups(ctx context.Context, filter Filter) (Page[Group], error) {
	page := normalizedPage(filter.Page)
	query := applyFilters(r.db.WithContext(ctx).Model(&groupRow{}), filter, "application_error_groups.")
	var total int64
	if err := query.Count(&total).Error; err != nil {
		return Page[Group]{}, fmt.Errorf("count error groups: %w", err)
	}
	var rows []groupRow
	err := query.Select("application_error_groups.*, (SELECT count(*) FROM public.application_error_occurrences eo WHERE eo.group_id = application_error_groups.id) AS available_count").Order("last_occurred_at DESC").Limit(PageSize).Offset((page - 1) * PageSize).Find(&rows).Error
	if err != nil {
		return Page[Group]{}, fmt.Errorf("list error groups: %w", err)
	}
	items := make([]Group, 0, len(rows))
	for _, row := range rows {
		items = append(items, Group{ID: row.ID, Method: row.Method, Route: row.Route, Status: row.Status, ErrorCode: row.ErrorCode, FailureKind: row.FailureKind, State: row.State, FirstOccurredAt: row.FirstOccurredAt, LastOccurredAt: row.LastOccurredAt, TotalOccurrences: row.TotalOccurrences, AvailableCount: row.AvailableCount, ResolvedAt: row.ResolvedAt})
	}
	return Page[Group]{Items: items, Page: page, PageSize: PageSize, TotalItems: total}, nil
}

func normalizedPage(page int) int {
	if page < 1 {
		return 1
	}
	return page
}

func (r *GORMRepository) Occurrences(ctx context.Context, filter Filter) (Page[Occurrence], error) {
	page := normalizedPage(filter.Page)
	query := r.db.WithContext(ctx).Model(&occurrenceRow{})
	if filter.Status > 0 {
		query = query.Where("status = ?", filter.Status)
	}
	if filter.Route != "" {
		query = query.Where("route ILIKE ?", "%"+filter.Route+"%")
	}
	if filter.RequestID != "" {
		query = query.Where("request_id = ?", filter.RequestID)
	}
	if filter.Since != nil {
		query = query.Where("occurred_at >= ?", *filter.Since)
	}
	if filter.Until != nil {
		query = query.Where("occurred_at < ?", *filter.Until)
	}
	if filter.State != "" {
		query = query.Where("group_id IN (SELECT id FROM public.application_error_groups WHERE state = ?)", filter.State)
	}
	var total int64
	if err := query.Count(&total).Error; err != nil {
		return Page[Occurrence]{}, fmt.Errorf("count error occurrences: %w", err)
	}
	var rows []occurrenceRow
	if err := query.Select("id, group_id, request_id, user_id, occurred_at, method, route, status, error_code, failure_kind, error_message, expires_at").Order("occurred_at DESC").Limit(PageSize).Offset((page - 1) * PageSize).Find(&rows).Error; err != nil {
		return Page[Occurrence]{}, fmt.Errorf("list error occurrences: %w", err)
	}
	items := make([]Occurrence, 0, len(rows))
	for _, row := range rows {
		items = append(items, toOccurrence(row))
	}
	return Page[Occurrence]{Items: items, Page: page, PageSize: PageSize, TotalItems: total}, nil
}

func (r *GORMRepository) Occurrence(ctx context.Context, id string) (Occurrence, error) {
	var row occurrenceRow
	err := r.db.WithContext(ctx).Where("id = ?", id).Take(&row).Error
	if errors.Is(err, gorm.ErrRecordNotFound) {
		return Occurrence{}, ErrNotFound
	}
	if err != nil {
		return Occurrence{}, fmt.Errorf("read error occurrence: %w", err)
	}
	return toOccurrence(row), nil
}

func toOccurrence(row occurrenceRow) Occurrence {
	return Occurrence{ID: row.ID, GroupID: row.GroupID, RequestID: row.RequestID, UserID: row.UserID, OccurredAt: row.OccurredAt, Method: row.Method, Route: row.Route, Status: row.Status, ErrorCode: row.ErrorCode, FailureKind: row.FailureKind, ErrorMessage: row.ErrorMessage, PanicStack: row.PanicStack, RequestHeaders: row.RequestHeaders, ResponseHeaders: row.ResponseHeaders, RequestBody: row.RequestBody, ResponseBody: row.ResponseBody, ExpiresAt: row.ExpiresAt}
}

func (r *GORMRepository) SetGroupState(ctx context.Context, id, state string) error {
	var resolvedAt any
	if state == "resolved" {
		resolvedAt = time.Now().UTC()
	}
	result := r.db.WithContext(ctx).Model(&groupRow{}).Where("id = ?", id).Updates(map[string]any{"state": state, "resolved_at": resolvedAt})
	if result.Error != nil {
		return fmt.Errorf("update error group: %w", result.Error)
	}
	if result.RowsAffected == 0 {
		return ErrNotFound
	}
	return nil
}

func (r *GORMRepository) UpdateOccurrences(ctx context.Context, update OccurrenceUpdate) error {
	return r.db.WithContext(ctx).Transaction(func(tx *gorm.DB) error {
		var count int64
		if err := tx.Model(&occurrenceRow{}).Where("id IN ?", update.IDs).Count(&count).Error; err != nil {
			return fmt.Errorf("validate occurrence selection: %w", err)
		}
		if count != int64(len(update.IDs)) {
			return ErrNotFound
		}
		if update.Delete {
			if err := tx.Where("id IN ?", update.IDs).Delete(&occurrenceRow{}).Error; err != nil {
				return fmt.Errorf("delete error occurrences: %w", err)
			}
			return nil
		}
		result := tx.Model(&occurrenceRow{}).Where("id IN ?", update.IDs).Update("expires_at", update.ExpiresAt)
		if result.Error != nil {
			return fmt.Errorf("update occurrence retention: %w", result.Error)
		}
		return nil
	})
}

func (r *GORMRepository) RetentionRules(ctx context.Context) ([]RetentionRule, error) {
	var rows []retentionRow
	if err := r.db.WithContext(ctx).Order("category").Find(&rows).Error; err != nil {
		return nil, fmt.Errorf("list retention rules: %w", err)
	}
	items := make([]RetentionRule, 0, len(rows))
	for _, row := range rows {
		items = append(items, RetentionRule{Category: row.Category, Days: row.Days})
	}
	return items, nil
}

func (r *GORMRepository) UpdateRetentionRules(ctx context.Context, rules []RetentionRule) error {
	return r.db.WithContext(ctx).Transaction(func(tx *gorm.DB) error {
		for _, rule := range rules {
			result := tx.Model(&retentionRow{}).Where("category = ?", rule.Category).Update("days", rule.Days)
			if result.Error != nil {
				return fmt.Errorf("update retention rule %s: %w", rule.Category, result.Error)
			}
			if result.RowsAffected == 0 {
				return fmt.Errorf("retention rule %s: %w", rule.Category, ErrNotFound)
			}
		}
		return nil
	})
}

func (r *GORMRepository) CleanupExpired(ctx context.Context, batchSize int) (int64, error) {
	var total int64
	for {
		var ids []string
		err := r.db.WithContext(ctx).Model(&occurrenceRow{}).Select("id").Where("expires_at IS NOT NULL AND expires_at <= now()").Order("expires_at").Limit(batchSize).Scan(&ids).Error
		if err != nil {
			return total, fmt.Errorf("find expired error occurrences: %w", err)
		}
		if len(ids) == 0 {
			return total, nil
		}
		result := r.db.WithContext(ctx).Where("id IN ?", ids).Delete(&occurrenceRow{})
		if result.Error != nil {
			return total, fmt.Errorf("delete expired error occurrences: %w", result.Error)
		}
		total += result.RowsAffected
		if len(ids) < batchSize {
			return total, nil
		}
	}
}
