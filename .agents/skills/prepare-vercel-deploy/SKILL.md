---
name: prepare-vercel-deploy
description: Preparar, revisar ou corrigir o deploy do frontend React e Vite na Vercel. Usar para build de produção, preview, variáveis de ambiente, rotas SPA, erros 404, configuração de domínio, integração com Supabase ou assets.
---

# Preparar deploy na Vercel

1. Ler scripts de build e configuração do Vite.
2. Executar build de produção local.
3. Auditar variáveis:
   - somente valores públicos usam `VITE_*`;
   - nenhuma chave administrativa ou segredo é incluído;
   - URLs de Supabase apontam para o ambiente correto.
4. Verificar se o roteamento da SPA exige rewrite para `index.html`.
5. Confirmar base path e caminhos de assets gerais.
6. Confirmar que o frontend não depende de arquivos locais ausentes no deploy.
7. Verificar CORS entre domínio da Vercel e Supabase quando a integração exigir.
8. Quando a versão incluir ou alterar a feature de mapa, verificar URLs de tiles, CORS com CDN, headers, disponibilidade dos tiles e smoke test do MapLibre.
9. Validar autenticação após refresh e navegação direta.
10. Executar smoke test das rotas e do fluxo alterado, incluindo fichas, campanhas ou sessões quando estiverem no escopo.
11. Não promover preview para produção sem verificar ambiente e dados alvo.
12. Relatar variáveis necessárias sem revelar valores secretos.
