# Reposicionamento das instruções do projeto — Plano de implementação

> **Para agentes executores:** SUB-SKILL OBRIGATÓRIA: usar
> `superpowers:subagent-driven-development` (recomendado) ou
> `superpowers:executing-plans` para implementar este plano tarefa por tarefa.
> Os passos usam checkboxes (`- [ ]`) para acompanhamento.

**Objetivo:** Corrigir as regras, os agentes e as skills existentes para
representar uma plataforma de gerenciamento de fichas, campanhas e sessões de
RPG, mantendo o mapa como feature especializada.

**Arquitetura:** As instruções gerais descrevem os domínios centrais e as
fronteiras compartilhadas de frontend, dados, autorização e deploy. Regras
geoespaciais permanecem em seções condicionais ou nos arquivos especializados
da feature de mapa.

**Stack:** Markdown, YAML frontmatter, React, Vite, TypeScript, TanStack Query,
Zustand, Motion, Supabase, MapLibre GL JS, Cloudflare R2 e Vercel.

## Restrições globais

- Atualizar somente arquivos existentes de regras, arquitetura e skills, além
  deste plano e da especificação já aprovada.
- Não criar novas skills, agentes, funcionalidades, schemas, componentes ou
  assets.
- Não definir identidade visual ou narrativa de The Witcher em nenhum
  `AGENTS.md`.
- Não antecipar o conteúdo do futuro `design.md`.
- Manter fichas, campanhas e sessões como domínios centrais.
- Manter o mapa como feature complementar e especializada.
- Preservar as garantias existentes de RLS, segurança, estado, acessibilidade,
  performance e deploy.
- Não presumir um schema definitivo ainda inexistente.
- O workspace não possui metadados Git válidos; etapas de commit não são
  executáveis nesta sessão.

---

### Tarefa 1: Registrar o comportamento atual das skills genéricas

**Arquivos:**

- Ler:
  `.agents/skills/fix-scoped-bug/SKILL.md`
- Ler:
  `.agents/skills/implement-frontend-feature/SKILL.md`
- Ler:
  `.agents/skills/change-supabase-data/SKILL.md`
- Ler:
  `.agents/skills/prepare-vercel-deploy/SKILL.md`
- Criar temporariamente fora do repositório:
  `/tmp/witcher-rpg-skill-baseline/`

**Interfaces:**

- Consome: descrições e instruções atuais das quatro skills genéricas.
- Produz: evidência de quais prompts ainda levam um agente a tratar mapa,
  MapLibre, tiles ou CDN como preocupações globais.

- [ ] **Passo 1: Preparar cenários de aplicação sem editar as skills**

Usar estes quatro prompts em contextos independentes:

```text
1. Corrija um erro de salvamento em uma ficha de personagem e liste as
   fronteiras técnicas que você investigaria.

2. Implemente a tela de detalhes de uma campanha e explique como dividiria
   estado remoto, estado global do cliente e estado local.

3. Modele a autorização para que o dono de uma ficha possa editá-la e membros
   de uma campanha possam apenas consultá-la.

4. Prepare o deploy de uma alteração somente na tela de sessões e liste todas
   as integrações externas que precisam de smoke test.
```

- [ ] **Passo 2: Executar os cenários contra as skills atuais**

Executar cada prompt com a skill correspondente, preservando a skill original.
Registrar em `/tmp/witcher-rpg-skill-baseline/` se a resposta:

```text
- trata MapLibre como fronteira obrigatória para bug sem mapa;
- omite fichas, campanhas ou sessões como casos centrais;
- não distingue ownership de ficha e membership de campanha;
- exige tiles ou CDN em deploy sem alteração geoespacial.
```

- [ ] **Passo 3: Confirmar a linha de base**

Ler integralmente as quatro respostas e resumir os desvios observados. A linha
de base é válida se revelar pelo menos uma instrução excessivamente centrada no
mapa ou uma lacuna objetiva de domínio. Se nenhum desvio aparecer, limitar as
edições posteriores à clareza textual exigida pela especificação.

