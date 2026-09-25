package domain

import "time"

type Resource struct {
	Current       int `json:"current"`
	Temporary     int `json:"temporary"`
	BaseMaximum   int `json:"baseMaximum"`
	MaxAdjustment int `json:"maxAdjustment"`
	Maximum       int `json:"maximum"`
}
type Attributes struct {
	Agility   int `json:"agility"`
	Strength  int `json:"strength"`
	Intellect int `json:"intellect"`
	Presence  int `json:"presence"`
	Vigor     int `json:"vigor"`
}
type Resources struct {
	Health Resource `json:"health"`
	Effort Resource `json:"effort"`
	Sanity Resource `json:"sanity"`
}
type OrdemData struct {
	Kind        string     `json:"kind"`
	NEX         int        `json:"nex"`
	ClassID     string     `json:"classId"`
	OriginID    *string    `json:"originId"`
	CreditLimit *string    `json:"creditLimit"`
	Attributes  Attributes `json:"attributes"`
	Resources   Resources  `json:"resources"`
	PELimit     int        `json:"peLimit"`
}
type Character struct {
	ID          string    `json:"id"`
	OwnerID     string    `json:"ownerId"`
	Name        string    `json:"name"`
	SystemID    string    `json:"systemId"`
	CampaignID  *string   `json:"campaignId"`
	Description string    `json:"description"`
	Appearance  string    `json:"appearance"`
	Personality string    `json:"personality"`
	Background  string    `json:"background"`
	Objective   string    `json:"objective"`
	SystemData  OrdemData `json:"systemData"`
	CreatedAt   time.Time `json:"createdAt"`
	UpdatedAt   time.Time `json:"updatedAt"`
}
type CharacterInput struct {
	Name        string    `json:"name" binding:"required,min=1,max=160"`
	SystemID    string    `json:"systemId" binding:"required,uuid"`
	CampaignID  *string   `json:"campaignId"`
	Description string    `json:"description"`
	Appearance  string    `json:"appearance"`
	Personality string    `json:"personality"`
	Background  string    `json:"background"`
	Objective   string    `json:"objective"`
	SystemData  OrdemData `json:"systemData"`
}
type ClassRule struct {
	InitialPVBase      int
	PVPerNEXBase       int
	InitialPEBase      int
	PEPerNEXBase       int
	InitialSAN         int
	SANPerNEX          int
	InitialPVAttribute *string
	PVPerNEXAttribute  *string
	InitialPEAttribute *string
	PEPerNEXAttribute  *string
}
type CharacterOptions struct {
	Classes        []Option         `json:"classes"`
	Origins        []Option         `json:"origins"`
	Attributes     []Option         `json:"attributes"`
	Resources      []Option         `json:"resources"`
	Skills         []Option         `json:"skills"`
	NEX            []NEXOption      `json:"nex"`
	TrainingLevels []TrainingOption `json:"trainingLevels"`
}
type Option struct {
	ID   string `json:"id"`
	Slug string `json:"slug"`
	Name string `json:"name"`
}
type NEXOption struct {
	Value   int `json:"value"`
	PELimit int `json:"peLimit"`
}
type TrainingOption struct {
	ID    string `json:"id"`
	Name  string `json:"name"`
	Bonus int    `json:"bonus"`
}
