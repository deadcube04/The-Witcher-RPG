package domain

type Skill struct {
	ID              string  `json:"id"`
	Name            string  `json:"name"`
	Slug            string  `json:"slug"`
	AttributeID     string  `json:"attributeId"`
	AttributeSlug   string  `json:"attributeSlug"`
	TrainingLevelID *string `json:"trainingLevelId"`
	TrainingName    string  `json:"trainingName"`
	TrainingBonus   int     `json:"trainingBonus"`
	OtherBonus      int     `json:"otherBonus"`
	Bonus           int     `json:"bonus"`
	DiceCount       int     `json:"diceCount"`
	Keep            string  `json:"keep"`
}
type SkillUpdate struct {
	ID              string  `json:"id" binding:"required,uuid"`
	AttributeID     string  `json:"attributeId" binding:"required,uuid"`
	TrainingLevelID *string `json:"trainingLevelId"`
	OtherBonus      int     `json:"otherBonus"`
}
