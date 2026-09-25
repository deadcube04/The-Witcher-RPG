package domain

import "encoding/json"

type InventoryInput struct {
	Kind               string `json:"kind" binding:"required"`
	Name               string `json:"name" binding:"required"`
	Description        string `json:"description"`
	Category           *int   `json:"category"`
	Spaces             int    `json:"spaces"`
	DamageExpression   string `json:"damageExpression"`
	CriticalThreshold  int    `json:"criticalThreshold"`
	CriticalMultiplier int    `json:"criticalMultiplier"`
	RangeText          string `json:"rangeText"`
	DamageType         string `json:"damageType"`
}
type RitualInput struct {
	Name           string                     `json:"name" binding:"required"`
	Description    string                     `json:"description"`
	Element        string                     `json:"element" binding:"required"`
	Circle         int                        `json:"circle"`
	Execution      string                     `json:"execution"`
	RangeText      string                     `json:"rangeText"`
	TargetText     string                     `json:"targetText"`
	AreaText       string                     `json:"areaText"`
	DurationText   string                     `json:"durationText"`
	ResistanceText string                     `json:"resistanceText"`
	Tiers          map[string]RitualTierInput `json:"tiers" binding:"required"`
}
type RitualTierInput struct {
	PECost int             `json:"peCost"`
	Effect string          `json:"effect"`
	Rolls  json.RawMessage `json:"rolls"`
}
type AttackInput struct {
	Name                   string  `json:"name" binding:"required"`
	Description            string  `json:"description"`
	SkillID                *string `json:"skillId"`
	SkillName              string  `json:"skillName"`
	TestExpression         string  `json:"testExpression"`
	DamageExpression       string  `json:"damageExpression"`
	DamageType             string  `json:"damageType"`
	CriticalThreshold      int     `json:"criticalThreshold"`
	CriticalMultiplier     int     `json:"criticalMultiplier"`
	RangeText              string  `json:"rangeText"`
	Special                string  `json:"special"`
	SourceItemDefinitionID *string `json:"sourceItemDefinitionId"`
}
