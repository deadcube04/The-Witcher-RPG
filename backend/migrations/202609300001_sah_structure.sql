-- +goose Up
CREATE TABLE core.rpg_supplement (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    rpg_system_id uuid NOT NULL REFERENCES core.rpg_system(id) ON DELETE RESTRICT,
    slug varchar(120) NOT NULL,
    name varchar(160) NOT NULL,
    edition text NOT NULL,
    source_title text NOT NULL,
    pdf_pages integer NOT NULL CHECK (pdf_pages > 0),
    UNIQUE (rpg_system_id, slug),
    UNIQUE (id, rpg_system_id)
);

CREATE TABLE core.supplement_page (
    supplement_id uuid NOT NULL REFERENCES core.rpg_supplement(id) ON DELETE CASCADE,
    pdf_page integer NOT NULL CHECK (pdf_page > 0),
    source_file text NOT NULL,
    raw_text text NOT NULL,
    sha256 char(64) NOT NULL CHECK (sha256 ~ '^[0-9a-f]{64}$'),
    needs_review boolean NOT NULL DEFAULT false,
    PRIMARY KEY (supplement_id, pdf_page)
);

ALTER TABLE core.origin_definition
    ADD COLUMN supplement_id uuid,
    ADD COLUMN supplement_page_start integer,
    ADD COLUMN supplement_page_end integer,
    ADD CONSTRAINT origin_supplement_complete CHECK (
        (supplement_id IS NULL AND supplement_page_start IS NULL AND supplement_page_end IS NULL)
        OR (supplement_id IS NOT NULL AND supplement_page_start IS NOT NULL
            AND supplement_page_end IS NOT NULL AND supplement_page_start <= supplement_page_end)
    ),
    ADD CONSTRAINT origin_supplement_system_fk FOREIGN KEY (supplement_id, rpg_system_id)
        REFERENCES core.rpg_supplement(id, rpg_system_id) ON DELETE RESTRICT,
    ADD CONSTRAINT origin_supplement_start_fk FOREIGN KEY (supplement_id, supplement_page_start)
        REFERENCES core.supplement_page(supplement_id, pdf_page) ON DELETE RESTRICT,
    ADD CONSTRAINT origin_supplement_end_fk FOREIGN KEY (supplement_id, supplement_page_end)
        REFERENCES core.supplement_page(supplement_id, pdf_page) ON DELETE RESTRICT;

ALTER TABLE core.archetype_definition
    ADD COLUMN supplement_id uuid,
    ADD COLUMN supplement_page_start integer,
    ADD COLUMN supplement_page_end integer,
    ADD CONSTRAINT archetype_supplement_complete CHECK (
        (supplement_id IS NULL AND supplement_page_start IS NULL AND supplement_page_end IS NULL)
        OR (supplement_id IS NOT NULL AND supplement_page_start IS NOT NULL
            AND supplement_page_end IS NOT NULL AND supplement_page_start <= supplement_page_end)
    ),
    ADD CONSTRAINT archetype_supplement_system_fk FOREIGN KEY (supplement_id, rpg_system_id)
        REFERENCES core.rpg_supplement(id, rpg_system_id) ON DELETE RESTRICT,
    ADD CONSTRAINT archetype_supplement_start_fk FOREIGN KEY (supplement_id, supplement_page_start)
        REFERENCES core.supplement_page(supplement_id, pdf_page) ON DELETE RESTRICT,
    ADD CONSTRAINT archetype_supplement_end_fk FOREIGN KEY (supplement_id, supplement_page_end)
        REFERENCES core.supplement_page(supplement_id, pdf_page) ON DELETE RESTRICT;