---

### Tarefa 2: Reposicionar as regras e a arquitetura gerais

**Arquivos:**

- Modificar: `AGENTS.md`
- Modificar: `docs/architecture.md`

**Interfaces:**

- Consome: objetivo e limites definidos na especificação aprovada.
- Produz: fonte geral de verdade sobre propósito, arquitetura, estado,
  segurança, armazenamento e deploy.

- [ ] **Passo 1: Atualizar o objetivo e a arquitetura oficial no `AGENTS.md`**

Substituir a definição de “aplicação web de mapa interativo” por:

```text
Plataforma web para gerenciamento de fichas de personagens, campanhas e
sessões de RPG.
```

Descrever o mapa como feature complementar. Manter MapLibre na stack somente
para tarefas geoespaciais. Separar armazenamento geral de arquivos do
armazenamento específico de assets do mapa.

- [ ] **Passo 2: Generalizar as fronteiras de estado no `AGENTS.md`**

Os exemplos devem representar:

```text
TanStack Query: fichas, campanhas, sessões, participantes e dados do Supabase.
Zustand: filtros compartilhados, painel/modal aberto, preferências locais e
modo de interação de uma feature.
React: estado efêmero pertencente a um componente.
```

Manter seleção de região, câmera e instância MapLibre somente em uma subseção
condicional à feature de mapa.

- [ ] **Passo 3: Generalizar segurança, arquivos e critérios no `AGENTS.md`**

Preservar todas as regras de chaves públicas, RLS, ownership, Storage e logs.
Descrever arquivos privados de fichas e campanhas como casos de Supabase
Storage. Manter tiles, GeoJSON, CDN e R2 como regras condicionais ao mapa.

- [ ] **Passo 4: Reestruturar `docs/architecture.md`**

Organizar a visão geral e a árvore sugerida com estas features:

```text
auth
characters
campaigns
sessions
map
```

Manter os fluxos de query e mutation como fluxos gerais da plataforma.
Posicionar renderização do mapa, convenções de tiles e GeoJSON em uma seção
especializada, sem alterar seus contratos técnicos.

- [ ] **Passo 5: Validar as regras gerais**

Executar:

```bash
rg -n -i 'aplicação web de mapa interativo|mapa é renderizado' AGENTS.md docs/architecture.md
rg -n -i 'fichas|campanhas|sessões' AGENTS.md docs/architecture.md
rg -n -i 'identidade visual|direção de arte|cânone|experiência de marca' AGENTS.md
```

Resultado esperado:

```text
- nenhum resultado que defina o produto inteiro como mapa;
- fichas, campanhas e sessões presentes nos dois arquivos;
- nenhuma regra de identidade ou narrativa no AGENTS.md.
```

---

### Tarefa 3: Corrigir os agentes especializados de frontend e Supabase

**Arquivos:**

- Modificar: `src/AGENTS.md`
- Modificar: `supabase/AGENTS.md`
- Preservar: `src/features/map/AGENTS.md`
- Preservar: `public/tiles/AGENTS.md`

**Interfaces:**

- Consome: regras gerais atualizadas na Tarefa 2.
- Produz: regras locais coerentes para frontend, autorização e banco.

- [ ] **Passo 1: Substituir os exemplos de estado em `src/AGENTS.md`**

Usar uma query de campanha, um painel compartilhado e um estado local efêmero:

```tsx
const campaignQuery = useQuery(campaignQueries.detail(campaignId));
const activePanel = useCampaignUiStore((state) => state.activePanel);
const [isConfirmDialogOpen, setConfirmDialogOpen] = useState(false);
```

O exemplo incorreto deve continuar demonstrando cópia de dados do Supabase para
Zustand, mas usando campanhas em vez de regiões.

- [ ] **Passo 2: Tornar as regras de MapLibre condicionais**

Renomear ou introduzir a seção como:

```text
MapLibre — somente para a feature de mapa
```

Preservar integralmente as garantias de instância única, `useRef`, cleanup,
sources, layers, listeners e performance.

- [ ] **Passo 3: Atualizar o exemplo de RLS em `supabase/AGENTS.md`**

Usar uma tabela ilustrativa `character_sheets` com `owner_id`, deixando
explícito que nomes definitivos dependem da migration da tarefa. Demonstrar:

```sql
using (owner_id = auth.uid())
with check (owner_id = auth.uid())
```

Manter o exemplo ruim com acesso amplo para mostrar por que `using (true)` e
`with check (true)` são inseguros.

- [ ] **Passo 4: Incluir atores condicionais de domínio**

Adicionar às regras de autorização:

```text
- proprietário da ficha;
- membro da campanha;
- administrador ou mestre da campanha;
```

Especificar que esses atores só devem ser usados quando existirem no contrato
da funcionalidade e que policies não podem inventar papéis.

- [ ] **Passo 5: Validar o escopo dos agentes**

Executar:

```bash
rg -n -i 'regionQuery|selectedRegionId|user_markers' src/AGENTS.md supabase/AGENTS.md
rg -n -i 'campaign|character_sheets|owner_id' src/AGENTS.md supabase/AGENTS.md
rg -n -i 'identidade visual|direção de arte|cânone|experiência de marca' --glob 'AGENTS.md' .
```

Resultado esperado:

```text
- nenhum exemplo genérico antigo centrado em mapa;
- exemplos de campanha e ficha presentes;
- nenhuma regra de identidade de The Witcher em arquivos AGENTS.md.
```

---

### Tarefa 4: Corrigir as quatro skills genéricas

**Arquivos:**

- Modificar: `.agents/skills/fix-scoped-bug/SKILL.md`
- Modificar: `.agents/skills/implement-frontend-feature/SKILL.md`
- Modificar: `.agents/skills/change-supabase-data/SKILL.md`
- Modificar: `.agents/skills/prepare-vercel-deploy/SKILL.md`
- Preservar: `.agents/skills/build-map-feature/SKILL.md`
- Preservar: `.agents/skills/manage-map-assets/SKILL.md`

**Interfaces:**

- Consome: desvios documentados na Tarefa 1 e regras atualizadas nas Tarefas 2
  e 3.
- Produz: gatilhos e workflows genéricos que não promovem mapa a preocupação
  global.

- [ ] **Passo 1: Corrigir `fix-scoped-bug`**

Alterar a descrição para disparar em bugs da plataforma React, Vite e Supabase,
sem listar MapLibre como característica global. No corpo, representar o fluxo
como:

```text
componente → hook → query, mutation ou store → Supabase ou integração
envolvida → policy ou dado, quando aplicável
```

MapLibre deve aparecer apenas quando o bug envolver a feature de mapa.

- [ ] **Passo 2: Corrigir `implement-frontend-feature`**

Incluir fichas, campanhas e sessões nos gatilhos de telas e fluxos. Preservar a
condição que direciona mudanças principalmente geoespaciais para
`build-map-feature`.

- [ ] **Passo 3: Corrigir `change-supabase-data`**

Na identificação de atores, incluir condicionalmente proprietário da ficha,
membro da campanha e mestre/administrador da campanha. Adicionar uma regra para
não inventar papéis ou permissões ausentes do contrato da funcionalidade.

- [ ] **Passo 4: Corrigir `prepare-vercel-deploy`**

Tratar Supabase, autenticação, rotas SPA e assets gerais como validações
globais. Executar verificações de tiles, CDN e MapLibre apenas quando o deploy
incluir ou alterar a feature de mapa.

- [ ] **Passo 5: Validar o frontmatter e o tamanho das skills**

Executar em cada diretório alterado:

```bash
python /home/deadcube/.codex/skills/.system/skill-creator/scripts/quick_validate.py .agents/skills/fix-scoped-bug
python /home/deadcube/.codex/skills/.system/skill-creator/scripts/quick_validate.py .agents/skills/implement-frontend-feature
python /home/deadcube/.codex/skills/.system/skill-creator/scripts/quick_validate.py .agents/skills/change-supabase-data
python /home/deadcube/.codex/skills/.system/skill-creator/scripts/quick_validate.py .agents/skills/prepare-vercel-deploy
wc -w .agents/skills/{fix-scoped-bug,implement-frontend-feature,change-supabase-data,prepare-vercel-deploy}/SKILL.md
```

Resultado esperado: quatro validações bem-sucedidas, frontmatters contendo
somente `name` e `description`, e nenhuma expansão desnecessária.

- [ ] **Passo 6: Reexecutar os cenários da Tarefa 1**

Usar os mesmos quatro prompts contra as skills atualizadas. Confirmar:

```text
- bug de ficha não exige MapLibre sem evidência;
- frontend reconhece fichas, campanhas e sessões;
- autorização distingue ownership e membership sem inventar policies;
- deploy sem mapa não exige tiles ou CDN.
```

Ler integralmente cada resposta e corrigir qualquer ambiguidade objetiva antes
de avançar.

---

### Tarefa 5: Revisão final de consistência

**Arquivos:**

- Revisar: `AGENTS.md`
- Revisar: `docs/architecture.md`
- Revisar: `src/AGENTS.md`
- Revisar: `supabase/AGENTS.md`
- Revisar: `.agents/skills/*/SKILL.md`

**Interfaces:**

- Consome: todos os documentos atualizados.
- Produz: conjunto coerente de instruções para futuras tarefas do repositório.

- [ ] **Passo 1: Procurar definições antigas do produto**

Executar:

```bash
rg -n -i --glob '!docs/superpowers/**' \
  'aplicação web de mapa interativo|repositório contém.*mapa interativo' \
  AGENTS.md .agents docs src public supabase
```

Resultado esperado: nenhum resultado.

- [ ] **Passo 2: Auditar a centralidade dos domínios**

Executar:

```bash
rg -n -i --glob '!docs/superpowers/**' \
  'ficha|personagem|campanha|sessão|sessões' \
  AGENTS.md .agents docs src supabase
```

Resultado esperado: os domínios aparecem nos documentos gerais e nas skills
genéricas relevantes.

- [ ] **Passo 3: Auditar o isolamento do mapa**

Executar:

```bash
rg -n -i --glob '!docs/superpowers/**' \
  'MapLibre|tiles|GeoJSON|CDN|R2' \
  AGENTS.md .agents docs src public supabase
```

Classificar manualmente cada ocorrência. Toda ocorrência deve estar em:

```text
- arquivo especializado de mapa;
- seção explicitamente condicional à feature de mapa;
- regra de segurança ou armazenamento que delimite sua aplicação.
```

- [ ] **Passo 4: Auditar a ausência de identidade nos agentes**

Executar:

```bash
rg -n -i --glob 'AGENTS.md' \
  'The Witcher|identidade visual|direção de arte|cânone|experiência de marca' .
```

Resultado esperado: nenhum resultado.

- [ ] **Passo 5: Revisar todas as alterações**

Como Git não está disponível, comparar os arquivos finais com o conteúdo
registrado na especificação e confirmar manualmente:

```text
- nenhum arquivo fora do escopo foi alterado;
- nenhuma skill nova foi criada;
- nenhuma garantia de segurança ou qualidade foi removida;
- nenhum schema definitivo foi inventado;
- todos os comandos de validação aplicáveis foram executados.
```

- [ ] **Passo 6: Entregar o relatório**

Informar:

```text
- arquivos alterados;
- reposicionamento realizado;
- skills validadas;
- buscas de consistência executadas;
- ausência de lint, typecheck, testes e build por não existir aplicação nem
  package.json;
- impossibilidade de gerar commit porque .git está vazio.
```
