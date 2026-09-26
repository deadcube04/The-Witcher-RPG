# Arquitetura do backend

O frontend é o cliente principal. A API HTTP em Go atende os contratos de `frontend/src/shared/api/domains.ts`; o PostgreSQL é a fonte de verdade. Ordem Paranormal permite escrita; D&D e The Witcher aparecem como preview.

## Camadas

`backend/cmd/api` carrega a configuração, abre o pool de conexões, compõe as dependências e gerencia o servidor HTTP. `backend/internal/httpserver` define as rotas Gin, limites, CORS, validação dos pedidos e tradução de erros, com mapeamento de erros também em `httpcommon`. Os pacotes `account`, `systems`, `campaigns`, `characters`, `content` e `localimport` agrupam serviços e repositórios por domínio. `dbscope` transporta o banco e a identidade local para esses componentes; `apperr` define erros compartilhados. `backend/internal/domain` contém os contratos de entrada e saída. A direção pretendida é handler → serviço → repositório → PostgreSQL, embora a importação também coordene operações de repositório diretamente na sua transação.

As migrações SQL versionadas ficam em `backend/migrations` e são executadas com Goose fora da inicialização da API. Não há AutoMigrate. A migração `202609250004_public_user_tables.sql` move `users`, `user_preferences` e `local_import_map` de `core` para `public`; as demais tabelas de domínio continuam em `core` e `ordem`. A identidade local é o UUID do usuário ativo configurado em `LOCAL_USER_ID`; as leituras e escritas de dados próprios filtram por ele. A API escuta apenas em `127.0.0.1`, aceita origens locais explicitamente configuradas, limita corpo HTTP a 1 MiB e usa timeouts e encerramento gracioso.

## Decisões de domínio

- Campanha pertence ao usuário e a um sistema. Ficha pode ser avulsa ou associada a uma campanha do mesmo sistema. Excluir campanha desvincula suas fichas.
- As ameaças já existentes permanecem em `core.rpg_character` e não são tratadas como fichas do usuário.
- As definições oficiais usam os catálogos existentes; homebrew recebe proprietário e metadados próprios. Ataques oficiais são derivados das armas cadastradas.
- A migração dos ataques oficiais usa limiar crítico 20 e multiplicador 2 como valores padrão quando o texto da arma não contém esses números no formato reconhecido. Esta é uma limitação da implementação atual em relação à decisão histórica de deixar formatos desconhecidos indisponíveis.
- Ficha de Ordem exige classe e NEX válido. O serviço calcula máximos de PV, PE e SAN, limite de PE, perícias e parâmetros do teste de ataque. O navegador executa as rolagens.
- `current`, `temporary`, `baseMaximum`, `maxAdjustment` e `maximum` são campos distintos. Ajustes positivos ou negativos do máximo são armazenados; aumento do máximo aumenta o valor atual quando o usuário ainda estava no valor anterior, e redução limita o valor atual ao novo máximo.
- Efeitos oficiais não registrados no banco permanecem ausentes. Homebrew exige preenchimento completo dos campos do formulário.
- A importação local usa uma transação e um mapa de IDs de origem para destino. A prévia executa as mesmas operações dentro de transação revertida. Os dados locais permanecem no navegador depois da aplicação.

Ver também [especificação aprovada](implementation-spec.md), [contratos HTTP](api-contract.md) e [glossário](../../CONTEXT.md).
