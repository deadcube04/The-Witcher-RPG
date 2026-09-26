# Especificação aprovada: backend e integração local

Este documento registra as decisões e o estado observado durante o planejamento. Os trechos no futuro e as contagens do banco são históricos. Para operar ou integrar o backend presente no diretório de trabalho, consulte [arquitetura](architecture.md), [contratos HTTP](api-contract.md), [migrações](migrations.md) e [execução local](local-setup.md).

## Objetivo e limite

Implementar um backend Go que atenda integralmente as telas e contratos HTTP atuais do frontend React/Vite, conectá-lo ao PostgreSQL local `rpg-manager` e preservar os dados existentes. A entrega inclui a integração do frontend, persistência da edição inline da ficha e importação opcional de dados do mock. Recursos do dump sem uso nas telas atuais não ganham API nesta entrega.

A aplicação continua local e de usuário único. A API escuta somente em `127.0.0.1`; frontend e backend rodam em processos e portas separados. O usuário ativo já existente no banco será a identidade local explícita. Não há login, acesso pela rede, multiplayer, sessões compartilhadas, upload definitivo ou processamento de rolagens no servidor.

Ordem Paranormal 1.1 é o único sistema que permite criar campanhas e fichas. D&D e The Witcher aparecem e podem ser selecionados para exploração, mas são preview. A seleção do sistema não modifica campanhas ou fichas existentes. O slug canônico de D&D no banco é `dungeons-and-dragons`; o frontend atual usa `dnd` e terá de ser ajustado.

## Estado observado durante o planejamento do repositório e banco

- Naquele momento, o backend continha apenas `backend/main.go`, com Gin, `GET /api/health` e escuta em `:8080`. A implementação atual usa `backend/cmd/api/main.go` e os pacotes em `backend/internal`.
- Naquele momento, `backend/go.mod` declarava Go 1.26.1. A versão declarada atualmente é Go 1.26.6; as dependências diretas incluem Gin 1.12, `gin-contrib/cors` 1.7.7, GORM 1.31.2 e o driver PostgreSQL 1.6.2.
- O frontend concentra o cliente HTTP em `frontend/src/shared/api/domains.ts`, valida respostas com Zod e monta URLs same-origin em `frontend/src/shared/api/client.ts`.
- `frontend/src/app/bootstrap/bootstrap.ts` liga o MSW automaticamente em desenvolvimento. A troca para API real precisa ser explícita por ambiente.
- A edição inline em `EditableCharacterSheet.tsx` mantém ficha e perícias apenas em estado React, apesar do indicador de salvamento. O formulário `/characters/:id/edit` já usa `PATCH`.
- `dumps/rpg-manager-backup-shema.sql` define 80 tabelas, 42 em `core` e 38 em `ordem`, mas não contém dados de seed. O banco vivo exige credencial e foi consultado somente em leitura durante o planejamento.
- Na inspeção de 25/09/2026, o banco tinha 1 usuário `ACTIVE/USER`, 2 sistemas, 5 temas, 67 personagens `THREAT`, 0 fichas de jogador, 0 preferências, 104 itens, 85 rituais, 36 armas, 28 perícias, 3 regras de classe e 20 linhas de NEX. Essas contagens são uma fotografia, não uma constante de implementação.
- Não há campanha no schema; `core.rpg_character` não possui `campaign_id`. Também faltam proveniência e proprietário para homebrew, definições de ataque reutilizáveis, detalhes completos de rituais e alguns metadados das entradas da ficha.
- As 85 habilidades ligadas a `ordem.ritual` estavam sem descrição preenchida. O serviço não deve inventar efeitos, versões discente/verdadeiro ou datas históricas.
- Na inspeção inicial, o banco continha Ordem e D&D; The Witcher ainda precisava de um registro preview, e `core.user_preferences` estava vazio. A migração `202609250001_backend_foundation.sql` inclui The Witcher; a migração `202609250004_public_user_tables.sql` move `users`, `user_preferences` e `local_import_map` para `public`. A existência dos dados no banco atual depende da aplicação das migrações.
- A validação de username do frontend aceita letras maiúsculas, ponto e sublinhado, enquanto a restrição atual do banco aceita apenas slug minúsculo com hífen.

## Decisões de domínio

