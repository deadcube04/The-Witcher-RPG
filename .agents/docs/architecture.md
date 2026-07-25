# Arquitetura da plataforma

## Visão geral

A plataforma é uma SPA em React e TypeScript, construída com Vite e publicada
na Vercel. Ela gerencia fichas de personagens, campanhas e sessões de RPG.

React, Vite e TypeScript compõem a base do frontend; Supabase fornece dados e
identidade; e Vercel publica a aplicação completa. A feature de mapa é
complementar e especializada, sendo usada apenas quando houver necessidade
geoespacial.

O Supabase fornece:

- PostgreSQL;
- autenticação;
- Data API;
- Row Level Security;
- Storage para arquivos que dependam de identidade e autorização.

Para arquivos privados ou controlados por autenticação, use Supabase Storage.
Arquivos de fichas e campanhas são exemplos desse uso.

## Fluxos principais

### Leitura de dados

```text
Componente React
    ↓
Hook de TanStack Query
    ↓
Função de acesso a dados
    ↓
Cliente Supabase
    ↓
PostgREST + sessão do usuário
    ↓
PostgreSQL + RLS
```

### Mutation

```text
Ação do usuário
    ↓
useMutation
    ↓
Cliente Supabase
    ↓
RLS valida a operação
    ↓
Sucesso
    ↓
Atualização otimista ou invalidação de query
```

## Arquitetura especializada do mapa (quando aplicável)

Quando uma campanha ou sessão exigir contexto geoespacial, a feature de mapa
usa MapLibre GL JS para renderização e interação.

### Renderização do mapa

```text
MapLibre
    ├── raster source → CDN → tiles WebP
    └── GeoJSON source → regiões e interações
```

O raster representa a aparência visual do mapa. O GeoJSON representa limites e regiões interativas.

## Responsabilidades das bibliotecas

### React

- composição da interface;
- ciclo de vida;
- estado local;
- acessibilidade.

### TanStack Query

- estado remoto;
- cache;
- paginação e infinite queries;
- mutations;
- retries;
- invalidação.

### Zustand

- estado compartilhado exclusivamente do cliente;
- filtros compartilhados, painel ou modal aberto, preferências locais e modo
  de interação de uma feature;
- UI transversal.

### Motion

- animações da interface React;
- transições de painéis, cards, modais e feedback visual;
- respeito a `prefers-reduced-motion`.

### MapLibre GL JS (quando a feature de mapa estiver em uso)

Motion não deve controlar a câmera ou o canvas interno do MapLibre.

- instância e ciclo de vida do mapa;
- fontes raster e GeoJSON;
- layers;
- câmera;
- eventos geográficos;
- consulta de features renderizadas.

## Organização sugerida

```text
src/
├── app/
│   ├── providers/
│   ├── router/
│   └── styles/
├── components/
│   └── ui/
├── features/
│   ├── auth/
│   ├── characters/
│   ├── campaigns/
│   ├── sessions/
│   ├── map/
│   │   ├── api/
│   │   ├── components/
│   │   ├── hooks/
│   │   ├── layers/
│   │   ├── stores/
│   │   ├── types/
│   │   └── utils/
├── lib/
│   ├── query/
│   ├── supabase/
│   └── env/
└── types/

supabase/
├── migrations/
├── seed.sql
└── AGENTS.md

public/
└── static/
```

Quando a feature de mapa estiver em uso, tiles de produção não devem ser
mantidos em `public/` quando forem distribuídos por R2/CDN.

## Decisão de armazenamento

### Supabase Storage

Use quando:

- o arquivo pertence a um usuário;
- o acesso depende da sessão;
- políticas RLS são relevantes;
- o arquivo é enviado ou removido pela aplicação;
- URLs assinadas são necessárias.

Exemplos:

- avatar;
- anexo privado;
- imagem enviada por usuário;
- arquivo privado de ficha;
- arquivo de campanha não público.

### Cloudflare R2 para a feature de mapa (quando aplicável)

Use quando:

- o arquivo é público;
- há grande volume de objetos;
- o conteúdo é distribuído por CDN;
- o arquivo é gerado por pipeline;
- cache longo e imutável é desejado.

Exemplos:

- tiles rasterizados;
- versões públicas de mapas;
- bundles geoespaciais grandes;
- imagens estáticas versionadas.

## Convenções da feature de mapa (quando aplicável)

### Tiles

Formato recomendado:

```text
https://tiles.example.com/maps/{mapVersion}/{z}/{x}/{y}.webp
```

Regras:

- `mapVersion` deve mudar quando os tiles mudarem.
- `tileSize`, `minzoom` e `maxzoom` devem corresponder ao pipeline de geração.
- O servidor deve responder com `Content-Type: image/webp`.
- Versões imutáveis podem receber cache longo.
- Não altere o conteúdo de uma URL versionada já publicada.

### GeoJSON

Cada feature clicável deve possuir identificador estável:

```json
{
  "type": "Feature",
  "id": "region-kaer-morhen",
  "properties": {
    "slug": "kaer-morhen",
    "name": "Kaer Morhen"
  },
  "geometry": {}
}
```

Regras:

- Coordenadas seguem `[longitude, latitude]`.
- Identificadores não dependem do nome exibido.
- Dados de domínio completos ficam no PostgreSQL.
- O GeoJSON deve carregar apenas o necessário para renderização e associação.
- GeoJSON muito grande deve ser simplificado, dividido ou convertido para tiles vetoriais.

## Consultas e cache

Query keys devem ser centralizadas por domínio, como fichas, campanhas e
sessões, e refletir os filtros estáveis de cada consulta.

Não inclua objetos instáveis ou funções em query keys.

## Autorização

RLS é a fronteira final de autorização.

Cada migration que cria uma tabela acessível pelo cliente deve incluir:

1. privilégios necessários;
2. `enable row level security`;
3. políticas de `select`, `insert`, `update` e `delete`, conforme aplicável;
4. índices necessários para colunas usadas nas políticas;
5. testes ou consultas de validação.

## Deploy

### Vercel

- Build do Vite gera arquivos estáticos.
- Variáveis públicas usam prefixo `VITE_`.
- Rotas de SPA precisam de fallback adequado quando houver roteamento no cliente.
- Preview e produção devem apontar para ambientes conscientemente escolhidos.
- O frontend não contém segredos.

### Supabase

- Mudanças de schema são versionadas em migrations.
- Tipos TypeScript são regenerados após mudança de schema.
- Políticas são testadas com usuários e papéis representativos.

### CDN/R2 para a feature de mapa (quando aplicável)

- Produção usa domínio próprio.
- CORS é restrito.
- Tiles recebem headers coerentes com versionamento.
- Invalidação de cache não substitui versionamento de assets.