ALTER TABLE core.ability_definition
    ADD COLUMN supplement_id uuid,
    ADD COLUMN supplement_page_start integer,
    ADD COLUMN supplement_page_end integer,
    ADD CONSTRAINT ability_supplement_complete CHECK (
        (supplement_id IS NULL AND supplement_page_start IS NULL AND supplement_page_end IS NULL)
        OR (supplement_id IS NOT NULL AND supplement_page_start IS NOT NULL
            AND supplement_page_end IS NOT NULL AND supplement_page_start <= supplement_page_end)
    ),
    ADD CONSTRAINT ability_supplement_system_fk FOREIGN KEY (supplement_id, rpg_system_id)
        REFERENCES core.rpg_supplement(id, rpg_system_id) ON DELETE RESTRICT,
    ADD CONSTRAINT ability_supplement_start_fk FOREIGN KEY (supplement_id, supplement_page_start)
        REFERENCES core.supplement_page(supplement_id, pdf_page) ON DELETE RESTRICT,
    ADD CONSTRAINT ability_supplement_end_fk FOREIGN KEY (supplement_id, supplement_page_end)
        REFERENCES core.supplement_page(supplement_id, pdf_page) ON DELETE RESTRICT,
    ADD CONSTRAINT ability_id_supplement_unique UNIQUE (id, supplement_id);

ALTER TABLE core.item_definition
    ADD COLUMN supplement_id uuid,
    ADD COLUMN supplement_page_start integer,
    ADD COLUMN supplement_page_end integer,
    ADD CONSTRAINT item_supplement_complete CHECK (
        (supplement_id IS NULL AND supplement_page_start IS NULL AND supplement_page_end IS NULL)
        OR (supplement_id IS NOT NULL AND supplement_page_start IS NOT NULL
            AND supplement_page_end IS NOT NULL AND supplement_page_start <= supplement_page_end)
    ),
    ADD CONSTRAINT item_supplement_system_fk FOREIGN KEY (supplement_id, rpg_system_id)
        REFERENCES core.rpg_supplement(id, rpg_system_id) ON DELETE RESTRICT,
    ADD CONSTRAINT item_supplement_start_fk FOREIGN KEY (supplement_id, supplement_page_start)
        REFERENCES core.supplement_page(supplement_id, pdf_page) ON DELETE RESTRICT,
    ADD CONSTRAINT item_supplement_end_fk FOREIGN KEY (supplement_id, supplement_page_end)
        REFERENCES core.supplement_page(supplement_id, pdf_page) ON DELETE RESTRICT,
    ADD CONSTRAINT item_id_supplement_unique UNIQUE (id, supplement_id);

ALTER TABLE core.rpg_character
    ADD COLUMN supplement_id uuid,
    ADD COLUMN supplement_page_start integer,
    ADD COLUMN supplement_page_end integer,
    ADD CONSTRAINT character_supplement_complete CHECK (
        (supplement_id IS NULL AND supplement_page_start IS NULL AND supplement_page_end IS NULL)
        OR (supplement_id IS NOT NULL AND character_type = 'THREAT'
            AND supplement_page_start IS NOT NULL AND supplement_page_end IS NOT NULL
            AND supplement_page_start <= supplement_page_end)
    ),
    ADD CONSTRAINT character_supplement_system_fk FOREIGN KEY (supplement_id, rpg_system_id)
        REFERENCES core.rpg_supplement(id, rpg_system_id) ON DELETE RESTRICT,
    ADD CONSTRAINT character_supplement_start_fk FOREIGN KEY (supplement_id, supplement_page_start)
        REFERENCES core.supplement_page(supplement_id, pdf_page) ON DELETE RESTRICT,
    ADD CONSTRAINT character_supplement_end_fk FOREIGN KEY (supplement_id, supplement_page_end)
        REFERENCES core.supplement_page(supplement_id, pdf_page) ON DELETE RESTRICT,
    ADD CONSTRAINT character_id_supplement_unique UNIQUE (id, supplement_id);

