# Instruções do projeto

## Objetivo

Este repositório contém uma plataforma web para gerenciamento de fichas de
personagens, campanhas e sessões de RPG.

## Arquitetura oficial

### Frontend

- React
- Vite
- TypeScript
- Motion
- TanStack Query
- Zustand

### Dados e identidade

- Supabase PostgreSQL
- Supabase Auth
- Supabase Row Level Security (RLS)

### Arquivos gerais

- Supabase Storage para arquivos privados ou controlados por autenticação,
  incluindo arquivos de fichas e campanhas.

### Deploy

- Vercel para o frontend.
- Supabase para banco, autenticação e, quando aplicável, arquivos privados.

Consulte `docs/architecture.md` antes de realizar mudanças arquiteturais.

Para alterações de uma feature específica, consulte as instruções locais e as
skills correspondentes ao domínio antes de modificar seus arquivos.

## Prioridade das instruções

1. Solicitação atual do usuário.
2. `AGENTS.md` mais próximo do arquivo alterado.
3. Este `AGENTS.md`.
4. Padrões já estabelecidos no código.

Não use uma instrução genérica para contrariar uma regra de negócio existente.

## Fluxo obrigatório

Antes de alterar código:

1. Leia os arquivos diretamente relacionados.
2. Identifique os contratos, tipos, hooks, stores, queries e políticas envolvidos.
3. Verifique como a funcionalidade é testada.
4. Defina a menor alteração capaz de atender à solicitação.
5. Identifique riscos de segurança, performance e regressão.

Durante a implementação:

- Mantenha a alteração dentro do escopo solicitado.
- Preserve regras de negócio e contratos não mencionados.
- Reutilize componentes, hooks, stores, query keys, clientes e utilitários existentes.
- Não faça refatorações oportunistas.
- Não adicione dependências sem necessidade demonstrável.
- Não silencie erros com casts, `any`, valores padrão enganosos ou blocos `catch` vazios.
- Não altere arquivos gerados manualmente quando existir um processo oficial de geração.
- Não misture mudanças funcionais com reformatação ampla.

Depois da implementação:

1. Revise o diff.
2. Execute os comandos aplicáveis definidos em `package.json`.
3. Execute, no mínimo, lint, typecheck, testes relacionados e build quando disponíveis.
4. Informe os arquivos alterados, validações executadas e limitações restantes.
5. Não declare uma validação como concluída se ela não foi executada.

Use o gerenciador de pacotes indicado pelo lockfile existente. Não troque o gerenciador de pacotes durante uma tarefa comum.

## Fronteiras de estado

### TanStack Query

Use TanStack Query para estado remoto e assíncrono:

- fichas, campanhas, sessões, participantes e outros dados do Supabase;
- consultas e paginação;
- cache;
- mutations;
- invalidação;
- sincronização e refetch.

### Zustand

Use Zustand para estado global exclusivamente do cliente:

- filtros compartilhados não persistidos no servidor;
- painel ou modal aberto;
- preferências visuais locais;
- modo de interação de uma feature.

### Estado local do React

Use estado local para informações efêmeras pertencentes a um componente.

### Proibições

- Não copie resultados de TanStack Query para Zustand.
- Não use Zustand como cache paralelo do Supabase.
- Não use TanStack Query para estado puramente visual.
- Não crie estado global quando estado local resolve o problema.

## Segurança

- Considere toda variável `VITE_*` pública e visível no bundle do navegador.
- Nunca coloque `service_role`, segredos de provedores ou tokens administrativos no frontend.
- O frontend pode usar somente a chave pública/publishable do Supabase.
- Autenticação no cliente não substitui autorização no banco.
- Toda tabela exposta ao cliente deve possuir RLS e políticas explícitas.
- Toda operação de Storage deve respeitar políticas adequadas.
- Não confie em `user_id`, role, owner ou permissões enviados pelo navegador sem validação no banco.
- Não desabilite RLS para corrigir um erro de autorização.
- Não use URLs assinadas como autorização permanente.
- Não registre tokens, sessões, chaves ou dados pessoais sensíveis em logs.

## Arquivos

- Arquivos privados de fichas e campanhas devem usar Supabase Storage e
  respeitar as políticas adequadas.
- Não armazene binários grandes no PostgreSQL.

## Critérios gerais de qualidade

- Tipagem estrita.
- Componentes pequenos e coesos.
- Acessibilidade preservada.
- Estados de loading, vazio, erro e sucesso.
- Tratamento explícito de falhas de rede.
- Sem regressões perceptíveis de performance.
- Sem listeners, subscriptions ou instâncias que sobrevivam ao unmount.
- Sem duplicação desnecessária de lógica ou estado.

## Skills do repositório

As skills reutilizáveis estão em `.agents/skills/`.

Use a menor quantidade de skills capaz de cobrir a tarefa. Não invoque uma skill apenas porque ela menciona uma tecnologia presente no projeto.
