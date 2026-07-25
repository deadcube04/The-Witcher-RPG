---
name: build-map-feature
description: Criar, alterar ou depurar recursos do mapa interativo com MapLibre GL JS, raster tiles WebP, GeoJSON, seleção de regiões, layers, câmera, hover, clique ou overlays. Usar quando a tarefa tiver mapa, tile, região, coordenada, layer, source, zoom, pan ou interação geográfica como parte central.
---

# Implementar feature de mapa

1. Ler `src/AGENTS.md`, `src/features/map/AGENTS.md` e a arquitetura.
2. Identificar:
   - source raster envolvida;
   - source GeoJSON envolvida;
   - layers e ordem;
   - eventos;
   - estado compartilhado;
   - dados remotos associados.
3. Confirmar identificadores estáveis entre GeoJSON e PostgreSQL.
4. Manter uma única instância do mapa por montagem.
5. Registrar sources, layers e eventos no momento correto do ciclo de vida.
6. Implementar cleanup para listeners e instância.
7. Usar:
   - MapLibre para câmera e renderização;
   - Zustand para seleção ou modo compartilhado;
   - TanStack Query para detalhes remotos;
   - React state para UI local.
8. Evitar rede em `mousemove` e outros eventos de alta frequência.
9. Não armazenar a instância MapLibre ou GeoJSON grande em Zustand.
10. Validar:
    - clique;
    - hover;
    - seleção;
    - resize;
    - unmount/remount;
    - falha de tiles;
    - falha de GeoJSON;
    - mobile;
    - redução de movimento;
    - performance durante pan e zoom.
11. Confirmar `tileSize`, zooms, URL versionada, CORS e `Content-Type`.
12. Executar testes e build.
13. Relatar qualquer limitação de dados geográficos ou pipeline de tiles.
