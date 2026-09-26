package dbscope

import "gorm.io/gorm"

type Scope struct {
	DB     *gorm.DB
	UserID string
}

func New(db *gorm.DB, userID string) *Scope { return &Scope{DB: db, UserID: userID} }
