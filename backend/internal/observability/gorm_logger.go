package observability

import (
	"context"
	"errors"
	"log/slog"
	"time"

	"gorm.io/gorm"
	gormlogger "gorm.io/gorm/logger"
)

type GORMLogger struct {
	logger *slog.Logger
	level  gormlogger.LogLevel
}

func NewGORMLogger(logger *slog.Logger) GORMLogger {
	return GORMLogger{logger: logger, level: gormlogger.Warn}
}

func (logger GORMLogger) LogMode(level gormlogger.LogLevel) gormlogger.Interface {
	logger.level = level
	return logger
}

func (logger GORMLogger) Info(context.Context, string, ...any) {}
func (logger GORMLogger) Warn(context.Context, string, ...any) {}
func (logger GORMLogger) Error(_ context.Context, _ string, _ ...any) {
	logger.logger.Error("database logger error")
}

func (logger GORMLogger) Trace(ctx context.Context, begin time.Time, _ func() (string, int64), err error) {
	if logger.level == gormlogger.Silent {
		return
	}
	duration := time.Since(begin)
	attrs := []any{"duration_ms", duration.Milliseconds()}
	if err != nil && !errors.Is(err, gorm.ErrRecordNotFound) {
		logger.logger.ErrorContext(ctx, "database operation failed", append(attrs, "error_type", "database")...)
		return
	}
	if duration >= time.Second {
		logger.logger.WarnContext(ctx, "slow database operation", attrs...)
	}
}
