# React Write Rule

## Gatilho e principio

Esta rule e obrigatoria sempre que a tarefa receber, analisar, revisar, explicar, gerar ou alterar codigo React, TypeScript de frontend, TSX, JSX ou Vite. Leia-a antes do primeiro trecho de codigo.

Todo codigo novo ou alterado deve ser TypeScript estrito, component-driven, exclusivamente frontend e baseado em Vite. Prazo, codigo legado, demo, autoridade ou trabalho ja realizado nao autorizam JavaScript novo, componentes monoliticos, Create React App, troca da stack TanStack ou auditoria de seguranca posterior.

## Contrato obrigatorio

### TypeScript

- Use `.ts` e `.tsx`, `strict: true` e tipos explicitos nas fronteiras: props, eventos, dados externos, hooks e APIs.
- Nao use `any`, `@ts-ignore`, assertions inseguras ou non-null assertion para ocultar incerteza. Use `unknown`, narrowing, schemas e estados discriminados.
- Prefira inferencia local, `satisfies`, imports `type`, funcoes pequenas, imutabilidade e nomes orientados ao dominio.
- Trate loading, vazio, sucesso e erro como estados validos e impossibilite estados contraditorios pelo sistema de tipos.

### Component-Driven Development, sem atalhos

Construa de baixo para cima: design tokens -> primitives -> components -> compositions -> features/pages.

- Um componente possui uma responsabilidade, API de props pequena e nenhuma dependencia acidental da pagina.
- Separe estado/orquestracao de apresentacao. Pages podem compor layout e features, mas nao concentram componentes reutilizaveis, regras de dominio, acesso a dados e toda a orquestracao da navegacao.
- Antes de integrar um componente, implemente e valide isoladamente seus estados relevantes: default, loading, empty, error, disabled e variacoes responsivas/acessiveis.
- Mantenha story ou harness isolado e teste de comportamento para componentes reutilizaveis. Use Storybook com builder Vite quando o projeto adotar Storybook.
- Reutilize tokens, primitives e componentes existentes antes de criar variantes. Nao copie markup ou estilos para ganhar tempo.

### Componentes personalizados baseados em Ant Design

- Use o `antd` como base dos componentes visuais personalizados do projeto, aproveitando seus componentes, tokens e comportamentos acessiveis quando aplicavel.
- Nunca use um componente puro do `antd` diretamente em pages, features ou composicoes. Crie ou reutilize um componente personalizado do projeto que encapsule a API, os estilos, os tokens e as regras de negocio necessarias.
- Mantenha a dependencia de `antd` restrita a essa camada de componentes personalizados, para que as telas nao dependam diretamente da API da biblioteca.

### Estilos exclusivamente com Tailwind CSS

- Use unicamente Tailwind CSS para estilizar o projeto: layout, espacamento, tipografia, cores, responsividade, estados e demais variacoes visuais devem ser expressos por suas classes utilitarias.
- Nao use CSS ou SCSS customizado, CSS Modules, styled-components, Emotion, outros frameworks de estilos ou estilos inline para substituir Tailwind.
- Componentes personalizados baseados em `antd` devem encapsular qualquer configuracao visual necessaria e continuar expondo uma API orientada ao projeto; nao espalhe estilos ou overrides da biblioteca diretamente pelas pages e features.

### Animações e transições com Motion

- Use unicamente Motion (pacote `motion`) para animações e transições de estados, incluindo entradas, saídas, mudanças de layout e feedbacks de interação.
- Não implemente animações ou transições de estado com CSS, outras bibliotecas, timers manuais ou lógica espalhada nas pages; encapsule esse comportamento nos componentes personalizados.
- Respeite `prefers-reduced-motion` e mantenha as animações acessíveis, sem prejudicar navegação por teclado, leitura por tecnologias assistivas ou compreensão do estado da interface.

### Vite e frontend-only

