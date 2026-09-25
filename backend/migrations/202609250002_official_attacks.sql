-- +goose Up
INSERT INTO ordem.attack_definition (
    rpg_system_id, source_item_id, skill_id, name, description,
    damage_expression, damage_type, critical_threshold, critical_multiplier,
    range_text, special
)
SELECT i.rpg_system_id, i.id, s.id, i.name, COALESCE(i.description, ''),
       w.damage, COALESCE(w.damage_type, ''),
       CASE WHEN w.critical ~ '^[0-9]+' THEN substring(w.critical FROM '^[0-9]+')::integer ELSE 20 END,
       CASE WHEN w.critical ~ 'x[0-9]+$' THEN substring(w.critical FROM 'x([0-9]+)$')::integer ELSE 2 END,
       COALESCE(w.range_text, ''), ''
FROM ordem.weapon w
JOIN core.item_definition i ON i.id = w.item_id
JOIN core.skill_definition s ON s.rpg_system_id = i.rpg_system_id
    AND s.slug = CASE WHEN w.weapon_kind = 'MELEE' THEN 'luta' ELSE 'pontaria' END
WHERE i.rpg_system_id = (SELECT id FROM core.rpg_system WHERE slug = 'ordem-paranormal')
ON CONFLICT (rpg_system_id, source_item_id) DO NOTHING;

-- +goose Down
DELETE FROM ordem.attack_definition WHERE owner_user_id IS NULL AND source_item_id IS NOT NULL;
