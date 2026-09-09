# RPG Manager — Release Local 0.1 Implementation Plan

> **Para o agente:** este documento é um plano de execução. Implemente as tarefas na ordem definida. Não avance entre Macro Objetivos sem autorização explícita do usuário.

## Objetivo

Implementar a primeira versão funcional local do RPG Manager contendo:

- Home como hub principal.
- Escolha de sistema de RPG.
- Perfil e configurações do usuário.
- Sistema de temas.
- Cinco temas de Ordem Paranormal:
  - Sangue;
  - Morte;
  - Conhecimento;
  - Energia;
  - Medo.
- CRUD de campanhas.
- CRUD de fichas.
- Fichas standalone ou vinculadas a campanhas.
- Primeira implementação de ficha para Ordem Paranormal.
- Rolagem de dados dentro da ficha.
- Persistência real em PostgreSQL ao fim da implementação.
- Interface moderna, dinâmica, responsiva, acessível e fortemente orientada a UI/UX.

A aplicação continuará exclusivamente local nesta release.

Não implementar:

- deploy;
- Oracle Cloud;
- VPN;
- Tailscale;
- autenticação remota;
- multiplayer;
- sessões compartilhadas;
- convites;
- chat;
- sincronização em tempo real;
- upload definitivo de arquivos;
- funcionalidades que não estejam descritas neste plano.

---

# 1. REGRA MAIS IMPORTANTE: MACRO GATES

A implementação está dividida em exatamente três Macro Objetivos:

1. Frontend mockado completamente funcional.
2. Backend completamente funcional conectado ao PostgreSQL.
3. Integração Frontend + Backend.

A ordem é obrigatória.

```text
MACRO 1
Frontend Mockado
      ↓
VALIDAÇÃO HUMANA OBRIGATÓRIA
      ↓
MACRO 2
Backend + PostgreSQL
      ↓
VALIDAÇÃO HUMANA OBRIGATÓRIA
      ↓
MACRO 3
Integração
      ↓
VALIDAÇÃO FINAL
```

## Proibição

Não iniciar nenhuma tarefa do Macro 2 enquanto o usuário não autorizar explicitamente após validar o Macro 1.

Não iniciar nenhuma tarefa do Macro 3 enquanto o usuário não autorizar explicitamente após validar o Macro 2.

Se existirem:

- bugs;
- ajustes visuais;
- alterações de UX;
- alterações de componentes;
- alterações de fluxo;
- alterações de contrato;

no Macro atual, resolva todas antes de solicitar liberação do próximo.

Não antecipe trabalho do Macro seguinte "para ganhar tempo".

---

# 2. REGRAS DO REPOSITÓRIO

Antes de modificar código:

1. Leia todas as rules do repositório.
2. Leia especialmente:
   - React Write Rule;
   - Go Write Rule.
3. Inspecione a estrutura existente.
4. Reutilize padrões existentes que não conflitem com as rules.
5. Não introduza uma arquitetura paralela desnecessariamente.
6. Não altere código fora do escopo da release sem necessidade real.

Se este plano e uma rule entrarem em conflito, a rule tem prioridade.

---

# 3. ESTRATÉGIA DE IMPLEMENTAÇÃO

A implementação deve ser contract-first.

Durante o Macro 1:

```text
React
  ↓
TanStack Query
  ↓
API Client
  ↓
HTTP
  ↓
MSW
  ↓
Mock Persistence
```

Durante o Macro 2:

```text
Gin Handler
  ↓
Service / Use Case
  ↓
Repository
  ↓
GORM
  ↓
PostgreSQL
```

Durante o Macro 3:

```text
React
  ↓
TanStack Query
  ↓
API Client
  ↓
Gin
  ↓
Service
  ↓
Repository
  ↓
GORM
  ↓
PostgreSQL
```

O frontend não deve saber se a resposta HTTP veio do MSW ou do backend Go.

---

# 4. STACK OBRIGATÓRIA

## Frontend

- React.
- Vite.
- TypeScript strict.
- TanStack Router.
- TanStack Query.
- TanStack Form.
- TanStack Store somente para estado global client-side quando realmente necessário.
- Outros membros da TanStack somente quando houver responsabilidade concreta correspondente.
- Ant Design somente encapsulado por componentes próprios.
- Tailwind CSS exclusivamente para estilos.
- Motion exclusivamente para animações e transições.
- MSW para mock de HTTP.
- Vitest.
- React Testing Library.

Não usar:

- React Router.
- Zustand.
- Redux.
- React Hook Form.
- styled-components.
- Emotion.
- CSS Modules.
- SCSS.
- Create React App.
- Next.js.
- TanStack Start.

## Backend

- Go.
- Gin.
- GORM.
- PostgreSQL.
- migrations versionadas.
- testes nativos de Go.
- `httptest` para handlers.

Direção obrigatória:

```text
transport/Gin
     ↓
service/use case
     ↓
repository/GORM
     ↓
database
```

---

# 5. ESTRUTURA ALVO DO FRONTEND

Adaptar os caminhos caso o projeto já possua convenções equivalentes.

```text
frontend/src/

app/
├── router/
├── providers/
├── layout/
└── bootstrap/

features/
├── home/
├── systems/
├── settings/
├── campaigns/
├── characters/
├── dice/
└── themes/

components/
├── primitives/
├── feedback/
├── navigation/
├── forms/
├── data-display/
└── overlay/

shared/
├── api/
├── contracts/
├── hooks/
├── types/
└── lib/

mocks/
├── browser.ts
├── handlers/
├── database/
├── factories/
└── seed/
```

Organizar por domínio/feature.

Não criar páginas monolíticas.

---

# 6. ESTRUTURA ALVO DO BACKEND

```text
backend/

cmd/
└── api/
    └── main.go

internal/
├── campaign/
├── character/
├── user/
├── preference/
├── rpgsystem/
├── platform/
│   ├── config/
│   ├── database/
│   ├── logging/
│   └── http/
└── shared/

migrations/
```

