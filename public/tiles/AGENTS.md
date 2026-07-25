# Regras para tiles locais

Esta pasta deve conter apenas amostras, fixtures ou assets locais pequenos.

Tiles de produção devem ser publicados em Supabase Storage ou, preferencialmente para conteúdo público volumoso, Cloudflare R2 com CDN.

## Convenções

- Use WebP.
- Preserve estrutura `{mapVersion}/{z}/{x}/{y}.webp`.
- Não substitua conteúdo publicado sob uma versão imutável.
- Documente `tileSize`, `minzoom`, `maxzoom` e sistema de coordenadas.
- Não versione no Git grandes conjuntos de tiles gerados.
- Não inclua chaves, tokens ou URLs assinadas permanentes.
- Fixtures devem ser pequenas e suficientes para testes.
