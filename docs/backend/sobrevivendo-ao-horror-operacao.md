# Sobrevivendo ao Horror: aplicação e verificação

As migrations [`202609300001_sah_structure.sql`](../../backend/migrations/202609300001_sah_structure.sql) e [`202609300002_sah_data.sql`](../../backend/migrations/202609300002_sah_data.sql) são executadas pelo Goose na ordem indicada. A segunda contém a carga inteira e as conferências SQL finais. Ela deve rodar após as migrations anteriores do backend.

## Aplicar

Configure `DATABASE_URL` para o banco de destino antes de iniciar. Confirme o nome do banco na mesma sessão do PowerShell; isso evita executar o comando contra o `.env` local por engano.

```powershell
cd C:\rpg-project\backend
psql -X -qAt -d $env:DATABASE_URL -c 'SELECT current_database()'
go run github.com/pressly/goose/v3/cmd/goose@v3.28.0 -dir migrations postgres $env:DATABASE_URL status
go run ./cmd/migrate up
```

O comando `./cmd/migrate` carrega `.env` para variáveis ainda ausentes. Por isso, confira que `DATABASE_URL` já aponta para o destino pretendido. Cada migration SQL roda em transação: falha de chave estrangeira, colisão ou conferência final impede uma carga parcial.

## Conferir a carga

As consultas abaixo devem ser executadas no banco que recebeu as migrations. Elas não alteram dados.

```sql
SELECT s.slug, count(p.*) AS paginas,
       count(p.*) FILTER (
           WHERE p.sha256 = encode(digest(convert_to(p.raw_text, 'UTF8'), 'sha256'), 'hex')
       ) AS hashes_validos
FROM core.rpg_supplement s
JOIN core.supplement_page p ON p.supplement_id = s.id
WHERE s.slug = 'sobrevivendo-ao-horror'
GROUP BY s.slug;
-- Esperado: 140 páginas e 140 hashes válidos.

SELECT a.ability_type, count(*)
FROM core.ability_definition a
JOIN core.rpg_supplement s ON s.id = a.supplement_id
WHERE s.slug = 'sobrevivendo-ao-horror'
GROUP BY a.ability_type
ORDER BY a.ability_type;
-- Esperado: ORIGIN_POWER 20, CLASS_POWER 31, TRAIL_ABILITY 36,
-- GENERAL_POWER 34, PARANORMAL_POWER 8 e RITUAL 16.

SELECT count(*) AS espacos_fracionarios,
       count(*) FILTER (WHERE r.spaces IS NOT NULL) AS arredondados_no_campo_antigo
FROM ordem.supplement_item_detail d
JOIN ordem.item_rule r ON r.item_id = d.item_id
WHERE d.exact_spaces <> trunc(d.exact_spaces);
-- Esperado: 18 e 0.

SELECT issue_kind, count(*)
FROM ordem.supplement_review_issue
WHERE NOT resolved
GROUP BY issue_kind
ORDER BY issue_kind;
-- Carga inicial: 67 dice_glyph, 21 unmatched_heading,
-- 2 incomplete_ritual_header e 3 modification_category.
```

A migration confere ainda contagens dos outros domínios, as 45 versões de rituais, o exemplo separado do Espectro, os PV `1000` do Amigo Imaginário e a ausência de espaços inteiros preenchidos para itens fracionários. As chaves estrangeiras validam suplemento, sistema, páginas e relações entre registros.

## Reverter

Confirme novamente o destino. Execute `down` duas vezes, primeiro para retirar os dados e depois para retirar a estrutura:

```powershell
cd C:\rpg-project\backend
psql -X -qAt -d $env:DATABASE_URL -c 'SELECT current_database()'
go run github.com/pressly/goose/v3/cmd/goose@v3.28.0 -dir migrations postgres $env:DATABASE_URL down
go run github.com/pressly/goose/v3/cmd/goose@v3.28.0 -dir migrations postgres $env:DATABASE_URL down
```

O `Down` dos dados remove somente registros vinculados ao suplemento. Se uma ficha, ataque, campanha ou outro dado posterior estiver usando conteúdo da carga, ele lança `SAH rollback blocked: supplemental content is referenced` e a transação mantém os dados e a versão da migration. Resolva essas referências conscientemente antes de tentar a reversão. Os quatro poderes do livro básico classificados pelo suplemento não são apagados.

## Ensaio realizado nesta implementação

As migrations foram aplicadas e revertidas com Goose em uma cópia isolada do banco local. A cópia chegou à versão `202609300002`; as 140 páginas tiveram hashes válidos. Os `Down` em ordem inversa funcionaram, e uma referência temporária de ficha a uma habilidade do suplemento bloqueou o rollback de forma atômica. Contagens e hashes dos registros básicos e dos dados de usuário comparados permaneceram iguais aos do banco original. O banco local original ficou na versão `202609290001`, sem a estrutura do suplemento.

Veja [modelo e conteúdo](sobrevivendo-ao-horror-modelo.md) para a distribuição dos dados e as decisões de representação.