Dentro de cada domínio, preferir arquivos pequenos:

```text
campaign/
├── handler.go
├── service.go
├── repository.go
├── domain.go
├── model.go
├── dto.go
└── errors.go
```

Não criar diretórios globais:

```text
handlers/
services/
repositories/
models/
```

quando isso quebrar a coesão por feature.

---

# ============================================================
# MACRO 1 — FRONTEND MOCKADO COMPLETAMENTE FUNCIONAL
# ============================================================

# Task 1 — Auditar estrutura e dependências do frontend

## Objetivo

Entender o estado atual antes de adicionar qualquer dependência ou estrutura.

## Passos

- [ ] Ler `package.json`.
- [ ] Identificar package manager.
- [ ] Ler lockfile.
- [ ] Identificar versões atuais de React, Vite e TypeScript.
- [ ] Identificar TanStack já instalado.
- [ ] Identificar Ant Design.
- [ ] Identificar Tailwind.
- [ ] Identificar Motion.
- [ ] Identificar ferramentas de testes.
- [ ] Verificar se MSW já existe.
- [ ] Executar audit permitido pela rule.
- [ ] Consultar advisories aplicáveis às dependências que precisarem ser adicionadas.
- [ ] Não adicionar pacote antes de verificar vulnerabilidades.
- [ ] Registrar no resumo da tarefa dependências adicionadas e versões verificadas.

## Aceite

Nenhuma dependência nova é adicionada sem necessidade concreta e verificação.

Commit:

```bash
git commit -m "chore(frontend): audit application foundation"
```

Somente se houver alteração real.

---

# Task 2 — Estabelecer bootstrap e providers

## Objetivo

Criar o shell técnico da aplicação.

## Criar ou ajustar

```text
src/app/bootstrap/
src/app/providers/
src/app/router/
```

## Providers esperados

- QueryClientProvider.
- RouterProvider.
- eventual Store provider apenas se necessário.
- infraestrutura de tema.
- MSW bootstrap somente em modo mock/dev apropriado.

## Aceite

Aplicação inicia sem feature específica e providers estão isolados.

Executar:

```bash
bun run typecheck
bun run lint
bun run build
```

ou scripts equivalentes existentes.

Commit:

```bash
git commit -m "feat(frontend): establish application providers"
```

---

# Task 3 — Configurar TanStack Router

## Rotas mínimas

```text
/
 /systems
 /settings
 /settings/profile
 /settings/appearance

 /campaigns
 /campaigns/new
 /campaigns/$campaignId
 /campaigns/$campaignId/edit

 /characters
 /characters/new
 /characters/$characterId
 /characters/$characterId/edit
```

## Regras

Utilizar search params para filtros que façam sentido compartilhar/recarregar.

Não usar React Router.

## Testar

- navegação direta;
- back/forward;
- rota inexistente;
- parâmetro inválido;
- reload em rota interna.

Commit:

```bash
git commit -m "feat(frontend): add application routing"
```

---

# Task 4 — Criar contratos compartilhados do frontend

Criar contratos TypeScript para as fronteiras HTTP.

Sugestão:

```text
src/shared/contracts/user.ts
src/shared/contracts/preferences.ts
src/shared/contracts/rpg-system.ts
src/shared/contracts/campaign.ts
src/shared/contracts/character-sheet.ts
src/shared/contracts/api-error.ts
```

## Tipos conceituais

### User

```text
id
name
username
avatarUrl?
```

### UserPreferences

```text
activeSystemId
activeThemeId
```

### RpgSystem

```text
id
slug
name
description
status
availableThemes
```

### Campaign

```text
id
ownerId
systemId
name
description
status
createdAt
updatedAt
```

### CharacterSheet

```text
id
ownerId
systemId
campaignId | null
name
createdAt
updatedAt
systemData
```

Não usar `any`.

`systemData` deve possuir tipagem discriminada/extensível adequada, e não um escape inseguro.

## Aceite

Contratos podem ser usados tanto pelo API Client quanto pelos handlers MSW.

Commit:

```bash
git commit -m "feat(frontend): define api contracts"
```

---

# Task 5 — Criar API Client centralizado

Criar:

```text
src/shared/api/client.ts
```

e clientes por domínio quando necessário.

Nenhuma page deve executar `fetch()` diretamente.

Fluxo:

```text
feature
  ↓
query/mutation
  ↓
API Client
```

Implementar parsing e validação das respostas externas conforme a rule.

Definir suporte a:

- respostas JSON;
- `204 No Content`;
- erros padronizados;
- abort/cancelamento.

## Aceite

Nenhum componente visual depende diretamente de detalhes HTTP.

Commit:

```bash
git commit -m "feat(frontend): add typed api client"
```

---

# Task 6 — Configurar TanStack Query

Criar QueryClient com defaults explícitos.

Criar query keys centralizadas por domínio.

Exemplo conceitual:

```text
campaignKeys.all
campaignKeys.list(filters)
campaignKeys.detail(id)

characterKeys.all
characterKeys.detail(id)

userKeys.current
systemKeys.all
```

Não utilizar strings aleatórias repetidas.

## Aceite

Cache e invalidation podem ser controlados previsivelmente.

Commit:

```bash
git commit -m "feat(frontend): configure server state layer"
```

---

# Task 7 — Construir a camada base de componentes

Criar abstrações do RPG Manager sobre Ant Design.

Exemplos:

```text
RpgButton
RpgInput
RpgTextArea
RpgSelect
RpgDialog
RpgDropdown
RpgTabs
RpgTooltip
RpgCard
RpgEmptyState
RpgErrorState
RpgSkeleton
RpgConfirmDialog
```

## Regra obrigatória

Features/pages não devem importar componentes visuais diretamente de `antd`.

Permitido:

```text
components/*
    ↓
antd
```

Proibido:

