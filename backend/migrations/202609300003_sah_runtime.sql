-- +goose Up
CREATE TABLE ordem.campaign_supplement (
    campaign_id uuid PRIMARY KEY REFERENCES core.campaign(id) ON DELETE CASCADE,
    supplement_id uuid NOT NULL REFERENCES core.rpg_supplement(id) ON DELETE RESTRICT,
    UNIQUE (campaign_id, supplement_id)
);

CREATE TABLE ordem.campaign_supplement_category (
    campaign_id uuid NOT NULL REFERENCES ordem.campaign_supplement(campaign_id) ON DELETE CASCADE,
    category varchar(24) NOT NULL CHECK (category IN ('survivor', 'trails', 'powers', 'rituals', 'items', 'modifications', 'threats')),
    PRIMARY KEY (campaign_id, category)
);

CREATE TABLE ordem.campaign_supplement_rule (
    campaign_id uuid NOT NULL REFERENCES ordem.campaign_supplement(campaign_id) ON DELETE CASCADE,
    rule_id uuid NOT NULL REFERENCES ordem.supplement_rule(id) ON DELETE RESTRICT,
    PRIMARY KEY (campaign_id, rule_id)
);

CREATE TABLE ordem.character_supplement (
    character_id uuid PRIMARY KEY REFERENCES core.character_sheet(character_id) ON DELETE CASCADE,
    supplement_id uuid NOT NULL REFERENCES core.rpg_supplement(id) ON DELETE RESTRICT
);

CREATE TABLE ordem.character_supplement_rule (
    character_id uuid NOT NULL REFERENCES ordem.character_supplement(character_id) ON DELETE CASCADE,
    rule_id uuid NOT NULL REFERENCES ordem.supplement_rule(id) ON DELETE RESTRICT,
    PRIMARY KEY (character_id, rule_id)
);

CREATE TABLE ordem.character_progression_runtime (
    character_id uuid PRIMARY KEY REFERENCES core.character_sheet(character_id) ON DELETE CASCADE,
    mode varchar(20) NOT NULL CHECK (mode IN ('nex', 'level-nex', 'patent', 'survivor')),
    level smallint CHECK (level BETWEEN 1 AND 20),
    patent varchar(32),
    survivor_class_id uuid REFERENCES ordem.supplement_survivor_class(id) ON DELETE RESTRICT,
    survivor_stage smallint CHECK (survivor_stage BETWEEN 1 AND 5),
    survivor_trail_id uuid REFERENCES ordem.supplement_survivor_trail(id) ON DELETE RESTRICT,
    CHECK ((mode = 'survivor') = (survivor_class_id IS NOT NULL AND survivor_stage IS NOT NULL)),
    CHECK ((mode = 'level-nex') = (level IS NOT NULL)),
    CHECK ((mode = 'patent') = (patent IS NOT NULL))
);

CREATE TABLE ordem.character_determination (
    character_id uuid PRIMARY KEY REFERENCES core.character_sheet(character_id) ON DELETE CASCADE,
    current_value integer NOT NULL CHECK (current_value >= 0),
    max_value integer NOT NULL CHECK (max_value >= 0),
    temporary_value integer NOT NULL DEFAULT 0 CHECK (temporary_value >= 0),
    max_adjustment integer NOT NULL DEFAULT 0
);

CREATE TABLE ordem.character_item_modification (
    inventory_entry_id uuid NOT NULL REFERENCES core.character_item(id) ON DELETE CASCADE,
    modification_id uuid NOT NULL REFERENCES ordem.item_modification(id) ON DELETE RESTRICT,
    PRIMARY KEY (inventory_entry_id, modification_id)
);

CREATE TABLE ordem.character_supplement_trail (
    character_id uuid PRIMARY KEY REFERENCES core.character_sheet(character_id) ON DELETE CASCADE,
    archetype_id uuid NOT NULL REFERENCES core.archetype_definition(id) ON DELETE RESTRICT
);

CREATE TABLE ordem.supplement_review_target (
    issue_id uuid PRIMARY KEY REFERENCES ordem.supplement_review_issue(id) ON DELETE CASCADE,
    target_kind varchar(32) NOT NULL CHECK (target_kind IN ('origin', 'trail', 'ability', 'ability_detail', 'item', 'item_detail', 'modification', 'ritual', 'rule', 'threat')),
    target_id uuid NOT NULL,
    field_name varchar(64) NOT NULL
);

CREATE TABLE ordem.supplement_review_audit (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    issue_id uuid NOT NULL REFERENCES ordem.supplement_review_issue(id) ON DELETE RESTRICT,
    actor_user_id uuid NOT NULL REFERENCES public.users(id) ON DELETE RESTRICT,
    target_kind varchar(32) NOT NULL,
    target_id uuid NOT NULL,
    field_name varchar(64) NOT NULL,
    previous_value text,
    new_value text NOT NULL,
    justification text NOT NULL CHECK (length(trim(justification)) >= 10),
    created_at timestamptz NOT NULL DEFAULT now()
);

INSERT INTO ordem.supplement_review_target(issue_id, target_kind, target_id, field_name)
SELECT i.id, 'modification', m.id, 'category_increase'
FROM ordem.supplement_review_issue i
JOIN ordem.item_modification m ON m.supplement_id=i.supplement_id
    AND m.name=i.source_text AND m.supplement_page_start <= i.source_page
    AND m.supplement_page_end >= i.source_page
WHERE i.issue_kind='modification_category';

-- +goose Down
DROP TABLE ordem.supplement_review_audit;
DROP TABLE ordem.supplement_review_target;
DROP TABLE ordem.character_item_modification;
DROP TABLE ordem.character_supplement_trail;
DROP TABLE ordem.character_determination;
DROP TABLE ordem.character_progression_runtime;
DROP TABLE ordem.character_supplement_rule;
DROP TABLE ordem.character_supplement;
DROP TABLE ordem.campaign_supplement_rule;
DROP TABLE ordem.campaign_supplement_category;
DROP TABLE ordem.campaign_supplement;
