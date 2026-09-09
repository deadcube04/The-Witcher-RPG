--
-- PostgreSQL database dump
--

\restrict 7GtLPCQQmNpHsAa6Jeaulfp4doISXfpEdgLl7ZLMg9wq17pO9ZrVfLEMQRh0HVI

-- Dumped from database version 18.4
-- Dumped by pg_dump version 18.4

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: core; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA core;


ALTER SCHEMA core OWNER TO postgres;

--
-- Name: ordem; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA ordem;


ALTER SCHEMA ordem OWNER TO postgres;

--
-- Name: pg_trgm; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_trgm WITH SCHEMA public;


--
-- Name: EXTENSION pg_trgm; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pg_trgm IS 'text similarity measurement and index searching based on trigrams';


--
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;


--
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


--
-- Name: unaccent; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS unaccent WITH SCHEMA public;


--
-- Name: EXTENSION unaccent; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION unaccent IS 'text search dictionary that removes accents';


--
-- Name: expand_search_query(text, character varying); Type: FUNCTION; Schema: core; Owner: postgres
--

CREATE FUNCTION core.expand_search_query(p_query text, p_domain character varying) RETURNS tsquery
    LANGUAGE plpgsql STABLE
    AS $$
DECLARE
    v_lexeme text;
    v_result tsquery;
    v_group tsquery;
    v_original tsquery;
    v_candidate tsquery;
    v_row record;
BEGIN
    IF p_query IS NULL OR btrim(p_query)='' THEN
        RETURN NULL;
    END IF;

    IF p_domain NOT IN ('ITEM','THREAT') THEN
        RAISE EXCEPTION
            'Domínio de busca inválido: %. Esperado ITEM ou THREAT.',
            p_domain;
    END IF;

    FOR v_lexeme IN
        SELECT unnest(
            tsvector_to_array(
                to_tsvector('core.portuguese_unaccent',p_query)
            )
        )
        ORDER BY 1
    LOOP
        v_original := plainto_tsquery(
            'core.portuguese_unaccent',
            v_lexeme
        );

        IF v_original IS NULL OR numnode(v_original)=0 THEN
            CONTINUE;
        END IF;

        v_group := v_original;

        FOR v_row IN
            SELECT s.term, s.synonym
            FROM core.search_synonym s
            WHERE s.is_active
              AND s.domain IN ('GLOBAL',p_domain)
              AND (
                    plainto_tsquery('core.portuguese_unaccent',s.term)=v_original
                 OR plainto_tsquery('core.portuguese_unaccent',s.synonym)=v_original
              )
        LOOP
            IF plainto_tsquery(
                'core.portuguese_unaccent',
                v_row.term
            )=v_original THEN
                v_candidate := plainto_tsquery(
                    'core.portuguese_unaccent',
                    v_row.synonym
                );
            ELSE
                v_candidate := plainto_tsquery(
                    'core.portuguese_unaccent',
                    v_row.term
                );
            END IF;

            IF v_candidate IS NOT NULL
               AND numnode(v_candidate)>0 THEN
                v_group := v_group || v_candidate;
            END IF;
        END LOOP;

        IF v_result IS NULL THEN
            v_result := v_group;
        ELSE
            v_result := v_result && v_group;
        END IF;
    END LOOP;

    RETURN v_result;
END;
$$;


ALTER FUNCTION core.expand_search_query(p_query text, p_domain character varying) OWNER TO postgres;

--
-- Name: FUNCTION expand_search_query(p_query text, p_domain character varying); Type: COMMENT; Schema: core; Owner: postgres
--

COMMENT ON FUNCTION core.expand_search_query(p_query text, p_domain character varying) IS 'Expande consultas FTS com stemming português, unaccent e sinônimos GLOBAL/ITEM/THREAT.';


--
-- Name: normalize_fuzzy_query(text); Type: FUNCTION; Schema: core; Owner: postgres
--

CREATE FUNCTION core.normalize_fuzzy_query(p_query text) RETURNS text
    LANGUAGE sql IMMUTABLE
    AS $$
    SELECT lower(unaccent(coalesce(p_query,'')));
$$;


ALTER FUNCTION core.normalize_fuzzy_query(p_query text) OWNER TO postgres;

--
-- Name: refresh_item_fuzzy_text(uuid); Type: FUNCTION; Schema: core; Owner: postgres
--

CREATE FUNCTION core.refresh_item_fuzzy_text(p_item_id uuid) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_name text;
    v_slug text;
    v_description text;
BEGIN
    SELECT
        name,
        slug,
        description
    INTO
        v_name,
        v_slug,
        v_description
    FROM core.item_definition
    WHERE id=p_item_id;

    IF NOT FOUND THEN
        RETURN;
    END IF;

    UPDATE core.item_definition
    SET fuzzy_text =
        lower(
            unaccent(
                coalesce(v_name,'') || ' ' ||
                coalesce(v_slug,'') || ' ' ||
                coalesce(v_description,'')
            )
        )
    WHERE id=p_item_id;
END;
$$;


ALTER FUNCTION core.refresh_item_fuzzy_text(p_item_id uuid) OWNER TO postgres;

--
-- Name: refresh_item_search_vector(uuid); Type: FUNCTION; Schema: core; Owner: postgres
--

CREATE FUNCTION core.refresh_item_search_vector(p_item_id uuid) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_name text;
    v_slug text;
    v_description text;
    v_type text;
BEGIN
    SELECT
        i.name,
        i.slug,
        i.description,
        t.name
    INTO
        v_name,
        v_slug,
        v_description,
        v_type
    FROM core.item_definition i
    LEFT JOIN core.item_type t
      ON t.id=i.item_type_id
    WHERE i.id=p_item_id;

    IF NOT FOUND THEN
        RETURN;
    END IF;

    UPDATE core.item_definition
    SET search_vector =
          setweight(
              to_tsvector('core.portuguese_unaccent',coalesce(v_name,'')),
              'A'
          )
        || setweight(
              to_tsvector('core.portuguese_unaccent',coalesce(v_slug,'')),
              'A'
          )
        || setweight(
              to_tsvector('core.portuguese_unaccent',coalesce(v_description,'')),
              'B'
          )
        || setweight(
              to_tsvector('core.portuguese_unaccent',coalesce(v_type,'')),
              'C'
          )
    WHERE id=p_item_id;
END;
$$;


ALTER FUNCTION core.refresh_item_search_vector(p_item_id uuid) OWNER TO postgres;

--
-- Name: search_items(text, uuid, uuid, integer, integer, real); Type: FUNCTION; Schema: core; Owner: postgres
--

CREATE FUNCTION core.search_items(p_query text, p_rpg_system_id uuid DEFAULT NULL::uuid, p_item_type_id uuid DEFAULT NULL::uuid, p_limit integer DEFAULT 50, p_offset integer DEFAULT 0, p_fuzzy_threshold real DEFAULT 0.25) RETURNS TABLE(id uuid, rpg_system_id uuid, item_type_id uuid, item_type_name character varying, name character varying, slug character varying, description text, source_ref text, rank real)
    LANGUAGE sql STABLE
    AS $$
    WITH params AS (
        SELECT
            core.expand_search_query(p_query,'ITEM') AS fts_query,
            core.normalize_fuzzy_query(p_query) AS fuzzy_query,
            greatest(0.0::real, least(1.0::real, p_fuzzy_threshold)) AS fuzzy_threshold
    ),
    ranked AS (
        SELECT
            i.id,
            i.rpg_system_id,
            i.item_type_id,
            t.name AS item_type_name,
            i.name,
            i.slug,
            i.description,
            i.source_ref,

            CASE
                WHEN p.fts_query IS NOT NULL
                 AND numnode(p.fts_query)>0
                 AND i.search_vector @@ p.fts_query
                THEN ts_rank_cd(i.search_vector,p.fts_query,32)
                ELSE 0
            END AS fts_rank,

            similarity(
                coalesce(i.fuzzy_text,''),
                p.fuzzy_query
            ) AS fuzzy_rank

        FROM core.item_definition i
        LEFT JOIN core.item_type t
          ON t.id=i.item_type_id
        CROSS JOIN params p
        WHERE
            nullif(btrim(p_query),'') IS NOT NULL
            AND (
                (
                    p.fts_query IS NOT NULL
                    AND numnode(p.fts_query)>0
                    AND i.search_vector @@ p.fts_query
                )
                OR
                similarity(
                    coalesce(i.fuzzy_text,''),
                    p.fuzzy_query
                ) >= p.fuzzy_threshold
            )
            AND (
                p_rpg_system_id IS NULL
                OR i.rpg_system_id=p_rpg_system_id
            )
            AND (
                p_item_type_id IS NULL
                OR i.item_type_id=p_item_type_id
            )
    )
    SELECT
        id,
        rpg_system_id,
        item_type_id,
        item_type_name,
        name,
        slug,
        description,
        source_ref,
        (
            fts_rank * 0.85
            +
            fuzzy_rank * 0.15
        )::real AS rank
    FROM ranked
    ORDER BY
        (fts_rank > 0) DESC,
        rank DESC,
        name ASC
    LIMIT greatest(p_limit,0)
    OFFSET greatest(p_offset,0);
$$;


ALTER FUNCTION core.search_items(p_query text, p_rpg_system_id uuid, p_item_type_id uuid, p_limit integer, p_offset integer, p_fuzzy_threshold real) OWNER TO postgres;

--
-- Name: trg_refresh_item_fuzzy_from_item(); Type: FUNCTION; Schema: core; Owner: postgres
--

CREATE FUNCTION core.trg_refresh_item_fuzzy_from_item() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    PERFORM core.refresh_item_fuzzy_text(NEW.id);
    RETURN NEW;
END;
$$;


ALTER FUNCTION core.trg_refresh_item_fuzzy_from_item() OWNER TO postgres;

--
-- Name: trg_refresh_item_search_from_item(); Type: FUNCTION; Schema: core; Owner: postgres
--

CREATE FUNCTION core.trg_refresh_item_search_from_item() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    PERFORM core.refresh_item_search_vector(NEW.id);
    RETURN NEW;
END;
$$;


ALTER FUNCTION core.trg_refresh_item_search_from_item() OWNER TO postgres;

--
-- Name: trg_refresh_item_search_from_type(); Type: FUNCTION; Schema: core; Owner: postgres
--

CREATE FUNCTION core.trg_refresh_item_search_from_type() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    r record;
BEGIN
    FOR r IN
        SELECT id
        FROM core.item_definition
        WHERE item_type_id=NEW.id
    LOOP
        PERFORM core.refresh_item_search_vector(r.id);
    END LOOP;

    RETURN NEW;
END;
$$;


ALTER FUNCTION core.trg_refresh_item_search_from_type() OWNER TO postgres;

--
-- Name: refresh_threat_fuzzy_text(uuid); Type: FUNCTION; Schema: ordem; Owner: postgres
--

CREATE FUNCTION ordem.refresh_threat_fuzzy_text(p_threat_id uuid) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_name text;
    v_slug text;
    v_description text;
BEGIN
    SELECT
        c.name,
        t.slug,
        c.description
    INTO
        v_name,
        v_slug,
        v_description
    FROM ordem.threat t
    JOIN core.rpg_character c
      ON c.id=t.character_id
    WHERE t.character_id=p_threat_id;

    IF NOT FOUND THEN
        RETURN;
    END IF;

    UPDATE ordem.threat
    SET fuzzy_text =
        lower(
            unaccent(
                coalesce(v_name,'') || ' ' ||
                coalesce(v_slug,'') || ' ' ||
                coalesce(v_description,'')
            )
        )
    WHERE character_id=p_threat_id;
END;
$$;


ALTER FUNCTION ordem.refresh_threat_fuzzy_text(p_threat_id uuid) OWNER TO postgres;

--
-- Name: refresh_threat_search_vector(uuid); Type: FUNCTION; Schema: ordem; Owner: postgres
--

CREATE FUNCTION ordem.refresh_threat_search_vector(p_threat_id uuid) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_name text;
    v_slug text;
    v_description text;
    v_elements text;
    v_being_type text;
BEGIN
    SELECT
        c.name,
        t.slug,
        c.description,
        bt.name
    INTO
        v_name,
        v_slug,
        v_description,
        v_being_type
    FROM ordem.threat t
    JOIN core.rpg_character c
      ON c.id=t.character_id
    LEFT JOIN ordem.being_type bt
      ON bt.id=t.being_type_id
    WHERE t.character_id=p_threat_id;

    IF NOT FOUND THEN
        RETURN;
    END IF;

    SELECT string_agg(e.name,' ' ORDER BY te.sort_order,e.name)
    INTO v_elements
    FROM ordem.threat_element te
    JOIN ordem.element e
      ON e.id=te.element_id
    WHERE te.threat_id=p_threat_id;

    UPDATE ordem.threat
    SET search_vector =
          setweight(
              to_tsvector('core.portuguese_unaccent',coalesce(v_name,'')),
              'A'
          )
        || setweight(
              to_tsvector('core.portuguese_unaccent',coalesce(v_slug,'')),
              'A'
          )
        || setweight(
              to_tsvector('core.portuguese_unaccent',coalesce(v_description,'')),
              'B'
          )
        || setweight(
              to_tsvector('core.portuguese_unaccent',coalesce(v_elements,'')),
              'B'
          )
        || setweight(
              to_tsvector('core.portuguese_unaccent',coalesce(v_being_type,'')),
              'C'
          )
    WHERE character_id=p_threat_id;
END;
$$;


ALTER FUNCTION ordem.refresh_threat_search_vector(p_threat_id uuid) OWNER TO postgres;

--
-- Name: search_threats(text, integer, integer, real); Type: FUNCTION; Schema: ordem; Owner: postgres
--

CREATE FUNCTION ordem.search_threats(p_query text, p_limit integer DEFAULT 50, p_offset integer DEFAULT 0, p_fuzzy_threshold real DEFAULT 0.25) RETURNS TABLE(character_id uuid, name character varying, slug character varying, description text, elements text, rank real)
    LANGUAGE sql STABLE
    AS $$
    WITH params AS (
        SELECT
            core.expand_search_query(p_query,'THREAT') AS fts_query,
            core.normalize_fuzzy_query(p_query) AS fuzzy_query,
            greatest(0.0::real, least(1.0::real, p_fuzzy_threshold)) AS fuzzy_threshold
    ),
    ranked AS (
        SELECT
            t.character_id,
            c.name,
            t.slug,
            c.description,

            (
                SELECT string_agg(
                    e.name,
                    ', '
                    ORDER BY te.sort_order,e.name
                )
                FROM ordem.threat_element te
                JOIN ordem.element e
                  ON e.id=te.element_id
                WHERE te.threat_id=t.character_id
            ) AS elements,

            CASE
                WHEN p.fts_query IS NOT NULL
                 AND numnode(p.fts_query)>0
                 AND t.search_vector @@ p.fts_query
                THEN ts_rank_cd(
                    t.search_vector,
                    p.fts_query,
                    32
                )
                ELSE 0
            END AS fts_rank,

            similarity(
                coalesce(t.fuzzy_text,''),
                p.fuzzy_query
            ) AS fuzzy_rank

        FROM ordem.threat t
        JOIN core.rpg_character c
          ON c.id=t.character_id
        CROSS JOIN params p
        WHERE
            nullif(btrim(p_query),'') IS NOT NULL
            AND (
                (
                    p.fts_query IS NOT NULL
                    AND numnode(p.fts_query)>0
                    AND t.search_vector @@ p.fts_query
                )
                OR
                similarity(
                    coalesce(t.fuzzy_text,''),
                    p.fuzzy_query
                ) >= p.fuzzy_threshold
            )
    )
    SELECT
        character_id,
        name,
        slug,
        description,
        elements,
        (
            fts_rank * 0.85
            +
            fuzzy_rank * 0.15
        )::real AS rank
    FROM ranked
    ORDER BY
        (fts_rank > 0) DESC,
        rank DESC,
        name ASC
    LIMIT greatest(p_limit,0)
    OFFSET greatest(p_offset,0);
$$;


ALTER FUNCTION ordem.search_threats(p_query text, p_limit integer, p_offset integer, p_fuzzy_threshold real) OWNER TO postgres;

--
-- Name: trg_refresh_threat_fuzzy_from_character(); Type: FUNCTION; Schema: ordem; Owner: postgres
--

CREATE FUNCTION ordem.trg_refresh_threat_fuzzy_from_character() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF EXISTS (
        SELECT 1
        FROM ordem.threat
        WHERE character_id=NEW.id
    ) THEN
        PERFORM ordem.refresh_threat_fuzzy_text(NEW.id);
    END IF;

    RETURN NEW;
END;
$$;


ALTER FUNCTION ordem.trg_refresh_threat_fuzzy_from_character() OWNER TO postgres;

--
-- Name: trg_refresh_threat_fuzzy_from_threat(); Type: FUNCTION; Schema: ordem; Owner: postgres
--

CREATE FUNCTION ordem.trg_refresh_threat_fuzzy_from_threat() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    PERFORM ordem.refresh_threat_fuzzy_text(NEW.character_id);
    RETURN NEW;
END;
$$;


ALTER FUNCTION ordem.trg_refresh_threat_fuzzy_from_threat() OWNER TO postgres;

--
-- Name: trg_refresh_threat_search_from_being_type(); Type: FUNCTION; Schema: ordem; Owner: postgres
--

CREATE FUNCTION ordem.trg_refresh_threat_search_from_being_type() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    r record;
BEGIN
    FOR r IN
        SELECT character_id
        FROM ordem.threat
        WHERE being_type_id=NEW.id
    LOOP
        PERFORM ordem.refresh_threat_search_vector(r.character_id);
    END LOOP;

    RETURN NEW;
END;
$$;


ALTER FUNCTION ordem.trg_refresh_threat_search_from_being_type() OWNER TO postgres;

--
-- Name: trg_refresh_threat_search_from_character(); Type: FUNCTION; Schema: ordem; Owner: postgres
--

CREATE FUNCTION ordem.trg_refresh_threat_search_from_character() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF EXISTS (
        SELECT 1
        FROM ordem.threat
        WHERE character_id=NEW.id
    ) THEN
        PERFORM ordem.refresh_threat_search_vector(NEW.id);
    END IF;

    RETURN NEW;
END;
$$;


ALTER FUNCTION ordem.trg_refresh_threat_search_from_character() OWNER TO postgres;

--
-- Name: trg_refresh_threat_search_from_element(); Type: FUNCTION; Schema: ordem; Owner: postgres
--

CREATE FUNCTION ordem.trg_refresh_threat_search_from_element() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    r record;
BEGIN
    FOR r IN
        SELECT threat_id
        FROM ordem.threat_element
        WHERE element_id=NEW.id
    LOOP
        PERFORM ordem.refresh_threat_search_vector(r.threat_id);
    END LOOP;

    RETURN NEW;
END;
$$;


ALTER FUNCTION ordem.trg_refresh_threat_search_from_element() OWNER TO postgres;

--
-- Name: trg_refresh_threat_search_from_threat(); Type: FUNCTION; Schema: ordem; Owner: postgres
--

CREATE FUNCTION ordem.trg_refresh_threat_search_from_threat() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    PERFORM ordem.refresh_threat_search_vector(NEW.character_id);
    RETURN NEW;
END;
$$;


ALTER FUNCTION ordem.trg_refresh_threat_search_from_threat() OWNER TO postgres;

--
-- Name: trg_refresh_threat_search_from_threat_element(); Type: FUNCTION; Schema: ordem; Owner: postgres
--

CREATE FUNCTION ordem.trg_refresh_threat_search_from_threat_element() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_threat_id uuid;
BEGIN
    v_threat_id := COALESCE(NEW.threat_id, OLD.threat_id);

    PERFORM ordem.refresh_threat_search_vector(v_threat_id);

    RETURN COALESCE(NEW,OLD);
END;
$$;