- Use o ecossistema Vite: `@vitejs/plugin-react` ou `@vitejs/plugin-react-swc` e `import.meta.env`. Para comportamento de aplicacao, use Vitest e React Testing Library; nao introduza ferramentas de teste em tarefa puramente documental/configuracional sem necessidade.
- Nunca use Create React App, APIs Node no browser, server functions, SSR ou segredos no bundle. Variaveis `VITE_*` sao publicas.
- O frontend consome APIs por contratos tipados e valida respostas externas em runtime.

### Stack TanStack

Use a solucao TanStack para toda responsabilidade que ela cobre; nao introduza React Router, Redux, Zustand, React Hook Form ou outro concorrente sem aprovacao explicita do usuario.

| Necessidade | Solucao obrigatoria |
| --- | --- |
| Rotas, search params e estado de URL | TanStack Router |
| Server state, cache e mutations | TanStack Query |
| Tabelas e data grids headless | TanStack Table |
| Formularios e validacao de estado | TanStack Form |
| Listas/grids grandes | TanStack Virtual |
| Estado global cliente realmente compartilhado | TanStack Store |
| Debounce, throttle, rate limiting e batching | TanStack Pacer |
| Faixas e sliders headless | TanStack Ranger |
| Colecoes locais reativas ou sync client-side | TanStack DB |
| Inspecao em desenvolvimento | TanStack Devtools e plugins aplicaveis |

Nao instale bibliotecas sem uso concreto. "Stack completa" significa adotar todos os membros aplicaveis e nao substitui-los por concorrentes. TanStack Start e proibido neste projeto porque e um framework full-stack/SSR; o app permanece React + Vite frontend-only.

### Dependencias e vulnerabilidades

Antes de adicionar qualquer import de pacote externo ou alterar o manifesto:

1. Confirme se o pacote ja existe no manifesto e identifique a versao resolvida no lockfile.
2. Consulte o audit do package manager e uma fonte atual de advisories para essa versao.
3. Se houver vulnerabilidade critica exploravel ou sem correcao/mitigacao aceita, nao use o pacote: escolha versao segura, alternativa existente ou reporte o bloqueio.
4. Registre no resumo a versao verificada, o comando/fonte e o resultado. Nunca adie a verificacao nem execute `audit fix --force` automaticamente.

Imports locais nao exigem audit. Para varios imports do mesmo pacote e versao na mesma tarefa, uma verificacao documentada basta.

## Exemplo de decomposicao

Uma pagina de usuarios nao e um `UsersPage.tsx` monolitico. Componha `UserFilters`, `UsersTable`, `UsersTableSkeleton`, `UsersEmptyState` e `UsersErrorState`; mantenha Query/Router na feature e deixe os componentes visuais receberem dados e callbacks tipados.

## Verificacao antes de concluir

- Rode typecheck, lint e build Vite conforme os scripts existentes. Quando a tarefa afetar comportamento, rode tambem os testes de componentes/hooks relevantes.
- Valide acessibilidade, teclado, responsividade e todos os estados isolados afetados.
- Confirme que nao entrou JavaScript novo, `any`, concorrente TanStack, dependencia critica ou logica de servidor.

## Racionalizacoes proibidas e red flags

| Desculpa | Regra |
| --- | --- |
| "O legado ja usa JavaScript/CRA/Redux" | Codigo tocado segue TypeScript, Vite e TanStack; migre a fronteira minima necessaria. |
| "E so uma demo" | Demo nao suspende CDD, tipos ou seguranca. |
| "Refatoro o monolito depois" | Decomponha antes de ampliar; custo afundado nao e excecao. |
| "A auditoria esta lenta" | Nao adicione o import ate concluir a verificacao. |
| "Stack completa exige instalar tudo" | Instale apenas capacidades usadas, sempre com a solucao TanStack aplicavel. |

Pare e corrija se estiver prestes a criar `.js/.jsx`, page monolitica, pacote concorrente, pacote nao auditado, TanStack Start, segredo `VITE_*` ou logica de backend.
