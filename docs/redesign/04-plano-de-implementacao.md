# Plano de implementação

## Restrições globais

- React 19, TypeScript estrito, Vite, Tailwind 4, Ant Design encapsulado, TanStack e Motion.
- Não adicionar concorrentes da stack existente.
- Não criar ou alterar testes.
- Não alterar contratos de campanha, personagem, usuário ou preferências para armazenar mídia.
- Preservar todas as rotas, filtros, CRUD e recursos da ficha.

## Etapa 1 — Fundação

1. Adicionar fontes locais e tokens tipográficos.
2. Expandir `ThemeDefinition` e integrar tokens ao `RpgVisualProvider`.
3. Criar acervo fotográfico otimizado e mapa de arte por sistema/contexto.
4. Criar `MediaFrame`, `EditorialFeature`, `DossierRow`, `UtilityPanel`, `PageMasthead` e `ContextToolbar`.

**Aceite:** temas preservam identidade comum, componentes não dependem de páginas e imagens possuem fallback e dimensões estáveis.

## Etapa 2 — Shell e estados

1. Transformar `AppSidebar` em rail responsiva.
2. Adicionar barra contextual orientada por metadados das rotas.
3. Criar dock mobile e ajustar margens/safe area no `AppShell`.
4. Atualizar transições, skeleton, vazio, erro, 404, modal e confirmação.

**Aceite:** todas as rotas continuam acessíveis por teclado, mobile não depende de hover e redução de movimento é respeitada.

## Etapa 3 — Home e coleções

1. Reestruturar Home para retomada de sessão e índices recentes.
2. Migrar campanhas para destaque + dossiers e toolbar.
3. Migrar personagens para composição visual própria, sem copiar campanhas.

**Aceite:** filtros continuam refletidos na URL; abrir, editar e excluir permanecem disponíveis; estados vazios guiam criação.

## Etapa 4 — Editores e detalhes

1. Criar layouts divididos para campanha e personagem.
2. Adicionar prévias locais derivadas dos valores já existentes.
3. Renovar detalhe de campanha e perfil.

**Aceite:** schemas, validação, bloqueios de sistema, mutations e navegação pós-salvamento permanecem inalterados.

## Etapa 5 — Ficha

1. Refinar identidade, recursos e resumo superior.
2. Compactar perícias sem reduzir alvos ou legibilidade.
3. Renovar drawers de inventário, rituais, ataques e dados.
4. Rebaixar visualmente narrativa sem ocultá-la.

**Aceite:** edição inline, autosave existente, recursos temporários, drawers e rolagem da tabela continuam funcionais.

## Etapa 6 — Sistemas e aparência

1. Destacar sistema ativo e diferenciar previews.
2. Transformar configurações em índice editorial.
3. Transformar aparência em showroom assimétrico.

**Aceite:** seleção do sistema, aplicação de tema e modo da rail continuam persistindo.

## Verificação final

- Executar `bun run lint`.
- Executar `bun run typecheck`.
- Executar `bun run build`.
- Inspecionar todas as rotas em desktop, tablet e mobile.
- Conferir teclado, foco, contraste, zoom, redução de movimento, loading, vazio e erro.
- Se bindings nativos locais impedirem build, restaurar `node_modules` exatamente a partir de `bun.lock`, sem alterar versões ou o lockfile.
