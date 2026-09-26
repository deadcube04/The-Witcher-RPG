-- +goose Up
CREATE TABLE public.application_error_groups (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    fingerprint char(64) NOT NULL UNIQUE,
    method varchar(12) NOT NULL,
    route text NOT NULL,
    status integer NOT NULL CHECK (status BETWEEN 400 AND 599),
    error_code varchar(80) NOT NULL DEFAULT '',
    failure_kind varchar(120) NOT NULL,
    state varchar(16) NOT NULL DEFAULT 'open' CHECK (state IN ('open', 'resolved')),
    first_occurred_at timestamptz NOT NULL,
    last_occurred_at timestamptz NOT NULL,
    total_occurrences bigint NOT NULL DEFAULT 0,
    resolved_at timestamptz
);
CREATE INDEX application_error_groups_state_last_idx
    ON public.application_error_groups(state, last_occurred_at DESC);
CREATE INDEX application_error_groups_status_last_idx
    ON public.application_error_groups(status, last_occurred_at DESC);

CREATE TABLE public.application_error_occurrences (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    group_id uuid NOT NULL REFERENCES public.application_error_groups(id) ON DELETE CASCADE,
    request_id varchar(32) NOT NULL,
    user_id uuid REFERENCES public.users(id) ON DELETE SET NULL,
    occurred_at timestamptz NOT NULL,
    method varchar(12) NOT NULL,
    route text NOT NULL,
    status integer NOT NULL CHECK (status BETWEEN 400 AND 599),
    error_code varchar(80) NOT NULL DEFAULT '',
    failure_kind varchar(120) NOT NULL,
    error_message text NOT NULL DEFAULT '',
    panic_stack text NOT NULL DEFAULT '',
    request_headers jsonb NOT NULL DEFAULT '{}'::jsonb,
    response_headers jsonb NOT NULL DEFAULT '{}'::jsonb,
    request_body jsonb NOT NULL DEFAULT '{}'::jsonb,
    response_body jsonb NOT NULL DEFAULT '{}'::jsonb,
    expires_at timestamptz
);
CREATE INDEX application_error_occurrences_group_time_idx
    ON public.application_error_occurrences(group_id, occurred_at DESC);
CREATE INDEX application_error_occurrences_request_id_idx
    ON public.application_error_occurrences(request_id);
CREATE INDEX application_error_occurrences_expiry_idx
    ON public.application_error_occurrences(expires_at)
    WHERE expires_at IS NOT NULL;

CREATE TABLE public.application_error_retention_rules (
    category varchar(32) PRIMARY KEY CHECK (category IN ('http_4xx', 'http_500', 'http_other_5xx')),
    days integer CHECK (days IS NULL OR days BETWEEN 1 AND 36500),
    CHECK (category <> 'http_4xx' OR days IS NOT NULL)
);
INSERT INTO public.application_error_retention_rules(category, days) VALUES
    ('http_4xx', 7),
    ('http_500', NULL),
    ('http_other_5xx', 30);

-- +goose Down
DROP TABLE public.application_error_occurrences;
DROP TABLE public.application_error_retention_rules;
DROP TABLE public.application_error_groups;