ALTER TABLE ordem.item_modification
    ADD COLUMN supplement_id uuid REFERENCES core.rpg_supplement(id) ON DELETE RESTRICT,
    ADD COLUMN supplement_page_start integer,
    ADD COLUMN supplement_page_end integer,
    ADD CONSTRAINT modification_supplement_complete CHECK (
        (supplement_id IS NULL AND supplement_page_start IS NULL AND supplement_page_end IS NULL)
        OR (supplement_id IS NOT NULL AND supplement_page_start IS NOT NULL
            AND supplement_page_end IS NOT NULL AND supplement_page_start <= supplement_page_end)
    ),
    ADD CONSTRAINT modification_supplement_start_fk FOREIGN KEY (supplement_id, supplement_page_start)
        REFERENCES core.supplement_page(supplement_id, pdf_page) ON DELETE RESTRICT,
    ADD CONSTRAINT modification_supplement_end_fk FOREIGN KEY (supplement_id, supplement_page_end)
        REFERENCES core.supplement_page(supplement_id, pdf_page) ON DELETE RESTRICT;

CREATE TABLE ordem.supplement_ability_detail (
    ability_id uuid PRIMARY KEY,
    supplement_id uuid NOT NULL,
    source_page integer NOT NULL,
    prerequisite_text text,
    element_id uuid REFERENCES ordem.element(id) ON DELETE RESTRICT,
    affinity_effect text,
    effect_text text NOT NULL,
    FOREIGN KEY (ability_id, supplement_id)
        REFERENCES core.ability_definition(id, supplement_id) ON DELETE CASCADE,
    FOREIGN KEY (supplement_id, source_page)
        REFERENCES core.supplement_page(supplement_id, pdf_page) ON DELETE RESTRICT
);

CREATE TABLE ordem.supplement_ability_classification (
    supplement_id uuid NOT NULL REFERENCES core.rpg_supplement(id) ON DELETE RESTRICT,
    ability_id uuid NOT NULL REFERENCES core.ability_definition(id) ON DELETE RESTRICT,
    source_page integer NOT NULL,
    classification varchar(40) NOT NULL CHECK (classification = 'GENERAL_POWER'),
    PRIMARY KEY (supplement_id, ability_id),
    FOREIGN KEY (supplement_id, source_page)
        REFERENCES core.supplement_page(supplement_id, pdf_page) ON DELETE RESTRICT
);

CREATE TABLE ordem.supplement_ritual_version (
    ability_id uuid NOT NULL,
    supplement_id uuid NOT NULL,
    version varchar(12) NOT NULL CHECK (version IN ('normal', 'discente', 'verdadeiro')),
    source_page integer NOT NULL,
    additional_pe_cost integer CHECK (additional_pe_cost >= 0),
    required_circle integer CHECK (required_circle BETWEEN 1 AND 4),
    affinity_required boolean NOT NULL DEFAULT false,
    effect_text text NOT NULL,
    PRIMARY KEY (ability_id, version),
    FOREIGN KEY (ability_id, supplement_id)
        REFERENCES core.ability_definition(id, supplement_id) ON DELETE CASCADE,
    FOREIGN KEY (supplement_id, source_page)
        REFERENCES core.supplement_page(supplement_id, pdf_page) ON DELETE RESTRICT
);

CREATE TABLE ordem.supplement_item_detail (
    item_id uuid PRIMARY KEY,
    supplement_id uuid NOT NULL,
    source_page integer NOT NULL,
    exact_spaces numeric(5,2) CHECK (exact_spaces >= 0),
    printed_category varchar(12),
    ammunition_capacity integer CHECK (ammunition_capacity > 0),
    variant_group text,
    item_group text,
    special_rule text,
    FOREIGN KEY (item_id, supplement_id)
        REFERENCES core.item_definition(id, supplement_id) ON DELETE CASCADE,
    FOREIGN KEY (supplement_id, source_page)
        REFERENCES core.supplement_page(supplement_id, pdf_page) ON DELETE RESTRICT
);