| Tema | Decisão aprovada |
| --- | --- |
| Fonte dos catálogos | PostgreSQL prevalece; o JSON/mock só complementa entradas ausentes e compatíveis quando houver decisão explícita de importação. |
| Cobertura de conteúdo | Expor todos os itens e rituais de Ordem compatíveis, não apenas os exemplos do mock. |
| Modelo de dados | Estender as tabelas `core`/`ordem` por migrações e relações; evitar um segundo modelo paralelo para as telas. |
| Dados existentes | Preservar dados, fazer backup antes das migrações e não tratar as 67 ameaças como fichas do usuário. |
| Campanha e ficha | Campanha pertence a um sistema e usuário. Ficha pode ser avulsa ou pertencer a uma campanha do mesmo sistema. |
| Exclusões | Excluir campanha desvincula fichas. Homebrew em uso não pode ser excluído. Remover item ligado a ataques exige política `detach` ou `remove`. |
| Inventário repetido | Adicionar a mesma definição aumenta a quantidade até o limite do contrato. |
| Ritual ou ataque repetido | Retornar `CONTENT_ALREADY_ADDED`. |
| Rituais oficiais incompletos | Campos ausentes aparecem como não cadastrados; homebrew continua exigindo os dados completos do formulário. |
| Ataques oficiais | Derivar definições das armas existentes e ligar cada uma ao item de origem. |
| Ataques homebrew novos | Usuário seleciona uma perícia do catálogo; expressões livres só precisam ser preservadas para dados legados importados. |
| Perícias | Persistir as 28 definições do banco, treinamento, atributo escolhido e bônus adicional. Calcular bônus; não distribuir automaticamente escolhas por classe, origem ou NEX, pois a regra de distribuição está armazenada como texto. |
| Rolagens | Continuam no cliente. Para testes de Ordem, atributo 1–5 lança essa quantidade de d20 e usa o maior; atributo 0 lança 2d20 e usa o menor. Somar treino e outros bônus ao dado escolhido. |

## Cálculo de ficha de Ordem

O cálculo automático nesta entrega cobre a ficha atual: máximos de PV, PE e SAN, limite de PE por NEX, bônus de perícia e teste de ataque por ficha. Não inclui execução de combate, interlúdio, condições, ameaças ou um motor completo de regras.

A ficha salva exige classe e um valor de NEX presente em `ordem.nex_rule`: 5, 10, 15, ..., 95 ou 99. A origem e o limite de crédito podem continuar opcionais. IDs de classe, origem, atributos e recursos devem vir do banco; o JSON fixo do frontend não é autoridade para esses identificadores.

O banco é a fonte das fórmulas. Na fotografia inspecionada, Combatente tinha PV inicial `20 + VIG` e `4 + VIG` por etapa posterior; PE inicial `2 + PRE` e `2 + PRE` por etapa; SAN inicial 12 e +3 por etapa. Especialista tinha PV `16 + VIG` e `3 + VIG`, PE `3 + PRE` e `3 + PRE`, SAN 16 e +4. Ocultista tinha PV `12 + VIG` e `2 + VIG`, PE `4 + PRE` e `4 + PRE`, SAN 20 e +5. A primeira etapa é NEX 5; cada linha posterior de `ordem.nex_rule` soma uma progressão. O limite de PE vem diretamente dessa tabela.

O máximo efetivo de cada recurso é `máximo base + ajuste manual`. O ajuste é um inteiro com sinal e acompanha mudanças de classe, atributo ou NEX; resultado negativo é inválido. Na criação, o valor atual começa no máximo. Quando o máximo cresce, acrescentar a diferença ao atual; quando cai, limitar o atual ao novo máximo. O valor temporário permanece separado. A API não aceita o máximo calculado como fonte de verdade.

O bônus de uma perícia é `bônus do nível de treinamento + outros`. O atributo escolhido determina a quantidade e a escolha dos d20, não entra como soma numérica no bônus. Ataques vinculados a armas usam Luta para corpo a corpo e Pontaria para armas à distância/arremesso, com teste projetado a partir da perícia e atributo da ficha. Dados de dano, crítico e alcance vêm da arma; formatos de crítico desconhecidos devem aparecer como dado indisponível, sem valor fabricado.

## Arquitetura e dados

