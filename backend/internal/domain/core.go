package domain

import "time"

type Profile struct {
	ID        string `json:"id"`
	Name      string `json:"name"`
	Username  string `json:"username"`
	AvatarURL string `json:"avatarUrl"`
	Role      string `json:"role"`
}

type Preferences struct {
	ActiveSystemID string  `json:"activeSystemId"`
	ActiveThemeID  *string `json:"activeThemeId"`
	SidebarMode    string  `json:"sidebarMode"`
	ColorMode      string  `json:"colorMode"`
}

type System struct {
	ID              string   `json:"id"`
	Slug            string   `json:"slug"`
	Name            string   `json:"name"`
	Description     string   `json:"description"`
	Status          string   `json:"status"`
	AvailableThemes []string `json:"availableThemes"`
}

type Campaign struct {
	ID          string    `json:"id"`
	OwnerID     string    `json:"ownerId"`
	SystemID    string    `json:"systemId"`
	Name        string    `json:"name"`
	Description string    `json:"description"`
	Status      string    `json:"status"`
	CreatedAt   time.Time `json:"createdAt"`
	UpdatedAt   time.Time `json:"updatedAt"`
}

type CampaignInput struct {
	SystemID    string `json:"systemId" binding:"required,uuid"`
	Name        string `json:"name" binding:"required,min=1,max=160"`
	Description string `json:"description" binding:"max=10000"`
	Status      string `json:"status" binding:"required,oneof=active archived"`
}
