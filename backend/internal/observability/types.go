package observability

import (
	"context"
	"time"
)

const PageSize = 25
const MaxBatchSize = 100

type OccurrenceInput struct {
	RequestID       string
	UserID          string
	Method          string
	Route           string
	Status          int
	ErrorCode       string
	FailureKind     string
	ErrorMessage    string
	PanicStack      string
	RequestHeaders  map[string]string
	ResponseHeaders map[string]string
	RequestBody     map[string]any
	ResponseBody    map[string]any
}

type Group struct {
	ID               string     `json:"id"`
	Method           string     `json:"method"`
	Route            string     `json:"route"`
	Status           int        `json:"status"`
	ErrorCode        string     `json:"errorCode"`
	FailureKind      string     `json:"failureKind"`
	State            string     `json:"state"`
	FirstOccurredAt  time.Time  `json:"firstOccurredAt"`
	LastOccurredAt   time.Time  `json:"lastOccurredAt"`
	TotalOccurrences int64      `json:"totalOccurrences"`
	AvailableCount   int64      `json:"availableCount"`
	ResolvedAt       *time.Time `json:"resolvedAt"`
}

type Occurrence struct {
	ID              string            `json:"id"`
	GroupID         string            `json:"groupId"`
	RequestID       string            `json:"requestId"`
	UserID          *string           `json:"userId"`
	OccurredAt      time.Time         `json:"occurredAt"`
	Method          string            `json:"method"`
	Route           string            `json:"route"`
	Status          int               `json:"status"`
	ErrorCode       string            `json:"errorCode"`
	FailureKind     string            `json:"failureKind"`
	ErrorMessage    string            `json:"errorMessage"`
	PanicStack      string            `json:"panicStack"`
	RequestHeaders  map[string]string `json:"requestHeaders"`
	ResponseHeaders map[string]string `json:"responseHeaders"`
	RequestBody     map[string]any    `json:"requestBody"`
	ResponseBody    map[string]any    `json:"responseBody"`
	ExpiresAt       *time.Time        `json:"expiresAt"`
}

type Filter struct {
	Page      int
	Status    int
	State     string
	Route     string
	RequestID string
	Since     *time.Time
	Until     *time.Time
}

type Page[T any] struct {
	Items      []T   `json:"items"`
	Page       int   `json:"page"`
	PageSize   int   `json:"pageSize"`
	TotalItems int64 `json:"totalItems"`
}

type RetentionRule struct {
	Category string `json:"category"`
	Days     *int   `json:"days"`
}

type OccurrenceUpdate struct {
	IDs       []string
	Delete    bool
	ExpiresAt *time.Time
}

type Repository interface {
	Record(context.Context, OccurrenceInput) error
	Groups(context.Context, Filter) (Page[Group], error)
	Occurrences(context.Context, Filter) (Page[Occurrence], error)
	Occurrence(context.Context, string) (Occurrence, error)
	SetGroupState(context.Context, string, string) error
	UpdateOccurrences(context.Context, OccurrenceUpdate) error
	RetentionRules(context.Context) ([]RetentionRule, error)
	UpdateRetentionRules(context.Context, []RetentionRule) error
	CleanupExpired(context.Context, int) (int64, error)
}

type AdminChecker interface {
	IsAdmin(ctx context.Context) (bool, error)
}
