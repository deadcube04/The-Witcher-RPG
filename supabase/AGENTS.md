# Regras de Supabase

Estas regras se aplicam a migrations, seeds, funções SQL, políticas e configuração versionada do Supabase.

## Fonte da verdade

- Alterações de schema devem ser migrations versionadas.
- Não dependa de uma alteração manual no Dashboard sem registrá-la no repositório.
- Não edite migrations já aplicadas em ambientes compartilhados.
- Crie uma nova migration para corrigir uma migration anterior.

## Tabelas

Ao criar ou alterar uma tabela:

1. Defina chave primária.
2. Defina tipos e nulabilidade conscientemente.
3. Defina foreign keys e comportamento de exclusão.
4. Inclua timestamps quando fizer sentido.
5. Crie índices para joins, filtros frequentes e colunas usadas em RLS.
6. Habilite RLS quando a tabela puder ser acessada pela Data API.
7. Crie políticas explícitas.

Não use JSONB para substituir um modelo relacional estável sem justificativa.

## RLS

- RLS é obrigatória para tabelas acessíveis pelo frontend.
- Políticas devem ser criadas por operação.
- Use `auth.uid()` para identidade do usuário.
- Não aceite ownership informado pelo cliente como prova de autorização.
- Políticas devem refletir regras de negócio reais.
- Quando existirem no contrato da funcionalidade, os atores podem incluir o
  proprietário da ficha, o membro da campanha e o administrador ou mestre da
  campanha. Policies não podem inventar papéis que o contrato não define.
- Não use `using (true)` para dados privados.
- Não desabilite RLS para corrigir testes ou desenvolvimento.
- Inclua índices nas colunas consultadas pelas políticas.
- Teste usuários autenticados, anônimos e usuários sem ownership.

### Bom

Os nomes abaixo são ilustrativos. O schema definitivo, incluindo tabelas,
colunas, relações e eventuais papéis, depende da migration da tarefa.

```sql
alter table public.character_sheets enable row level security;

create policy "owners can read own character sheets"
on public.character_sheets
for select
to authenticated
using (owner_id = auth.uid());

create policy "owners can create own character sheets"
on public.character_sheets
for insert
to authenticated
with check (owner_id = auth.uid());

create policy "owners can update own character sheets"
on public.character_sheets
for update
to authenticated
using (owner_id = auth.uid())
with check (owner_id = auth.uid());

create index character_sheets_owner_id_idx
on public.character_sheets (owner_id);
```

### Ruim

```sql
alter table public.character_sheets disable row level security;

create policy "authenticated access"
on public.character_sheets
for all
to authenticated
using (true)
with check (true);
```

Motivos:

- remove a fronteira de autorização;
- qualquer usuário autenticado acessa registros de outros;
- não representa ownership.

## Auth

- Referencie usuários por `auth.users.id` apenas quando necessário.
- Perfis de aplicação devem ficar em tabela pública própria protegida por RLS.
- Triggers de criação de perfil precisam ser idempotentes e falhar de forma observável.
- Não exponha o schema `auth`.
- Claims customizadas não substituem dados relacionais quando a regra muda com frequência.

## Funções SQL

- Prefira funções simples e com contrato explícito.
- Use `security definer` apenas quando indispensável.
- Em `security definer`, fixe `search_path` e valide autorização dentro da função.
- Não conceda execução ampla por padrão.
- Evite lógica opaca que contorne RLS sem justificativa documentada.

## Storage

- Trate o schema `storage` como metadado gerenciado.
- Faça upload, move, copy e delete pela API de Storage.
- Controle operações por políticas em `storage.objects`.
- Separe buckets por modelo de acesso.
- Valide MIME type, tamanho e ownership.
- Não permita upload arbitrário para caminho pertencente a outro usuário.
- Não altere diretamente registros do schema `storage`.

## Tipos TypeScript

Após mudanças de schema:

1. regenere os tipos do Supabase;
2. atualize consumidores;
3. não edite o arquivo gerado manualmente;
4. execute typecheck.

## Seeds

- Seeds devem ser reproduzíveis.
- Não coloque credenciais reais ou dados pessoais.
- Use identificadores estáveis somente quando necessários para relações.
- Diferencie seed de desenvolvimento de migration de produção.

## Validação

Para mudanças de dados:

- aplique migrations em ambiente local ou isolado;
- verifique rollback lógico quando aplicável;
- teste políticas com diferentes usuários;
- execute geração de tipos;
- execute testes do frontend afetado;
- revise se alguma query exige novo índice.
