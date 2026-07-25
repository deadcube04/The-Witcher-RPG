# Regras da feature de mapa

Estas regras se aplicam à implementação do mapa interativo.

## Separação de fontes

- Tiles raster WebP fornecem a imagem base.
- GeoJSON fornece regiões, limites e alvos de interação.
- Dados de negócio completos vêm do Supabase por identificador estável.
- Não codifique regras de negócio dentro das properties do GeoJSON.

## Raster tiles

Configure explicitamente:

- URL template;
- `tileSize`;
- `minzoom`;
- `maxzoom`;
- attribution quando necessária.

`tileSize` deve corresponder ao tamanho gerado pelo pipeline.

Exemplo:

```ts
map.addSource('world-raster', {
  type: 'raster',
  tiles: [`${env.VITE_TILE_BASE_URL}/maps/${mapVersion}/{z}/{x}/{y}.webp`],
  tileSize: 256,
  minzoom: 0,
  maxzoom: 6,
});
```

Não fixe URL de produção diretamente em componentes.

## GeoJSON

- Use `FeatureCollection` tipada.
- Cada feature deve possuir `id` ou `properties.slug` estável.
- Coordenadas usam `[longitude, latitude]`.
- Valide geometria gerada por ferramentas externas.
- Simplifique geometrias quando a precisão exceder a necessidade visual.
- Não carregue atributos sensíveis no GeoJSON público.
- Não armazene GeoJSON grande em Zustand.

## Layers

- IDs de source e layer devem ser constantes.
- Adicione sources antes das layers.
- Verifique existência antes de adicionar ou remover.
- Organize a ordem das layers conscientemente.
- Separe fill, outline, hover e selection quando isso tornar o estilo mais previsível.
- Não recrie layers em cada render React.

## Interação

- Restrinja eventos à layer interativa.
- Atualize cursor no hover quando apropriado.
- Remova listeners no cleanup.
- Não faça uma consulta remota por cada evento `mousemove`.
- Clique seleciona a região por identificador; detalhes remotos são carregados por TanStack Query.
- Hover não deve substituir seleção persistente.
- Teclado e alternativas fora do mapa devem existir para ações essenciais.

### Bom

```ts
const onRegionClick = (event: MapLayerMouseEvent) => {
  const feature = event.features?.[0];
  const regionId = getRegionId(feature);

  if (regionId) {
    selectRegion(regionId);
  }
};

map.on('click', REGION_FILL_LAYER_ID, onRegionClick);

return () => {
  map.off('click', REGION_FILL_LAYER_ID, onRegionClick);
};
```

### Ruim

```ts
map.on('mousemove', async (event) => {
  const region = await fetchRegion(event.lngLat);
  setGlobalRegion(region);
});
```

Motivos:

- executa rede em evento de alta frequência;
- não limita o evento a uma layer;
- mistura hover, seleção e estado remoto;
- não demonstra cleanup.

## Estado do mapa

- Instância: `useRef`.
- Região selecionada: Zustand quando compartilhada.
- Dados da região: TanStack Query.
- Tooltip local: React state.
- Câmera: MapLibre; sincronize com Zustand apenas se outra parte da aplicação realmente consumir ou restaurar esse valor.
- Não sincronize cada frame de movimento da câmera com React.

## Atualização de dados

- Para GeoJSON pequeno e dinâmico, use `GeoJSONSource#setData`.
- Não chame `setData` se a referência semântica não mudou.
- Para conjuntos grandes, avalie simplificação, divisão ou tiles vetoriais.
- Não converta tiles raster para base64 no frontend.

## Performance e UX

- Mantenha interações fluidas durante pan e zoom.
- Evite overlays React em grande quantidade acompanhando features.
- Prefira layers do MapLibre para centenas ou milhares de elementos.
- Use markers DOM somente em quantidades controladas.
- Exiba fallback e mensagem de erro quando style, tiles ou GeoJSON falharem.
- Teste diferentes densidades de pixel e tamanhos de viewport.
