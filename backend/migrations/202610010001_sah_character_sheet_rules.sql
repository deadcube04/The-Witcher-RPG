-- +goose Up
-- +goose StatementBegin
DO $$
DECLARE
    sid uuid;
    allowed_slugs text[] := ARRAY[
        'limites-de-itens-vestidos',
        'nex-experiencia',
        'nex-experiencia-p99-ganhando-nex',
        'nex-experiencia-p100-separando-nivel-e-nex',
        'nex-experiencia-p100-progressao-de-nex',
        'nex-experiencia-p100-alteracoes-gerais',
        'nex-experiencia-p101-alteracoes-de-morte',
        'nex-experiencia-p101-alteracoes-de-sangue',
        'nex-experiencia-p102-alteracoes-de-conhecimento',
        'nex-experiencia-p103-alteracoes-de-energia',
        'nex-experiencia-p104-modificando-alteracoes',
        'jogando-sem-sanidade',
        'evolucao-por-patentes',
        'evolucao-por-patentes-p110-evoluindo-de-patente',
        'evolucao-por-patentes-p111-habilidades-de-classe',
        'evolucao-por-patentes-p111-pericias-treinadas',
        'evolucao-por-patentes-p112-pericias-treinadas',
        'evolucao-por-patentes-p113-pericias-treinadas',
        'evolucao-por-patentes-p113-habilidades-de-classe',
        'os-limites-da-compreensao-humana',
        'os-limites-da-compreensao-humana-p114-estudando-rituais'
    ];
    removed_rule_ids uuid[];
    removed_issue_ids uuid[];
BEGIN
    SELECT s.id INTO STRICT sid
    FROM core.rpg_supplement s
    JOIN core.rpg_system sys ON sys.id = s.rpg_system_id
    WHERE s.slug = 'sobrevivendo-ao-horror' AND sys.slug = 'ordem-paranormal';

    SELECT coalesce(array_agg(id), ARRAY[]::uuid[]) INTO removed_rule_ids
    FROM ordem.supplement_rule
    WHERE supplement_id = sid AND NOT (slug = ANY(allowed_slugs));

    SELECT coalesce(array_agg(i.id), ARRAY[]::uuid[]) INTO removed_issue_ids
    FROM ordem.supplement_review_issue i
    WHERE i.supplement_id = sid AND (
        i.source_page BETWEEN 82 AND 98
        OR i.source_page BETWEEN 107 AND 108
        OR i.source_page BETWEEN 115 AND 124
        OR EXISTS (
            SELECT 1 FROM ordem.supplement_review_target t
            WHERE t.issue_id = i.id AND t.target_kind = 'rule'
                AND t.target_id = ANY(removed_rule_ids)
        )
    );

    DELETE FROM ordem.supplement_review_audit WHERE issue_id = ANY(removed_issue_ids)
        OR (target_kind = 'rule' AND target_id = ANY(removed_rule_ids));
    DELETE FROM ordem.supplement_review_issue WHERE id = ANY(removed_issue_ids);
    DELETE FROM ordem.campaign_supplement_rule WHERE rule_id = ANY(removed_rule_ids);
    DELETE FROM ordem.character_supplement_rule WHERE rule_id = ANY(removed_rule_ids);
    -- Parent/child, relation and content-link foreign keys cascade these deletions.
    DELETE FROM ordem.supplement_rule WHERE id = ANY(removed_rule_ids);

    -- Remove mission rewards from retained patent rules before trimming the source.
    UPDATE ordem.supplement_rule r
    SET rule_text = replace(r.rule_text,
        substring(p.raw_text FROM position(E'PONTOS DE\nPRESTÍGIO POR MISSÃO' IN p.raw_text)), '')
    FROM core.supplement_page p
    WHERE r.supplement_id = sid AND p.supplement_id = sid AND p.pdf_page = 110
        AND r.slug IN ('evolucao-por-patentes', 'evolucao-por-patentes-p110-evoluindo-de-patente')
        AND position(E'PONTOS DE\nPRESTÍGIO POR MISSÃO' IN p.raw_text) > 0;

    UPDATE core.supplement_page
    SET raw_text = rtrim(split_part(raw_text, CASE pdf_page
            WHEN 39 THEN 'SOBREVIVÊNCIA E MUNIÇÃO'
            WHEN 40 THEN 'OPÇÃO: DURAÇÃO'
            WHEN 106 THEN 'FERIMENTOS'
            WHEN 110 THEN E'PONTOS DE\nPRESTÍGIO POR MISSÃO'
        END, 1), E' \r\n')
    WHERE supplement_id = sid AND pdf_page IN (39, 40, 106, 110);

    UPDATE core.supplement_page
    SET sha256 = encode(digest(convert_to(raw_text, 'UTF8'), 'sha256'), 'hex')
    WHERE supplement_id = sid AND pdf_page IN (39, 40, 106, 110);

    -- The original import cut off the end of Determination at the next page.
    UPDATE ordem.supplement_rule r
    SET rule_text = r.rule_text || E'\n' || p.raw_text, source_page_end = 106
    FROM core.supplement_page p
    WHERE r.supplement_id = sid AND r.slug = 'jogando-sem-sanidade'
        AND r.source_page_end = 105 AND p.supplement_id = sid AND p.pdf_page = 106;

    DELETE FROM core.supplement_page
    WHERE supplement_id = sid AND (
        pdf_page BETWEEN 82 AND 98 OR pdf_page BETWEEN 107 AND 108
        OR pdf_page BETWEEN 115 AND 124
    );

    -- Discard glyph-review excerpts belonging to removed parts of mixed pages.
    SELECT coalesce(array_agg(i.id), ARRAY[]::uuid[]) INTO removed_issue_ids
    FROM ordem.supplement_review_issue i
    JOIN core.supplement_page p ON p.supplement_id = i.supplement_id
        AND p.pdf_page = i.source_page
    WHERE i.supplement_id = sid AND i.issue_kind = 'dice_glyph'
        AND i.source_page IN (39, 40, 106, 110)
        AND position(i.source_text IN p.raw_text) = 0;
    DELETE FROM ordem.supplement_review_audit WHERE issue_id = ANY(removed_issue_ids);
    DELETE FROM ordem.supplement_review_issue WHERE id = ANY(removed_issue_ids);

    -- Reject future imports of rules outside the character-sheet catalog.
    EXECUTE format(
        'ALTER TABLE ordem.supplement_rule ADD CONSTRAINT sah_character_sheet_rules_only CHECK (supplement_id <> %L::uuid OR slug = ANY(%L::text[]))',
        sid, allowed_slugs
    );
END $$;
-- +goose StatementEnd

-- +goose Down
-- Purged rules and selections must not be silently recreated by rollback.
-- +goose StatementBegin
DO $$ BEGIN
    RAISE EXCEPTION 'Character-sheet rule cleanup is irreversible; restore a backup to recover removed data';
END $$;
-- +goose StatementEnd