A direção obrigatória é `transport/Gin → service/use case → repository/GORM → PostgreSQL`. Organizar packages por domínio (`user`, `preference`, `rpgsystem`, `campaign`, `character`, `ordem`, `localimport`) e manter infraestrutura em `internal/platform`. O `main` compõe configuração, logger, banco, repositórios, serviços, handlers e ciclo de vida. O handler valida DTOs e traduz erros; o serviço decide regras e transações; o repositório encapsula GORM com `context.Context`. Models GORM não são respostas HTTP.

Usar `gin.New()` com recovery, request ID, logs estruturados, limites de body e JSON estrito; grupos versionados em `/api/v1`; `http.Server` com timeouts e shutdown gracioso; `TrustedProxies` fechado. O pool PostgreSQL é configurado via `sql.DB`. Queries recebem contexto, valores SQL são parametrizados e ordenações/filtros dinâmicos usam listas fechadas. Não executar `AutoMigrate` no startup.

Migrations SQL versionadas com Goose v3.28.0 partem do schema existente e rodam como comando separado. Elas devem criar campanha e vínculo da ficha; ajustes de recurso e atributo por perícia; metadados de homebrew e de entradas; detalhes de tier de ritual; definições de ataque; vínculos de ataque à entrada de inventário. Usar FKs e índices para integridade, inclusive igualdade de sistema entre campanha/ficha, definição/entrada e item/ataque. A migração de username amplia a restrição para corresponder ao formulário, preservando valores atuais. Criar The Witcher como preview sem alterar os sistemas já cadastrados.

O usuário local é escolhido por `LOCAL_USER_ID`, validado no startup como ativo e não excluído. `GET /me/preferences` retorna padrão derivado de Ordem, tema nulo e barra lateral recolhida quando a linha ainda não existe; `PATCH` cria/atualiza a linha. Apenas fichas `PLAYER` ligadas a `core.character_sheet` e ao usuário local aparecem nas listas. Nenhuma credencial é gravada em arquivo versionado ou em variável `VITE_*`.

## Contratos HTTP

Manter os métodos e caminhos consumidos por `frontend/src/shared/api/domains.ts`:

- `GET/PATCH /api/v1/me` e `/api/v1/me/preferences`; `GET /api/v1/rpg-systems`.
- `GET/POST /api/v1/campaigns` e `GET/PATCH/DELETE /api/v1/campaigns/:id`.
- `GET/POST /api/v1/character-sheets` e `GET/PATCH/DELETE /api/v1/character-sheets/:id`.
- `GET /api/v1/ordem/catalog/{inventory,rituals,attacks}` com os filtros já enviados pelo cliente.
- `POST/PATCH/DELETE /api/v1/ordem/homebrew/{inventory,rituals,attacks}` e seus `:id`.
- `GET/POST /api/v1/character-sheets/:id/{inventory,rituals,attacks}`, `PATCH/DELETE` das respectivas entradas e `POST /api/v1/character-sheets/:id/attacks/from-inventory`.

Acrescentar `GET /api/v1/ordem/character-options` para IDs e escolhas do banco; `GET/PUT /api/v1/character-sheets/:id/skills` para snapshot das 28 perícias; `POST /api/v1/local-import/preview` e `/apply` para importação opcional. Um endpoint de saúde e outro de prontidão podem distinguir processo vivo de conexão disponível ao banco.

Manter respostas JSON diretas, `DELETE` com 204 e o envelope `{ "error": { "code": "...", "message": "..." } }`. Usar os códigos estáveis do frontend: `INVALID_REQUEST`, `USER_NOT_FOUND`, `CAMPAIGN_NOT_FOUND`, `CHARACTER_NOT_FOUND`, `RPG_SYSTEM_NOT_FOUND`, `SYSTEM_MISMATCH`, `CONTENT_NOT_FOUND`, `CONTENT_IN_USE`, `CONTENT_ALREADY_ADDED`, `CONFLICT`, `INTERNAL_ERROR`. Preservar o mapeamento atual de HTTP: not found 404, conflitos 409, inválidos 400 e falha interna 500. Não devolver SQL, stack ou erro interno ao cliente.

O contrato de recurso passa a expor `current`, `temporary`, `baseMaximum`, `maxAdjustment` e `maximum`; a escrita só fornece campos editáveis. A resposta de Ordem também expõe `peLimit`. Definições oficiais de inventário, ritual e ataque podem omitir datas e dados não cadastrados. Entradas e homebrew continuam tendo IDs, propriedade e datas. O contrato de ataque da ficha inclui o teste calculado (`diceCount`, escolha maior/menor e bônus); homebrew novo usa `skillId` do catálogo. A resposta de perícia inclui definição, treinamento, atributo escolhido, bônus e parâmetros da rolagem.

