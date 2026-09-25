-- +goose Up
CREATE TABLE core.local_import_map (
    owner_user_id uuid NOT NULL REFERENCES core.users(id),
    source_kind varchar(40) NOT NULL,
    source_id uuid NOT NULL,
    target_id uuid NOT NULL,
    created_at timestamptz NOT NULL DEFAULT now(),
    PRIMARY KEY (owner_user_id, source_kind, source_id)
);
CREATE INDEX local_import_target_idx ON core.local_import_map(source_kind, target_id);

-- +goose Down
DROP TABLE core.local_import_map;
