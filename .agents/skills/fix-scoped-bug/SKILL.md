---
name: fix-scoped-bug
description: Corrigir bugs de forma localizada nesta plataforma React, Vite e Supabase. Usar quando fichas, campanhas, sessões ou outros fluxos apresentarem erro, regressão, comportamento incorreto, tela quebrada ou necessidade de correção com preservação das regras de negócio e do escopo.
---

# Corrigir bug com escopo controlado

1. Ler o `AGENTS.md` aplicável aos arquivos envolvidos.
2. Reproduzir ou caracterizar o comportamento incorreto em fichas, campanhas, sessões ou no fluxo envolvido.
3. Identificar:
   - comportamento esperado;
   - comportamento atual;
   - primeira fronteira em que os dois divergem;
   - causa raiz;
   - riscos de regressão.
4. Traçar o fluxo completo relevante: componente → hook → query, mutation ou store → Supabase ou integração envolvida → policy ou dado, quando aplicável.
5. Considerar MapLibre somente se o erro estiver na feature de mapa.
6. Implementar a menor correção capaz de resolver a causa raiz.
7. Não realizar refatorações não necessárias.
8. Adicionar ou atualizar teste de regressão quando a infraestrutura permitir.
9. Validar estados relacionados:
   - loading;
   - erro;
   - vazio;
   - sucesso;
   - usuário sem permissão;
   - ausência ou falha de assets.
10. Executar lint, typecheck, testes relacionados e build quando disponíveis.
11. Entregar resumo com causa, correção, arquivos alterados e validações.

Não corrigir falhas de autorização desabilitando RLS, usando chaves administrativas no frontend ou ampliando políticas sem necessidade.