```text
features/*
    ↓
antd
```

Todos os estilos devem usar Tailwind conforme a rule.

## Para cada componente

Cobrir quando aplicável:

- default;
- hover;
- focus;
- disabled;
- loading;
- erro;
- responsividade;
- teclado.

Adicionar teste de comportamento aos componentes reutilizáveis.

Commit:

```bash
git commit -m "feat(frontend): build application component primitives"
```

---

# Task 8 — Criar arquitetura de Motion

Criar abstrações reutilizáveis para:

- entrada/saída de página;
- presença;
- cards;
- dialogs;
- drawers;
- listas;
- mudança de layout.

Possíveis componentes:

```text
AnimatedPage
AnimatedList
AnimatedListItem
AnimatedCard
MotionDialog
```

Respeitar `prefers-reduced-motion`.

Não espalhar configuração complexa do Motion em pages.

Commit:

```bash
git commit -m "feat(frontend): establish motion system"
```

---

# Task 9 — Criar Theme Engine

Criar conceito de:

```text
ThemeDefinition
```

Cada tema deve poder definir:

- ID.
- RPG.
- nome.
- tokens visuais.
- assets/decoradores.
- perfil de Motion quando necessário.

Não espalhar verificações:

```text
theme === "sangue"
```

pelos componentes.

Criar API única para resolver tema ativo.

## Temas

Implementar:

```text
ordem-sangue
ordem-morte
ordem-conhecimento
ordem-energia
ordem-medo
```

## Direção visual

### Sangue

Orgânico, agressivo, visceral.

### Morte

Temporal, deteriorado, envelhecido, pesado.

### Conhecimento

Editorial, informação, símbolos, documentos.

### Energia

Instável, digital, dinâmico.

### Medo

Estranho, sóbrio, desconfortável e minimalista.

## Proibição

Não implementar apenas troca de cor.

Cada tema deve possuir diferenças perceptíveis de:

- superfícies;
- contraste;
- detalhes;
- decoração;
- motion;
- textura visual quando possível dentro das regras.

Commit:

```bash
git commit -m "feat(frontend): add rpg theme engine"
```

---

# Task 10 — Criar App Shell

Criar:

```text
src/app/layout/
```

O shell deve conter:

- navegação principal;
- identificação do sistema ativo;
- acesso a campanhas;
- acesso a fichas;
- acesso a configurações;
- acesso ao perfil;
- layout responsivo.

Evitar estética genérica de dashboard SaaS.

A navegação deve parecer parte de uma aplicação de RPG/editorial.

Testar:

- desktop;
- tablet;
- mobile;
- teclado;
- estado de rota ativa.

Commit:

```bash
git commit -m "feat(frontend): create application shell"
```

---

# Task 11 — Implementar Mock Database e seed

Criar:

```text
src/mocks/database/
src/mocks/factories/
src/mocks/seed/
```

O mock não deve vazar para features.

Criar seed determinístico contendo:

- usuário;
- preferências;
- sistemas;
- campanhas;
- personagens.

Persistir alterações entre reloads usando uma abstração própria de persistência local.

Não acessar `localStorage` diretamente em feature/page.

Fluxo obrigatório:

```text
feature
 ↓
TanStack Query
 ↓
API Client
 ↓
HTTP
 ↓
MSW
 ↓
Mock Repository
 ↓
Local persistence
```

Commit:

```bash
git commit -m "feat(frontend): add deterministic mock data layer"
```

---

# Task 12 — Implementar MSW

Criar handlers para:

```text
GET    /api/v1/me
PATCH  /api/v1/me

GET    /api/v1/me/preferences
PATCH  /api/v1/me/preferences

GET    /api/v1/rpg-systems

GET    /api/v1/campaigns
POST   /api/v1/campaigns
GET    /api/v1/campaigns/:id
PATCH  /api/v1/campaigns/:id
DELETE /api/v1/campaigns/:id

GET    /api/v1/character-sheets
POST   /api/v1/character-sheets
GET    /api/v1/character-sheets/:id
PATCH  /api/v1/character-sheets/:id
DELETE /api/v1/character-sheets/:id
```

## Envelope de erro

Padronizar:

```json
{
  "error": {
    "code": "CAMPAIGN_NOT_FOUND",
    "message": "Campaign not found"
  }
}
```

Usar os mesmos códigos que o backend deverá implementar no Macro 2.

Commit:

```bash
git commit -m "feat(frontend): implement mock api"
```

---

# Task 13 — RPG Systems

Implementar:

```text
/systems
```

Sistemas iniciais:

- Ordem Paranormal.
- Dungeons & Dragons.
- The Witcher RPG.

Ordem Paranormal é o único sistema que precisa possuir suporte completo nesta release.

Permitir selecionar sistema ativo.

A seleção altera:

```text
UserPreferences.activeSystemId
```

Não alterar campanhas/fichas existentes ao mudar o sistema ativo.

Adicionar TanStack Query + mutation.

Commit:

```bash
git commit -m "feat(frontend): add rpg system selection"
```

---

# Task 14 — Perfil do usuário

Implementar:

```text
/settings/profile
```

Exibir e permitir edição das informações básicas existentes no contrato.

Utilizar TanStack Form.

Cobrir:

- carregamento;
- sucesso;
- validação;
- erro;
- disabled durante mutation.

Após sucesso:

- atualizar/invalidate cache corretamente;
- apresentar feedback discreto.

Commit:

```bash
git commit -m "feat(frontend): add profile settings"
```

---

# Task 15 — Aparência e temas

Implementar:

```text
/settings/appearance
```

Exibir os temas disponíveis para o RPG apropriado.

Permitir preview adequado.

Ao selecionar:

1. aplicar imediatamente;
2. persistir via mutation de preferences;
3. manter após reload.

Commit:

```bash
git commit -m "feat(frontend): add appearance settings"
```

---

# Task 16 — Home Hub

Implementar `/`.

