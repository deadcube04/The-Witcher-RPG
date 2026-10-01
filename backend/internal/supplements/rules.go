package supplements

import (
	"strings"

	"RPG-manager/backend/internal/apperr"
)

// ExpandRuleIDs includes every optional descendant of each selected rule.
func ExpandRuleIDs(rules []Rule, ruleIDs []string) ([]string, error) {
	if len(ruleIDs) == 0 {
		return []string{}, nil
	}
	known := make(map[string]bool, len(rules))
	bySlug := make(map[string]string, len(rules))
	for _, row := range rules {
		known[row.ID] = true
		bySlug[row.Slug] = row.ID
	}
	selected := make(map[string]bool, len(ruleIDs))
	for _, id := range ruleIDs {
		id = strings.ToLower(id)
		if !known[id] || selected[id] {
			return nil, apperr.ErrInvalid
		}
		selected[id] = true
	}
	if selected[bySlug["evolucao-por-patentes"]] {
		sanityID, ok := bySlug["jogando-sem-sanidade"]
		if !ok {
			return nil, apperr.ErrInvalid
		}
		selected[sanityID] = true
	}
	for changed := true; changed; {
		changed = false
		for _, row := range rules {
			if row.ParentID != nil && selected[*row.ParentID] && !selected[row.ID] {
				selected[row.ID] = true
				changed = true
			}
		}
	}
	expanded := make([]string, 0, len(selected))
	for _, row := range rules {
		if selected[row.ID] {
			expanded = append(expanded, row.ID)
		}
	}
	return expanded, nil
}
