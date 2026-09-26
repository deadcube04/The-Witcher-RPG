-- +goose Up
ALTER TABLE core.users SET SCHEMA public;
ALTER TABLE core.user_preferences SET SCHEMA public;
ALTER TABLE core.local_import_map SET SCHEMA public;

-- +goose Down
ALTER TABLE public.local_import_map SET SCHEMA core;
ALTER TABLE public.user_preferences SET SCHEMA core;
ALTER TABLE public.users SET SCHEMA core;