A Home deve priorizar retomada e navegação.

Conteúdo mínimo:

- sistema atual;
- última campanha/recurso acessado quando aplicável;
- campanhas recentes;
- personagens recentes;
- ações rápidas:
  - criar campanha;
  - criar ficha;
  - escolher sistema.

Não construir apenas uma grid uniforme de cards.

Criar hierarquia visual clara.

Adicionar:

- skeleton;
- empty;
- error;
- success.

Commit:

```bash
git commit -m "feat(frontend): build home hub"
```

---

# Task 17 — Listagem de campanhas

Implementar:

```text
/campaigns
```

Funcionalidades:

- listar;
- buscar por nome;
- filtrar por sistema;
- mostrar status;
- criar;
- abrir;
- editar;
- excluir;
- arquivar se o modelo atual suportar.

Filtros relevantes devem utilizar TanStack Router search params.

Criar componentes separados:

```text
CampaignFilters
CampaignList
CampaignCard
CampaignListSkeleton
CampaignEmptyState
CampaignErrorState
```

Commit:

```bash
git commit -m "feat(frontend): add campaign listing"
```

---

# Task 18 — Criação de campanha

Implementar:

```text
/campaigns/new
```

Campos mínimos:

- nome;
- sistema;
- descrição.

Utilizar TanStack Form.

Após criação:

- invalidar lista;
- navegar para detalhe da campanha.

Commit:

```bash
git commit -m "feat(frontend): add campaign creation"
```

---

# Task 19 — Detalhe da campanha

Implementar:

```text
/campaigns/$campaignId
```

Mostrar:

- nome;
- sistema;
- descrição;
- status;
- personagens vinculados;
- ação para editar;
- ação para excluir;
- ação para adicionar personagem.

Estados:

- loading;
- not found;
- error;
- success;
- campanha sem personagens.

Commit:

```bash
git commit -m "feat(frontend): add campaign details"
```

---

# Task 20 — Edição e exclusão de campanha

Implementar:

```text
/campaigns/$campaignId/edit
```

Usar TanStack Form.

Exclusão deve exigir confirmação.

Após mutation:

- atualizar cache;
- evitar dados stale;
- navegar de forma coerente.

Commit:

```bash
git commit -m "feat(frontend): add campaign management"
```

---

# Task 21 — Criar arquitetura extensível de fichas

Criar abstração equivalente a:

```text
CharacterSheetDefinition
```

Ela deve permitir que cada RPG registre:

- campos;
- seções;
- validações;
- componentes especiais;
- renderer/layout.

Criar registry central de definições.

Exemplo conceitual:

```text
characterSheetRegistry.get(systemSlug)
```

Não implementar condicionais de sistema espalhadas.

Commit:

```bash
git commit -m "feat(frontend): establish character sheet architecture"
```

---

# Task 22 — Listagem de fichas

Implementar:

```text
/characters
```

Suportar:

- listar;
- pesquisar;
- filtrar por sistema;
- filtrar standalone/campanha;
- abrir;
- criar;
- editar;
- excluir.

Estados completos obrigatórios.

Commit:

```bash
git commit -m "feat(frontend): add character listing"
```

---

# Task 23 — Fluxo de criação de ficha

Implementar:

```text
/characters/new
```

Fluxo:

1. escolher sistema;
2. escolher:
   - standalone;
   - campanha;
3. se campanha:
   - apresentar apenas campanhas compatíveis;
4. preencher dados da ficha.

Se criação iniciar a partir da campanha:

```text
systemId
campaignId
```

devem vir pré-configurados.

Commit:

```bash
git commit -m "feat(frontend): add character creation flow"
```

---

# Task 24 — Primeira ficha de Ordem Paranormal

Implementar a definição de ficha para Ordem Paranormal usando o schema/domínio já existente no projeto como fonte de verdade.

Não inventar campos que não estejam suportados pela estrutura atual ou documentação do projeto.

A ficha deve:

- possuir divisão clara em seções;
- ser editável;
- ser responsiva;
- usar componentes próprios;
- ter validação;
- não ser um componente monolítico.

Separar cada seção significativa.

Commit:

```bash
git commit -m "feat(frontend): implement ordem character sheet"
```

---

# Task 25 — Regra campanha ↔ ficha

Implementar no frontend:

```text
CharacterSheet.campaignId = string | null
```

Se `campaignId === null`:

```text
standalone
```

Se houver campanha:

```text
character.systemId === campaign.systemId
```

deve ser obrigatório.

A interface nunca deve oferecer combinação inválida.

Adicionar teste explícito para isso.

Commit:

```bash
git commit -m "feat(frontend): enforce campaign character compatibility"
```

---

# Task 26 — Edição e exclusão de fichas

Implementar:

```text
/characters/$characterId
/characters/$characterId/edit
```

Cobrir:

- detalhe;
- edição;
- exclusão;
- standalone;
- vinculado a campanha;
- not found.

Commit:

```bash
git commit -m "feat(frontend): add character management"
```

---

# Task 27 — Dice Roller

Implementar rolagem dentro da ficha.

Suportar inicialmente:

```text
D4
D6
D8
D10
D12
D20
D100
```

Funcionalidades:

- escolher dado;
- escolher quantidade;
- modificador opcional;
- rolar;
- mostrar resultado individual;
- mostrar total.

Não criar endpoint backend.

A rolagem simples é client-side nesta release.

Criar animação usando Motion.

Garantir que animação reduzida seja respeitada.

Testes devem garantir ranges válidos.

Exemplo:

```text
D20 → 1 <= resultado <= 20
```

Commit:

```bash
git commit -m "feat(frontend): add character dice roller"
```

---

# Task 28 — Revisão completa de estados

Auditar todas as features.

Cada operação remota deve possuir estados adequados:

- loading;
- empty;
- error;
- success.

Não permitir combinações contraditórias de estado.

Adicionar retry quando fizer sentido.

Commit:

```bash
git commit -m "refactor(frontend): complete feature states"
```

---

# Task 29 — Responsividade e acessibilidade

Validar:

- desktop;
- tablet;
- mobile;
- keyboard navigation;
- focus visible;
- dialogs;
- forms;
- menus;
- contraste;
- reduced motion.

Corrigir problemas encontrados.

Commit:

```bash
git commit -m "fix(frontend): improve responsiveness and accessibility"
```

---

# Task 30 — Testes do Macro 1

Criar testes para pelo menos:

## Sistemas

```text
usuário seleciona Ordem
→ preferência muda
```

## Perfil

```text
usuário edita dados
→ mutation ocorre
→ UI atualiza
```

## Tema

```text
seleciona tema Sangue
→ tema muda
→ reload
→ tema permanece
```

## Campanha

```text
criar
→ visualizar
→ editar
→ excluir
```

## Ficha standalone

```text
criar
→ persistir
→ reabrir
```

## Ficha em campanha

```text
criar dentro da campanha
→ ficha aparece na campanha
```

## Integridade

```text
campanha Ordem
→ ficha D&D não pode ser vinculada
```

## Dice

```text
D20 nunca retorna abaixo de 1 ou acima de 20
```

Executar todos os scripts definidos pelo projeto:

```bash
bun run typecheck
bun run lint
bun run test
bun run build
```

Não considerar Macro 1 concluído com falha em qualquer um deles.

Commit:

```bash
git commit -m "test(frontend): cover release workflows"
```

---

# GATE 1 — PARADA OBRIGATÓRIA

Executar manualmente a jornada:

```text
abrir aplicação

→ escolher Ordem Paranormal
→ escolher um dos cinco temas
→ criar campanha
→ abrir campanha
→ criar personagem
→ preencher ficha
→ rolar dados
→ voltar para home
→ abrir novamente campanha/ficha
→ editar perfil
→ trocar tema
→ atualizar página
→ confirmar persistência
```

Verificar:

- sem páginas TODO;
- CRUDs completos;
- todos os temas funcionais;
- responsividade aceitável;
- UX consistente;
- testes passando;
- build passando;
- lint passando;
- typecheck passando.

## Ação obrigatória

PARE.

Apresente ao usuário:

- resumo do implementado;
- screenshots ou formas práticas de validação quando disponíveis;
- comandos para executar;
- lista objetiva de eventuais limitações dentro do escopo.

Solicite validação do Macro 1.

**NÃO EXECUTE NENHUMA TAREFA ABAIXO SEM AUTORIZAÇÃO EXPLÍCITA.**

---

# ============================================================
# MACRO 2 — BACKEND GO + GIN + GORM + POSTGRESQL
# ============================================================

# Task 31 — Auditar backend e dependências

Antes de adicionar pacotes:

- [ ] ler `go.mod`;
- [ ] ler `go.sum`;
- [ ] identificar versão do Go;
- [ ] verificar Gin;
- [ ] verificar GORM;
- [ ] verificar driver PostgreSQL;
- [ ] verificar ferramenta de migrations;
- [ ] executar/verificar vulnerabilidades conforme rule.

Não substituir dependências existentes sem necessidade.

Commit somente se houver mudança.

---

# Task 32 — Bootstrap da aplicação Go

Criar/completar:

```text
cmd/api/main.go
internal/platform/config/
internal/platform/database/
internal/platform/logging/
internal/platform/http/
```

Ordem de composição:

```text
config
 ↓
logger
 ↓
database
 ↓
repositories
 ↓
services
 ↓
handlers
 ↓
router
 ↓
http.Server
```

Usar:

```text
gin.New()
```

Configurar explicitamente:

- recovery;
- logging;
- request ID;
- CORS;
- trusted proxies;
- request limits;
- timeouts;
- graceful shutdown.

Commit:

```bash
git commit -m "feat(backend): establish api bootstrap"
```

---

# Task 33 — PostgreSQL e GORM

Configurar conexão.

Não utilizar DB global.

Configurar pool usando `sql.DB`.

GORM deve ser injetado.

Queries devem receber `context.Context`.

Não executar `AutoMigrate` no startup.

Commit:

```bash
git commit -m "feat(backend): configure postgres persistence"
```

---

# Task 34 — Migrations

Usar migrations versionadas.

Respeitar arquitetura de schemas existente:

```text
core
ordem
dnd
witcher
```

Não recriar estrutura que já exista.

Inspecionar migrations atuais antes de produzir nova migration.

Criar somente alterações necessárias para:

- user/preferences se necessário;
- campaigns;
- character sheets;
- relacionamentos necessários à release.

As migrations devem funcionar a partir de um banco limpo conforme estratégia do projeto.

Commit:

```bash
git commit -m "feat(database): add release persistence migrations"
```

---

# Task 35 — Error model da API

Criar envelope consistente:

```json
{
  "error": {
    "code": "CAMPAIGN_NOT_FOUND",
    "message": "Campaign not found"
  }
}
```

Definir códigos estáveis.

Cobrir pelo menos:

```text
INVALID_REQUEST
USER_NOT_FOUND
CAMPAIGN_NOT_FOUND
CHARACTER_NOT_FOUND
RPG_SYSTEM_NOT_FOUND
SYSTEM_MISMATCH
CONFLICT
INTERNAL_ERROR
```

Nunca retornar:

- `err.Error()`;
- SQL;
- stack trace;
- detalhes internos.

Commit:

```bash
git commit -m "feat(backend): standardize api errors"
```

---

# Task 36 — Current User abstraction

Criar interface pequena equivalente a:

```text
CurrentUserProvider
```

Nesta release, implementar:

```text
LocalCurrentUserProvider
```

que resolve o usuário de desenvolvimento local.

Services não devem depender de usuário hardcoded.

A futura autenticação deve poder substituir o provider sem reescrever use cases.

Commit:

```bash
git commit -m "feat(backend): add local current user provider"
```