## Integração do frontend

Usar `VITE_API_BASE_URL` apenas para o endereço público da API local e uma chave explícita de modo `mock`/`real`; `VITE_*` nunca recebe segredo. O MSW só inicia no modo mock. A API real é chamada diretamente pelo frontend em outra porta; CORS aceita somente origens locais configuradas, sem credenciais de navegador. A API escuta em loopback e valida `Origin`/`Host` em requisições com escrita.

Substituir IDs e opções fixas de classe, origem, NEX e perícias pelos dados de `/ordem/character-options`. Atualizar os contratos Zod e os componentes para mostrar ausência de detalhes oficiais sem inventar regras. Bloquear criação de campanhas e fichas em preview também na API. A edição inline deve fazer `PATCH` real com debounce, mutações sequenciadas por ficha e indicador que distingue pendente, salvo e erro. Perícias usam os novos endpoints. O cliente deve atualizar/invalidate as queries relacionadas após cada gravação. Rolagens de teste da ficha usam a regra dos d20 por atributo; o lançador genérico de dados continua independente.

## Importação opcional do mock

O mock guarda dados no `localStorage` sob `rpg-manager:mock:v1`, com versões 1 e 2. O frontend oferece uma ação explícita em configurações. A prévia compara com o seed conhecido para excluir exemplos intactos e incluir exemplos alterados e entidades criadas pelo usuário: campanhas, fichas, definições homebrew e entradas vinculadas. Perfil e preferências não fazem parte desta importação.

O servidor valida a carga, força o proprietário para o usuário local, resolve sistema/classe/origem e definições oficiais para IDs do banco por chave canônica, verifica relações e duplicatas e devolve contagens e problemas por entidade. O usuário seleciona os itens; dependências necessárias acompanham a seleção. `/apply` revalida tudo dentro de uma transação e só grava quando todos os itens selecionados são importáveis. Uma repetição da mesma carga deve ser idempotente. O `localStorage` permanece disponível após o sucesso; a interface marca a importação concluída para não oferecer uma repetição acidental.

## Operação, validação e documentação

Criar `backend/.env.example` e `frontend/.env.example`, ignorar os `.env` reais e carregar o arquivo local sem sobrescrever variáveis já exportadas. Configuração mínima: `DATABASE_URL`, `LOCAL_USER_ID`, `HTTP_ADDR=127.0.0.1:8080`, `CORS_ALLOWED_ORIGINS` com as origens exatas do Vite, `VITE_API_BASE_URL` e modo de API. A credencial informada nesta conversa não deve aparecer em Markdown, logs ou arquivos versionados. Antes de migrations no banco real, produzir backup local e conferir sua legibilidade; registrar versão Goose e contagens antes/depois.

Validar por `gofmt`, `goimports`, `go build`, `go vet`, `staticcheck`, `govulncheck`, typecheck, lint e build do frontend, além de conferência manual de contrato, CORS, erros, persistência, cálculos, importação repetida e preservação das ameaças/catálogos. As regras deste repositório proíbem criar ou executar testes automatizados sem novo pedido explícito do usuário.

Documentar a arquitetura e o vocabulário, contratos/erros, configuração local, migrations e importação em Markdown. O usuário autorizou expressamente arquivos `.md` documentais. Comandos Git que alterem índice, histórico ou remoto continuam fora da execução do Codex.

## Fontes consultadas

- Documentação de [Gin](https://github.com/gin-gonic/gin/blob/master/docs/doc.md), [GORM PostgreSQL/contexto](https://gorm.io/docs/connecting_to_the_database.html), [Gin CORS](https://github.com/gin-contrib/cors/blob/master/README.md), [Vite env](https://github.com/vitejs/vite/blob/main/docs/guide/env-and-mode.md), [Goose](https://github.com/pressly/goose/blob/main/README.md) e [godotenv](https://github.com/joho/godotenv/blob/main/README.md), obtida via Context7 durante o planejamento.
- Contratos, handlers MSW e seed em `frontend/src/shared`, `frontend/src/mocks` e o dump `dumps/rpg-manager-backup-shema.sql`.
