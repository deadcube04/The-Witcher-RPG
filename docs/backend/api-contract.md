# Contratos HTTP da API local

Base: `http://127.0.0.1:8080/api/v1`. Pedidos e respostas usam JSON, exceto respostas `204`. IDs são UUIDs. Campos desconhecidos em entradas JSON são rejeitados. Erros seguem `{ "error": { "code": "INVALID_REQUEST", "message": "..." } }`, com códigos `INVALID_REQUEST` (400), `*_NOT_FOUND` (404), `SYSTEM_MISMATCH` (400), `CONFLICT`, `CONTENT_IN_USE` e `CONTENT_ALREADY_ADDED` (409), `INTERNAL_ERROR` (500). Na aplicação de importação com problemas, a resposta 409 contém o resultado com `issues` por item.

| Recurso | Rotas |
| --- | --- |
| Estado | `GET /api/health`, `GET /api/ready` (fora de `/api/v1`) |
| Usuário | `GET/PATCH /me`, `GET/PATCH /me/preferences` |
| Sistemas | `GET /rpg-systems` |
| Campanhas | `GET/POST /campaigns`, `GET/PATCH/DELETE /campaigns/:id` |
| Fichas | `GET/POST /character-sheets`, `GET/PATCH/DELETE /character-sheets/:id` |
| Opções e perícias | `GET /ordem/character-options`, `GET/PUT /character-sheets/:id/skills` |
| Catálogos | `GET /ordem/catalog/inventory`, `/ordem/catalog/rituals`, `/ordem/catalog/attacks` |
| Homebrew | `POST /ordem/homebrew/{inventory,rituals,attacks}`, `PATCH/DELETE /ordem/homebrew/{inventory,rituals,attacks}/:id` |
| Conteúdo da ficha | `GET/POST /character-sheets/:id/{inventory,rituals,attacks}`, `PATCH/DELETE /character-sheets/:id/{inventory,rituals,attacks}/:entryId` |
| Ataque do inventário | `POST /character-sheets/:id/attacks/from-inventory` |
| Importação | `POST /local-import/preview`, `POST /local-import/apply` |

Os contratos exatos de campos e validação no cliente estão em `frontend/src/shared/contracts`; `frontend/src/shared/api/domains.ts` define as chamadas. `GET /ordem/character-options` fornece classes, origens, atributos, recursos, 28 perícias, NEX e níveis de treinamento. Uma ficha de Ordem requer `systemData.kind = ordem-paranormal`, `classId` válido e NEX do catálogo. O recurso inclui `current`, `temporary`, `baseMaximum`, `maxAdjustment` e `maximum`; o servidor calcula os dois máximos e `peLimit`. `GET /character-sheets/:id/attacks` inclui `test` calculado para ataques com perícia conhecida. Detalhes oficiais ausentes aparecem como `null`.

O parâmetro `attackPolicy=detach|remove` controla a remoção de item que origina ataques. Catálogos aceitam busca e filtro de fonte previstos no cliente. Criações devolvem 201, exclusões 204. A API de preview de importação retorna `total`, `ready`, `alreadyImported`, `issues` e `applied: false`; a aplicação confirma com `applied: true` somente quando todos os itens selecionados puderem ser gravados.
