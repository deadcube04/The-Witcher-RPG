-- +goose Up
CREATE TABLE core.campaign (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    owner_user_id uuid NOT NULL REFERENCES core.users(id),
    rpg_system_id uuid NOT NULL REFERENCES core.rpg_system(id),
    name varchar(160) NOT NULL,
    description text NOT NULL DEFAULT '',
    status varchar(20) NOT NULL DEFAULT 'active' CHECK (status IN ('active', 'archived')),
    created_at timestamptz NOT NULL DEFAULT now(),
    updated_at timestamptz NOT NULL DEFAULT now(),
    UNIQUE (id, rpg_system_id)
);
CREATE INDEX campaign_owner_idx ON core.campaign(owner_user_id, updated_at DESC);
ALTER TABLE core.rpg_character ADD COLUMN campaign_id uuid;
ALTER TABLE core.rpg_character ADD CONSTRAINT rpg_character_campaign_system_fk
    FOREIGN KEY (campaign_id, rpg_system_id) REFERENCES core.campaign(id, rpg_system_id) ON DELETE SET NULL (campaign_id);
CREATE INDEX rpg_character_campaign_idx ON core.rpg_character(campaign_id);

ALTER TABLE core.character_resource ADD COLUMN max_adjustment numeric(10,2) NOT NULL DEFAULT 0;
ALTER TABLE core.character_skill ADD COLUMN attribute_id uuid REFERENCES core.attribute_definition(id);
ALTER TABLE core.character_item ADD COLUMN created_at timestamptz NOT NULL DEFAULT now();
ALTER TABLE core.character_item ADD COLUMN updated_at timestamptz NOT NULL DEFAULT now();
ALTER TABLE core.character_ability ADD COLUMN id uuid NOT NULL DEFAULT gen_random_uuid();
ALTER TABLE core.character_ability ADD COLUMN created_at timestamptz NOT NULL DEFAULT now();
ALTER TABLE core.character_ability ADD COLUMN updated_at timestamptz NOT NULL DEFAULT now();
ALTER TABLE core.character_ability ADD CONSTRAINT character_ability_id_unique UNIQUE (id);
ALTER TABLE core.character_attack ADD COLUMN definition_id uuid;
ALTER TABLE core.character_attack ADD COLUMN source_inventory_entry_id uuid REFERENCES core.character_item(id) ON DELETE SET NULL;
ALTER TABLE core.character_attack ADD COLUMN notes text NOT NULL DEFAULT '';
ALTER TABLE core.character_attack ADD COLUMN created_at timestamptz NOT NULL DEFAULT now();
ALTER TABLE core.character_attack ADD COLUMN updated_at timestamptz NOT NULL DEFAULT now();

ALTER TABLE core.item_definition ADD COLUMN owner_user_id uuid REFERENCES core.users(id);
ALTER TABLE core.item_definition ADD COLUMN created_at timestamptz;
ALTER TABLE core.item_definition ADD COLUMN updated_at timestamptz;
ALTER TABLE core.ability_definition ADD COLUMN owner_user_id uuid REFERENCES core.users(id);
ALTER TABLE core.ability_definition ADD COLUMN created_at timestamptz;
ALTER TABLE core.ability_definition ADD COLUMN updated_at timestamptz;

CREATE TABLE ordem.ritual_tier (
    ability_id uuid NOT NULL REFERENCES core.ability_definition(id) ON DELETE CASCADE,
    tier varchar(20) NOT NULL CHECK (tier IN ('normal', 'discente', 'verdadeiro')),
    pe_cost integer NOT NULL CHECK (pe_cost BETWEEN 0 AND 99),
    effect text NOT NULL,
    rolls jsonb NOT NULL DEFAULT '[]'::jsonb,
    PRIMARY KEY (ability_id, tier)
);

CREATE TABLE ordem.attack_definition (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    rpg_system_id uuid NOT NULL REFERENCES core.rpg_system(id),
    owner_user_id uuid REFERENCES core.users(id),
    source_item_id uuid REFERENCES core.item_definition(id),
    skill_id uuid REFERENCES core.skill_definition(id),
    name varchar(160) NOT NULL,
    description text NOT NULL DEFAULT '',
    test_expression varchar(120),
    damage_expression varchar(120) NOT NULL,
    damage_type varchar(80) NOT NULL DEFAULT '',
    critical_threshold integer,
    critical_multiplier integer,
    range_text varchar(120) NOT NULL DEFAULT '',
    special text NOT NULL DEFAULT '',
    created_at timestamptz,
    updated_at timestamptz,
    UNIQUE (rpg_system_id, source_item_id)
);
ALTER TABLE core.character_attack ADD CONSTRAINT character_attack_definition_fk
    FOREIGN KEY (definition_id) REFERENCES ordem.attack_definition(id);

ALTER TABLE core.users DROP CONSTRAINT users_username_slug;
ALTER TABLE core.users ADD CONSTRAINT users_username_slug
    CHECK (length(username) BETWEEN 2 AND 40 AND username ~ '^[a-zA-Z0-9_.-]+$');

INSERT INTO core.rpg_system(name, slug, version, description, is_active)
VALUES ('The Witcher', 'witcher', NULL, 'Em breve', false)
ON CONFLICT (slug) DO NOTHING;

-- +goose Down
DELETE FROM core.rpg_system WHERE slug = 'witcher';
ALTER TABLE core.users DROP CONSTRAINT users_username_slug;
ALTER TABLE core.users ADD CONSTRAINT users_username_slug
    CHECK (length(username) BETWEEN 2 AND 40 AND username ~ '^[a-z0-9]+(-[a-z0-9]+)*$');
ALTER TABLE core.character_attack DROP CONSTRAINT character_attack_definition_fk;
DROP TABLE ordem.attack_definition;
DROP TABLE ordem.ritual_tier;
ALTER TABLE core.ability_definition DROP COLUMN updated_at, DROP COLUMN created_at, DROP COLUMN owner_user_id;
ALTER TABLE core.item_definition DROP COLUMN updated_at, DROP COLUMN created_at, DROP COLUMN owner_user_id;
ALTER TABLE core.character_attack DROP COLUMN updated_at, DROP COLUMN created_at, DROP COLUMN notes,
    DROP COLUMN source_inventory_entry_id, DROP COLUMN definition_id;
ALTER TABLE core.character_ability DROP CONSTRAINT character_ability_id_unique;
ALTER TABLE core.character_ability DROP COLUMN updated_at, DROP COLUMN created_at, DROP COLUMN id;
ALTER TABLE core.character_item DROP COLUMN updated_at, DROP COLUMN created_at;
ALTER TABLE core.character_skill DROP COLUMN attribute_id;
ALTER TABLE core.character_resource DROP COLUMN max_adjustment;
ALTER TABLE core.rpg_character DROP CONSTRAINT rpg_character_campaign_system_fk;
ALTER TABLE core.rpg_character DROP COLUMN campaign_id;
DROP TABLE core.campaign;