ALTER FUNCTION ordem.trg_refresh_threat_search_from_threat_element() OWNER TO postgres;

--
-- Name: portuguese_unaccent; Type: TEXT SEARCH CONFIGURATION; Schema: core; Owner: postgres
--

CREATE TEXT SEARCH CONFIGURATION core.portuguese_unaccent (
    PARSER = pg_catalog."default" );

ALTER TEXT SEARCH CONFIGURATION core.portuguese_unaccent
    ADD MAPPING FOR asciiword WITH portuguese_stem;

ALTER TEXT SEARCH CONFIGURATION core.portuguese_unaccent
    ADD MAPPING FOR word WITH public.unaccent, portuguese_stem;

ALTER TEXT SEARCH CONFIGURATION core.portuguese_unaccent
    ADD MAPPING FOR numword WITH simple;

ALTER TEXT SEARCH CONFIGURATION core.portuguese_unaccent
    ADD MAPPING FOR email WITH simple;

ALTER TEXT SEARCH CONFIGURATION core.portuguese_unaccent
    ADD MAPPING FOR url WITH simple;

ALTER TEXT SEARCH CONFIGURATION core.portuguese_unaccent
    ADD MAPPING FOR host WITH simple;

ALTER TEXT SEARCH CONFIGURATION core.portuguese_unaccent
    ADD MAPPING FOR sfloat WITH simple;

ALTER TEXT SEARCH CONFIGURATION core.portuguese_unaccent
    ADD MAPPING FOR version WITH simple;

ALTER TEXT SEARCH CONFIGURATION core.portuguese_unaccent
    ADD MAPPING FOR hword_numpart WITH simple;

ALTER TEXT SEARCH CONFIGURATION core.portuguese_unaccent
    ADD MAPPING FOR hword_part WITH public.unaccent, portuguese_stem;

ALTER TEXT SEARCH CONFIGURATION core.portuguese_unaccent
    ADD MAPPING FOR hword_asciipart WITH portuguese_stem;

ALTER TEXT SEARCH CONFIGURATION core.portuguese_unaccent
    ADD MAPPING FOR numhword WITH simple;

ALTER TEXT SEARCH CONFIGURATION core.portuguese_unaccent
    ADD MAPPING FOR asciihword WITH portuguese_stem;

ALTER TEXT SEARCH CONFIGURATION core.portuguese_unaccent
    ADD MAPPING FOR hword WITH public.unaccent, portuguese_stem;

ALTER TEXT SEARCH CONFIGURATION core.portuguese_unaccent
    ADD MAPPING FOR url_path WITH simple;

ALTER TEXT SEARCH CONFIGURATION core.portuguese_unaccent
    ADD MAPPING FOR file WITH simple;

ALTER TEXT SEARCH CONFIGURATION core.portuguese_unaccent
    ADD MAPPING FOR "float" WITH simple;

ALTER TEXT SEARCH CONFIGURATION core.portuguese_unaccent
    ADD MAPPING FOR "int" WITH simple;

ALTER TEXT SEARCH CONFIGURATION core.portuguese_unaccent
    ADD MAPPING FOR uint WITH simple;


ALTER TEXT SEARCH CONFIGURATION core.portuguese_unaccent OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: ability_definition; Type: TABLE; Schema: core; Owner: postgres
--

CREATE TABLE core.ability_definition (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    rpg_system_id uuid NOT NULL,
    name character varying(160) NOT NULL,
    slug character varying(140) NOT NULL,
    ability_type character varying(60) NOT NULL,
    description text,
    is_active boolean DEFAULT false NOT NULL,
    source_ref text
);


ALTER TABLE core.ability_definition OWNER TO postgres;

--
-- Name: action_definition; Type: TABLE; Schema: core; Owner: postgres
--

CREATE TABLE core.action_definition (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    rpg_system_id uuid NOT NULL,
    name character varying(140) NOT NULL,
    slug character varying(140) NOT NULL,
    action_type character varying(20) NOT NULL,
    description text NOT NULL,
    sort_order integer DEFAULT 0 NOT NULL,
    source_ref text,
    metadata jsonb DEFAULT '{}'::jsonb NOT NULL,
    CONSTRAINT action_definition_action_type_check CHECK (((action_type)::text = ANY ((ARRAY['STANDARD'::character varying, 'MOVEMENT'::character varying, 'FULL'::character varying, 'FREE'::character varying, 'REACTION'::character varying])::text[])))
);


ALTER TABLE core.action_definition OWNER TO postgres;

--
-- Name: archetype_ability_unlock; Type: TABLE; Schema: core; Owner: postgres
--

CREATE TABLE core.archetype_ability_unlock (
    archetype_id uuid NOT NULL,
    ability_id uuid NOT NULL,
    required_progression numeric(12,2) DEFAULT 0 NOT NULL,
    rpg_system_id uuid NOT NULL
);


ALTER TABLE core.archetype_ability_unlock OWNER TO postgres;

--
-- Name: archetype_definition; Type: TABLE; Schema: core; Owner: postgres
--

CREATE TABLE core.archetype_definition (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    rpg_system_id uuid NOT NULL,
    class_id uuid NOT NULL,
    name character varying(120) NOT NULL,
    slug character varying(100) NOT NULL,
    description text,
    source_ref text
);


ALTER TABLE core.archetype_definition OWNER TO postgres;

--
-- Name: attribute_definition; Type: TABLE; Schema: core; Owner: postgres
--

CREATE TABLE core.attribute_definition (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    rpg_system_id uuid NOT NULL,
    name character varying(100) NOT NULL,
    slug character varying(80) NOT NULL,
    abbreviation character varying(12),
    description text,
    min_value numeric(10,2),
    max_value numeric(10,2),
    default_value numeric(10,2),
    sort_order integer DEFAULT 0 NOT NULL,
    source_ref text,
    CONSTRAINT ck_attribute_definition_valid_range CHECK ((((min_value IS NULL) OR (max_value IS NULL) OR (min_value <= max_value)) AND ((default_value IS NULL) OR (min_value IS NULL) OR (default_value >= min_value)) AND ((default_value IS NULL) OR (max_value IS NULL) OR (default_value <= max_value))))
);


ALTER TABLE core.attribute_definition OWNER TO postgres;

--
-- Name: character_ability; Type: TABLE; Schema: core; Owner: postgres
--

CREATE TABLE core.character_ability (
    character_id uuid NOT NULL,
    ability_id uuid NOT NULL,
    acquisition_source character varying(80),
    acquired_at_progression numeric(12,2),
    notes text,
    rpg_system_id uuid NOT NULL
);


ALTER TABLE core.character_ability OWNER TO postgres;

--
-- Name: character_archetype; Type: TABLE; Schema: core; Owner: postgres
--

CREATE TABLE core.character_archetype (
    character_id uuid NOT NULL,
    archetype_id uuid NOT NULL,
    rpg_system_id uuid NOT NULL
);


ALTER TABLE core.character_archetype OWNER TO postgres;

--
-- Name: character_attack; Type: TABLE; Schema: core; Owner: postgres
--

CREATE TABLE core.character_attack (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    character_id uuid NOT NULL,
    source_item_id uuid,
    skill_id uuid,
    name character varying(160) NOT NULL,
    test_expression character varying(120),
    damage_expression character varying(120),
    damage_type character varying(80),
    attack_bonus numeric(10,2) DEFAULT 0 NOT NULL,
    critical_threshold integer,
    critical_multiplier integer,
    range_text character varying(120),
    special text,
    rpg_system_id uuid NOT NULL
);


ALTER TABLE core.character_attack OWNER TO postgres;

--
-- Name: character_attribute; Type: TABLE; Schema: core; Owner: postgres
--

CREATE TABLE core.character_attribute (
    character_id uuid NOT NULL,
    attribute_id uuid NOT NULL,
    value numeric(10,2) DEFAULT 0 NOT NULL,
    rpg_system_id uuid NOT NULL
);


ALTER TABLE core.character_attribute OWNER TO postgres;

--
-- Name: character_class; Type: TABLE; Schema: core; Owner: postgres
--

CREATE TABLE core.character_class (
    character_id uuid NOT NULL,
    class_id uuid NOT NULL,
    primary_class boolean DEFAULT true NOT NULL,
    rpg_system_id uuid NOT NULL
);


ALTER TABLE core.character_class OWNER TO postgres;

--
-- Name: character_item; Type: TABLE; Schema: core; Owner: postgres
--

CREATE TABLE core.character_item (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    character_id uuid NOT NULL,
    item_id uuid NOT NULL,
    quantity integer DEFAULT 1 NOT NULL,
    equipped boolean DEFAULT false NOT NULL,
    notes text,
    rpg_system_id uuid NOT NULL,
    CONSTRAINT character_item_quantity_check CHECK ((quantity > 0))
);


ALTER TABLE core.character_item OWNER TO postgres;

--
-- Name: character_origin; Type: TABLE; Schema: core; Owner: postgres
--

CREATE TABLE core.character_origin (
    character_id uuid NOT NULL,
    origin_id uuid NOT NULL,
    rpg_system_id uuid NOT NULL
);


ALTER TABLE core.character_origin OWNER TO postgres;

--
-- Name: character_proficiency; Type: TABLE; Schema: core; Owner: postgres
--

CREATE TABLE core.character_proficiency (
    character_id uuid NOT NULL,
    proficiency_id uuid NOT NULL,
    acquisition_source character varying(80),
    rpg_system_id uuid NOT NULL
);


ALTER TABLE core.character_proficiency OWNER TO postgres;

--
-- Name: character_progression; Type: TABLE; Schema: core; Owner: postgres
--

CREATE TABLE core.character_progression (
    character_id uuid NOT NULL,
    progression_id uuid NOT NULL,
    value numeric(12,2) NOT NULL,
    rpg_system_id uuid NOT NULL
);


ALTER TABLE core.character_progression OWNER TO postgres;

--
-- Name: character_resistance; Type: TABLE; Schema: core; Owner: postgres
--

CREATE TABLE core.character_resistance (
    character_id uuid NOT NULL,
    resistance_id uuid NOT NULL,
    value numeric(10,2) DEFAULT 0 NOT NULL,
    rpg_system_id uuid NOT NULL
);


ALTER TABLE core.character_resistance OWNER TO postgres;

--
-- Name: character_resource; Type: TABLE; Schema: core; Owner: postgres
--

CREATE TABLE core.character_resource (
    character_id uuid NOT NULL,
    resource_id uuid NOT NULL,
    current_value numeric(10,2) DEFAULT 0 NOT NULL,
    max_value numeric(10,2) DEFAULT 0 NOT NULL,
    temporary_value numeric(10,2) DEFAULT 0 NOT NULL,
    rpg_system_id uuid NOT NULL,
    CONSTRAINT ck_character_resource_nonnegative_capacity CHECK (((max_value >= (0)::numeric) AND (temporary_value >= (0)::numeric)))
);


ALTER TABLE core.character_resource OWNER TO postgres;

--
-- Name: character_skill; Type: TABLE; Schema: core; Owner: postgres
--

CREATE TABLE core.character_skill (
    character_id uuid NOT NULL,
    skill_id uuid NOT NULL,
    training_level_id uuid,
    other_bonus numeric(10,2) DEFAULT 0 NOT NULL,
    specialization character varying(160),
    rpg_system_id uuid NOT NULL
);


ALTER TABLE core.character_skill OWNER TO postgres;

--
-- Name: character_stat; Type: TABLE; Schema: core; Owner: postgres
--

CREATE TABLE core.character_stat (
    character_id uuid NOT NULL,
    stat_id uuid NOT NULL,
    base_value numeric(10,2) DEFAULT 0 NOT NULL,
    equipment_bonus numeric(10,2) DEFAULT 0 NOT NULL,
    other_bonus numeric(10,2) DEFAULT 0 NOT NULL,
    calculated_value numeric(10,2),
    rpg_system_id uuid NOT NULL
);


ALTER TABLE core.character_stat OWNER TO postgres;

--
-- Name: class_ability_unlock; Type: TABLE; Schema: core; Owner: postgres
--

CREATE TABLE core.class_ability_unlock (
    class_id uuid NOT NULL,
    ability_id uuid NOT NULL,
    required_progression numeric(12,2) DEFAULT 0 NOT NULL,
    rpg_system_id uuid NOT NULL
);


ALTER TABLE core.class_ability_unlock OWNER TO postgres;

--
-- Name: class_definition; Type: TABLE; Schema: core; Owner: postgres
--

CREATE TABLE core.class_definition (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    rpg_system_id uuid NOT NULL,
    name character varying(120) NOT NULL,
    slug character varying(100) NOT NULL,
    description text,
    source_ref text
);


ALTER TABLE core.class_definition OWNER TO postgres;

--
-- Name: class_proficiency; Type: TABLE; Schema: core; Owner: postgres
--

CREATE TABLE core.class_proficiency (
    class_id uuid NOT NULL,
    proficiency_id uuid NOT NULL,
    rpg_system_id uuid NOT NULL
);


ALTER TABLE core.class_proficiency OWNER TO postgres;

--
-- Name: condition_definition; Type: TABLE; Schema: core; Owner: postgres
--

CREATE TABLE core.condition_definition (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    rpg_system_id uuid NOT NULL,
    name character varying(120) NOT NULL,
    slug character varying(120) NOT NULL,
    description text NOT NULL,
    category character varying(40),
    sort_order integer DEFAULT 0 NOT NULL,
    source_ref text,
    metadata jsonb DEFAULT '{}'::jsonb NOT NULL
);


ALTER TABLE core.condition_definition OWNER TO postgres;

--
-- Name: downtime_action_definition; Type: TABLE; Schema: core; Owner: postgres
--

CREATE TABLE core.downtime_action_definition (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    rpg_system_id uuid NOT NULL,
    name character varying(140) NOT NULL,
    slug character varying(140) NOT NULL,
    description text NOT NULL,
    sort_order integer DEFAULT 0 NOT NULL,
    source_ref text,
    metadata jsonb DEFAULT '{}'::jsonb NOT NULL
);


ALTER TABLE core.downtime_action_definition OWNER TO postgres;

--
-- Name: item_definition; Type: TABLE; Schema: core; Owner: postgres
--

CREATE TABLE core.item_definition (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    rpg_system_id uuid NOT NULL,
    item_type_id uuid,
    name character varying(160) NOT NULL,
    slug character varying(140) NOT NULL,
    description text,
    weight numeric(10,2),
    source_ref text,
    search_vector tsvector,
    fuzzy_text text
);


ALTER TABLE core.item_definition OWNER TO postgres;

--
-- Name: item_type; Type: TABLE; Schema: core; Owner: postgres
--

CREATE TABLE core.item_type (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    rpg_system_id uuid NOT NULL,
    parent_id uuid,
    name character varying(100) NOT NULL,
    slug character varying(80) NOT NULL,
    description text,
    source_ref text,
    CONSTRAINT item_type_check CHECK (((parent_id IS NULL) OR (parent_id <> id)))
);


ALTER TABLE core.item_type OWNER TO postgres;

--
-- Name: origin_ability; Type: TABLE; Schema: core; Owner: postgres
--

CREATE TABLE core.origin_ability (
    origin_id uuid NOT NULL,
    ability_id uuid NOT NULL,
    rpg_system_id uuid NOT NULL
);


ALTER TABLE core.origin_ability OWNER TO postgres;

--
-- Name: origin_definition; Type: TABLE; Schema: core; Owner: postgres
--

CREATE TABLE core.origin_definition (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    rpg_system_id uuid NOT NULL,
    name character varying(120) NOT NULL,
    slug character varying(100) NOT NULL,
    description text,
    source_ref text
);


ALTER TABLE core.origin_definition OWNER TO postgres;

--
-- Name: proficiency_definition; Type: TABLE; Schema: core; Owner: postgres
--

CREATE TABLE core.proficiency_definition (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    rpg_system_id uuid NOT NULL,
    name character varying(120) NOT NULL,
    slug character varying(100) NOT NULL,
    proficiency_type character varying(60),
    description text,
    source_ref text
);


ALTER TABLE core.proficiency_definition OWNER TO postgres;

--
-- Name: progression_definition; Type: TABLE; Schema: core; Owner: postgres
--

CREATE TABLE core.progression_definition (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    rpg_system_id uuid NOT NULL,
    name character varying(100) NOT NULL,
    slug character varying(80) NOT NULL,
    abbreviation character varying(16),
    value_type character varying(30) NOT NULL,
    min_value numeric(12,2),
    max_value numeric(12,2),
    description text,
    sort_order integer DEFAULT 0 NOT NULL,
    source_ref text,
    CONSTRAINT ck_progression_definition_valid_range CHECK (((min_value IS NULL) OR (max_value IS NULL) OR (min_value <= max_value))),
    CONSTRAINT progression_definition_value_type_check CHECK (((value_type)::text = ANY ((ARRAY['INTEGER'::character varying, 'DECIMAL'::character varying, 'PERCENTAGE'::character varying])::text[])))
);


ALTER TABLE core.progression_definition OWNER TO postgres;

--
-- Name: progression_tier; Type: TABLE; Schema: core; Owner: postgres
--

CREATE TABLE core.progression_tier (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    progression_id uuid NOT NULL,
    name character varying(100) NOT NULL,
    slug character varying(80) NOT NULL,
    required_value numeric(12,2) NOT NULL,
    rule_data jsonb DEFAULT '{}'::jsonb NOT NULL,
    sort_order integer DEFAULT 0 NOT NULL,
    source_ref text,
    rpg_system_id uuid NOT NULL
);


ALTER TABLE core.progression_tier OWNER TO postgres;

--
-- Name: resistance_definition; Type: TABLE; Schema: core; Owner: postgres
--

CREATE TABLE core.resistance_definition (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    rpg_system_id uuid NOT NULL,
    name character varying(120) NOT NULL,
    slug character varying(100) NOT NULL,
    description text,
    source_ref text
);


ALTER TABLE core.resistance_definition OWNER TO postgres;

--
-- Name: resource_definition; Type: TABLE; Schema: core; Owner: postgres
--

CREATE TABLE core.resource_definition (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    rpg_system_id uuid NOT NULL,
    name character varying(100) NOT NULL,
    slug character varying(80) NOT NULL,
    abbreviation character varying(16),
    description text,
    sort_order integer DEFAULT 0 NOT NULL,
    source_ref text
);


ALTER TABLE core.resource_definition OWNER TO postgres;

--
-- Name: rpg_character; Type: TABLE; Schema: core; Owner: postgres
--

CREATE TABLE core.rpg_character (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    rpg_system_id uuid NOT NULL,
    name character varying(160) NOT NULL,
    character_type character varying(30) NOT NULL,
    description text,
    image_url text,
    appearance text,
    personality text,
    background text,
    objective text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT rpg_character_character_type_check CHECK (((character_type)::text = ANY ((ARRAY['PLAYER'::character varying, 'NPC'::character varying, 'THREAT'::character varying])::text[])))
);


ALTER TABLE core.rpg_character OWNER TO postgres;

--
-- Name: rpg_system; Type: TABLE; Schema: core; Owner: postgres
--

