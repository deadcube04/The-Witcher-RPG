package apperr

import "errors"

var (
	ErrNotFound       = errors.New("not found")
	ErrConflict       = errors.New("conflict")
	ErrInUse          = errors.New("content in use")
	ErrAlreadyAdded   = errors.New("content already added")
	ErrInvalid        = errors.New("invalid request")
	ErrPreview        = errors.New("preview system")
	ErrSystemMismatch = errors.New("system mismatch")
)
