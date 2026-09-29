package bestiary

import "context"

const PageSize = 24
const MaxPageSize = 100
const MaxPageNumber = 100000

type Filters struct {
	Query       string
	ElementID   string
	BeingTypeID string
	SizeID      string
	VDMin       *int
	VDMax       *int
	Sort        string
	Page        int
	PageSize    int
}

type Option struct {
	ID   string `json:"id"`
	Name string `json:"name"`
}

type Options struct {
	Elements []Option `json:"elements"`
	Types    []Option `json:"types"`
	Sizes    []Option `json:"sizes"`
	MinVD    int      `json:"minVD"`
	MaxVD    int      `json:"maxVD"`
}

type Element struct {
	ID        string `json:"id"`
	Name      string `json:"name"`
	IsPrimary bool   `json:"isPrimary"`
}

type ThreatSummary struct {
	ID          string    `json:"id"`
	Name        string    `json:"name"`
	Description *string   `json:"description"`
	ImageURL    *string   `json:"imageUrl"`
	BeingTypeID *string   `json:"beingTypeId"`
	BeingType   *string   `json:"beingType"`
	Challenge   *int      `json:"challengeValue"`
	SizeID      *string   `json:"sizeId"`
	Size        *string   `json:"size"`
	Elements    []Element `json:"elements"`
}

type Page struct {
	Items    []ThreatSummary `json:"items"`
	Total    int64           `json:"total"`
	Page     int             `json:"page"`
	PageSize int             `json:"pageSize"`
	NextPage *int            `json:"nextPage"`
}

type MainStats struct {
	Defense   *int `json:"defense"`
	HitPoints *int `json:"hitPoints"`
	WoundedAt *int `json:"woundedAt"`
	Agility   *int `json:"agility"`
	Strength  *int `json:"strength"`
	Intellect *int `json:"intellect"`
	Presence  *int `json:"presence"`
	Vigor     *int `json:"vigor"`
}

type Tests struct {
	Perception *string `json:"perception"`
	Initiative *string `json:"initiative"`
	Fortitude  *string `json:"fortitude"`
	Reflexes   *string `json:"reflexes"`
	Will       *string `json:"will"`
}

type Presence struct {
	Difficulty *int    `json:"difficulty"`
	Damage     *string `json:"damage"`
	ImmuneNEX  *int    `json:"immuneNex"`
}

type Action struct {
	ID               string  `json:"id"`
	Name             string  `json:"name"`
	Type             *string `json:"type" gorm:"column:action_kind"`
	Description      *string `json:"description"`
	TestExpression   *string `json:"testExpression"`
	DamageExpression *string `json:"damageExpression"`
	AttackCount      *int    `json:"attackCount"`
	Range            *string `json:"range" gorm:"column:action_range"`
	Critical         *string `json:"critical"`
	DamageType       *string `json:"damageType"`
	Resistance       *string `json:"resistance"`
	SourceRef        *string `json:"sourceRef"`
}

type Ability struct {
	ID            string  `json:"id"`
	Name          string  `json:"name"`
	EffectSummary *string `json:"effectSummary"`
	SourceRef     *string `json:"sourceRef"`
}

type DefenseTrait struct {
	ID        string  `json:"id"`
	Type      string  `json:"type" gorm:"column:trait_kind"`
	Name      string  `json:"name"`
	ValueText *string `json:"valueText"`
	SourceRef *string `json:"sourceRef"`
}

type Skill struct {
	ID             string  `json:"id"`
	Name           string  `json:"name"`
	TestExpression string  `json:"testExpression"`
	SourceRef      *string `json:"sourceRef"`
}

type Threat struct {
	ThreatSummary
	Appearance           *string        `json:"appearance"`
	Behavior             *string        `json:"behavior"`
	History              *string        `json:"history"`
	BeingTypeDescription *string        `json:"beingTypeDescription"`
	SourceRef            *string        `json:"sourceRef"`
	MainStats            MainStats      `json:"stats"`
	Tests                Tests          `json:"tests"`
	Senses               *string        `json:"senses"`
	Movement             *string        `json:"movement"`
	DisturbingPresence   *string        `json:"disturbingPresence"`
	Presence             Presence       `json:"presence"`
	FearEnigmaSummary    *string        `json:"fearEnigmaSummary"`
	Group                *string        `json:"group"`
	ResistancesText      *string        `json:"resistancesText"`
	ImmunitiesText       *string        `json:"immunitiesText"`
	VulnerabilitiesText  *string        `json:"vulnerabilitiesText"`
	Descriptors          []string       `json:"descriptors"`
	Actions              []Action       `json:"actions"`
	Abilities            []Ability      `json:"abilities"`
	DefenseTraits        []DefenseTrait `json:"defenseTraits"`
	Skills               []Skill        `json:"skills"`
}

type NavigationItem struct {
	ID   string `json:"id"`
	Name string `json:"name"`
}

type Navigation struct {
	Previous *NavigationItem `json:"previous"`
	Next     *NavigationItem `json:"next"`
	Position *int64          `json:"position"`
	Total    int64           `json:"total"`
}

type Detail struct {
	Creature   Threat     `json:"creature"`
	Navigation Navigation `json:"navigation"`
}

type Repository interface {
	Options(context.Context) (Options, error)
	List(context.Context, Filters) (Page, error)
	Get(context.Context, string, Filters) (Threat, Navigation, error)
}