CREATE TABLE ordem.supplement_item_alias (
    item_id uuid NOT NULL,
    supplement_id uuid NOT NULL,
    alias text NOT NULL,
    source_page integer NOT NULL,
    PRIMARY KEY (item_id, alias),
    FOREIGN KEY (item_id, supplement_id)
        REFERENCES core.item_definition(id, supplement_id) ON DELETE CASCADE,
    FOREIGN KEY (supplement_id, source_page)
        REFERENCES core.supplement_page(supplement_id, pdf_page) ON DELETE RESTRICT
);

CREATE TABLE ordem.supplement_catalyst_element (
    item_id uuid NOT NULL,
    supplement_id uuid NOT NULL,
    element_id uuid NOT NULL REFERENCES ordem.element(id) ON DELETE RESTRICT,
    PRIMARY KEY (item_id, element_id),
    FOREIGN KEY (item_id, supplement_id)
        REFERENCES core.item_definition(id, supplement_id) ON DELETE CASCADE
);

CREATE TABLE ordem.supplement_modification_applicability (
    modification_id uuid NOT NULL REFERENCES ordem.item_modification(id) ON DELETE CASCADE,
    applies_to varchar(40) NOT NULL CHECK (applies_to IN ('FIREARM', 'MELEE_PROJECTILE', 'ACCESSORY')),
    PRIMARY KEY (modification_id, applies_to)
);

CREATE TABLE ordem.supplement_survivor_class (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    supplement_id uuid NOT NULL,
    rpg_system_id uuid NOT NULL,
    slug varchar(100) NOT NULL,
    name varchar(120) NOT NULL,
    initial_pv integer NOT NULL,
    initial_pe integer NOT NULL,
    initial_san integer NOT NULL,
    pv_per_stage integer NOT NULL,
    pe_per_stage integer NOT NULL,
    san_per_stage integer NOT NULL,
    trained_skills_rule text NOT NULL,
    proficiency_rule text NOT NULL,
    source_page integer NOT NULL,
    UNIQUE (supplement_id, slug),
    UNIQUE (id, supplement_id),
    FOREIGN KEY (supplement_id, rpg_system_id)
        REFERENCES core.rpg_supplement(id, rpg_system_id) ON DELETE RESTRICT,
    FOREIGN KEY (supplement_id, source_page)
        REFERENCES core.supplement_page(supplement_id, pdf_page) ON DELETE RESTRICT
);

CREATE TABLE ordem.supplement_survivor_stage (
    class_id uuid NOT NULL,
    supplement_id uuid NOT NULL,
    source_page integer NOT NULL,
    stage smallint NOT NULL CHECK (stage BETWEEN 1 AND 5),
    pe_limit smallint NOT NULL CHECK (pe_limit = 1),
    feature_name text NOT NULL,
    effect_text text NOT NULL,
    PRIMARY KEY (class_id, stage),
    FOREIGN KEY (class_id, supplement_id)
        REFERENCES ordem.supplement_survivor_class(id, supplement_id) ON DELETE CASCADE,
    FOREIGN KEY (supplement_id, source_page)
        REFERENCES core.supplement_page(supplement_id, pdf_page) ON DELETE RESTRICT
);

CREATE TABLE ordem.supplement_survivor_trail (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    class_id uuid NOT NULL,
    supplement_id uuid NOT NULL,
    source_page integer NOT NULL,
    slug varchar(100) NOT NULL,
    name varchar(120) NOT NULL,
    UNIQUE (class_id, slug),
    UNIQUE (id, supplement_id),
    FOREIGN KEY (class_id, supplement_id)
        REFERENCES ordem.supplement_survivor_class(id, supplement_id) ON DELETE CASCADE,
    FOREIGN KEY (supplement_id, source_page)
        REFERENCES core.supplement_page(supplement_id, pdf_page) ON DELETE RESTRICT
);