---

# Task 37 — RPG Systems

Implementar:

```text
GET /api/v1/rpg-systems
```

Camadas:

```text
handler
service
repository
```

Se sistemas já estiverem no schema existente, utilizar a estrutura existente.

Adicionar testes.

Commit:

```bash
git commit -m "feat(backend): expose rpg systems api"
```

---

# Task 38 — User API

Implementar:

```text
GET   /api/v1/me
PATCH /api/v1/me
```

Separar:

- request DTO;
- service input;
- domain;
- persistence model quando responsabilidades divergirem;
- response DTO.

Testes do handler:

- sucesso;
- JSON inválido;
- campo desconhecido;
- validação;
- erro interno sem vazamento.

Commit:

```bash
git commit -m "feat(backend): add user api"
```

---

# Task 39 — Preferences API

Implementar:

```text
GET   /api/v1/me/preferences
PATCH /api/v1/me/preferences
```

Validar:

- sistema existente;
- tema compatível quando aplicável.

Adicionar testes.

Commit:

```bash
git commit -m "feat(backend): add user preferences api"
```

---

# Task 40 — Campaign Repository

Implementar operações necessárias:

```text
List
FindByID
Create
Update
Delete
```

Todos os métodos:

- recebem `context.Context`;
- usam `db.WithContext(ctx)`;
- tratam `gorm.ErrRecordNotFound`;
- verificam `Error`;
- verificam `RowsAffected` quando semanticamente necessário.

Não interpolar entrada externa em SQL.

Commit:

```bash
git commit -m "feat(backend): add campaign repository"
```

---

# Task 41 — Campaign Service

Implementar use cases:

```text
ListCampaigns
GetCampaign
CreateCampaign
UpdateCampaign
DeleteCampaign
```

Responsabilidades:

- ownership;
- sistema válido;
- validações de domínio;
- transações quando necessárias.

Service não conhece:

```text
*gin.Context
```

Commit:

```bash
git commit -m "feat(backend): add campaign use cases"
```

---

# Task 42 — Campaign Handler

Implementar:

```text
GET    /api/v1/campaigns
POST   /api/v1/campaigns
GET    /api/v1/campaigns/:id
PATCH  /api/v1/campaigns/:id
DELETE /api/v1/campaigns/:id
```

Handler deve somente:

1. bind;
2. validar;
3. extrair params/identidade;
4. chamar service;
5. traduzir resultado para HTTP.

Usar contexto da request.

Adicionar testes via `httptest`.

Commit:

```bash
git commit -m "feat(backend): expose campaign api"
```

---

# Task 43 — Character Repository

Implementar:

```text
List
FindByID
Create
Update
Delete
```

Suportar corretamente:

```text
campaignId == null
```

e relacionamento com extensão específica de Ordem.

Usar transação quando criação/edição exigir múltiplas escritas.

Commit:

```bash
git commit -m "feat(backend): add character repository"
```

---

# Task 44 — Character Service

Implementar:

```text
ListCharacters
GetCharacter
CreateCharacter
UpdateCharacter
DeleteCharacter
```

Regra obrigatória:

```text
if campaignId != nil:
    character.systemId == campaign.systemId
```

Caso contrário:

```text
SYSTEM_MISMATCH
```

Também validar ownership.

Commit:

```bash
git commit -m "feat(backend): add character use cases"
```

---

# Task 45 — Character Handler

Implementar:

```text
GET    /api/v1/character-sheets
POST   /api/v1/character-sheets
GET    /api/v1/character-sheets/:id
PATCH  /api/v1/character-sheets/:id
DELETE /api/v1/character-sheets/:id
```

Os contratos HTTP devem permanecer compatíveis com o Macro 1.

Commit:

```bash
git commit -m "feat(backend): expose character api"
```

---

# Task 46 — Seed local

Criar seed ou mecanismo oficial do projeto para popular dados de desenvolvimento.

Incluir:

- usuário;
- preferências;
- RPG systems;
- dados mínimos necessários ao funcionamento.

Não misturar seed com migrations estruturais se o padrão existente separar essas responsabilidades.

O seed deve ser idempotente quando apropriado.

Commit:

```bash
git commit -m "chore(database): add local development seed"
```

---

# Task 47 — Testes de Repository

Usar PostgreSQL, o mesmo dialeto utilizado em produção/local real.

Testar ao menos:

- insert;
- update;
- delete;
- not found;
- constraints;
- rollback;
- associação campanha/ficha;
- null campaign.

Evitar SQLite para testes cuja semântica PostgreSQL seja relevante.

Commit:

```bash
git commit -m "test(backend): cover repository persistence"
```

---

# Task 48 — Testes de Services

Cobrir:

```text
campanha válida
campanha inexistente
ownership inválido
ficha standalone
ficha em campanha correta
ficha com system mismatch
update
delete
```

Não testar implementação interna; testar comportamento.

Commit:

```bash
git commit -m "test(backend): cover domain use cases"
```

---

# Task 49 — Testes de Handlers

Usar `httptest`.

Cobrir:

- sucesso;
- JSON inválido;
- campo desconhecido;
- validação;
- not found;
- conflict;
- system mismatch;
- internal error sem vazamento;
- timeout/cancelamento quando aplicável.

Commit:

```bash
git commit -m "test(backend): cover http api"
```

---

# Task 50 — Verificação do backend

Executar:

```bash
gofmt
goimports
go vet ./...
staticcheck ./...
govulncheck ./...
go test ./...
```

Executar também:

```bash
go test -race ./...
```

quando houver concorrência relevante.

Não declarar sucesso caso ferramenta obrigatória não tenha sido executada.

Resolver todas as falhas antes do Gate 2.

Commit somente se houver correções.

---

# GATE 2 — PARADA OBRIGATÓRIA

Subir backend e PostgreSQL sem integrar o frontend real.

Validar diretamente pela API:

```text
GET /me

PATCH /me

GET /me/preferences
PATCH /me/preferences

GET /rpg-systems

POST /campaigns
GET /campaigns/:id
PATCH /campaigns/:id

POST /character-sheets
GET /character-sheets/:id
PATCH /character-sheets/:id
```

Reiniciar o backend e confirmar persistência.

Validar também:

```text
campanha Ordem
+
ficha Ordem
→ permitido

campanha Ordem
+
ficha D&D
→ SYSTEM_MISMATCH
```

Verificar que o frontend ainda está utilizando MSW.

## Ação obrigatória

PARE.

Mostre ao usuário:

- endpoints implementados;
- migrations;
- comandos de execução;
- resultado dos testes;
- verificações estáticas;
- eventuais limitações.

Solicite autorização explícita para Macro 3.

**NÃO INICIE A INTEGRAÇÃO SEM ESSA AUTORIZAÇÃO.**

---

# ============================================================
# MACRO 3 — INTEGRAÇÃO FRONTEND + BACKEND
# ============================================================

# Task 51 — Configuração de API mode

Permitir execução do frontend em pelo menos dois modos:

```text
mock
http
```

Exemplo conceitual:

```text
VITE_API_MODE=mock
VITE_API_MODE=http
```

e:

```text
VITE_API_URL=http://localhost:8080
```

Variáveis `VITE_*` não podem conter segredo.

MSW deve iniciar somente no modo mock.

Commit:

```bash
git commit -m "feat(frontend): support mock and http api modes"
```

---

# Task 52 — Integrar User

Trocar somente a origem HTTP.

Não alterar componentes sem necessidade.

Validar:

```text
GET /me
PATCH /me
```

Verificar cache e mutations.

Commit:

```bash
git commit -m "feat(integration): connect user api"
```

---

# Task 53 — Integrar Preferences e Themes

Conectar:

```text
GET /me/preferences
PATCH /me/preferences
```

Testar:

```text
trocar tema
→ backend persiste
→ reload
→ tema permanece
```

Commit:

```bash
git commit -m "feat(integration): connect user preferences"
```

---

# Task 54 — Integrar RPG Systems

Conectar:

```text
GET /rpg-systems
```

Garantir funcionamento da seleção de sistema.

Commit:

```bash
git commit -m "feat(integration): connect rpg systems"
```

---

# Task 55 — Integrar Campaigns

Conectar:

```text
list
create
detail
update
delete
```

Verificar TanStack Query invalidation.

Nenhuma page deve ser reescrita apenas por causa da integração.

Commit:

```bash
git commit -m "feat(integration): connect campaigns"
```

---

# Task 56 — Integrar Character Sheets

Conectar:

```text
list
create
detail
update
delete
```

Validar:

- standalone;
- vinculada;
- Ordem;
- system mismatch vindo do backend.

Commit:

```bash
git commit -m "feat(integration): connect character sheets"
```

---

# Task 57 — Error mapping

Mapear códigos estáveis da API para UX apropriada.

Exemplo:

```text
CAMPAIGN_NOT_FOUND
→ estado de not found

CHARACTER_NOT_FOUND
→ estado de not found

SYSTEM_MISMATCH
→ mensagem de incompatibilidade

INVALID_REQUEST
→ validação/form feedback

INTERNAL_ERROR
→ feedback genérico + retry quando possível
```

Nunca mostrar detalhes internos.

Commit:

```bash
git commit -m "feat(integration): map backend errors to ui"
```

---

# Task 58 — Fullstack E2E

Executar jornadas com frontend real + backend real + PostgreSQL real/local.

## Jornada 1 — Perfil

```text
abrir aplicação
→ editar perfil
→ reload
→ valor permanece
```

## Jornada 2 — Tema

```text
trocar tema
→ reload
→ preferência permanece
```

## Jornada 3 — Campanha

```text
criar campanha
→ abrir
→ editar
→ voltar
→ campanha permanece
```

## Jornada 4 — Ficha standalone

```text
criar ficha
→ preencher
→ salvar
→ reabrir
```

## Jornada 5 — Ficha vinculada

```text
abrir campanha
→ criar ficha
→ salvar
→ ficha aparece na campanha
```

## Jornada 6 — Dice Roller

```text
abrir ficha
→ rolar D20
→ resultado válido
```

## Jornada 7 — Persistência

```text
criar dados
→ reiniciar frontend
→ reiniciar backend
→ dados permanecem
```

## Jornada 8 — Integridade

Validar no frontend e backend que uma ficha de sistema incompatível não pode ser associada a uma campanha.

Commit:

```bash
git commit -m "test(integration): cover local release journeys"
```

---

# Task 59 — Verificação final

Frontend:

```bash
bun run typecheck
bun run lint
bun run test
bun run build
```

Backend:

```bash
gofmt
goimports
go vet ./...
staticcheck ./...
govulncheck ./...
go test ./...
```

Executar `-race` quando aplicável.

Revisar:

- console do navegador;
- logs backend;
- network requests;
- warnings React;
- queries duplicadas;
- erros 500;
- N+1 óbvio;
- states inconsistentes;
- acessibilidade;
- responsividade.

Resolver tudo que pertença ao escopo.

---

# Task 60 — Documentação local mínima

Documentar no README ou documentação já existente:

## Requisitos

- versões necessárias;
- PostgreSQL;
- Bun/package manager adotado;
- Go.

## Como subir banco

Comandos reais do projeto.

## Como executar migrations

Comandos reais.

## Como executar seed

Comandos reais.

## Como executar backend

Comando real.

## Como executar frontend mockado

Comando real.

## Como executar frontend integrado

Comando real.

## Como executar testes

Frontend e backend.

Não documentar deploy/VPN nesta release.

Commit:

```bash
git commit -m "docs: document local release workflow"
```

---

# GATE 3 — VALIDAÇÃO FINAL

A release somente pode ser considerada concluída quando:

- Home funciona.
- Sistema ativo funciona.
- Perfil funciona.
- Preferências funcionam.
- Cinco temas de Ordem funcionam.
- Campanhas possuem CRUD completo.
- Fichas possuem CRUD completo.
- Fichas podem ser standalone.
- Fichas podem pertencer a campanha.
- Relação sistema/campanha é validada no front e backend.
- Ficha de Ordem está funcional.
- Dice Roller está funcional.
- Persistência PostgreSQL funciona.
- Reload não perde dados.
- Backend reiniciado não perde dados.
- Frontend mockado continua disponível.
- Frontend integrado funciona.
- Testes passam.
- Lint passa.
- Typecheck passa.
- Build passa.
- Verificações Go passam.
- Não existem páginas TODO.
- Não existem mocks utilizados acidentalmente no modo HTTP.
- Não existe código backend acessado diretamente pelo frontend.
- Não existe AntD importado diretamente em features/pages.
- Não existe CSS/SCSS/CSS Modules/styled-components.
- Não existe React Router/Zustand/Redux/React Hook Form.
- Não existe GORM em handler.
- Não existe `*gin.Context` dentro de service/repository.
- Não existe DB global.
- Não existe `AutoMigrate` no startup.
- Não existe `err.Error()` retornado ao cliente.

---

# 7. POLÍTICA DE IMPLEMENTAÇÃO

## TDD

Para alterações comportamentais:

```text
1. escrever teste que falha;
2. executar e confirmar falha pelo motivo esperado;
3. implementar mínimo necessário;
4. executar teste;
5. refatorar se necessário;
6. executar suíte relevante;
7. commit.
```

Não escrever dezenas de features para só depois testar.

---

# 8. POLÍTICA DE COMMITS

Preferir commits pequenos e semanticamente fechados.

Formato:

```text
feat(frontend): ...
feat(backend): ...
feat(database): ...
feat(integration): ...

fix(frontend): ...
fix(backend): ...

test(frontend): ...
test(backend): ...
test(integration): ...

refactor(...): ...
docs: ...
chore(...): ...
```

Não criar um único commit contendo todo o Macro Objetivo.

---

# 9. POLÍTICA DE DEPENDÊNCIAS

Antes de adicionar pacote:

1. verificar se já existe;
2. confirmar versão resolvida;
3. verificar audit/advisories;
4. justificar necessidade;
5. preferir stack já determinada;
6. registrar resultado no resumo.

Não instalar pacote apenas para economizar poucas linhas de código.

---

# 10. POLÍTICA DE COMPONENTES

Ao criar UI:

```text
tokens
 ↓
primitives
 ↓
components
 ↓
compositions
 ↓
features
 ↓
pages
```

Pages apenas orquestram.

Não criar:

```text
CampaignPage.tsx
```

com:

- form;
- table;
- dialogs;
- API;
- filtros;
- cards;
- regras;
- navegação;

todos no mesmo arquivo.

---

# 11. POLÍTICA DE UX

Para cada feature perguntar:

1. Qual é a ação primária?
2. O usuário entende onde está?
3. O usuário sabe como voltar?
4. O estado vazio ensina o próximo passo?
5. O loading preserva a estrutura visual?
6. O erro possui recuperação quando possível?
7. Há feedback depois de mutation?
8. A ação destrutiva exige confirmação?
9. A tela funciona sem mouse?
10. A tela funciona em tamanho menor?

Não otimizar apenas estética.

---

# 12. DIREÇÃO VISUAL

Evitar:

- dashboard SaaS genérico;
- glassmorphism indiscriminado;
- gradients roxo/azul padrão;
- cards idênticos em toda tela;
- excesso de border-radius;
- grandes ícones usados como decoração arbitrária;
- animações sem função;
- excesso de glow;
- estética que pareça template de IA.

Buscar:

- identidade editorial;
- elementos de RPG;
- hierarquia;
- profundidade;
- composição assimétrica quando apropriada;
- microinterações;
- transições fluidas;
- forte identidade por tema;
- boa legibilidade;
- ações claras.

A experiência tem prioridade sobre ornamentação.

---

# 13. REGRAS DE DOMÍNIO FUNDAMENTAIS

## Sistema ativo

```text
UserPreferences.activeSystemId
```

define contexto atual da aplicação.

Não altera entidades existentes.

## Campanha

Toda campanha possui:

```text
systemId
```

## Ficha

Toda ficha possui:

```text
systemId
campaignId | null
```

## Standalone

```text
campaignId == null
```

## Vinculada

Se:

```text
campaignId != null
```

então:

```text
character.systemId == campaign.systemId
```

obrigatoriamente.

## Tema

Tema é preferência do usuário e deve possuir associação clara com sistemas compatíveis.

## Dice

Rolagem simples permanece frontend-only.

---

# 14. CRITÉRIO DE SUCESSO ARQUITETURAL

No fim do Macro 3, a troca:

```text
MSW
```

por:

```text
Gin
```

não deve exigir reescrita das páginas.

Se a integração exigir refatoração grande dos componentes, investigar primeiro divergência de contrato ou acoplamento criado no Macro 1 em vez de duplicar lógica.

---

# 15. ORIENTAÇÃO PARA O CODEX

Execute uma Task por vez.

Antes de cada Task:

1. releia o trecho correspondente;
2. inspecione os arquivos relacionados;
3. verifique regras do projeto;
4. verifique dependências necessárias;
5. identifique testes relevantes.

Depois de cada Task:

1. execute testes relevantes;
2. execute verificações estáticas relevantes;
3. revise diff;
4. remova código morto;
5. confirme ausência de atalhos proibidos;
6. faça commit pequeno.

Ao atingir um Macro Gate:

**PARE obrigatoriamente e aguarde o usuário.**

Não interprete:

- ausência de resposta;
- testes passando;
- task concluída;
- "parece bom";

como autorização para avançar.

A autorização deve ser explícita.