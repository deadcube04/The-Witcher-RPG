package domain

import "encoding/json"

type ImportRecord struct {
	Kind     string          `json:"kind" binding:"required"`
	SourceID string          `json:"sourceId" binding:"required,uuid"`
	Name     string          `json:"name"`
	Payload  json.RawMessage `json:"payload" binding:"required"`
}
type ImportRequest struct {
	Items []ImportRecord `json:"items" binding:"required"`
}
type ImportIssue struct {
	Kind     string `json:"kind"`
	SourceID string `json:"sourceId"`
	Code     string `json:"code"`
}
type ImportResult struct {
	Total           int           `json:"total"`
	Ready           int           `json:"ready"`
	AlreadyImported int           `json:"alreadyImported"`
	Issues          []ImportIssue `json:"issues"`
	Applied         bool          `json:"applied"`
}
type OfficialReference struct {
	Name string `json:"name"`
}
type InventoryImportEntry struct {
	CharacterSourceID  string `json:"characterSourceId"`
	DefinitionSourceID string `json:"definitionSourceId"`
	Quantity           int    `json:"quantity"`
	Equipped           bool   `json:"equipped"`
	Notes              string `json:"notes"`
}
type RitualImportEntry struct {
	CharacterSourceID  string `json:"characterSourceId"`
	DefinitionSourceID string `json:"definitionSourceId"`
	Notes              string `json:"notes"`
}
type AttackImportEntry struct {
	CharacterSourceID      string  `json:"characterSourceId"`
	DefinitionSourceID     string  `json:"definitionSourceId"`
	SourceInventoryEntryID *string `json:"sourceInventoryEntryId"`
	Notes                  string  `json:"notes"`
}