CREATE TABLE ordem.supplement_survivor_trail_ability (
    trail_id uuid NOT NULL,
    supplement_id uuid NOT NULL,
    source_page integer NOT NULL,
    stage smallint NOT NULL CHECK (stage IN (2, 4)),
    name varchar(160) NOT NULL,
    effect_text text NOT NULL,
    PRIMARY KEY (trail_id, stage),
    FOREIGN KEY (trail_id, supplement_id)
        REFERENCES ordem.supplement_survivor_trail(id, supplement_id) ON DELETE CASCADE,
    FOREIGN KEY (supplement_id, source_page)
        REFERENCES core.supplement_page(supplement_id, pdf_page) ON DELETE RESTRICT
);

CREATE TABLE ordem.supplement_survivor_transition (
    class_id uuid NOT NULL,
    supplement_id uuid NOT NULL,
    source_page integer NOT NULL,
    target_class_id uuid NOT NULL REFERENCES core.class_definition(id) ON DELETE RESTRICT,
    nex smallint NOT NULL CHECK (nex = 5),
    rule_text text NOT NULL,
    PRIMARY KEY (class_id, target_class_id),
    FOREIGN KEY (class_id, supplement_id)
        REFERENCES ordem.supplement_survivor_class(id, supplement_id) ON DELETE CASCADE,
    FOREIGN KEY (supplement_id, source_page)
        REFERENCES core.supplement_page(supplement_id, pdf_page) ON DELETE RESTRICT
);

CREATE TABLE ordem.supplement_threat_template (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    supplement_id uuid NOT NULL REFERENCES core.rpg_supplement(id) ON DELETE RESTRICT,
    slug varchar(180) NOT NULL,
    name varchar(160) NOT NULL,
    vd_formula text NOT NULL,
    rule_text text NOT NULL,
    source_page_start integer NOT NULL,
    source_page_end integer NOT NULL,
    UNIQUE (supplement_id, slug),
    UNIQUE (id, supplement_id),
    CHECK (source_page_start <= source_page_end),
    FOREIGN KEY (supplement_id, source_page_start)
        REFERENCES core.supplement_page(supplement_id, pdf_page) ON DELETE RESTRICT,
    FOREIGN KEY (supplement_id, source_page_end)
        REFERENCES core.supplement_page(supplement_id, pdf_page) ON DELETE RESTRICT
);

CREATE TABLE ordem.supplement_threat_example (
    template_id uuid PRIMARY KEY,
    supplement_id uuid NOT NULL,
    source_page integer NOT NULL,
    example_vd integer NOT NULL CHECK (example_vd > 0),
    statblock_text text NOT NULL,
    statblock_data jsonb NOT NULL DEFAULT '{}'::jsonb,
    FOREIGN KEY (template_id, supplement_id)
        REFERENCES ordem.supplement_threat_template(id, supplement_id) ON DELETE CASCADE,
    FOREIGN KEY (supplement_id, source_page)
        REFERENCES core.supplement_page(supplement_id, pdf_page) ON DELETE RESTRICT
);

CREATE TABLE ordem.supplement_rule (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    supplement_id uuid NOT NULL REFERENCES core.rpg_supplement(id) ON DELETE RESTRICT,
    parent_id uuid,
    slug varchar(180) NOT NULL,
    name varchar(180) NOT NULL,
    is_optional boolean NOT NULL,
    rule_text text NOT NULL,
    source_page_start integer NOT NULL,
    source_page_end integer NOT NULL,
    UNIQUE (supplement_id, slug),
    UNIQUE (id, supplement_id),
    CHECK (source_page_start <= source_page_end),
    FOREIGN KEY (supplement_id, source_page_start)
        REFERENCES core.supplement_page(supplement_id, pdf_page) ON DELETE RESTRICT,
    FOREIGN KEY (supplement_id, source_page_end)
        REFERENCES core.supplement_page(supplement_id, pdf_page) ON DELETE RESTRICT,
    FOREIGN KEY (parent_id, supplement_id)
        REFERENCES ordem.supplement_rule(id, supplement_id) ON DELETE CASCADE
);

