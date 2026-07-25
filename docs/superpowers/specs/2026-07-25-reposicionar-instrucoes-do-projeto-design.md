# Reposicionamento das instruções do projeto

## Objetivo

Corrigir as regras, os agentes e as skills existentes para representar o
produto como uma plataforma de gerenciamento de fichas, campanhas e sessões de
RPG. O mapa interativo permanece como uma feature especializada, sem ocupar o
centro da arquitetura ou das regras gerais.

## Escopo

Esta alteração atualizará somente arquivos existentes. Não serão criadas novas
skills, novos agentes, funcionalidades, schemas, componentes ou assets.

### Arquivos gerais

- `AGENTS.md`
  - Definir fichas, campanhas e sessões como domínios centrais.
  - Tratar o mapa como uma feature complementar.
  - Manter as regras técnicas, de estado, segurança e qualidade aplicáveis à
    plataforma inteira.
  - Tornar regras de MapLibre, tiles, GeoJSON e CDN condicionais a tarefas que
    realmente envolvam o mapa.
  - Não descrever identidade visual ou narrativa de The Witcher.

- `docs/architecture.md`
  - Apresentar a SPA e o Supabase como base da plataforma completa.
  - Organizar a arquitetura sugerida por `auth`, `characters`, `campaigns`,
    `sessions` e `map`.
  - Adicionar fluxos gerais de leitura e alteração dos domínios principais.
  - Manter a arquitetura geoespacial em uma seção própria e secundária.
  - Tornar requisitos de R2, CDN, tiles e GeoJSON condicionais à feature de
    mapa.

### Regras especializadas

- `src/AGENTS.md`
  - Substituir exemplos genéricos centrados em regiões por exemplos dos
    domínios principais.
  - Preservar a separação entre TanStack Query, Zustand e estado local.
  - Manter as regras de MapLibre em seção explicitamente aplicável apenas à
    feature de mapa.
  - Não introduzir regras de identidade visual; elas serão definidas
    posteriormente em `design.md`.

- `supabase/AGENTS.md`
  - Usar exemplos de ownership e autorização coerentes com fichas e campanhas,
    em vez de marcadores de mapa.
  - Incluir membership de campanha entre os atores de autorização quando
    aplicável.
  - Não presumir um schema definitivo ainda inexistente.

### Skills existentes

- `.agents/skills/fix-scoped-bug/SKILL.md`
  - Descrever a aplicação como React, Vite e Supabase, tratando MapLibre como
    integração condicional.
  - Fazer o diagnóstico percorrer somente as fronteiras envolvidas no bug.

- `.agents/skills/implement-frontend-feature/SKILL.md`
  - Reconhecer telas e fluxos de fichas, campanhas e sessões como casos
    centrais.
  - Manter tarefas geoespaciais sob a skill especializada de mapa.

- `.agents/skills/change-supabase-data/SKILL.md`
  - Considerar proprietário de ficha e membros ou administradores de campanha
    na matriz de autorização, quando esses atores fizerem parte da tarefa.
  - Preservar todas as garantias de RLS e segurança existentes.

- `.agents/skills/prepare-vercel-deploy/SKILL.md`
  - Validar o fluxo principal da plataforma, autenticação e rotas.
  - Verificar tiles e CDN apenas quando a versão implantada incluir ou alterar a
    feature de mapa.

### Arquivos mantidos especializados

Os arquivos abaixo continuarão focados em mapa porque sua responsabilidade já
é corretamente limitada ao domínio geoespacial:

- `.agents/skills/build-map-feature/SKILL.md`;
- `.agents/skills/manage-map-assets/SKILL.md`;
- `src/features/map/AGENTS.md`;
- `public/tiles/AGENTS.md`.

Eles poderão receber apenas correções de referências globais se uma
inconsistência objetiva for encontrada durante a implementação.

## Limites de produto e design

A plataforma é temática de The Witcher, mas a definição de identidade visual,
direção de arte, referências narrativas, terminologia, cânone e experiência de
marca não faz parte desta alteração. Essas decisões serão documentadas
posteriormente em um arquivo `design.md`.

Nenhum `AGENTS.md` deverá antecipar ou inventar essas regras.

## Compatibilidade e riscos

- As skills de mapa devem continuar sendo descobertas quando mapa, tiles,
  GeoJSON, layers, câmera ou assets geoespaciais forem o centro da tarefa.
- As skills genéricas não devem acionar regras de MapLibre ou CDN para mudanças
  sem relação com o mapa.
- As regras não devem inventar tabelas, papéis ou permissões definitivas antes
  da modelagem dos domínios.
- Regras existentes de segurança, RLS, estado, acessibilidade, performance e
  deploy devem ser preservadas.
- A alteração não deve adicionar dependências nem modificar código de
  aplicação.

## Validação

1. Validar o frontmatter YAML de cada skill alterada.
2. Procurar referências que ainda definam o produto inteiro como mapa
   interativo.
3. Confirmar que referências geoespaciais restantes estejam dentro de seções ou
   arquivos especializados.
4. Confirmar que fichas, campanhas e sessões apareçam como os domínios centrais
   nas regras e na arquitetura geral.
5. Confirmar que nenhum `AGENTS.md` contenha regras de identidade visual ou
   narrativa de The Witcher.
6. Revisar o diff completo para evitar alterações fora do escopo.

Não há aplicação ou `package.json` neste estado do workspace; portanto, lint,
typecheck, testes e build de frontend não se aplicam a esta alteração
documental.
