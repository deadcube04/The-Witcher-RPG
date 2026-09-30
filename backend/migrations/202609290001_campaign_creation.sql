-- +goose Up
ALTER TABLE core.campaign
    ADD COLUMN cover_image_url text NOT NULL DEFAULT '',
    ADD COLUMN sheet_mode varchar(10) NOT NULL DEFAULT 'free'
        CHECK (sheet_mode IN ('guided', 'free'));

CREATE TABLE ordem.campaign_settings (
    campaign_id uuid PRIMARY KEY,
    rpg_system_id uuid NOT NULL,
    class_mode varchar(10) NOT NULL CHECK (class_mode IN ('all', 'selected')),
    origin_mode varchar(10) NOT NULL CHECK (origin_mode IN ('all', 'selected')),
    UNIQUE (campaign_id, rpg_system_id),
    FOREIGN KEY (campaign_id, rpg_system_id)
        REFERENCES core.campaign(id, rpg_system_id) ON DELETE CASCADE
);

CREATE TABLE ordem.campaign_allowed_class (
    campaign_id uuid NOT NULL,
    rpg_system_id uuid NOT NULL,
    class_id uuid NOT NULL,
    PRIMARY KEY (campaign_id, class_id),
    FOREIGN KEY (campaign_id, rpg_system_id)
        REFERENCES ordem.campaign_settings(campaign_id, rpg_system_id) ON DELETE CASCADE,
    FOREIGN KEY (class_id, rpg_system_id)
        REFERENCES core.class_definition(id, rpg_system_id) ON DELETE RESTRICT
);

CREATE TABLE ordem.campaign_allowed_origin (
    campaign_id uuid NOT NULL,
    rpg_system_id uuid NOT NULL,
    origin_id uuid NOT NULL,
    PRIMARY KEY (campaign_id, origin_id),
    FOREIGN KEY (campaign_id, rpg_system_id)
        REFERENCES ordem.campaign_settings(campaign_id, rpg_system_id) ON DELETE CASCADE,
    FOREIGN KEY (origin_id, rpg_system_id)
        REFERENCES core.origin_definition(id, rpg_system_id) ON DELETE RESTRICT
);

INSERT INTO ordem.campaign_settings(campaign_id, rpg_system_id, class_mode, origin_mode)
SELECT c.id, c.rpg_system_id, 'all', 'all'
FROM core.campaign AS c
JOIN core.rpg_system AS s ON s.id = c.rpg_system_id
WHERE s.slug = 'ordem-paranormal';

-- +goose Down
DROP TABLE ordem.campaign_allowed_origin;
DROP TABLE ordem.campaign_allowed_class;
DROP TABLE ordem.campaign_settings;
ALTER TABLE core.campaign DROP COLUMN sheet_mode, DROP COLUMN cover_image_url;