CREATE TABLE ordem.supplement_rule_relation (
    supplement_id uuid NOT NULL REFERENCES core.rpg_supplement(id) ON DELETE RESTRICT,
    source_rule_id uuid NOT NULL,
    target_rule_id uuid NOT NULL,
    relation_kind varchar(20) NOT NULL CHECK (relation_kind IN ('requires', 'modifies', 'references')),
    PRIMARY KEY (source_rule_id, target_rule_id, relation_kind),
    CHECK (source_rule_id <> target_rule_id),
    FOREIGN KEY (source_rule_id, supplement_id)
        REFERENCES ordem.supplement_rule(id, supplement_id) ON DELETE CASCADE,
    FOREIGN KEY (target_rule_id, supplement_id)
        REFERENCES ordem.supplement_rule(id, supplement_id) ON DELETE CASCADE
);

CREATE TABLE ordem.supplement_rule_content_link (
    rule_id uuid NOT NULL REFERENCES ordem.supplement_rule(id) ON DELETE CASCADE,
    ability_id uuid REFERENCES core.ability_definition(id) ON DELETE CASCADE,
    item_id uuid REFERENCES core.item_definition(id) ON DELETE CASCADE,
    archetype_id uuid REFERENCES core.archetype_definition(id) ON DELETE CASCADE,
    threat_id uuid REFERENCES core.rpg_character(id) ON DELETE CASCADE,
    CHECK (num_nonnulls(ability_id, item_id, archetype_id, threat_id) = 1),
    UNIQUE NULLS NOT DISTINCT (rule_id, ability_id, item_id, archetype_id, threat_id)
);

CREATE TABLE ordem.supplement_review_issue (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    supplement_id uuid NOT NULL,
    source_page integer NOT NULL,
    issue_kind varchar(40) NOT NULL,
    source_text text NOT NULL,
    handling text NOT NULL,
    resolved boolean NOT NULL DEFAULT false,
    FOREIGN KEY (supplement_id, source_page)
        REFERENCES core.supplement_page(supplement_id, pdf_page) ON DELETE RESTRICT
);

-- +goose Down
DROP TABLE ordem.supplement_review_issue;
DROP TABLE ordem.supplement_rule_content_link;
DROP TABLE ordem.supplement_rule_relation;
DROP TABLE ordem.supplement_rule;
DROP TABLE ordem.supplement_threat_example;
DROP TABLE ordem.supplement_threat_template;
DROP TABLE ordem.supplement_survivor_transition;
DROP TABLE ordem.supplement_survivor_trail_ability;
DROP TABLE ordem.supplement_survivor_trail;
DROP TABLE ordem.supplement_survivor_stage;
DROP TABLE ordem.supplement_survivor_class;
DROP TABLE ordem.supplement_modification_applicability;
DROP TABLE ordem.supplement_catalyst_element;
DROP TABLE ordem.supplement_item_alias;
DROP TABLE ordem.supplement_item_detail;
DROP TABLE ordem.supplement_ritual_version;
DROP TABLE ordem.supplement_ability_classification;
DROP TABLE ordem.supplement_ability_detail;
ALTER TABLE ordem.item_modification DROP COLUMN supplement_page_end, DROP COLUMN supplement_page_start, DROP COLUMN supplement_id;
ALTER TABLE core.rpg_character DROP COLUMN supplement_page_end, DROP COLUMN supplement_page_start, DROP COLUMN supplement_id;
ALTER TABLE core.item_definition DROP COLUMN supplement_page_end, DROP COLUMN supplement_page_start, DROP COLUMN supplement_id;
ALTER TABLE core.ability_definition DROP COLUMN supplement_page_end, DROP COLUMN supplement_page_start, DROP COLUMN supplement_id;
ALTER TABLE core.archetype_definition DROP COLUMN supplement_page_end, DROP COLUMN supplement_page_start, DROP COLUMN supplement_id;
ALTER TABLE core.origin_definition DROP COLUMN supplement_page_end, DROP COLUMN supplement_page_start, DROP COLUMN supplement_id;
DROP TABLE core.supplement_page;
DROP TABLE core.rpg_supplement;
