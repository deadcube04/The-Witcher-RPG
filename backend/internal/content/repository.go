package content

import "gorm.io/gorm"

type Repository struct {
	DB     *gorm.DB
	UserID string
}

func NewRepository(db *gorm.DB, userID string) *Repository {
	return &Repository{DB: db, UserID: userID}
}
