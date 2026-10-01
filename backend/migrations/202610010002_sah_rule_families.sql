-- +goose Up
-- +goose StatementBegin
WITH RECURSIVE selected_rules(campaign_id, rule_id) AS (
    SELECT selected.campaign_id, selected.rule_id
    FROM ordem.campaign_supplement_rule selected
    JOIN ordem.campaign_supplement enabled ON enabled.campaign_id = selected.campaign_id
    JOIN core.rpg_supplement supplement ON supplement.id = enabled.supplement_id
    WHERE supplement.slug = 'sobrevivendo-ao-horror'
    UNION
    SELECT selected.campaign_id, child.id
    FROM selected_rules selected
    JOIN ordem.supplement_rule parent ON parent.id = selected.rule_id
    JOIN ordem.supplement_rule child ON child.parent_id = parent.id
        AND child.supplement_id = parent.supplement_id AND child.is_optional
)
INSERT INTO ordem.campaign_supplement_rule(campaign_id, rule_id)
SELECT campaign_id, rule_id FROM selected_rules
ON CONFLICT DO NOTHING;
-- +goose StatementEnd

-- +goose StatementBegin
WITH RECURSIVE selected_rules(character_id, rule_id) AS (
    SELECT selected.character_id, selected.rule_id
    FROM ordem.character_supplement_rule selected
    JOIN ordem.character_supplement enabled ON enabled.character_id = selected.character_id
    JOIN core.rpg_supplement supplement ON supplement.id = enabled.supplement_id
    WHERE supplement.slug = 'sobrevivendo-ao-horror'
    UNION
    SELECT selected.character_id, child.id
    FROM selected_rules selected
    JOIN ordem.supplement_rule parent ON parent.id = selected.rule_id
    JOIN ordem.supplement_rule child ON child.parent_id = parent.id
        AND child.supplement_id = parent.supplement_id AND child.is_optional
)
INSERT INTO ordem.character_supplement_rule(character_id, rule_id)
SELECT character_id, rule_id FROM selected_rules
ON CONFLICT DO NOTHING;
-- +goose StatementEnd

-- +goose Down
-- Keep enabled descendants: previous and automatically added selections are indistinguishable.
SELECT 1;
