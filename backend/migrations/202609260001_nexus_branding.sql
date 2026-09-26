-- +goose Up
ALTER TABLE public.user_preferences ADD COLUMN color_mode varchar(10) NOT NULL DEFAULT 'system'
    CONSTRAINT user_preferences_color_mode CHECK (color_mode IN ('system', 'light', 'dark'));

INSERT INTO core.rpg_theme (rpg_system_id, theme_id, display_name)
SELECT id, 'nexus', 'NEXUS' FROM core.rpg_system
ON CONFLICT (rpg_system_id, theme_id) DO NOTHING;

-- Keep the neutral theme for every pre-existing user, including those without preferences.
INSERT INTO public.user_preferences (user_id, active_rpg_system_id, active_theme_id, sidebar_mode)
SELECT u.id, (SELECT id FROM core.rpg_system WHERE slug = 'ordem-paranormal'), NULL, 'collapsed'
FROM public.users u
ON CONFLICT (user_id) DO NOTHING;

-- Future systems inherit the global theme while retaining the composite foreign key.
-- +goose StatementBegin
CREATE FUNCTION core.register_nexus_theme() RETURNS trigger LANGUAGE plpgsql AS $$
BEGIN
    INSERT INTO core.rpg_theme (rpg_system_id, theme_id, display_name)
    VALUES (NEW.id, 'nexus', 'NEXUS') ON CONFLICT (rpg_system_id, theme_id) DO NOTHING;
    RETURN NEW;
END;
$$;
-- +goose StatementEnd
CREATE TRIGGER rpg_system_nexus_theme AFTER INSERT ON core.rpg_system
FOR EACH ROW EXECUTE FUNCTION core.register_nexus_theme();

-- +goose Down
DROP TRIGGER rpg_system_nexus_theme ON core.rpg_system;
DROP FUNCTION core.register_nexus_theme();
UPDATE public.user_preferences SET active_theme_id = NULL WHERE active_theme_id = 'nexus';
DELETE FROM core.rpg_theme WHERE theme_id = 'nexus';
ALTER TABLE public.user_preferences DROP COLUMN color_mode;
