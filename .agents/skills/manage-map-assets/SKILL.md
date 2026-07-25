---
name: manage-map-assets
description: Preparar, organizar, publicar ou migrar tiles WebP, GeoJSON e outros arquivos geoespaciais entre Supabase Storage, Cloudflare R2 e CDN. Usar para upload, versionamento, cache, CORS, caminhos de tiles, manifests, publicação ou escolha do armazenamento de assets do mapa.
---

# Gerenciar assets geoespaciais

1. Classificar o asset:
   - privado ou dependente de usuário: Supabase Storage;
   - público, volumoso e imutável: Cloudflare R2 + CDN.
2. Confirmar formato, tamanho, quantidade e padrão de acesso.
3. Para tiles:
   - usar WebP;
   - confirmar `tileSize`;
   - confirmar `minzoom` e `maxzoom`;
   - usar caminho `{mapVersion}/{z}/{x}/{y}.webp`;
   - gerar nova `mapVersion` quando o conteúdo mudar.
4. Para GeoJSON:
   - validar geometria;
   - remover propriedades sensíveis;
   - garantir IDs estáveis;
   - simplificar quando necessário.
5. Definir metadados HTTP:
   - `Content-Type`;
   - cache;
   - CORS;
   - content encoding, se aplicável.
6. Não usar `r2.dev` como endpoint de produção.
7. Não sobrescrever assets imutáveis já cacheados.
8. Não expor credenciais de upload no frontend.
9. Usar URL assinada ou serviço intermediário para uploads privados quando necessário.
10. Criar ou atualizar manifest de versão se o projeto possuir esse mecanismo.
11. Fazer smoke test com URLs reais e no MapLibre.
12. Verificar ausência de 404, erro de CORS, MIME incorreto e tiles borrados por `tileSize` divergente.
13. Informar estratégia de cache e rollback.
