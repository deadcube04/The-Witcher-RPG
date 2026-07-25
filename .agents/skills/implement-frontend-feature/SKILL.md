---
name: implement-frontend-feature
description: Implementar ou alterar funcionalidades de interface em React, Vite e TypeScript usando TanStack Query, Zustand e Motion. Usar para telas e fluxos de fichas, campanhas, sessões, componentes, formulários, painéis, listas, filtros e animações que não sejam principalmente geoespaciais.
---

# Implementar feature de frontend

1. Ler os requisitos e identificar critérios de aceite.
2. Localizar a feature existente, seus padrões e os contratos de ficha, campanha ou sessão envolvidos, quando aplicável.
3. Direcionar mudanças principalmente geoespaciais para `build-map-feature`.
4. Classificar cada estado antes de implementar:
   - remoto: TanStack Query;
   - global do cliente: Zustand;
   - local e efêmero: React state.
5. Reutilizar query keys, hooks, componentes e tokens existentes.
6. Modelar tipos de entrada, saída, loading, erro e estado vazio.
7. Manter acesso a dados fora de componentes puramente visuais.
8. Usar Motion somente quando a animação melhorar hierarquia, feedback ou transição.
9. Respeitar redução de movimento e acessibilidade.
10. Não criar store global para estado local.
11. Não duplicar query data em Zustand.
12. Não adicionar dependência para resolver algo já suportado pela stack.
13. Testar o comportamento principal e casos de borda.
14. Executar lint, typecheck, testes relacionados e build.
15. Informar decisões de estado e cache na conclusão.