CREATE TABLE core.rpg_system (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name character varying(120) NOT NULL,
    slug character varying(80) NOT NULL,
    version character varying(40),
    description text,
    source_ref text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE core.rpg_system OWNER TO postgres;

--
-- Name: search_synonym; Type: TABLE; Schema: core; Owner: postgres
--

CREATE TABLE core.search_synonym (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    domain character varying(20) NOT NULL,
    term text NOT NULL,
    synonym text NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT search_synonym_check CHECK ((lower(btrim(term)) <> lower(btrim(synonym)))),
    CONSTRAINT search_synonym_domain_check CHECK (((domain)::text = ANY ((ARRAY['GLOBAL'::character varying, 'ITEM'::character varying, 'THREAT'::character varying])::text[]))),
    CONSTRAINT search_synonym_synonym_check CHECK ((btrim(synonym) <> ''::text)),
    CONSTRAINT search_synonym_term_check CHECK ((btrim(term) <> ''::text))
);


ALTER TABLE core.search_synonym OWNER TO postgres;

--
-- Name: TABLE search_synonym; Type: COMMENT; Schema: core; Owner: postgres
--

COMMENT ON TABLE core.search_synonym IS 'Sinônimos bidirecionais usados para expandir consultas FTS.';


--
-- Name: skill_definition; Type: TABLE; Schema: core; Owner: postgres
--

CREATE TABLE core.skill_definition (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    rpg_system_id uuid NOT NULL,
    base_attribute_id uuid,
    name character varying(120) NOT NULL,
    slug character varying(100) NOT NULL,
    description text,
    allows_specialization boolean DEFAULT false NOT NULL,
    sort_order integer DEFAULT 0 NOT NULL,
    source_ref text
);


ALTER TABLE core.skill_definition OWNER TO postgres;

--
-- Name: skill_training_level; Type: TABLE; Schema: core; Owner: postgres
--

CREATE TABLE core.skill_training_level (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    rpg_system_id uuid NOT NULL,
    name character varying(80) NOT NULL,
    slug character varying(60) NOT NULL,
    bonus numeric(10,2) DEFAULT 0 NOT NULL,
    sort_order integer DEFAULT 0 NOT NULL,
    source_ref text
);


ALTER TABLE core.skill_training_level OWNER TO postgres;

--
-- Name: stat_definition; Type: TABLE; Schema: core; Owner: postgres
--

CREATE TABLE core.stat_definition (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    rpg_system_id uuid NOT NULL,
    name character varying(100) NOT NULL,
    slug character varying(80) NOT NULL,
    abbreviation character varying(16),
    description text,
    sort_order integer DEFAULT 0 NOT NULL,
    source_ref text
);


ALTER TABLE core.stat_definition OWNER TO postgres;

--
-- Name: ammunition; Type: TABLE; Schema: ordem; Owner: postgres
--

CREATE TABLE ordem.ammunition (
    item_id uuid NOT NULL,
    duration_text character varying(120),
    source_ref text
);


ALTER TABLE ordem.ammunition OWNER TO postgres;

--
-- Name: being_type; Type: TABLE; Schema: ordem; Owner: postgres
--

CREATE TABLE ordem.being_type (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name character varying(100) NOT NULL,
    slug character varying(80) NOT NULL,
    description text,
    source_ref text
);


ALTER TABLE ordem.being_type OWNER TO postgres;

--
-- Name: character_detail; Type: TABLE; Schema: ordem; Owner: postgres
--

CREATE TABLE ordem.character_detail (
    character_id uuid NOT NULL,
    credit_limit character varying(20),
    CONSTRAINT character_detail_credit_limit_check CHECK (((credit_limit IS NULL) OR ((credit_limit)::text = ANY ((ARRAY['BAIXO'::character varying, 'MEDIO'::character varying, 'ALTO'::character varying, 'ILIMITADO'::character varying])::text[]))))
);


ALTER TABLE ordem.character_detail OWNER TO postgres;

--
-- Name: class_rule; Type: TABLE; Schema: ordem; Owner: postgres
--

CREATE TABLE ordem.class_rule (
    class_id uuid NOT NULL,
    initial_pv_base integer NOT NULL,
    initial_pv_attribute character varying(12),
    pv_per_nex_base integer NOT NULL,
    pv_per_nex_attribute character varying(12),
    initial_pe_base integer NOT NULL,
    initial_pe_attribute character varying(12),
    pe_per_nex_base integer NOT NULL,
    pe_per_nex_attribute character varying(12),
    initial_san integer NOT NULL,
    san_per_nex integer NOT NULL,
    trained_skills_rule text NOT NULL,
    source_ref text
);


ALTER TABLE ordem.class_rule OWNER TO postgres;

--
-- Name: combat_action_rule; Type: TABLE; Schema: ordem; Owner: postgres
--

CREATE TABLE ordem.combat_action_rule (
    action_id uuid NOT NULL,
    required_skill_id uuid,
    requires_training boolean DEFAULT false NOT NULL,
    attack_dice_modifier integer,
    attack_flat_modifier integer,
    defense_modifier integer,
    movement_multiplier numeric(5,2),
    minimum_movement_m numeric(6,2),
    requires_melee_attack boolean DEFAULT false NOT NULL,
    requires_ranged_attack boolean DEFAULT false NOT NULL,
    requires_visible_target boolean DEFAULT false NOT NULL,
    rule_data jsonb DEFAULT '{}'::jsonb NOT NULL,
    source_ref text
);


ALTER TABLE ordem.combat_action_rule OWNER TO postgres;

--
-- Name: combat_maneuver; Type: TABLE; Schema: ordem; Owner: postgres
--

CREATE TABLE ordem.combat_maneuver (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name character varying(120) NOT NULL,
    slug character varying(120) NOT NULL,
    base_skill_id uuid,
    opposed_skill_id uuid,
    action_id uuid,
    effect_condition_id uuid,
    movement_on_success_m numeric(6,2),
    extra_effect_per_margin integer,
    size_rule text,
    description text NOT NULL,
    rule_data jsonb DEFAULT '{}'::jsonb NOT NULL,
    source_ref text
);


ALTER TABLE ordem.combat_maneuver OWNER TO postgres;

--
-- Name: combat_situation_modifier; Type: TABLE; Schema: ordem; Owner: postgres
--

CREATE TABLE ordem.combat_situation_modifier (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name character varying(140) NOT NULL,
    slug character varying(140) NOT NULL,
    applies_to character varying(30) NOT NULL,
    attack_dice_modifier integer,
    defense_modifier integer,
    failure_chance_percent integer,
    prevents_attack boolean DEFAULT false NOT NULL,
    melee_only boolean DEFAULT false NOT NULL,
    ranged_only boolean DEFAULT false NOT NULL,
    description text NOT NULL,
    rule_data jsonb DEFAULT '{}'::jsonb NOT NULL,
    source_ref text,
    CONSTRAINT combat_situation_modifier_applies_to_check CHECK (((applies_to)::text = ANY ((ARRAY['ATTACKER'::character varying, 'TARGET'::character varying, 'ENVIRONMENT'::character varying])::text[]))),
    CONSTRAINT combat_situation_modifier_failure_chance_percent_check CHECK (((failure_chance_percent IS NULL) OR ((failure_chance_percent >= 0) AND (failure_chance_percent <= 100))))
);


ALTER TABLE ordem.combat_situation_modifier OWNER TO postgres;

--
-- Name: combat_turn_rule; Type: TABLE; Schema: ordem; Owner: postgres
--

CREATE TABLE ordem.combat_turn_rule (
    id smallint NOT NULL,
    standard_actions integer NOT NULL,
    movement_actions integer NOT NULL,
    can_standard_be_movement boolean NOT NULL,
    can_movement_be_standard boolean NOT NULL,
    full_replaces_standard boolean NOT NULL,
    full_replaces_movement boolean NOT NULL,
    free_actions_unbounded boolean NOT NULL,
    reactions_unbounded boolean NOT NULL,
    round_duration_seconds integer NOT NULL,
    source_ref text,
    CONSTRAINT combat_turn_rule_id_check CHECK ((id = 1))
);


ALTER TABLE ordem.combat_turn_rule OWNER TO postgres;

--
-- Name: condition_relation; Type: TABLE; Schema: ordem; Owner: postgres
--

CREATE TABLE ordem.condition_relation (
    condition_id uuid NOT NULL,
    related_condition_id uuid NOT NULL,
    relation_type character varying(30) NOT NULL,
    source_ref text,
    CONSTRAINT condition_relation_check CHECK ((condition_id <> related_condition_id)),
    CONSTRAINT condition_relation_relation_type_check CHECK (((relation_type)::text = ANY ((ARRAY['IMPOSES'::character varying, 'REAPPLY_BECOMES'::character varying, 'COUNTS_AS'::character varying])::text[])))
);


ALTER TABLE ordem.condition_relation OWNER TO postgres;

--
-- Name: condition_rule; Type: TABLE; Schema: ordem; Owner: postgres
--

CREATE TABLE ordem.condition_rule (
    condition_id uuid NOT NULL,
    movement_effect text,
    defense_effect text,
    action_effect text,
    attack_effect text,
    skill_effect text,
    recovery_text text,
    default_end character varying(40) DEFAULT 'END_OF_SCENE'::character varying NOT NULL,
    stacks boolean DEFAULT false NOT NULL,
    source_ref text,
    rule_data jsonb DEFAULT '{}'::jsonb NOT NULL,
    CONSTRAINT condition_rule_default_end_check CHECK (((default_end)::text = ANY ((ARRAY['END_OF_SCENE'::character varying, 'SPECIAL'::character varying, 'SOURCE_DEFINED'::character varying])::text[])))
);


ALTER TABLE ordem.condition_rule OWNER TO postgres;

--
-- Name: curse_definition; Type: TABLE; Schema: ordem; Owner: postgres
--

CREATE TABLE ordem.curse_definition (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    element_id uuid,
    name character varying(120) NOT NULL,
    slug character varying(160) NOT NULL,
    applies_to character varying(20) NOT NULL,
    variable_element boolean DEFAULT false NOT NULL,
    effect_summary text NOT NULL,
    source_ref text,
    CONSTRAINT curse_definition_applies_to_check CHECK (((applies_to)::text = ANY ((ARRAY['WEAPON'::character varying, 'PROTECTION'::character varying, 'ACCESSORY'::character varying])::text[]))),
    CONSTRAINT curse_definition_check CHECK ((((variable_element = false) AND (element_id IS NOT NULL)) OR ((variable_element = true) AND (element_id IS NULL))))
);


ALTER TABLE ordem.curse_definition OWNER TO postgres;

--
-- Name: curse_price_rule; Type: TABLE; Schema: ordem; Owner: postgres
--

CREATE TABLE ordem.curse_price_rule (
    element_id uuid NOT NULL,
    trigger_attribute_slugs text[] DEFAULT '{}'::text[] NOT NULL,
    sanity_loss_per_curse integer,
    custom_price boolean DEFAULT false NOT NULL,
    rule_summary text NOT NULL,
    source_ref text,
    CONSTRAINT curse_price_rule_sanity_loss_per_curse_check CHECK (((sanity_loss_per_curse IS NULL) OR (sanity_loss_per_curse >= 0)))
);


ALTER TABLE ordem.curse_price_rule OWNER TO postgres;

--
-- Name: cursed_item_rule; Type: TABLE; Schema: ordem; Owner: postgres
--

CREATE TABLE ordem.cursed_item_rule (
    id smallint NOT NULL,
    first_curse_category_increase integer NOT NULL,
    subsequent_curse_category_increase integer NOT NULL,
    hp_bonus_per_curse integer NOT NULL,
    rd_bonus_per_curse integer NOT NULL,
    resistance_test_bonus_per_curse integer NOT NULL,
    minimum_patent_slug character varying(120),
    same_curse_stacks boolean DEFAULT false NOT NULL,
    cursed_item_bonuses_stack boolean DEFAULT false NOT NULL,
    rule_summary text NOT NULL,
    source_ref text,
    CONSTRAINT cursed_item_rule_first_curse_category_increase_check CHECK ((first_curse_category_increase >= 0)),
    CONSTRAINT cursed_item_rule_hp_bonus_per_curse_check CHECK ((hp_bonus_per_curse >= 0)),
    CONSTRAINT cursed_item_rule_id_check CHECK ((id = 1)),
    CONSTRAINT cursed_item_rule_rd_bonus_per_curse_check CHECK ((rd_bonus_per_curse >= 0)),
    CONSTRAINT cursed_item_rule_resistance_test_bonus_per_curse_check CHECK ((resistance_test_bonus_per_curse >= 0)),
    CONSTRAINT cursed_item_rule_subsequent_curse_category_increase_check CHECK ((subsequent_curse_category_increase >= 0))
);


ALTER TABLE ordem.cursed_item_rule OWNER TO postgres;

--
-- Name: defensive_reaction_rule; Type: TABLE; Schema: ordem; Owner: postgres
--

CREATE TABLE ordem.defensive_reaction_rule (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name character varying(120) NOT NULL,
    slug character varying(120) NOT NULL,
    required_skill_id uuid NOT NULL,
    trigger_text text NOT NULL,
    effect_text text NOT NULL,
    once_per_round_group character varying(80) DEFAULT 'special-defense'::character varying NOT NULL,
    rule_data jsonb DEFAULT '{}'::jsonb NOT NULL,
    source_ref text
);


ALTER TABLE ordem.defensive_reaction_rule OWNER TO postgres;

--
-- Name: element; Type: TABLE; Schema: ordem; Owner: postgres
--

CREATE TABLE ordem.element (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name character varying(100) NOT NULL,
    slug character varying(80) NOT NULL,
    description text,
    source_ref text
);


ALTER TABLE ordem.element OWNER TO postgres;

--
-- Name: interlude_action_rule; Type: TABLE; Schema: ordem; Owner: postgres
--

CREATE TABLE ordem.interlude_action_rule (
    action_id uuid NOT NULL,
    max_uses_per_interlude integer,
    repeatable boolean DEFAULT false NOT NULL,
    base_resource character varying(20),
    recovery_basis character varying(40),
    test_bonus_expression character varying(60),
    bonus_attribute_limit character varying(10),
    effect_summary text NOT NULL,
    rule_data jsonb DEFAULT '{}'::jsonb NOT NULL,
    source_ref text,
    CONSTRAINT interlude_action_rule_base_resource_check CHECK (((base_resource IS NULL) OR ((base_resource)::text = ANY ((ARRAY['PV'::character varying, 'PE'::character varying, 'SAN'::character varying])::text[])))),
    CONSTRAINT interlude_action_rule_bonus_attribute_limit_check CHECK (((bonus_attribute_limit IS NULL) OR ((bonus_attribute_limit)::text = ANY ((ARRAY['AGI'::character varying, 'FOR'::character varying, 'INT'::character varying, 'PRE'::character varying, 'VIG'::character varying])::text[])))),
    CONSTRAINT interlude_action_rule_max_uses_per_interlude_check CHECK (((max_uses_per_interlude IS NULL) OR (max_uses_per_interlude > 0))),
    CONSTRAINT interlude_action_rule_recovery_basis_check CHECK (((recovery_basis IS NULL) OR ((recovery_basis)::text = ANY ((ARRAY['PE_LIMIT'::character varying, 'REST_LIKE_SLEEP'::character varying, 'FULL_ITEM_HP'::character varying, 'NONE'::character varying])::text[]))))
);


ALTER TABLE ordem.interlude_action_rule OWNER TO postgres;

--
-- Name: interlude_meal_option; Type: TABLE; Schema: ordem; Owner: postgres
--

CREATE TABLE ordem.interlude_meal_option (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name character varying(120) NOT NULL,
    slug character varying(120) NOT NULL,
    related_action_slug character varying(140),
    effect_summary text NOT NULL,
    rule_data jsonb DEFAULT '{}'::jsonb NOT NULL,
    source_ref text
);


ALTER TABLE ordem.interlude_meal_option OWNER TO postgres;

--
-- Name: interlude_rule; Type: TABLE; Schema: ordem; Owner: postgres
--

CREATE TABLE ordem.interlude_rule (
    id smallint NOT NULL,
    max_actions_per_character integer NOT NULL,
    fixed_duration boolean DEFAULT false NOT NULL,
    requires_safe_place boolean DEFAULT true NOT NULL,
    description text NOT NULL,
    rule_data jsonb DEFAULT '{}'::jsonb NOT NULL,
    source_ref text,
    CONSTRAINT interlude_rule_id_check CHECK ((id = 1)),
    CONSTRAINT interlude_rule_max_actions_per_character_check CHECK ((max_actions_per_character > 0))
);


ALTER TABLE ordem.interlude_rule OWNER TO postgres;

--
-- Name: item_modification; Type: TABLE; Schema: ordem; Owner: postgres
--

CREATE TABLE ordem.item_modification (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name character varying(120) NOT NULL,
    slug character varying(120) NOT NULL,
    applies_to character varying(40) NOT NULL,
    category_increase integer DEFAULT 1 NOT NULL,
    effect_summary text NOT NULL,
    source_ref text,
    CONSTRAINT item_modification_applies_to_check CHECK (((applies_to)::text = ANY ((ARRAY['MELEE_PROJECTILE'::character varying, 'FIREARM'::character varying, 'AMMUNITION'::character varying, 'PROTECTION'::character varying, 'ACCESSORY'::character varying])::text[]))),
    CONSTRAINT item_modification_category_increase_check CHECK ((category_increase >= 0))
);


ALTER TABLE ordem.item_modification OWNER TO postgres;

--
-- Name: item_rule; Type: TABLE; Schema: ordem; Owner: postgres
--

CREATE TABLE ordem.item_rule (
    item_id uuid NOT NULL,
    inventory_category integer,
    spaces integer,
    special_spaces_rule text,
    source_ref text,
    CONSTRAINT item_rule_inventory_category_check CHECK (((inventory_category IS NULL) OR ((inventory_category >= 0) AND (inventory_category <= 4)))),
    CONSTRAINT item_rule_spaces_check CHECK (((spaces IS NULL) OR (spaces >= 0)))
);


ALTER TABLE ordem.item_rule OWNER TO postgres;

--
-- Name: movement_rule; Type: TABLE; Schema: ordem; Owner: postgres
--

CREATE TABLE ordem.movement_rule (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name character varying(140) NOT NULL,
    slug character varying(140) NOT NULL,
    multiplier numeric(6,3),
    flat_modifier_m numeric(6,2),
    description text NOT NULL,
    rule_data jsonb DEFAULT '{}'::jsonb NOT NULL,
    source_ref text
);


ALTER TABLE ordem.movement_rule OWNER TO postgres;

--
-- Name: nex_rule; Type: TABLE; Schema: ordem; Owner: postgres
--

CREATE TABLE ordem.nex_rule (
    nex integer NOT NULL,
    pe_limit integer NOT NULL,
    source_ref text,
    CONSTRAINT nex_rule_nex_check CHECK (((nex >= 0) AND (nex <= 100))),
    CONSTRAINT nex_rule_pe_limit_check CHECK ((pe_limit >= 0))
);


ALTER TABLE ordem.nex_rule OWNER TO postgres;

--
-- Name: origin_skill_grant; Type: TABLE; Schema: ordem; Owner: postgres
--

CREATE TABLE ordem.origin_skill_grant (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    origin_id uuid NOT NULL,
    skill_id uuid,
    grant_group integer DEFAULT 1 NOT NULL,
    choice_count integer DEFAULT 0 NOT NULL,
    master_choice boolean DEFAULT false NOT NULL,
    notes text,
    CONSTRAINT origin_skill_grant_choice_count_check CHECK ((choice_count >= 0))
);


ALTER TABLE ordem.origin_skill_grant OWNER TO postgres;

--
-- Name: patent_rule; Type: TABLE; Schema: ordem; Owner: postgres
--

CREATE TABLE ordem.patent_rule (
    progression_tier_id uuid NOT NULL,
    credit_limit character varying(20) NOT NULL,
    category_i_limit integer DEFAULT 0 NOT NULL,
    category_ii_limit integer DEFAULT 0 NOT NULL,
    category_iii_limit integer DEFAULT 0 NOT NULL,
    category_iv_limit integer DEFAULT 0 NOT NULL,
    source_ref text,
    CONSTRAINT patent_rule_category_i_limit_check CHECK ((category_i_limit >= 0)),
    CONSTRAINT patent_rule_category_ii_limit_check CHECK ((category_ii_limit >= 0)),
    CONSTRAINT patent_rule_category_iii_limit_check CHECK ((category_iii_limit >= 0)),
    CONSTRAINT patent_rule_category_iv_limit_check CHECK ((category_iv_limit >= 0)),
    CONSTRAINT patent_rule_credit_limit_check CHECK (((credit_limit)::text = ANY ((ARRAY['BAIXO'::character varying, 'MEDIO'::character varying, 'ALTO'::character varying, 'ILIMITADO'::character varying])::text[])))
);


ALTER TABLE ordem.patent_rule OWNER TO postgres;

--
-- Name: protection; Type: TABLE; Schema: ordem; Owner: postgres
--

CREATE TABLE ordem.protection (
    item_id uuid NOT NULL,
    proficiency_id uuid,
    defense_bonus integer DEFAULT 0 NOT NULL,
    rd_text text,
    load_penalty_value integer,
    source_ref text
);


ALTER TABLE ordem.protection OWNER TO postgres;

--
-- Name: rest_condition; Type: TABLE; Schema: ordem; Owner: postgres
--

CREATE TABLE ordem.rest_condition (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name character varying(100) NOT NULL,
    slug character varying(100) NOT NULL,
    recovery_multiplier numeric(5,2) NOT NULL,
    sort_order integer DEFAULT 0 NOT NULL,
    description text NOT NULL,
    source_ref text,
    CONSTRAINT rest_condition_recovery_multiplier_check CHECK ((recovery_multiplier >= (0)::numeric))
);


ALTER TABLE ordem.rest_condition OWNER TO postgres;

--
-- Name: ritual; Type: TABLE; Schema: ordem; Owner: postgres
--

CREATE TABLE ordem.ritual (
    ability_id uuid NOT NULL,
    element_id uuid NOT NULL,
    circle integer NOT NULL,
    pe_cost integer,
    execution character varying(120),
    range_text character varying(120),
    target_text character varying(180),
    area_text character varying(180),
    duration_text character varying(120),
    resistance_text character varying(180),
    source_ref text,
    CONSTRAINT ritual_circle_check CHECK (((circle >= 1) AND (circle <= 4))),
    CONSTRAINT ritual_pe_cost_check CHECK (((pe_cost IS NULL) OR (pe_cost >= 0)))
);


ALTER TABLE ordem.ritual OWNER TO postgres;

--
-- Name: skill_rule; Type: TABLE; Schema: ordem; Owner: postgres
--

CREATE TABLE ordem.skill_rule (
    skill_id uuid NOT NULL,
    trained_only boolean DEFAULT false NOT NULL,
    load_penalty boolean DEFAULT false NOT NULL,
    requires_kit boolean DEFAULT false NOT NULL
);


ALTER TABLE ordem.skill_rule OWNER TO postgres;

--
-- Name: special_cursed_item; Type: TABLE; Schema: ordem; Owner: postgres
--

CREATE TABLE ordem.special_cursed_item (
    item_id uuid NOT NULL,
    element_id uuid NOT NULL,
    curse_count integer DEFAULT 1 NOT NULL,
    unique_item boolean DEFAULT false NOT NULL,
    effect_summary text NOT NULL,
    source_ref text,
    CONSTRAINT special_cursed_item_curse_count_check CHECK ((curse_count > 0))
);


ALTER TABLE ordem.special_cursed_item OWNER TO postgres;

--
-- Name: threat; Type: TABLE; Schema: ordem; Owner: postgres
--

CREATE TABLE ordem.threat (
    character_id uuid NOT NULL,
    being_type_id uuid,
    challenge_value integer,
    size character varying(60),
    disturbing_presence text,
    senses text,
    slug character varying(180),
    size_id uuid,
    source_ref text,
    defense integer,
    hit_points integer,
    wounded_at integer,
    agility integer,
    strength integer,
    intellect integer,
    presence integer,
    vigor integer,
    perception_test character varying(80),
    initiative_test character varying(80),
    fortitude_test character varying(80),
    reflexes_test character varying(80),
    will_test character varying(80),
    movement_text text,
    presence_dt integer,
    presence_damage character varying(60),
    presence_immune_nex integer,
    fear_enigma_summary text,
    statblock_data jsonb DEFAULT '{}'::jsonb NOT NULL,
    search_vector tsvector,
    fuzzy_text text,
    CONSTRAINT ck_ordem_threat_nonnegative_main_stats CHECK ((((defense IS NULL) OR (defense >= 0)) AND ((hit_points IS NULL) OR (hit_points >= 0)) AND ((wounded_at IS NULL) OR (wounded_at >= 0)) AND ((presence_dt IS NULL) OR (presence_dt >= 0)) AND ((presence_immune_nex IS NULL) OR ((presence_immune_nex >= 0) AND (presence_immune_nex <= 100))))),
    CONSTRAINT threat_challenge_value_check CHECK (((challenge_value IS NULL) OR (challenge_value >= 0)))
);


ALTER TABLE ordem.threat OWNER TO postgres;

--
-- Name: threat_ability; Type: TABLE; Schema: ordem; Owner: postgres
--

CREATE TABLE ordem.threat_ability (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    threat_id uuid NOT NULL,
    name character varying(180) NOT NULL,
    effect_summary text,
    sort_order integer DEFAULT 0 NOT NULL,
    source_ref text
);


ALTER TABLE ordem.threat_ability OWNER TO postgres;

--
-- Name: threat_action; Type: TABLE; Schema: ordem; Owner: postgres
--

CREATE TABLE ordem.threat_action (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    threat_id uuid NOT NULL,
    name character varying(160) NOT NULL,
    action_type character varying(80),
    description text,
    test_expression character varying(120),
    damage_expression character varying(120),
    sort_order integer DEFAULT 0 NOT NULL,
    attack_count integer,
    range_text character varying(120),
    critical character varying(80),
    damage_type character varying(100),
    resistance_text character varying(180),
    source_ref text,
    mechanics_data jsonb DEFAULT '{}'::jsonb NOT NULL,
    CONSTRAINT ck_ordem_threat_action_attack_count CHECK (((attack_count IS NULL) OR (attack_count > 0)))
);


ALTER TABLE ordem.threat_action OWNER TO postgres;

--
-- Name: threat_defense_trait; Type: TABLE; Schema: ordem; Owner: postgres
--

CREATE TABLE ordem.threat_defense_trait (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    threat_id uuid NOT NULL,
    trait_type character varying(20) NOT NULL,
    name character varying(180) NOT NULL,
    value_text character varying(120),
    sort_order integer DEFAULT 0 NOT NULL,
    source_ref text,
    CONSTRAINT threat_defense_trait_trait_type_check CHECK (((trait_type)::text = ANY ((ARRAY['RESISTANCE'::character varying, 'IMMUNITY'::character varying, 'VULNERABILITY'::character varying])::text[])))
);


ALTER TABLE ordem.threat_defense_trait OWNER TO postgres;

--
-- Name: threat_descriptor; Type: TABLE; Schema: ordem; Owner: postgres
--

CREATE TABLE ordem.threat_descriptor (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    threat_id uuid NOT NULL,
    descriptor character varying(100) NOT NULL,
    sort_order integer DEFAULT 0 NOT NULL,
    source_ref text
);


ALTER TABLE ordem.threat_descriptor OWNER TO postgres;

--
-- Name: threat_element; Type: TABLE; Schema: ordem; Owner: postgres
--

CREATE TABLE ordem.threat_element (
    threat_id uuid NOT NULL,
    element_id uuid NOT NULL,
    is_primary boolean DEFAULT false NOT NULL,
    sort_order integer DEFAULT 0 NOT NULL,
    source_ref text
);


ALTER TABLE ordem.threat_element OWNER TO postgres;

--
-- Name: threat_size; Type: TABLE; Schema: ordem; Owner: postgres
--

CREATE TABLE ordem.threat_size (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name character varying(40) NOT NULL,
    slug character varying(40) NOT NULL,
    occupied_space_m numeric(5,2) NOT NULL,
    natural_reach_m numeric(5,2) NOT NULL,
    stealth_modifier integer NOT NULL,
    maneuver_modifier integer NOT NULL,
    sort_order integer DEFAULT 0 NOT NULL,
    source_ref text,
    CONSTRAINT threat_size_natural_reach_m_check CHECK ((natural_reach_m > (0)::numeric)),
    CONSTRAINT threat_size_occupied_space_m_check CHECK ((occupied_space_m > (0)::numeric))
);


ALTER TABLE ordem.threat_size OWNER TO postgres;

--
-- Name: threat_skill; Type: TABLE; Schema: ordem; Owner: postgres
--

CREATE TABLE ordem.threat_skill (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    threat_id uuid NOT NULL,
    skill_id uuid,
    skill_name character varying(120) NOT NULL,
    test_expression character varying(80) NOT NULL,
    sort_order integer DEFAULT 0 NOT NULL,
    source_ref text
);


ALTER TABLE ordem.threat_skill OWNER TO postgres;

--
-- Name: weapon; Type: TABLE; Schema: ordem; Owner: postgres
--

CREATE TABLE ordem.weapon (
    item_id uuid NOT NULL,
    proficiency_id uuid,
    weapon_kind character varying(30) NOT NULL,
    grip character varying(30),
    damage character varying(60) NOT NULL,
    critical character varying(40),
    range_text character varying(120),
    damage_type character varying(80),
    agile boolean DEFAULT false NOT NULL,
    automatic boolean DEFAULT false NOT NULL,
    ammunition_item_id uuid,
    source_ref text,
    CONSTRAINT weapon_grip_check CHECK (((grip IS NULL) OR ((grip)::text = ANY ((ARRAY['LIGHT'::character varying, 'ONE_HAND'::character varying, 'TWO_HAND'::character varying])::text[])))),
    CONSTRAINT weapon_weapon_kind_check CHECK (((weapon_kind)::text = ANY ((ARRAY['MELEE'::character varying, 'THROWN'::character varying, 'PROJECTILE'::character varying, 'FIREARM'::character varying])::text[])))
);


ALTER TABLE ordem.weapon OWNER TO postgres;

--
-- Name: ability_definition ability_definition_pkey; Type: CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.ability_definition
    ADD CONSTRAINT ability_definition_pkey PRIMARY KEY (id);


--
-- Name: ability_definition ability_definition_rpg_system_id_slug_key; Type: CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.ability_definition
    ADD CONSTRAINT ability_definition_rpg_system_id_slug_key UNIQUE (rpg_system_id, slug);


--
-- Name: action_definition action_definition_pkey; Type: CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.action_definition
    ADD CONSTRAINT action_definition_pkey PRIMARY KEY (id);


--
-- Name: action_definition action_definition_rpg_system_id_slug_key; Type: CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.action_definition
    ADD CONSTRAINT action_definition_rpg_system_id_slug_key UNIQUE (rpg_system_id, slug);


--
-- Name: archetype_ability_unlock archetype_ability_unlock_pkey; Type: CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.archetype_ability_unlock
    ADD CONSTRAINT archetype_ability_unlock_pkey PRIMARY KEY (archetype_id, ability_id, required_progression);


--
-- Name: archetype_definition archetype_definition_pkey; Type: CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.archetype_definition
    ADD CONSTRAINT archetype_definition_pkey PRIMARY KEY (id);


--
-- Name: archetype_definition archetype_definition_rpg_system_id_slug_key; Type: CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.archetype_definition
    ADD CONSTRAINT archetype_definition_rpg_system_id_slug_key UNIQUE (rpg_system_id, slug);


--
-- Name: attribute_definition attribute_definition_pkey; Type: CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.attribute_definition
    ADD CONSTRAINT attribute_definition_pkey PRIMARY KEY (id);


--
-- Name: attribute_definition attribute_definition_rpg_system_id_slug_key; Type: CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.attribute_definition
    ADD CONSTRAINT attribute_definition_rpg_system_id_slug_key UNIQUE (rpg_system_id, slug);


--
-- Name: character_ability character_ability_pkey; Type: CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.character_ability
    ADD CONSTRAINT character_ability_pkey PRIMARY KEY (character_id, ability_id);


--
-- Name: character_archetype character_archetype_pkey; Type: CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.character_archetype
    ADD CONSTRAINT character_archetype_pkey PRIMARY KEY (character_id);


--
-- Name: character_attack character_attack_pkey; Type: CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.character_attack
    ADD CONSTRAINT character_attack_pkey PRIMARY KEY (id);


--
-- Name: character_attribute character_attribute_pkey; Type: CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.character_attribute
    ADD CONSTRAINT character_attribute_pkey PRIMARY KEY (character_id, attribute_id);


--
-- Name: character_class character_class_pkey; Type: CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.character_class
    ADD CONSTRAINT character_class_pkey PRIMARY KEY (character_id, class_id);


--
-- Name: character_item character_item_pkey; Type: CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.character_item
    ADD CONSTRAINT character_item_pkey PRIMARY KEY (id);


--
-- Name: character_origin character_origin_pkey; Type: CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.character_origin
    ADD CONSTRAINT character_origin_pkey PRIMARY KEY (character_id);


--
-- Name: character_proficiency character_proficiency_pkey; Type: CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.character_proficiency
    ADD CONSTRAINT character_proficiency_pkey PRIMARY KEY (character_id, proficiency_id);


--
-- Name: character_progression character_progression_pkey; Type: CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.character_progression
    ADD CONSTRAINT character_progression_pkey PRIMARY KEY (character_id, progression_id);


--
-- Name: character_resistance character_resistance_pkey; Type: CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.character_resistance
    ADD CONSTRAINT character_resistance_pkey PRIMARY KEY (character_id, resistance_id);


--
-- Name: character_resource character_resource_pkey; Type: CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.character_resource
    ADD CONSTRAINT character_resource_pkey PRIMARY KEY (character_id, resource_id);


--
-- Name: character_skill character_skill_pkey; Type: CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.character_skill
    ADD CONSTRAINT character_skill_pkey PRIMARY KEY (character_id, skill_id);


--
-- Name: character_stat character_stat_pkey; Type: CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.character_stat
    ADD CONSTRAINT character_stat_pkey PRIMARY KEY (character_id, stat_id);


--
-- Name: class_ability_unlock class_ability_unlock_pkey; Type: CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.class_ability_unlock
    ADD CONSTRAINT class_ability_unlock_pkey PRIMARY KEY (class_id, ability_id, required_progression);


--
-- Name: class_definition class_definition_pkey; Type: CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.class_definition
    ADD CONSTRAINT class_definition_pkey PRIMARY KEY (id);


--
-- Name: class_definition class_definition_rpg_system_id_slug_key; Type: CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.class_definition
    ADD CONSTRAINT class_definition_rpg_system_id_slug_key UNIQUE (rpg_system_id, slug);


--
-- Name: class_proficiency class_proficiency_pkey; Type: CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.class_proficiency
    ADD CONSTRAINT class_proficiency_pkey PRIMARY KEY (class_id, proficiency_id);


--
-- Name: condition_definition condition_definition_pkey; Type: CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.condition_definition
    ADD CONSTRAINT condition_definition_pkey PRIMARY KEY (id);


--
-- Name: condition_definition condition_definition_rpg_system_id_slug_key; Type: CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.condition_definition
    ADD CONSTRAINT condition_definition_rpg_system_id_slug_key UNIQUE (rpg_system_id, slug);


--
-- Name: downtime_action_definition downtime_action_definition_pkey; Type: CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.downtime_action_definition
    ADD CONSTRAINT downtime_action_definition_pkey PRIMARY KEY (id);


--
-- Name: downtime_action_definition downtime_action_definition_rpg_system_id_slug_key; Type: CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.downtime_action_definition
    ADD CONSTRAINT downtime_action_definition_rpg_system_id_slug_key UNIQUE (rpg_system_id, slug);


--
-- Name: item_definition item_definition_pkey; Type: CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.item_definition
    ADD CONSTRAINT item_definition_pkey PRIMARY KEY (id);


--
-- Name: item_definition item_definition_rpg_system_id_slug_key; Type: CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.item_definition
    ADD CONSTRAINT item_definition_rpg_system_id_slug_key UNIQUE (rpg_system_id, slug);


--
-- Name: item_type item_type_pkey; Type: CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.item_type
    ADD CONSTRAINT item_type_pkey PRIMARY KEY (id);


--
-- Name: item_type item_type_rpg_system_id_slug_key; Type: CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.item_type
    ADD CONSTRAINT item_type_rpg_system_id_slug_key UNIQUE (rpg_system_id, slug);


--
-- Name: origin_ability origin_ability_pkey; Type: CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.origin_ability
    ADD CONSTRAINT origin_ability_pkey PRIMARY KEY (origin_id, ability_id);


--
-- Name: origin_definition origin_definition_pkey; Type: CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.origin_definition
    ADD CONSTRAINT origin_definition_pkey PRIMARY KEY (id);


--
-- Name: origin_definition origin_definition_rpg_system_id_slug_key; Type: CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.origin_definition
    ADD CONSTRAINT origin_definition_rpg_system_id_slug_key UNIQUE (rpg_system_id, slug);


--
-- Name: proficiency_definition proficiency_definition_pkey; Type: CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.proficiency_definition
    ADD CONSTRAINT proficiency_definition_pkey PRIMARY KEY (id);


--
-- Name: proficiency_definition proficiency_definition_rpg_system_id_slug_key; Type: CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.proficiency_definition
    ADD CONSTRAINT proficiency_definition_rpg_system_id_slug_key UNIQUE (rpg_system_id, slug);


--
-- Name: progression_definition progression_definition_pkey; Type: CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.progression_definition
    ADD CONSTRAINT progression_definition_pkey PRIMARY KEY (id);


--
-- Name: progression_definition progression_definition_rpg_system_id_slug_key; Type: CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.progression_definition
    ADD CONSTRAINT progression_definition_rpg_system_id_slug_key UNIQUE (rpg_system_id, slug);


--
-- Name: progression_tier progression_tier_pkey; Type: CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.progression_tier
    ADD CONSTRAINT progression_tier_pkey PRIMARY KEY (id);


--
-- Name: progression_tier progression_tier_progression_id_slug_key; Type: CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.progression_tier
    ADD CONSTRAINT progression_tier_progression_id_slug_key UNIQUE (progression_id, slug);


--
-- Name: resistance_definition resistance_definition_pkey; Type: CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.resistance_definition
    ADD CONSTRAINT resistance_definition_pkey PRIMARY KEY (id);


--
-- Name: resistance_definition resistance_definition_rpg_system_id_slug_key; Type: CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.resistance_definition
    ADD CONSTRAINT resistance_definition_rpg_system_id_slug_key UNIQUE (rpg_system_id, slug);


--
-- Name: resource_definition resource_definition_pkey; Type: CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.resource_definition
    ADD CONSTRAINT resource_definition_pkey PRIMARY KEY (id);


--
-- Name: resource_definition resource_definition_rpg_system_id_slug_key; Type: CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.resource_definition
    ADD CONSTRAINT resource_definition_rpg_system_id_slug_key UNIQUE (rpg_system_id, slug);


--
-- Name: rpg_character rpg_character_pkey; Type: CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.rpg_character
    ADD CONSTRAINT rpg_character_pkey PRIMARY KEY (id);


--
-- Name: rpg_system rpg_system_pkey; Type: CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.rpg_system
    ADD CONSTRAINT rpg_system_pkey PRIMARY KEY (id);


--
-- Name: rpg_system rpg_system_slug_key; Type: CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.rpg_system
    ADD CONSTRAINT rpg_system_slug_key UNIQUE (slug);


--
-- Name: search_synonym search_synonym_pkey; Type: CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.search_synonym
    ADD CONSTRAINT search_synonym_pkey PRIMARY KEY (id);


--
-- Name: skill_definition skill_definition_pkey; Type: CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.skill_definition
    ADD CONSTRAINT skill_definition_pkey PRIMARY KEY (id);


--
-- Name: skill_definition skill_definition_rpg_system_id_slug_key; Type: CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.skill_definition
    ADD CONSTRAINT skill_definition_rpg_system_id_slug_key UNIQUE (rpg_system_id, slug);


--
-- Name: skill_training_level skill_training_level_pkey; Type: CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.skill_training_level
    ADD CONSTRAINT skill_training_level_pkey PRIMARY KEY (id);


--
-- Name: skill_training_level skill_training_level_rpg_system_id_slug_key; Type: CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.skill_training_level
    ADD CONSTRAINT skill_training_level_rpg_system_id_slug_key UNIQUE (rpg_system_id, slug);


--
-- Name: stat_definition stat_definition_pkey; Type: CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.stat_definition
    ADD CONSTRAINT stat_definition_pkey PRIMARY KEY (id);


--
-- Name: stat_definition stat_definition_rpg_system_id_slug_key; Type: CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.stat_definition
    ADD CONSTRAINT stat_definition_rpg_system_id_slug_key UNIQUE (rpg_system_id, slug);


--
-- Name: ammunition ammunition_pkey; Type: CONSTRAINT; Schema: ordem; Owner: postgres
--

ALTER TABLE ONLY ordem.ammunition
    ADD CONSTRAINT ammunition_pkey PRIMARY KEY (item_id);


--
-- Name: being_type being_type_pkey; Type: CONSTRAINT; Schema: ordem; Owner: postgres
--

ALTER TABLE ONLY ordem.being_type
    ADD CONSTRAINT being_type_pkey PRIMARY KEY (id);


--
-- Name: being_type being_type_slug_key; Type: CONSTRAINT; Schema: ordem; Owner: postgres
--

ALTER TABLE ONLY ordem.being_type
    ADD CONSTRAINT being_type_slug_key UNIQUE (slug);


--
-- Name: character_detail character_detail_pkey; Type: CONSTRAINT; Schema: ordem; Owner: postgres
--

ALTER TABLE ONLY ordem.character_detail
    ADD CONSTRAINT character_detail_pkey PRIMARY KEY (character_id);


--
-- Name: class_rule class_rule_pkey; Type: CONSTRAINT; Schema: ordem; Owner: postgres
--

ALTER TABLE ONLY ordem.class_rule
    ADD CONSTRAINT class_rule_pkey PRIMARY KEY (class_id);


--
-- Name: combat_action_rule combat_action_rule_pkey; Type: CONSTRAINT; Schema: ordem; Owner: postgres
--

ALTER TABLE ONLY ordem.combat_action_rule
    ADD CONSTRAINT combat_action_rule_pkey PRIMARY KEY (action_id);


--
-- Name: combat_maneuver combat_maneuver_pkey; Type: CONSTRAINT; Schema: ordem; Owner: postgres
--

ALTER TABLE ONLY ordem.combat_maneuver
    ADD CONSTRAINT combat_maneuver_pkey PRIMARY KEY (id);


--
-- Name: combat_maneuver combat_maneuver_slug_key; Type: CONSTRAINT; Schema: ordem; Owner: postgres
--

ALTER TABLE ONLY ordem.combat_maneuver
    ADD CONSTRAINT combat_maneuver_slug_key UNIQUE (slug);


--
-- Name: combat_situation_modifier combat_situation_modifier_pkey; Type: CONSTRAINT; Schema: ordem; Owner: postgres
--

ALTER TABLE ONLY ordem.combat_situation_modifier
    ADD CONSTRAINT combat_situation_modifier_pkey PRIMARY KEY (id);


--
-- Name: combat_situation_modifier combat_situation_modifier_slug_key; Type: CONSTRAINT; Schema: ordem; Owner: postgres
--

ALTER TABLE ONLY ordem.combat_situation_modifier
    ADD CONSTRAINT combat_situation_modifier_slug_key UNIQUE (slug);


--
-- Name: combat_turn_rule combat_turn_rule_pkey; Type: CONSTRAINT; Schema: ordem; Owner: postgres
--

ALTER TABLE ONLY ordem.combat_turn_rule
    ADD CONSTRAINT combat_turn_rule_pkey PRIMARY KEY (id);


--
-- Name: condition_relation condition_relation_pkey; Type: CONSTRAINT; Schema: ordem; Owner: postgres
--

ALTER TABLE ONLY ordem.condition_relation
    ADD CONSTRAINT condition_relation_pkey PRIMARY KEY (condition_id, related_condition_id, relation_type);


--
-- Name: condition_rule condition_rule_pkey; Type: CONSTRAINT; Schema: ordem; Owner: postgres
--

ALTER TABLE ONLY ordem.condition_rule
    ADD CONSTRAINT condition_rule_pkey PRIMARY KEY (condition_id);


--
-- Name: curse_definition curse_definition_pkey; Type: CONSTRAINT; Schema: ordem; Owner: postgres
--

ALTER TABLE ONLY ordem.curse_definition
    ADD CONSTRAINT curse_definition_pkey PRIMARY KEY (id);


--
-- Name: curse_definition curse_definition_slug_key; Type: CONSTRAINT; Schema: ordem; Owner: postgres
--

ALTER TABLE ONLY ordem.curse_definition
    ADD CONSTRAINT curse_definition_slug_key UNIQUE (slug);


--
-- Name: curse_price_rule curse_price_rule_pkey; Type: CONSTRAINT; Schema: ordem; Owner: postgres
--

ALTER TABLE ONLY ordem.curse_price_rule
    ADD CONSTRAINT curse_price_rule_pkey PRIMARY KEY (element_id);


--
-- Name: cursed_item_rule cursed_item_rule_pkey; Type: CONSTRAINT; Schema: ordem; Owner: postgres
--

ALTER TABLE ONLY ordem.cursed_item_rule
    ADD CONSTRAINT cursed_item_rule_pkey PRIMARY KEY (id);


--
-- Name: defensive_reaction_rule defensive_reaction_rule_pkey; Type: CONSTRAINT; Schema: ordem; Owner: postgres
--

ALTER TABLE ONLY ordem.defensive_reaction_rule
    ADD CONSTRAINT defensive_reaction_rule_pkey PRIMARY KEY (id);


--
-- Name: defensive_reaction_rule defensive_reaction_rule_slug_key; Type: CONSTRAINT; Schema: ordem; Owner: postgres
--

ALTER TABLE ONLY ordem.defensive_reaction_rule
    ADD CONSTRAINT defensive_reaction_rule_slug_key UNIQUE (slug);


--
-- Name: element element_pkey; Type: CONSTRAINT; Schema: ordem; Owner: postgres
--

ALTER TABLE ONLY ordem.element
    ADD CONSTRAINT element_pkey PRIMARY KEY (id);


--
-- Name: element element_slug_key; Type: CONSTRAINT; Schema: ordem; Owner: postgres
--

ALTER TABLE ONLY ordem.element
    ADD CONSTRAINT element_slug_key UNIQUE (slug);


--
-- Name: interlude_action_rule interlude_action_rule_pkey; Type: CONSTRAINT; Schema: ordem; Owner: postgres
--

ALTER TABLE ONLY ordem.interlude_action_rule
    ADD CONSTRAINT interlude_action_rule_pkey PRIMARY KEY (action_id);


--
-- Name: interlude_meal_option interlude_meal_option_pkey; Type: CONSTRAINT; Schema: ordem; Owner: postgres
--

ALTER TABLE ONLY ordem.interlude_meal_option
    ADD CONSTRAINT interlude_meal_option_pkey PRIMARY KEY (id);


--
-- Name: interlude_meal_option interlude_meal_option_slug_key; Type: CONSTRAINT; Schema: ordem; Owner: postgres
--

ALTER TABLE ONLY ordem.interlude_meal_option
    ADD CONSTRAINT interlude_meal_option_slug_key UNIQUE (slug);


--
-- Name: interlude_rule interlude_rule_pkey; Type: CONSTRAINT; Schema: ordem; Owner: postgres
--

ALTER TABLE ONLY ordem.interlude_rule
    ADD CONSTRAINT interlude_rule_pkey PRIMARY KEY (id);


--
-- Name: item_modification item_modification_pkey; Type: CONSTRAINT; Schema: ordem; Owner: postgres
--

ALTER TABLE ONLY ordem.item_modification
    ADD CONSTRAINT item_modification_pkey PRIMARY KEY (id);


--
-- Name: item_modification item_modification_slug_key; Type: CONSTRAINT; Schema: ordem; Owner: postgres
--

ALTER TABLE ONLY ordem.item_modification
    ADD CONSTRAINT item_modification_slug_key UNIQUE (slug);


--
-- Name: item_rule item_rule_pkey; Type: CONSTRAINT; Schema: ordem; Owner: postgres
--

ALTER TABLE ONLY ordem.item_rule
    ADD CONSTRAINT item_rule_pkey PRIMARY KEY (item_id);


--
-- Name: movement_rule movement_rule_pkey; Type: CONSTRAINT; Schema: ordem; Owner: postgres
--

ALTER TABLE ONLY ordem.movement_rule
    ADD CONSTRAINT movement_rule_pkey PRIMARY KEY (id);


--
-- Name: movement_rule movement_rule_slug_key; Type: CONSTRAINT; Schema: ordem; Owner: postgres
--

ALTER TABLE ONLY ordem.movement_rule
    ADD CONSTRAINT movement_rule_slug_key UNIQUE (slug);


--
-- Name: nex_rule nex_rule_pkey; Type: CONSTRAINT; Schema: ordem; Owner: postgres
--

ALTER TABLE ONLY ordem.nex_rule
    ADD CONSTRAINT nex_rule_pkey PRIMARY KEY (nex);


--
-- Name: origin_skill_grant origin_skill_grant_pkey; Type: CONSTRAINT; Schema: ordem; Owner: postgres
--

ALTER TABLE ONLY ordem.origin_skill_grant
    ADD CONSTRAINT origin_skill_grant_pkey PRIMARY KEY (id);


--
-- Name: patent_rule patent_rule_pkey; Type: CONSTRAINT; Schema: ordem; Owner: postgres
--

ALTER TABLE ONLY ordem.patent_rule
    ADD CONSTRAINT patent_rule_pkey PRIMARY KEY (progression_tier_id);


--
-- Name: protection protection_pkey; Type: CONSTRAINT; Schema: ordem; Owner: postgres
--

ALTER TABLE ONLY ordem.protection
    ADD CONSTRAINT protection_pkey PRIMARY KEY (item_id);


--
-- Name: rest_condition rest_condition_pkey; Type: CONSTRAINT; Schema: ordem; Owner: postgres
--

ALTER TABLE ONLY ordem.rest_condition
    ADD CONSTRAINT rest_condition_pkey PRIMARY KEY (id);


--
-- Name: rest_condition rest_condition_slug_key; Type: CONSTRAINT; Schema: ordem; Owner: postgres
--

ALTER TABLE ONLY ordem.rest_condition
    ADD CONSTRAINT rest_condition_slug_key UNIQUE (slug);


--
-- Name: ritual ritual_pkey; Type: CONSTRAINT; Schema: ordem; Owner: postgres
--

ALTER TABLE ONLY ordem.ritual
    ADD CONSTRAINT ritual_pkey PRIMARY KEY (ability_id);


--
-- Name: skill_rule skill_rule_pkey; Type: CONSTRAINT; Schema: ordem; Owner: postgres
--

ALTER TABLE ONLY ordem.skill_rule
    ADD CONSTRAINT skill_rule_pkey PRIMARY KEY (skill_id);


--
-- Name: special_cursed_item special_cursed_item_pkey; Type: CONSTRAINT; Schema: ordem; Owner: postgres
--

ALTER TABLE ONLY ordem.special_cursed_item
    ADD CONSTRAINT special_cursed_item_pkey PRIMARY KEY (item_id);


--
-- Name: threat_ability threat_ability_pkey; Type: CONSTRAINT; Schema: ordem; Owner: postgres
--

ALTER TABLE ONLY ordem.threat_ability
    ADD CONSTRAINT threat_ability_pkey PRIMARY KEY (id);


--
-- Name: threat_ability threat_ability_threat_id_name_key; Type: CONSTRAINT; Schema: ordem; Owner: postgres
--

ALTER TABLE ONLY ordem.threat_ability
    ADD CONSTRAINT threat_ability_threat_id_name_key UNIQUE (threat_id, name);


--
-- Name: threat_action threat_action_pkey; Type: CONSTRAINT; Schema: ordem; Owner: postgres
--

ALTER TABLE ONLY ordem.threat_action
    ADD CONSTRAINT threat_action_pkey PRIMARY KEY (id);


--
-- Name: threat_defense_trait threat_defense_trait_pkey; Type: CONSTRAINT; Schema: ordem; Owner: postgres
--

ALTER TABLE ONLY ordem.threat_defense_trait
    ADD CONSTRAINT threat_defense_trait_pkey PRIMARY KEY (id);


--
-- Name: threat_defense_trait threat_defense_trait_threat_id_trait_type_name_key; Type: CONSTRAINT; Schema: ordem; Owner: postgres
--

ALTER TABLE ONLY ordem.threat_defense_trait
    ADD CONSTRAINT threat_defense_trait_threat_id_trait_type_name_key UNIQUE (threat_id, trait_type, name);


--
-- Name: threat_descriptor threat_descriptor_pkey; Type: CONSTRAINT; Schema: ordem; Owner: postgres
--

ALTER TABLE ONLY ordem.threat_descriptor
    ADD CONSTRAINT threat_descriptor_pkey PRIMARY KEY (id);


--
-- Name: threat_descriptor threat_descriptor_threat_id_descriptor_key; Type: CONSTRAINT; Schema: ordem; Owner: postgres
--

ALTER TABLE ONLY ordem.threat_descriptor
    ADD CONSTRAINT threat_descriptor_threat_id_descriptor_key UNIQUE (threat_id, descriptor);


--
-- Name: threat_element threat_element_pkey; Type: CONSTRAINT; Schema: ordem; Owner: postgres
--

ALTER TABLE ONLY ordem.threat_element
    ADD CONSTRAINT threat_element_pkey PRIMARY KEY (threat_id, element_id);


--
-- Name: threat threat_pkey; Type: CONSTRAINT; Schema: ordem; Owner: postgres
--

ALTER TABLE ONLY ordem.threat
    ADD CONSTRAINT threat_pkey PRIMARY KEY (character_id);


--
-- Name: threat_size threat_size_pkey; Type: CONSTRAINT; Schema: ordem; Owner: postgres
--

ALTER TABLE ONLY ordem.threat_size
    ADD CONSTRAINT threat_size_pkey PRIMARY KEY (id);


--
-- Name: threat_size threat_size_slug_key; Type: CONSTRAINT; Schema: ordem; Owner: postgres
--

ALTER TABLE ONLY ordem.threat_size
    ADD CONSTRAINT threat_size_slug_key UNIQUE (slug);


--
-- Name: threat_skill threat_skill_pkey; Type: CONSTRAINT; Schema: ordem; Owner: postgres
--

ALTER TABLE ONLY ordem.threat_skill
    ADD CONSTRAINT threat_skill_pkey PRIMARY KEY (id);


--
-- Name: threat_skill threat_skill_threat_id_skill_name_key; Type: CONSTRAINT; Schema: ordem; Owner: postgres
--

ALTER TABLE ONLY ordem.threat_skill
    ADD CONSTRAINT threat_skill_threat_id_skill_name_key UNIQUE (threat_id, skill_name);


--
-- Name: weapon weapon_pkey; Type: CONSTRAINT; Schema: ordem; Owner: postgres
--

ALTER TABLE ONLY ordem.weapon
    ADD CONSTRAINT weapon_pkey PRIMARY KEY (item_id);


--
-- Name: idx_archetype_ability_unlock_system; Type: INDEX; Schema: core; Owner: postgres
--

CREATE INDEX idx_archetype_ability_unlock_system ON core.archetype_ability_unlock USING btree (rpg_system_id);


--
-- Name: idx_character_ability_system; Type: INDEX; Schema: core; Owner: postgres
--

CREATE INDEX idx_character_ability_system ON core.character_ability USING btree (rpg_system_id);


--
-- Name: idx_character_archetype_system; Type: INDEX; Schema: core; Owner: postgres
--

CREATE INDEX idx_character_archetype_system ON core.character_archetype USING btree (rpg_system_id);


--
-- Name: idx_character_attack_character; Type: INDEX; Schema: core; Owner: postgres
--

CREATE INDEX idx_character_attack_character ON core.character_attack USING btree (character_id);


--
-- Name: idx_character_attack_system; Type: INDEX; Schema: core; Owner: postgres
--

CREATE INDEX idx_character_attack_system ON core.character_attack USING btree (rpg_system_id);


--
-- Name: idx_character_attribute_system; Type: INDEX; Schema: core; Owner: postgres
--

CREATE INDEX idx_character_attribute_system ON core.character_attribute USING btree (rpg_system_id);


--
-- Name: idx_character_class_system; Type: INDEX; Schema: core; Owner: postgres
--

CREATE INDEX idx_character_class_system ON core.character_class USING btree (rpg_system_id);


--
-- Name: idx_character_item_character; Type: INDEX; Schema: core; Owner: postgres
--

CREATE INDEX idx_character_item_character ON core.character_item USING btree (character_id);


--
-- Name: idx_character_item_system; Type: INDEX; Schema: core; Owner: postgres
--

CREATE INDEX idx_character_item_system ON core.character_item USING btree (rpg_system_id);


--
-- Name: idx_character_origin_system; Type: INDEX; Schema: core; Owner: postgres
--

CREATE INDEX idx_character_origin_system ON core.character_origin USING btree (rpg_system_id);


--
-- Name: idx_character_proficiency_system; Type: INDEX; Schema: core; Owner: postgres
--

CREATE INDEX idx_character_proficiency_system ON core.character_proficiency USING btree (rpg_system_id);


--
-- Name: idx_character_progression_system; Type: INDEX; Schema: core; Owner: postgres
--

CREATE INDEX idx_character_progression_system ON core.character_progression USING btree (rpg_system_id);


--
-- Name: idx_character_resistance_system; Type: INDEX; Schema: core; Owner: postgres
--

CREATE INDEX idx_character_resistance_system ON core.character_resistance USING btree (rpg_system_id);


--
-- Name: idx_character_resource_system; Type: INDEX; Schema: core; Owner: postgres
--

CREATE INDEX idx_character_resource_system ON core.character_resource USING btree (rpg_system_id);


--
-- Name: idx_character_skill_system; Type: INDEX; Schema: core; Owner: postgres
--

CREATE INDEX idx_character_skill_system ON core.character_skill USING btree (rpg_system_id);


--
-- Name: idx_character_stat_system; Type: INDEX; Schema: core; Owner: postgres
--

CREATE INDEX idx_character_stat_system ON core.character_stat USING btree (rpg_system_id);


--
-- Name: idx_class_ability_unlock_system; Type: INDEX; Schema: core; Owner: postgres
--

CREATE INDEX idx_class_ability_unlock_system ON core.class_ability_unlock USING btree (rpg_system_id);


--
-- Name: idx_class_proficiency_system; Type: INDEX; Schema: core; Owner: postgres
--

CREATE INDEX idx_class_proficiency_system ON core.class_proficiency USING btree (rpg_system_id);


--
-- Name: idx_core_action_definition_system_type; Type: INDEX; Schema: core; Owner: postgres
--

CREATE INDEX idx_core_action_definition_system_type ON core.action_definition USING btree (rpg_system_id, action_type);


--
-- Name: idx_core_condition_definition_category; Type: INDEX; Schema: core; Owner: postgres
--

CREATE INDEX idx_core_condition_definition_category ON core.condition_definition USING btree (rpg_system_id, category);


--
-- Name: idx_core_condition_definition_system; Type: INDEX; Schema: core; Owner: postgres
--

CREATE INDEX idx_core_condition_definition_system ON core.condition_definition USING btree (rpg_system_id);


--
-- Name: idx_core_downtime_action_system; Type: INDEX; Schema: core; Owner: postgres
--

CREATE INDEX idx_core_downtime_action_system ON core.downtime_action_definition USING btree (rpg_system_id);


--
-- Name: idx_item_definition_fuzzy_text_trgm; Type: INDEX; Schema: core; Owner: postgres
--

CREATE INDEX idx_item_definition_fuzzy_text_trgm ON core.item_definition USING gin (fuzzy_text public.gin_trgm_ops);


--
-- Name: idx_item_definition_item_type; Type: INDEX; Schema: core; Owner: postgres
--

CREATE INDEX idx_item_definition_item_type ON core.item_definition USING btree (item_type_id);


--
-- Name: idx_item_definition_rpg_system; Type: INDEX; Schema: core; Owner: postgres
--

CREATE INDEX idx_item_definition_rpg_system ON core.item_definition USING btree (rpg_system_id);


--
-- Name: idx_item_definition_search_vector_gin; Type: INDEX; Schema: core; Owner: postgres
--

CREATE INDEX idx_item_definition_search_vector_gin ON core.item_definition USING gin (search_vector);


--
-- Name: idx_item_definition_system_type; Type: INDEX; Schema: core; Owner: postgres
--

CREATE INDEX idx_item_definition_system_type ON core.item_definition USING btree (rpg_system_id, item_type_id);


--
-- Name: idx_origin_ability_system; Type: INDEX; Schema: core; Owner: postgres
--

CREATE INDEX idx_origin_ability_system ON core.origin_ability USING btree (rpg_system_id);


--
-- Name: idx_progression_tier_system; Type: INDEX; Schema: core; Owner: postgres
--

CREATE INDEX idx_progression_tier_system ON core.progression_tier USING btree (rpg_system_id);


--
-- Name: idx_rpg_character_system; Type: INDEX; Schema: core; Owner: postgres
--

CREATE INDEX idx_rpg_character_system ON core.rpg_character USING btree (rpg_system_id);


--
-- Name: idx_rpg_character_type; Type: INDEX; Schema: core; Owner: postgres
--

CREATE INDEX idx_rpg_character_type ON core.rpg_character USING btree (rpg_system_id, character_type);


--
-- Name: idx_search_synonym_domain_active; Type: INDEX; Schema: core; Owner: postgres
--

CREATE INDEX idx_search_synonym_domain_active ON core.search_synonym USING btree (domain, is_active);


--
-- Name: idx_search_synonym_synonym; Type: INDEX; Schema: core; Owner: postgres
--

CREATE INDEX idx_search_synonym_synonym ON core.search_synonym USING btree (lower(btrim(synonym)));


--
-- Name: idx_search_synonym_term; Type: INDEX; Schema: core; Owner: postgres
--

CREATE INDEX idx_search_synonym_term ON core.search_synonym USING btree (lower(btrim(term)));


--
-- Name: uq_ability_definition_id_system; Type: INDEX; Schema: core; Owner: postgres
--

CREATE UNIQUE INDEX uq_ability_definition_id_system ON core.ability_definition USING btree (id, rpg_system_id);


--
-- Name: uq_action_definition_id_system; Type: INDEX; Schema: core; Owner: postgres
--

CREATE UNIQUE INDEX uq_action_definition_id_system ON core.action_definition USING btree (id, rpg_system_id);


--
-- Name: uq_archetype_definition_id_system; Type: INDEX; Schema: core; Owner: postgres
--

CREATE UNIQUE INDEX uq_archetype_definition_id_system ON core.archetype_definition USING btree (id, rpg_system_id);


--
-- Name: uq_attribute_definition_id_system; Type: INDEX; Schema: core; Owner: postgres
--

CREATE UNIQUE INDEX uq_attribute_definition_id_system ON core.attribute_definition USING btree (id, rpg_system_id);


--
-- Name: uq_character_primary_class; Type: INDEX; Schema: core; Owner: postgres
--

CREATE UNIQUE INDEX uq_character_primary_class ON core.character_class USING btree (character_id) WHERE (primary_class = true);


--
-- Name: uq_class_definition_id_system; Type: INDEX; Schema: core; Owner: postgres
--

CREATE UNIQUE INDEX uq_class_definition_id_system ON core.class_definition USING btree (id, rpg_system_id);


--
-- Name: uq_condition_definition_id_system; Type: INDEX; Schema: core; Owner: postgres
--

CREATE UNIQUE INDEX uq_condition_definition_id_system ON core.condition_definition USING btree (id, rpg_system_id);


--
-- Name: uq_downtime_action_definition_id_system; Type: INDEX; Schema: core; Owner: postgres
--

CREATE UNIQUE INDEX uq_downtime_action_definition_id_system ON core.downtime_action_definition USING btree (id, rpg_system_id);


--
-- Name: uq_item_definition_id_system; Type: INDEX; Schema: core; Owner: postgres
--

CREATE UNIQUE INDEX uq_item_definition_id_system ON core.item_definition USING btree (id, rpg_system_id);


--
-- Name: uq_item_type_id_system; Type: INDEX; Schema: core; Owner: postgres
--

CREATE UNIQUE INDEX uq_item_type_id_system ON core.item_type USING btree (id, rpg_system_id);


--
-- Name: uq_origin_definition_id_system; Type: INDEX; Schema: core; Owner: postgres
--

CREATE UNIQUE INDEX uq_origin_definition_id_system ON core.origin_definition USING btree (id, rpg_system_id);


--
-- Name: uq_proficiency_definition_id_system; Type: INDEX; Schema: core; Owner: postgres
--

CREATE UNIQUE INDEX uq_proficiency_definition_id_system ON core.proficiency_definition USING btree (id, rpg_system_id);


--
-- Name: uq_progression_definition_id_system; Type: INDEX; Schema: core; Owner: postgres
--

CREATE UNIQUE INDEX uq_progression_definition_id_system ON core.progression_definition USING btree (id, rpg_system_id);


--
-- Name: uq_progression_tier_id_system; Type: INDEX; Schema: core; Owner: postgres
--

CREATE UNIQUE INDEX uq_progression_tier_id_system ON core.progression_tier USING btree (id, rpg_system_id);


--
-- Name: uq_resistance_definition_id_system; Type: INDEX; Schema: core; Owner: postgres
--

CREATE UNIQUE INDEX uq_resistance_definition_id_system ON core.resistance_definition USING btree (id, rpg_system_id);


--
-- Name: uq_resource_definition_id_system; Type: INDEX; Schema: core; Owner: postgres
--

CREATE UNIQUE INDEX uq_resource_definition_id_system ON core.resource_definition USING btree (id, rpg_system_id);


--
-- Name: uq_rpg_character_id_system; Type: INDEX; Schema: core; Owner: postgres
--

CREATE UNIQUE INDEX uq_rpg_character_id_system ON core.rpg_character USING btree (id, rpg_system_id);


--
-- Name: uq_search_synonym_domain_pair; Type: INDEX; Schema: core; Owner: postgres
--

CREATE UNIQUE INDEX uq_search_synonym_domain_pair ON core.search_synonym USING btree (domain, lower(btrim(term)), lower(btrim(synonym)));


--
-- Name: uq_skill_definition_id_system; Type: INDEX; Schema: core; Owner: postgres
--

CREATE UNIQUE INDEX uq_skill_definition_id_system ON core.skill_definition USING btree (id, rpg_system_id);


--
-- Name: uq_skill_training_level_id_system; Type: INDEX; Schema: core; Owner: postgres
--

CREATE UNIQUE INDEX uq_skill_training_level_id_system ON core.skill_training_level USING btree (id, rpg_system_id);


--
-- Name: uq_stat_definition_id_system; Type: INDEX; Schema: core; Owner: postgres
--

CREATE UNIQUE INDEX uq_stat_definition_id_system ON core.stat_definition USING btree (id, rpg_system_id);


--
-- Name: idx_ordem_combat_maneuver_action; Type: INDEX; Schema: ordem; Owner: postgres
--

CREATE INDEX idx_ordem_combat_maneuver_action ON ordem.combat_maneuver USING btree (action_id);


--
-- Name: idx_ordem_condition_relation_related; Type: INDEX; Schema: ordem; Owner: postgres
--

CREATE INDEX idx_ordem_condition_relation_related ON ordem.condition_relation USING btree (related_condition_id);


--
-- Name: idx_ordem_curse_definition_applies_to; Type: INDEX; Schema: ordem; Owner: postgres
--

CREATE INDEX idx_ordem_curse_definition_applies_to ON ordem.curse_definition USING btree (applies_to);


--
-- Name: idx_ordem_curse_definition_element; Type: INDEX; Schema: ordem; Owner: postgres
--

CREATE INDEX idx_ordem_curse_definition_element ON ordem.curse_definition USING btree (element_id);


--
-- Name: idx_ordem_special_cursed_item_element; Type: INDEX; Schema: ordem; Owner: postgres
--

CREATE INDEX idx_ordem_special_cursed_item_element ON ordem.special_cursed_item USING btree (element_id);


--
-- Name: idx_ordem_threat_action_threat; Type: INDEX; Schema: ordem; Owner: postgres
--

CREATE INDEX idx_ordem_threat_action_threat ON ordem.threat_action USING btree (threat_id);


--
-- Name: idx_ordem_threat_action_type; Type: INDEX; Schema: ordem; Owner: postgres
--

CREATE INDEX idx_ordem_threat_action_type ON ordem.threat_action USING btree (action_type);


--
-- Name: idx_ordem_threat_element_element; Type: INDEX; Schema: ordem; Owner: postgres
--

CREATE INDEX idx_ordem_threat_element_element ON ordem.threat_element USING btree (element_id);


--
-- Name: idx_ordem_threat_search_vector_gin; Type: INDEX; Schema: ordem; Owner: postgres
--

CREATE INDEX idx_ordem_threat_search_vector_gin ON ordem.threat USING gin (search_vector);


--
-- Name: idx_ordem_threat_size_id; Type: INDEX; Schema: ordem; Owner: postgres
--

CREATE INDEX idx_ordem_threat_size_id ON ordem.threat USING btree (size_id);


--
-- Name: idx_ordem_threat_vd; Type: INDEX; Schema: ordem; Owner: postgres
--

CREATE INDEX idx_ordem_threat_vd ON ordem.threat USING btree (challenge_value);


--
-- Name: idx_threat_fuzzy_text_trgm; Type: INDEX; Schema: ordem; Owner: postgres
--

CREATE INDEX idx_threat_fuzzy_text_trgm ON ordem.threat USING gin (fuzzy_text public.gin_trgm_ops);


--
-- Name: uq_ordem_threat_action_seed_identity; Type: INDEX; Schema: ordem; Owner: postgres
--

CREATE UNIQUE INDEX uq_ordem_threat_action_seed_identity ON ordem.threat_action USING btree (threat_id, action_type, name, sort_order);


--
-- Name: uq_ordem_threat_slug; Type: INDEX; Schema: ordem; Owner: postgres
--

CREATE UNIQUE INDEX uq_ordem_threat_slug ON ordem.threat USING btree (slug) WHERE (slug IS NOT NULL);


--
-- Name: uq_origin_skill_grant_choice; Type: INDEX; Schema: ordem; Owner: postgres
--

CREATE UNIQUE INDEX uq_origin_skill_grant_choice ON ordem.origin_skill_grant USING btree (origin_id, grant_group) WHERE (skill_id IS NULL);


--
-- Name: uq_origin_skill_grant_fixed; Type: INDEX; Schema: ordem; Owner: postgres
--

CREATE UNIQUE INDEX uq_origin_skill_grant_fixed ON ordem.origin_skill_grant USING btree (origin_id, skill_id, grant_group) WHERE (skill_id IS NOT NULL);


--
-- Name: item_definition trg_item_fuzzy_from_item; Type: TRIGGER; Schema: core; Owner: postgres
--

CREATE TRIGGER trg_item_fuzzy_from_item AFTER INSERT OR UPDATE OF name, slug, description ON core.item_definition FOR EACH ROW EXECUTE FUNCTION core.trg_refresh_item_fuzzy_from_item();


--
-- Name: item_definition trg_item_search_from_item; Type: TRIGGER; Schema: core; Owner: postgres
--

CREATE TRIGGER trg_item_search_from_item AFTER INSERT OR UPDATE OF name, slug, description, item_type_id ON core.item_definition FOR EACH ROW EXECUTE FUNCTION core.trg_refresh_item_search_from_item();


--
-- Name: item_type trg_item_search_from_type; Type: TRIGGER; Schema: core; Owner: postgres
--

CREATE TRIGGER trg_item_search_from_type AFTER UPDATE OF name ON core.item_type FOR EACH ROW EXECUTE FUNCTION core.trg_refresh_item_search_from_type();


--
-- Name: rpg_character trg_threat_fuzzy_from_character; Type: TRIGGER; Schema: core; Owner: postgres
--

CREATE TRIGGER trg_threat_fuzzy_from_character AFTER UPDATE OF name, description ON core.rpg_character FOR EACH ROW EXECUTE FUNCTION ordem.trg_refresh_threat_fuzzy_from_character();


--
-- Name: rpg_character trg_threat_search_from_character; Type: TRIGGER; Schema: core; Owner: postgres
--

CREATE TRIGGER trg_threat_search_from_character AFTER UPDATE OF name, description ON core.rpg_character FOR EACH ROW EXECUTE FUNCTION ordem.trg_refresh_threat_search_from_character();


--
-- Name: threat trg_threat_fuzzy_from_threat; Type: TRIGGER; Schema: ordem; Owner: postgres
--

CREATE TRIGGER trg_threat_fuzzy_from_threat AFTER INSERT OR UPDATE OF slug ON ordem.threat FOR EACH ROW EXECUTE FUNCTION ordem.trg_refresh_threat_fuzzy_from_threat();


--
-- Name: being_type trg_threat_search_from_being_type; Type: TRIGGER; Schema: ordem; Owner: postgres
--

CREATE TRIGGER trg_threat_search_from_being_type AFTER UPDATE OF name ON ordem.being_type FOR EACH ROW EXECUTE FUNCTION ordem.trg_refresh_threat_search_from_being_type();


--
-- Name: element trg_threat_search_from_element; Type: TRIGGER; Schema: ordem; Owner: postgres
--

CREATE TRIGGER trg_threat_search_from_element AFTER UPDATE OF name ON ordem.element FOR EACH ROW EXECUTE FUNCTION ordem.trg_refresh_threat_search_from_element();


--
-- Name: threat trg_threat_search_from_threat; Type: TRIGGER; Schema: ordem; Owner: postgres
--

CREATE TRIGGER trg_threat_search_from_threat AFTER INSERT OR UPDATE OF slug, being_type_id ON ordem.threat FOR EACH ROW EXECUTE FUNCTION ordem.trg_refresh_threat_search_from_threat();


--
-- Name: threat_element trg_threat_search_from_threat_element; Type: TRIGGER; Schema: ordem; Owner: postgres
--

CREATE TRIGGER trg_threat_search_from_threat_element AFTER INSERT OR DELETE OR UPDATE ON ordem.threat_element FOR EACH ROW EXECUTE FUNCTION ordem.trg_refresh_threat_search_from_threat_element();


--
-- Name: ability_definition ability_definition_rpg_system_id_fkey; Type: FK CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.ability_definition
    ADD CONSTRAINT ability_definition_rpg_system_id_fkey FOREIGN KEY (rpg_system_id) REFERENCES core.rpg_system(id) ON DELETE CASCADE;


--
-- Name: action_definition action_definition_rpg_system_id_fkey; Type: FK CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.action_definition
    ADD CONSTRAINT action_definition_rpg_system_id_fkey FOREIGN KEY (rpg_system_id) REFERENCES core.rpg_system(id) ON DELETE CASCADE;


--
-- Name: archetype_ability_unlock archetype_ability_unlock_ability_id_fkey; Type: FK CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.archetype_ability_unlock
    ADD CONSTRAINT archetype_ability_unlock_ability_id_fkey FOREIGN KEY (ability_id) REFERENCES core.ability_definition(id) ON DELETE CASCADE;


--
-- Name: archetype_ability_unlock archetype_ability_unlock_archetype_id_fkey; Type: FK CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.archetype_ability_unlock
    ADD CONSTRAINT archetype_ability_unlock_archetype_id_fkey FOREIGN KEY (archetype_id) REFERENCES core.archetype_definition(id) ON DELETE CASCADE;


--
-- Name: archetype_definition archetype_definition_class_id_fkey; Type: FK CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.archetype_definition
    ADD CONSTRAINT archetype_definition_class_id_fkey FOREIGN KEY (class_id) REFERENCES core.class_definition(id) ON DELETE CASCADE;


--
-- Name: archetype_definition archetype_definition_rpg_system_id_fkey; Type: FK CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.archetype_definition
    ADD CONSTRAINT archetype_definition_rpg_system_id_fkey FOREIGN KEY (rpg_system_id) REFERENCES core.rpg_system(id) ON DELETE CASCADE;


--
-- Name: attribute_definition attribute_definition_rpg_system_id_fkey; Type: FK CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.attribute_definition
    ADD CONSTRAINT attribute_definition_rpg_system_id_fkey FOREIGN KEY (rpg_system_id) REFERENCES core.rpg_system(id) ON DELETE CASCADE;


--
-- Name: character_ability character_ability_ability_id_fkey; Type: FK CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.character_ability
    ADD CONSTRAINT character_ability_ability_id_fkey FOREIGN KEY (ability_id) REFERENCES core.ability_definition(id) ON DELETE CASCADE;


--
-- Name: character_ability character_ability_character_id_fkey; Type: FK CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.character_ability
    ADD CONSTRAINT character_ability_character_id_fkey FOREIGN KEY (character_id) REFERENCES core.rpg_character(id) ON DELETE CASCADE;


--
-- Name: character_archetype character_archetype_archetype_id_fkey; Type: FK CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.character_archetype
    ADD CONSTRAINT character_archetype_archetype_id_fkey FOREIGN KEY (archetype_id) REFERENCES core.archetype_definition(id) ON DELETE RESTRICT;


--
-- Name: character_archetype character_archetype_character_id_fkey; Type: FK CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.character_archetype
    ADD CONSTRAINT character_archetype_character_id_fkey FOREIGN KEY (character_id) REFERENCES core.rpg_character(id) ON DELETE CASCADE;


--
-- Name: character_attack character_attack_character_id_fkey; Type: FK CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.character_attack
    ADD CONSTRAINT character_attack_character_id_fkey FOREIGN KEY (character_id) REFERENCES core.rpg_character(id) ON DELETE CASCADE;


--
-- Name: character_attack character_attack_skill_id_fkey; Type: FK CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.character_attack
    ADD CONSTRAINT character_attack_skill_id_fkey FOREIGN KEY (skill_id) REFERENCES core.skill_definition(id) ON DELETE SET NULL;


--
-- Name: character_attack character_attack_source_item_id_fkey; Type: FK CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.character_attack
    ADD CONSTRAINT character_attack_source_item_id_fkey FOREIGN KEY (source_item_id) REFERENCES core.item_definition(id) ON DELETE SET NULL;


--
-- Name: character_attribute character_attribute_attribute_id_fkey; Type: FK CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.character_attribute
    ADD CONSTRAINT character_attribute_attribute_id_fkey FOREIGN KEY (attribute_id) REFERENCES core.attribute_definition(id) ON DELETE CASCADE;


--
-- Name: character_attribute character_attribute_character_id_fkey; Type: FK CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.character_attribute
    ADD CONSTRAINT character_attribute_character_id_fkey FOREIGN KEY (character_id) REFERENCES core.rpg_character(id) ON DELETE CASCADE;


--
-- Name: character_class character_class_character_id_fkey; Type: FK CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.character_class
    ADD CONSTRAINT character_class_character_id_fkey FOREIGN KEY (character_id) REFERENCES core.rpg_character(id) ON DELETE CASCADE;


--
-- Name: character_class character_class_class_id_fkey; Type: FK CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.character_class
    ADD CONSTRAINT character_class_class_id_fkey FOREIGN KEY (class_id) REFERENCES core.class_definition(id) ON DELETE RESTRICT;


--
-- Name: character_item character_item_character_id_fkey; Type: FK CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.character_item
    ADD CONSTRAINT character_item_character_id_fkey FOREIGN KEY (character_id) REFERENCES core.rpg_character(id) ON DELETE CASCADE;


--
-- Name: character_item character_item_item_id_fkey; Type: FK CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.character_item
    ADD CONSTRAINT character_item_item_id_fkey FOREIGN KEY (item_id) REFERENCES core.item_definition(id) ON DELETE RESTRICT;


--
-- Name: character_origin character_origin_character_id_fkey; Type: FK CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.character_origin
    ADD CONSTRAINT character_origin_character_id_fkey FOREIGN KEY (character_id) REFERENCES core.rpg_character(id) ON DELETE CASCADE;


--
-- Name: character_origin character_origin_origin_id_fkey; Type: FK CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.character_origin
    ADD CONSTRAINT character_origin_origin_id_fkey FOREIGN KEY (origin_id) REFERENCES core.origin_definition(id) ON DELETE RESTRICT;


--
-- Name: character_proficiency character_proficiency_character_id_fkey; Type: FK CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.character_proficiency
    ADD CONSTRAINT character_proficiency_character_id_fkey FOREIGN KEY (character_id) REFERENCES core.rpg_character(id) ON DELETE CASCADE;


--
-- Name: character_proficiency character_proficiency_proficiency_id_fkey; Type: FK CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.character_proficiency
    ADD CONSTRAINT character_proficiency_proficiency_id_fkey FOREIGN KEY (proficiency_id) REFERENCES core.proficiency_definition(id) ON DELETE CASCADE;


--
-- Name: character_progression character_progression_character_id_fkey; Type: FK CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.character_progression
    ADD CONSTRAINT character_progression_character_id_fkey FOREIGN KEY (character_id) REFERENCES core.rpg_character(id) ON DELETE CASCADE;


--
-- Name: character_progression character_progression_progression_id_fkey; Type: FK CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.character_progression
    ADD CONSTRAINT character_progression_progression_id_fkey FOREIGN KEY (progression_id) REFERENCES core.progression_definition(id) ON DELETE CASCADE;


--
-- Name: character_resistance character_resistance_character_id_fkey; Type: FK CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.character_resistance
    ADD CONSTRAINT character_resistance_character_id_fkey FOREIGN KEY (character_id) REFERENCES core.rpg_character(id) ON DELETE CASCADE;


--
-- Name: character_resistance character_resistance_resistance_id_fkey; Type: FK CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.character_resistance
    ADD CONSTRAINT character_resistance_resistance_id_fkey FOREIGN KEY (resistance_id) REFERENCES core.resistance_definition(id) ON DELETE CASCADE;


--
-- Name: character_resource character_resource_character_id_fkey; Type: FK CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.character_resource
    ADD CONSTRAINT character_resource_character_id_fkey FOREIGN KEY (character_id) REFERENCES core.rpg_character(id) ON DELETE CASCADE;


--
-- Name: character_resource character_resource_resource_id_fkey; Type: FK CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.character_resource
    ADD CONSTRAINT character_resource_resource_id_fkey FOREIGN KEY (resource_id) REFERENCES core.resource_definition(id) ON DELETE CASCADE;


--
-- Name: character_skill character_skill_character_id_fkey; Type: FK CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.character_skill
    ADD CONSTRAINT character_skill_character_id_fkey FOREIGN KEY (character_id) REFERENCES core.rpg_character(id) ON DELETE CASCADE;


--
-- Name: character_skill character_skill_skill_id_fkey; Type: FK CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.character_skill
    ADD CONSTRAINT character_skill_skill_id_fkey FOREIGN KEY (skill_id) REFERENCES core.skill_definition(id) ON DELETE CASCADE;


--
-- Name: character_skill character_skill_training_level_id_fkey; Type: FK CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.character_skill
    ADD CONSTRAINT character_skill_training_level_id_fkey FOREIGN KEY (training_level_id) REFERENCES core.skill_training_level(id) ON DELETE RESTRICT;


--
-- Name: character_stat character_stat_character_id_fkey; Type: FK CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.character_stat
    ADD CONSTRAINT character_stat_character_id_fkey FOREIGN KEY (character_id) REFERENCES core.rpg_character(id) ON DELETE CASCADE;


--
-- Name: character_stat character_stat_stat_id_fkey; Type: FK CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.character_stat
    ADD CONSTRAINT character_stat_stat_id_fkey FOREIGN KEY (stat_id) REFERENCES core.stat_definition(id) ON DELETE CASCADE;


--
-- Name: class_ability_unlock class_ability_unlock_ability_id_fkey; Type: FK CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.class_ability_unlock
    ADD CONSTRAINT class_ability_unlock_ability_id_fkey FOREIGN KEY (ability_id) REFERENCES core.ability_definition(id) ON DELETE CASCADE;


--
-- Name: class_ability_unlock class_ability_unlock_class_id_fkey; Type: FK CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.class_ability_unlock
    ADD CONSTRAINT class_ability_unlock_class_id_fkey FOREIGN KEY (class_id) REFERENCES core.class_definition(id) ON DELETE CASCADE;


--
-- Name: class_definition class_definition_rpg_system_id_fkey; Type: FK CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.class_definition
    ADD CONSTRAINT class_definition_rpg_system_id_fkey FOREIGN KEY (rpg_system_id) REFERENCES core.rpg_system(id) ON DELETE CASCADE;


--
-- Name: class_proficiency class_proficiency_class_id_fkey; Type: FK CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.class_proficiency
    ADD CONSTRAINT class_proficiency_class_id_fkey FOREIGN KEY (class_id) REFERENCES core.class_definition(id) ON DELETE CASCADE;


--
-- Name: class_proficiency class_proficiency_proficiency_id_fkey; Type: FK CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.class_proficiency
    ADD CONSTRAINT class_proficiency_proficiency_id_fkey FOREIGN KEY (proficiency_id) REFERENCES core.proficiency_definition(id) ON DELETE CASCADE;


--
-- Name: condition_definition condition_definition_rpg_system_id_fkey; Type: FK CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.condition_definition
    ADD CONSTRAINT condition_definition_rpg_system_id_fkey FOREIGN KEY (rpg_system_id) REFERENCES core.rpg_system(id) ON DELETE CASCADE;


--
-- Name: downtime_action_definition downtime_action_definition_rpg_system_id_fkey; Type: FK CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.downtime_action_definition
    ADD CONSTRAINT downtime_action_definition_rpg_system_id_fkey FOREIGN KEY (rpg_system_id) REFERENCES core.rpg_system(id) ON DELETE CASCADE;


--
-- Name: archetype_ability_unlock fk_archetype_ability_unlock_ability_same_system; Type: FK CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.archetype_ability_unlock
    ADD CONSTRAINT fk_archetype_ability_unlock_ability_same_system FOREIGN KEY (ability_id, rpg_system_id) REFERENCES core.ability_definition(id, rpg_system_id) ON DELETE CASCADE;


--
-- Name: archetype_ability_unlock fk_archetype_ability_unlock_archetype_same_system; Type: FK CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.archetype_ability_unlock
    ADD CONSTRAINT fk_archetype_ability_unlock_archetype_same_system FOREIGN KEY (archetype_id, rpg_system_id) REFERENCES core.archetype_definition(id, rpg_system_id) ON DELETE CASCADE;


--
-- Name: archetype_definition fk_archetype_class_same_system; Type: FK CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.archetype_definition
    ADD CONSTRAINT fk_archetype_class_same_system FOREIGN KEY (class_id, rpg_system_id) REFERENCES core.class_definition(id, rpg_system_id) ON DELETE CASCADE;


--
-- Name: character_ability fk_character_ability_character_same_system; Type: FK CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.character_ability
    ADD CONSTRAINT fk_character_ability_character_same_system FOREIGN KEY (character_id, rpg_system_id) REFERENCES core.rpg_character(id, rpg_system_id) ON DELETE CASCADE;


--
-- Name: character_ability fk_character_ability_definition_same_system; Type: FK CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.character_ability
    ADD CONSTRAINT fk_character_ability_definition_same_system FOREIGN KEY (ability_id, rpg_system_id) REFERENCES core.ability_definition(id, rpg_system_id) ON DELETE CASCADE;


--
-- Name: character_archetype fk_character_archetype_character_same_system; Type: FK CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.character_archetype
    ADD CONSTRAINT fk_character_archetype_character_same_system FOREIGN KEY (character_id, rpg_system_id) REFERENCES core.rpg_character(id, rpg_system_id) ON DELETE CASCADE;


--
-- Name: character_archetype fk_character_archetype_definition_same_system; Type: FK CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.character_archetype
    ADD CONSTRAINT fk_character_archetype_definition_same_system FOREIGN KEY (archetype_id, rpg_system_id) REFERENCES core.archetype_definition(id, rpg_system_id) ON DELETE RESTRICT;


--
-- Name: character_attack fk_character_attack_character_same_system; Type: FK CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.character_attack
    ADD CONSTRAINT fk_character_attack_character_same_system FOREIGN KEY (character_id, rpg_system_id) REFERENCES core.rpg_character(id, rpg_system_id) ON DELETE CASCADE;


--
-- Name: character_attack fk_character_attack_item_same_system; Type: FK CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.character_attack
    ADD CONSTRAINT fk_character_attack_item_same_system FOREIGN KEY (source_item_id, rpg_system_id) REFERENCES core.item_definition(id, rpg_system_id) ON DELETE SET NULL;


--
-- Name: character_attack fk_character_attack_skill_same_system; Type: FK CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.character_attack
    ADD CONSTRAINT fk_character_attack_skill_same_system FOREIGN KEY (skill_id, rpg_system_id) REFERENCES core.skill_definition(id, rpg_system_id) ON DELETE SET NULL;


--
-- Name: character_attribute fk_character_attribute_character_same_system; Type: FK CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.character_attribute
    ADD CONSTRAINT fk_character_attribute_character_same_system FOREIGN KEY (character_id, rpg_system_id) REFERENCES core.rpg_character(id, rpg_system_id) ON DELETE CASCADE;


--
-- Name: character_attribute fk_character_attribute_definition_same_system; Type: FK CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.character_attribute
    ADD CONSTRAINT fk_character_attribute_definition_same_system FOREIGN KEY (attribute_id, rpg_system_id) REFERENCES core.attribute_definition(id, rpg_system_id) ON DELETE CASCADE;


--
-- Name: character_class fk_character_class_character_same_system; Type: FK CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.character_class
    ADD CONSTRAINT fk_character_class_character_same_system FOREIGN KEY (character_id, rpg_system_id) REFERENCES core.rpg_character(id, rpg_system_id) ON DELETE CASCADE;


--
-- Name: character_class fk_character_class_definition_same_system; Type: FK CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.character_class
    ADD CONSTRAINT fk_character_class_definition_same_system FOREIGN KEY (class_id, rpg_system_id) REFERENCES core.class_definition(id, rpg_system_id) ON DELETE RESTRICT;


--
-- Name: character_item fk_character_item_character_same_system; Type: FK CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.character_item
    ADD CONSTRAINT fk_character_item_character_same_system FOREIGN KEY (character_id, rpg_system_id) REFERENCES core.rpg_character(id, rpg_system_id) ON DELETE CASCADE;


--
-- Name: character_item fk_character_item_definition_same_system; Type: FK CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.character_item
    ADD CONSTRAINT fk_character_item_definition_same_system FOREIGN KEY (item_id, rpg_system_id) REFERENCES core.item_definition(id, rpg_system_id) ON DELETE RESTRICT;


--
-- Name: character_origin fk_character_origin_character_same_system; Type: FK CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.character_origin
    ADD CONSTRAINT fk_character_origin_character_same_system FOREIGN KEY (character_id, rpg_system_id) REFERENCES core.rpg_character(id, rpg_system_id) ON DELETE CASCADE;


--
-- Name: character_origin fk_character_origin_definition_same_system; Type: FK CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.character_origin
    ADD CONSTRAINT fk_character_origin_definition_same_system FOREIGN KEY (origin_id, rpg_system_id) REFERENCES core.origin_definition(id, rpg_system_id) ON DELETE RESTRICT;


--
-- Name: character_proficiency fk_character_proficiency_character_same_system; Type: FK CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.character_proficiency
    ADD CONSTRAINT fk_character_proficiency_character_same_system FOREIGN KEY (character_id, rpg_system_id) REFERENCES core.rpg_character(id, rpg_system_id) ON DELETE CASCADE;


--
-- Name: character_proficiency fk_character_proficiency_definition_same_system; Type: FK CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.character_proficiency
    ADD CONSTRAINT fk_character_proficiency_definition_same_system FOREIGN KEY (proficiency_id, rpg_system_id) REFERENCES core.proficiency_definition(id, rpg_system_id) ON DELETE CASCADE;


--
-- Name: character_progression fk_character_progression_character_same_system; Type: FK CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.character_progression
    ADD CONSTRAINT fk_character_progression_character_same_system FOREIGN KEY (character_id, rpg_system_id) REFERENCES core.rpg_character(id, rpg_system_id) ON DELETE CASCADE;


--
-- Name: character_progression fk_character_progression_definition_same_system; Type: FK CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.character_progression
    ADD CONSTRAINT fk_character_progression_definition_same_system FOREIGN KEY (progression_id, rpg_system_id) REFERENCES core.progression_definition(id, rpg_system_id) ON DELETE CASCADE;


--
-- Name: character_resistance fk_character_resistance_character_same_system; Type: FK CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.character_resistance
    ADD CONSTRAINT fk_character_resistance_character_same_system FOREIGN KEY (character_id, rpg_system_id) REFERENCES core.rpg_character(id, rpg_system_id) ON DELETE CASCADE;


--
-- Name: character_resistance fk_character_resistance_definition_same_system; Type: FK CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.character_resistance
    ADD CONSTRAINT fk_character_resistance_definition_same_system FOREIGN KEY (resistance_id, rpg_system_id) REFERENCES core.resistance_definition(id, rpg_system_id) ON DELETE CASCADE;


--
-- Name: character_resource fk_character_resource_character_same_system; Type: FK CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.character_resource
    ADD CONSTRAINT fk_character_resource_character_same_system FOREIGN KEY (character_id, rpg_system_id) REFERENCES core.rpg_character(id, rpg_system_id) ON DELETE CASCADE;


--
-- Name: character_resource fk_character_resource_definition_same_system; Type: FK CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.character_resource
    ADD CONSTRAINT fk_character_resource_definition_same_system FOREIGN KEY (resource_id, rpg_system_id) REFERENCES core.resource_definition(id, rpg_system_id) ON DELETE CASCADE;


--
-- Name: character_skill fk_character_skill_character_same_system; Type: FK CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.character_skill
    ADD CONSTRAINT fk_character_skill_character_same_system FOREIGN KEY (character_id, rpg_system_id) REFERENCES core.rpg_character(id, rpg_system_id) ON DELETE CASCADE;


--
-- Name: character_skill fk_character_skill_definition_same_system; Type: FK CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.character_skill
    ADD CONSTRAINT fk_character_skill_definition_same_system FOREIGN KEY (skill_id, rpg_system_id) REFERENCES core.skill_definition(id, rpg_system_id) ON DELETE CASCADE;


--
-- Name: character_skill fk_character_skill_training_level_same_system; Type: FK CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.character_skill
    ADD CONSTRAINT fk_character_skill_training_level_same_system FOREIGN KEY (training_level_id, rpg_system_id) REFERENCES core.skill_training_level(id, rpg_system_id) ON DELETE RESTRICT;


--
-- Name: character_stat fk_character_stat_character_same_system; Type: FK CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.character_stat
    ADD CONSTRAINT fk_character_stat_character_same_system FOREIGN KEY (character_id, rpg_system_id) REFERENCES core.rpg_character(id, rpg_system_id) ON DELETE CASCADE;


--
-- Name: character_stat fk_character_stat_definition_same_system; Type: FK CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.character_stat
    ADD CONSTRAINT fk_character_stat_definition_same_system FOREIGN KEY (stat_id, rpg_system_id) REFERENCES core.stat_definition(id, rpg_system_id) ON DELETE CASCADE;


--
-- Name: class_ability_unlock fk_class_ability_unlock_ability_same_system; Type: FK CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.class_ability_unlock
    ADD CONSTRAINT fk_class_ability_unlock_ability_same_system FOREIGN KEY (ability_id, rpg_system_id) REFERENCES core.ability_definition(id, rpg_system_id) ON DELETE CASCADE;


--
-- Name: class_ability_unlock fk_class_ability_unlock_class_same_system; Type: FK CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.class_ability_unlock
    ADD CONSTRAINT fk_class_ability_unlock_class_same_system FOREIGN KEY (class_id, rpg_system_id) REFERENCES core.class_definition(id, rpg_system_id) ON DELETE CASCADE;


--
-- Name: class_proficiency fk_class_proficiency_class_same_system; Type: FK CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.class_proficiency
    ADD CONSTRAINT fk_class_proficiency_class_same_system FOREIGN KEY (class_id, rpg_system_id) REFERENCES core.class_definition(id, rpg_system_id) ON DELETE CASCADE;


--
-- Name: class_proficiency fk_class_proficiency_proficiency_same_system; Type: FK CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.class_proficiency
    ADD CONSTRAINT fk_class_proficiency_proficiency_same_system FOREIGN KEY (proficiency_id, rpg_system_id) REFERENCES core.proficiency_definition(id, rpg_system_id) ON DELETE CASCADE;


--
-- Name: item_type fk_item_type_parent_same_system; Type: FK CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.item_type
    ADD CONSTRAINT fk_item_type_parent_same_system FOREIGN KEY (parent_id, rpg_system_id) REFERENCES core.item_type(id, rpg_system_id) ON DELETE CASCADE;


--
-- Name: item_definition fk_item_type_same_system; Type: FK CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.item_definition
    ADD CONSTRAINT fk_item_type_same_system FOREIGN KEY (item_type_id, rpg_system_id) REFERENCES core.item_type(id, rpg_system_id) ON DELETE RESTRICT;


--
-- Name: origin_ability fk_origin_ability_ability_same_system; Type: FK CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.origin_ability
    ADD CONSTRAINT fk_origin_ability_ability_same_system FOREIGN KEY (ability_id, rpg_system_id) REFERENCES core.ability_definition(id, rpg_system_id) ON DELETE CASCADE;


--
-- Name: origin_ability fk_origin_ability_origin_same_system; Type: FK CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.origin_ability
    ADD CONSTRAINT fk_origin_ability_origin_same_system FOREIGN KEY (origin_id, rpg_system_id) REFERENCES core.origin_definition(id, rpg_system_id) ON DELETE CASCADE;


--
-- Name: progression_tier fk_progression_tier_same_system; Type: FK CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.progression_tier
    ADD CONSTRAINT fk_progression_tier_same_system FOREIGN KEY (progression_id, rpg_system_id) REFERENCES core.progression_definition(id, rpg_system_id) ON DELETE CASCADE;


--
-- Name: skill_definition fk_skill_base_attribute_same_system; Type: FK CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.skill_definition
    ADD CONSTRAINT fk_skill_base_attribute_same_system FOREIGN KEY (base_attribute_id, rpg_system_id) REFERENCES core.attribute_definition(id, rpg_system_id) ON DELETE RESTRICT;


--
-- Name: item_definition item_definition_item_type_id_fkey; Type: FK CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.item_definition
    ADD CONSTRAINT item_definition_item_type_id_fkey FOREIGN KEY (item_type_id) REFERENCES core.item_type(id) ON DELETE RESTRICT;


--
-- Name: item_definition item_definition_rpg_system_id_fkey; Type: FK CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.item_definition
    ADD CONSTRAINT item_definition_rpg_system_id_fkey FOREIGN KEY (rpg_system_id) REFERENCES core.rpg_system(id) ON DELETE CASCADE;


--
-- Name: item_type item_type_parent_id_fkey; Type: FK CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.item_type
    ADD CONSTRAINT item_type_parent_id_fkey FOREIGN KEY (parent_id) REFERENCES core.item_type(id) ON DELETE CASCADE;


--
-- Name: item_type item_type_rpg_system_id_fkey; Type: FK CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.item_type
    ADD CONSTRAINT item_type_rpg_system_id_fkey FOREIGN KEY (rpg_system_id) REFERENCES core.rpg_system(id) ON DELETE CASCADE;


--
-- Name: origin_ability origin_ability_ability_id_fkey; Type: FK CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.origin_ability
    ADD CONSTRAINT origin_ability_ability_id_fkey FOREIGN KEY (ability_id) REFERENCES core.ability_definition(id) ON DELETE CASCADE;


--
-- Name: origin_ability origin_ability_origin_id_fkey; Type: FK CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.origin_ability
    ADD CONSTRAINT origin_ability_origin_id_fkey FOREIGN KEY (origin_id) REFERENCES core.origin_definition(id) ON DELETE CASCADE;


--
-- Name: origin_definition origin_definition_rpg_system_id_fkey; Type: FK CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.origin_definition
    ADD CONSTRAINT origin_definition_rpg_system_id_fkey FOREIGN KEY (rpg_system_id) REFERENCES core.rpg_system(id) ON DELETE CASCADE;


--
-- Name: proficiency_definition proficiency_definition_rpg_system_id_fkey; Type: FK CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.proficiency_definition
    ADD CONSTRAINT proficiency_definition_rpg_system_id_fkey FOREIGN KEY (rpg_system_id) REFERENCES core.rpg_system(id) ON DELETE CASCADE;


--
-- Name: progression_definition progression_definition_rpg_system_id_fkey; Type: FK CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.progression_definition
    ADD CONSTRAINT progression_definition_rpg_system_id_fkey FOREIGN KEY (rpg_system_id) REFERENCES core.rpg_system(id) ON DELETE CASCADE;


--
-- Name: progression_tier progression_tier_progression_id_fkey; Type: FK CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.progression_tier
    ADD CONSTRAINT progression_tier_progression_id_fkey FOREIGN KEY (progression_id) REFERENCES core.progression_definition(id) ON DELETE CASCADE;


--
-- Name: resistance_definition resistance_definition_rpg_system_id_fkey; Type: FK CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.resistance_definition
    ADD CONSTRAINT resistance_definition_rpg_system_id_fkey FOREIGN KEY (rpg_system_id) REFERENCES core.rpg_system(id) ON DELETE CASCADE;


--
-- Name: resource_definition resource_definition_rpg_system_id_fkey; Type: FK CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.resource_definition
    ADD CONSTRAINT resource_definition_rpg_system_id_fkey FOREIGN KEY (rpg_system_id) REFERENCES core.rpg_system(id) ON DELETE CASCADE;


--
-- Name: rpg_character rpg_character_rpg_system_id_fkey; Type: FK CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.rpg_character
    ADD CONSTRAINT rpg_character_rpg_system_id_fkey FOREIGN KEY (rpg_system_id) REFERENCES core.rpg_system(id) ON DELETE RESTRICT;


--
-- Name: skill_definition skill_definition_base_attribute_id_fkey; Type: FK CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.skill_definition
    ADD CONSTRAINT skill_definition_base_attribute_id_fkey FOREIGN KEY (base_attribute_id) REFERENCES core.attribute_definition(id) ON DELETE RESTRICT;


--
-- Name: skill_definition skill_definition_rpg_system_id_fkey; Type: FK CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.skill_definition
    ADD CONSTRAINT skill_definition_rpg_system_id_fkey FOREIGN KEY (rpg_system_id) REFERENCES core.rpg_system(id) ON DELETE CASCADE;


--
-- Name: skill_training_level skill_training_level_rpg_system_id_fkey; Type: FK CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.skill_training_level
    ADD CONSTRAINT skill_training_level_rpg_system_id_fkey FOREIGN KEY (rpg_system_id) REFERENCES core.rpg_system(id) ON DELETE CASCADE;


--
-- Name: stat_definition stat_definition_rpg_system_id_fkey; Type: FK CONSTRAINT; Schema: core; Owner: postgres
--

ALTER TABLE ONLY core.stat_definition
    ADD CONSTRAINT stat_definition_rpg_system_id_fkey FOREIGN KEY (rpg_system_id) REFERENCES core.rpg_system(id) ON DELETE CASCADE;


--
-- Name: ammunition ammunition_item_id_fkey; Type: FK CONSTRAINT; Schema: ordem; Owner: postgres
--

ALTER TABLE ONLY ordem.ammunition
    ADD CONSTRAINT ammunition_item_id_fkey FOREIGN KEY (item_id) REFERENCES core.item_definition(id) ON DELETE CASCADE;


--
-- Name: character_detail character_detail_character_id_fkey; Type: FK CONSTRAINT; Schema: ordem; Owner: postgres
--

ALTER TABLE ONLY ordem.character_detail
    ADD CONSTRAINT character_detail_character_id_fkey FOREIGN KEY (character_id) REFERENCES core.rpg_character(id) ON DELETE CASCADE;


--
-- Name: class_rule class_rule_class_id_fkey; Type: FK CONSTRAINT; Schema: ordem; Owner: postgres
--

ALTER TABLE ONLY ordem.class_rule
    ADD CONSTRAINT class_rule_class_id_fkey FOREIGN KEY (class_id) REFERENCES core.class_definition(id) ON DELETE CASCADE;


--
-- Name: combat_action_rule combat_action_rule_action_id_fkey; Type: FK CONSTRAINT; Schema: ordem; Owner: postgres
--

ALTER TABLE ONLY ordem.combat_action_rule
    ADD CONSTRAINT combat_action_rule_action_id_fkey FOREIGN KEY (action_id) REFERENCES core.action_definition(id) ON DELETE CASCADE;


--
-- Name: combat_action_rule combat_action_rule_required_skill_id_fkey; Type: FK CONSTRAINT; Schema: ordem; Owner: postgres
--

ALTER TABLE ONLY ordem.combat_action_rule
    ADD CONSTRAINT combat_action_rule_required_skill_id_fkey FOREIGN KEY (required_skill_id) REFERENCES core.skill_definition(id) ON DELETE RESTRICT;


--
-- Name: combat_maneuver combat_maneuver_action_id_fkey; Type: FK CONSTRAINT; Schema: ordem; Owner: postgres
--

ALTER TABLE ONLY ordem.combat_maneuver
    ADD CONSTRAINT combat_maneuver_action_id_fkey FOREIGN KEY (action_id) REFERENCES core.action_definition(id) ON DELETE RESTRICT;


--
-- Name: combat_maneuver combat_maneuver_base_skill_id_fkey; Type: FK CONSTRAINT; Schema: ordem; Owner: postgres
--

ALTER TABLE ONLY ordem.combat_maneuver
    ADD CONSTRAINT combat_maneuver_base_skill_id_fkey FOREIGN KEY (base_skill_id) REFERENCES core.skill_definition(id) ON DELETE RESTRICT;


--
-- Name: combat_maneuver combat_maneuver_effect_condition_id_fkey; Type: FK CONSTRAINT; Schema: ordem; Owner: postgres
--

ALTER TABLE ONLY ordem.combat_maneuver
    ADD CONSTRAINT combat_maneuver_effect_condition_id_fkey FOREIGN KEY (effect_condition_id) REFERENCES core.condition_definition(id) ON DELETE RESTRICT;


--
-- Name: combat_maneuver combat_maneuver_opposed_skill_id_fkey; Type: FK CONSTRAINT; Schema: ordem; Owner: postgres
--

ALTER TABLE ONLY ordem.combat_maneuver
    ADD CONSTRAINT combat_maneuver_opposed_skill_id_fkey FOREIGN KEY (opposed_skill_id) REFERENCES core.skill_definition(id) ON DELETE RESTRICT;


--
-- Name: condition_relation condition_relation_condition_id_fkey; Type: FK CONSTRAINT; Schema: ordem; Owner: postgres
--

ALTER TABLE ONLY ordem.condition_relation
    ADD CONSTRAINT condition_relation_condition_id_fkey FOREIGN KEY (condition_id) REFERENCES core.condition_definition(id) ON DELETE CASCADE;


--
-- Name: condition_relation condition_relation_related_condition_id_fkey; Type: FK CONSTRAINT; Schema: ordem; Owner: postgres
--

ALTER TABLE ONLY ordem.condition_relation
    ADD CONSTRAINT condition_relation_related_condition_id_fkey FOREIGN KEY (related_condition_id) REFERENCES core.condition_definition(id) ON DELETE CASCADE;


--
-- Name: condition_rule condition_rule_condition_id_fkey; Type: FK CONSTRAINT; Schema: ordem; Owner: postgres
--

ALTER TABLE ONLY ordem.condition_rule
    ADD CONSTRAINT condition_rule_condition_id_fkey FOREIGN KEY (condition_id) REFERENCES core.condition_definition(id) ON DELETE CASCADE;


--
-- Name: curse_definition curse_definition_element_id_fkey; Type: FK CONSTRAINT; Schema: ordem; Owner: postgres
--

ALTER TABLE ONLY ordem.curse_definition
    ADD CONSTRAINT curse_definition_element_id_fkey FOREIGN KEY (element_id) REFERENCES ordem.element(id) ON DELETE RESTRICT;


--
-- Name: curse_price_rule curse_price_rule_element_id_fkey; Type: FK CONSTRAINT; Schema: ordem; Owner: postgres
--

ALTER TABLE ONLY ordem.curse_price_rule
    ADD CONSTRAINT curse_price_rule_element_id_fkey FOREIGN KEY (element_id) REFERENCES ordem.element(id) ON DELETE CASCADE;


--
-- Name: defensive_reaction_rule defensive_reaction_rule_required_skill_id_fkey; Type: FK CONSTRAINT; Schema: ordem; Owner: postgres
--

ALTER TABLE ONLY ordem.defensive_reaction_rule
    ADD CONSTRAINT defensive_reaction_rule_required_skill_id_fkey FOREIGN KEY (required_skill_id) REFERENCES core.skill_definition(id) ON DELETE RESTRICT;


--
-- Name: threat fk_ordem_threat_size; Type: FK CONSTRAINT; Schema: ordem; Owner: postgres
--

ALTER TABLE ONLY ordem.threat
    ADD CONSTRAINT fk_ordem_threat_size FOREIGN KEY (size_id) REFERENCES ordem.threat_size(id) ON DELETE RESTRICT;


--
-- Name: interlude_action_rule interlude_action_rule_action_id_fkey; Type: FK CONSTRAINT; Schema: ordem; Owner: postgres
--

ALTER TABLE ONLY ordem.interlude_action_rule
    ADD CONSTRAINT interlude_action_rule_action_id_fkey FOREIGN KEY (action_id) REFERENCES core.downtime_action_definition(id) ON DELETE CASCADE;


--
-- Name: item_rule item_rule_item_id_fkey; Type: FK CONSTRAINT; Schema: ordem; Owner: postgres
--

ALTER TABLE ONLY ordem.item_rule
    ADD CONSTRAINT item_rule_item_id_fkey FOREIGN KEY (item_id) REFERENCES core.item_definition(id) ON DELETE CASCADE;


--
-- Name: origin_skill_grant origin_skill_grant_origin_id_fkey; Type: FK CONSTRAINT; Schema: ordem; Owner: postgres
--

ALTER TABLE ONLY ordem.origin_skill_grant
    ADD CONSTRAINT origin_skill_grant_origin_id_fkey FOREIGN KEY (origin_id) REFERENCES core.origin_definition(id) ON DELETE CASCADE;


--
-- Name: origin_skill_grant origin_skill_grant_skill_id_fkey; Type: FK CONSTRAINT; Schema: ordem; Owner: postgres
--

ALTER TABLE ONLY ordem.origin_skill_grant
    ADD CONSTRAINT origin_skill_grant_skill_id_fkey FOREIGN KEY (skill_id) REFERENCES core.skill_definition(id) ON DELETE CASCADE;


--
-- Name: patent_rule patent_rule_progression_tier_id_fkey; Type: FK CONSTRAINT; Schema: ordem; Owner: postgres
--

ALTER TABLE ONLY ordem.patent_rule
    ADD CONSTRAINT patent_rule_progression_tier_id_fkey FOREIGN KEY (progression_tier_id) REFERENCES core.progression_tier(id) ON DELETE CASCADE;


--
-- Name: protection protection_item_id_fkey; Type: FK CONSTRAINT; Schema: ordem; Owner: postgres
--

ALTER TABLE ONLY ordem.protection
    ADD CONSTRAINT protection_item_id_fkey FOREIGN KEY (item_id) REFERENCES core.item_definition(id) ON DELETE CASCADE;


--
-- Name: protection protection_proficiency_id_fkey; Type: FK CONSTRAINT; Schema: ordem; Owner: postgres
--

ALTER TABLE ONLY ordem.protection
    ADD CONSTRAINT protection_proficiency_id_fkey FOREIGN KEY (proficiency_id) REFERENCES core.proficiency_definition(id) ON DELETE RESTRICT;


--
-- Name: ritual ritual_ability_id_fkey; Type: FK CONSTRAINT; Schema: ordem; Owner: postgres
--

ALTER TABLE ONLY ordem.ritual
    ADD CONSTRAINT ritual_ability_id_fkey FOREIGN KEY (ability_id) REFERENCES core.ability_definition(id) ON DELETE CASCADE;


--
-- Name: ritual ritual_element_id_fkey; Type: FK CONSTRAINT; Schema: ordem; Owner: postgres
--

ALTER TABLE ONLY ordem.ritual
    ADD CONSTRAINT ritual_element_id_fkey FOREIGN KEY (element_id) REFERENCES ordem.element(id) ON DELETE RESTRICT;


--
-- Name: skill_rule skill_rule_skill_id_fkey; Type: FK CONSTRAINT; Schema: ordem; Owner: postgres
--

ALTER TABLE ONLY ordem.skill_rule
    ADD CONSTRAINT skill_rule_skill_id_fkey FOREIGN KEY (skill_id) REFERENCES core.skill_definition(id) ON DELETE CASCADE;


--
-- Name: special_cursed_item special_cursed_item_element_id_fkey; Type: FK CONSTRAINT; Schema: ordem; Owner: postgres
--

ALTER TABLE ONLY ordem.special_cursed_item
    ADD CONSTRAINT special_cursed_item_element_id_fkey FOREIGN KEY (element_id) REFERENCES ordem.element(id) ON DELETE RESTRICT;


--
-- Name: special_cursed_item special_cursed_item_item_id_fkey; Type: FK CONSTRAINT; Schema: ordem; Owner: postgres
--

ALTER TABLE ONLY ordem.special_cursed_item
    ADD CONSTRAINT special_cursed_item_item_id_fkey FOREIGN KEY (item_id) REFERENCES core.item_definition(id) ON DELETE CASCADE;


--
-- Name: threat_ability threat_ability_threat_id_fkey; Type: FK CONSTRAINT; Schema: ordem; Owner: postgres
--

ALTER TABLE ONLY ordem.threat_ability
    ADD CONSTRAINT threat_ability_threat_id_fkey FOREIGN KEY (threat_id) REFERENCES ordem.threat(character_id) ON DELETE CASCADE;


--
-- Name: threat_action threat_action_threat_id_fkey; Type: FK CONSTRAINT; Schema: ordem; Owner: postgres
--

ALTER TABLE ONLY ordem.threat_action
    ADD CONSTRAINT threat_action_threat_id_fkey FOREIGN KEY (threat_id) REFERENCES ordem.threat(character_id) ON DELETE CASCADE;


--
-- Name: threat threat_being_type_id_fkey; Type: FK CONSTRAINT; Schema: ordem; Owner: postgres
--

ALTER TABLE ONLY ordem.threat
    ADD CONSTRAINT threat_being_type_id_fkey FOREIGN KEY (being_type_id) REFERENCES ordem.being_type(id) ON DELETE RESTRICT;


--
-- Name: threat threat_character_id_fkey; Type: FK CONSTRAINT; Schema: ordem; Owner: postgres
--

ALTER TABLE ONLY ordem.threat
    ADD CONSTRAINT threat_character_id_fkey FOREIGN KEY (character_id) REFERENCES core.rpg_character(id) ON DELETE CASCADE;


--
-- Name: threat_defense_trait threat_defense_trait_threat_id_fkey; Type: FK CONSTRAINT; Schema: ordem; Owner: postgres
--

ALTER TABLE ONLY ordem.threat_defense_trait
    ADD CONSTRAINT threat_defense_trait_threat_id_fkey FOREIGN KEY (threat_id) REFERENCES ordem.threat(character_id) ON DELETE CASCADE;


--
-- Name: threat_descriptor threat_descriptor_threat_id_fkey; Type: FK CONSTRAINT; Schema: ordem; Owner: postgres
--

ALTER TABLE ONLY ordem.threat_descriptor
    ADD CONSTRAINT threat_descriptor_threat_id_fkey FOREIGN KEY (threat_id) REFERENCES ordem.threat(character_id) ON DELETE CASCADE;


--
-- Name: threat_element threat_element_element_id_fkey; Type: FK CONSTRAINT; Schema: ordem; Owner: postgres
--

ALTER TABLE ONLY ordem.threat_element
    ADD CONSTRAINT threat_element_element_id_fkey FOREIGN KEY (element_id) REFERENCES ordem.element(id) ON DELETE RESTRICT;


--
-- Name: threat_element threat_element_threat_id_fkey; Type: FK CONSTRAINT; Schema: ordem; Owner: postgres
--

ALTER TABLE ONLY ordem.threat_element
    ADD CONSTRAINT threat_element_threat_id_fkey FOREIGN KEY (threat_id) REFERENCES ordem.threat(character_id) ON DELETE CASCADE;


--
-- Name: threat_skill threat_skill_skill_id_fkey; Type: FK CONSTRAINT; Schema: ordem; Owner: postgres
--

ALTER TABLE ONLY ordem.threat_skill
    ADD CONSTRAINT threat_skill_skill_id_fkey FOREIGN KEY (skill_id) REFERENCES core.skill_definition(id) ON DELETE RESTRICT;


--
-- Name: threat_skill threat_skill_threat_id_fkey; Type: FK CONSTRAINT; Schema: ordem; Owner: postgres
--

ALTER TABLE ONLY ordem.threat_skill
    ADD CONSTRAINT threat_skill_threat_id_fkey FOREIGN KEY (threat_id) REFERENCES ordem.threat(character_id) ON DELETE CASCADE;


--
-- Name: weapon weapon_ammunition_item_id_fkey; Type: FK CONSTRAINT; Schema: ordem; Owner: postgres
--

ALTER TABLE ONLY ordem.weapon
    ADD CONSTRAINT weapon_ammunition_item_id_fkey FOREIGN KEY (ammunition_item_id) REFERENCES core.item_definition(id) ON DELETE RESTRICT;


--
-- Name: weapon weapon_item_id_fkey; Type: FK CONSTRAINT; Schema: ordem; Owner: postgres
--

ALTER TABLE ONLY ordem.weapon
    ADD CONSTRAINT weapon_item_id_fkey FOREIGN KEY (item_id) REFERENCES core.item_definition(id) ON DELETE CASCADE;


--
-- Name: weapon weapon_proficiency_id_fkey; Type: FK CONSTRAINT; Schema: ordem; Owner: postgres
--

ALTER TABLE ONLY ordem.weapon
    ADD CONSTRAINT weapon_proficiency_id_fkey FOREIGN KEY (proficiency_id) REFERENCES core.proficiency_definition(id) ON DELETE RESTRICT;


--
-- PostgreSQL database dump complete
--

\unrestrict 7GtLPCQQmNpHsAa6Jeaulfp4doISXfpEdgLl7ZLMg9wq17pO9ZrVfLEMQRh0HVI

