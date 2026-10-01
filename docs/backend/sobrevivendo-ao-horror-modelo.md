# Sobrevivendo ao Horror: modelo e carga

O suplemento **Sobrevivendo ao Horror** foi integrado ao sistema existente `ordem-paranormal` por duas migrations SQL. A entrega adiciona dados ao PostgreSQL; não muda a API, não automatiza as novas mecânicas e não ativa regras opcionais por campanha.

## Arquivos e fontes

| Migration | Responsabilidade |
|---|---|
| [`202609300001_sah_structure.sql`](../../backend/migrations/202609300001_sah_structure.sql) | Identidade do suplemento, proveniência, restrições e tabelas auxiliares. |
| [`202609300002_sah_data.sql`](../../backend/migrations/202609300002_sah_data.sql) | Carga autocontida, conferências de integridade e remoção dos registros do suplemento no `Down`. |

A carga usa as seções 01–08 e 10–13 de `nexus_sah_context`: páginas físicas 8–62 e 82–166, totalizando 140. Cada página incluída fica em `core.supplement_page` com texto extraído, caminho da seção e hash SHA-256. O SQL contém os textos necessários e não lê `nexus_sah_context` durante o deploy. A seção 09, as missões 14–15, os apêndices 16 e a referência duplicada 99 ficaram fora desta carga.

## Proveniência e integridade

`core.rpg_supplement` identifica o suplemento pelo slug `sobrevivendo-ao-horror` e o vincula a `ordem-paranormal`. Origens, trilhas, habilidades, itens, ameaças fixas e modificações recebem `supplement_id` e páginas inicial e final. Onde o registro já possui `rpg_system_id`, uma chave estrangeira composta exige que ele e o suplemento pertençam ao mesmo sistema. As páginas inicial e final também precisam existir para o suplemento indicado. Registros filhos herdam a proveniência pelo vínculo com o registro principal.

As novas tabelas `ordem.supplement_*` guardam campos que não cabiam no modelo anterior: pré-requisitos e afinidades, versões de rituais, espaços exatos e variantes de itens, classe Sobrevivente, modelo de ameaça, regras e pendências de revisão. Chaves estrangeiras e unicidade impedem referências órfãs e identidades repetidas. A migration de dados não usa `ON CONFLICT DO NOTHING`: uma colisão inesperada interrompe a carga.

## Conteúdo carregado

| Domínio | Quantidade e tratamento |
|---|---|
| Origens | 20, com poder e perícias associados. |
| Trilhas das classes existentes | 9, com 36 habilidades de trilha. |
| Outros poderes | 31 de classe, 34 gerais e 8 paranormais. |
| Rituais | 16, com 45 versões efetivamente publicadas entre normal, Discente e Verdadeiro. |
| Itens | 11 armas, 45 equipamentos gerais e 19 itens amaldiçoados. |
| Modificações | Carregador Rápido, Bateria Potente e Lente de Revelação. |
| Ameaças | 28 fichas fixas. O Espectro Inesquecido tem modelo variável e exemplo de VD 220 separados. |
| Sobrevivente | 5 estágios, 3 trilhas, 6 habilidades de trilha e transição para as classes de Ordem. |
| Regras | 17 famílias dos capítulos de regras, 37 subdivisões identificáveis, 3 opções de equipamentos e 2 regras adicionais para ameaças. |

As quatro habilidades do livro básico **Artista Marcial**, **Combater com Duas Armas**, **Saque Rápido** e **Tiro Certeiro** permanecem intactas. `ordem.supplement_ability_classification` registra sua classificação contextual como poderes gerais do suplemento.

**Tábula do Saber Custoso** é o nome canônico; **Tablet do saber custoso** fica em `ordem.supplement_item_alias` com origem na página 59. Os 18 itens com espaços fracionários usam `numeric(5,2)` em `ordem.supplement_item_detail`; `ordem.item_rule.spaces` fica nulo nesses casos, sem arredondamento. A capacidade das armas, os elementos dos catalisadores e as variantes de rituais também ficam em tabelas auxiliares.

Sobrevivente não foi inserido em `core.class_definition`: a criação atual de fichas exige progressão por NEX, enquanto Sobrevivente progride por estágios. O Espectro Inesquecido não foi cadastrado como ameaça de ficha fixa porque seus atributos dependem do Marcado usado para criá-lo.

## Texto incerto e revisão

O texto original das páginas foi preservado, inclusive glifos e resultados ambíguos da extração. Valores incertos não foram convertidos em números presumidos. Há **93 pendências** em `ordem.supplement_review_issue`: 67 relativas a glifos de dados, 21 a cabeçalhos não reconhecidos, 2 a cabeçalhos incompletos de rituais e 3 à categoria das modificações. Os trechos e as páginas correspondentes permitem revisão posterior. Para as três modificações, `category_increase = 1` segue o padrão atual de `ordem.item_modification`, com a decisão explicitamente marcada para revisão.

As descrições completas continuam acessíveis pelas páginas preservadas quando uma entrada individual não pôde ser recortada com segurança. Consulte [aplicação e verificação](sobrevivendo-ao-horror-operacao.md) para os comandos e as consultas de auditoria.
