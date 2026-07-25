---
name: change-supabase-data
description: Alterar schema, migrations, tabelas, funções SQL, Supabase Auth, Row Level Security, policies, seeds ou tipos gerados. Usar quando a tarefa envolver banco, autorização por linha, ownership, acesso de usuários, migration, SQL ou erro de permissão do Supabase.
---

# Alterar dados e autorização no Supabase

1. Ler `supabase/AGENTS.md` e as migrations relacionadas.
2. Identificar os atores e operações:
   - anônimo;
   - autenticado;
   - proprietário da ficha, quando existir no contrato da funcionalidade;
   - membro da campanha, quando existir no contrato da funcionalidade;
   - mestre ou administrador da campanha, quando existir no contrato da funcionalidade;
   - backend administrativo, se existir.
3. Usar papéis e permissões somente quando existirem no contrato da funcionalidade; não inventar policies, papéis ou relações definitivas.
4. Distinguir ownership de ficha de membership de campanha quando ambos existirem no contrato.
5. Especificar permissões esperadas para `select`, `insert`, `update` e `delete`.
6. Criar nova migration; não reescrever migration aplicada.
7. Incluir:
   - schema;
   - constraints;
   - foreign keys;
   - índices;
   - RLS;
   - policies;
   - grants necessários.
8. Verificar `using` e `with check` separadamente.
9. Não confiar em ownership enviado pelo frontend.
10. Não usar `service_role` no navegador.
11. Para Storage, alterar acesso por API e policies, não por edição direta do schema.
12. Aplicar a migration em ambiente local ou isolado.
13. Testar ao menos:
    - acesso autorizado;
    - usuário diferente;
    - não autenticado;
    - criação com ownership inválido;
    - update que tenta trocar ownership.
14. Regenerar tipos TypeScript.
15. Atualizar queries afetadas.
16. Executar typecheck e testes.
17. Resumir a matriz de permissões na conclusão.
