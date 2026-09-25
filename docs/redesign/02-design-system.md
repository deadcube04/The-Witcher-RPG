# Design system

## Tipografia

- Interface e controles: **Geist**, peso variável, alta legibilidade.
- Títulos editoriais: **Newsreader**, usada apenas em mastheads, destaques e nomes de registros.
- Metadados: **IBM Plex Mono**, para códigos, índices, sistemas e estados.
- Fontes servidas localmente em WOFF2 com `font-display: swap`.
- Corpo mínimo de 14px; textos longos com largura máxima aproximada de 65 caracteres.

## Cores e temas

Cada tema expõe tokens semânticos, não estilos de página prontos:

- `canvas`: fundo estrutural.
- `surface`: painéis operacionais.
- `surfaceRaised`: destaques e overlays.
- `ink`: texto principal.
- `muted`: texto secundário.
- `accent`: única cor de ênfase do tema.
- `edge`: separadores de baixa ênfase.
- `danger`, `success` e `focus`: estados funcionais com contraste verificável.
- `shadow`, `scrim` e `grain`: profundidade e mídia.

Arquivo, Sangue, Morte, Conhecimento, Energia e Medo compartilham estrutura, raios e componentes. Variam paleta, fotografia, textura e ritmo de movimento sem alterar a posição de ações essenciais.

## Forma e materialidade

- Painéis operacionais: raio de 16px.
- Molduras editoriais e mídia: raio de 24px com bezel externo discreto.
- Botões principais e filtros compactos: formato pill.
- Separadores substituem cartões quando não há elevação semântica.
- Sombras são difusas e tingidas pelo canvas; sombras pretas duras são proibidas.
- Textura de grão é fixa, muito sutil e sem eventos de ponteiro.

## Componentes

- **EditorialFeature:** item protagonista com mídia, scrim, metadados e CTA.
- **DossierRow:** registro escaneável para coleções densas.
- **UtilityPanel:** área operacional para formulário, filtros e dados.
- **MediaFrame:** imagem responsiva com fallback, scrim e legenda acessível.
- **PageMasthead:** cabeçalho contextual com variantes editorial e operacional.
- **ContextToolbar:** filtros e ações da coleção.
- **RpgButton/Input/Select/Modal:** continuam encapsulando Ant Design.

## Fotografia

- Linguagem: documental cinematográfica, sem logotipos, texto incorporado ou símbolos copiados de franquias.
- Assuntos: arquivos, corredores vazios, mesas de evidência, florestas, ruínas e objetos anômalos.
- Composição: espaço negativo planejado para sobreposição de conteúdo.
- Entrega: AVIF ou WebP responsivo; hero prioritário, demais imagens com lazy loading.
- Nenhuma informação ou ação depende exclusivamente da imagem.

## Iconografia

Usar uma única família Phosphor Light via `react-icons/pi`. Ícones recebem rótulo acessível quando representam ações e ficam ocultos de tecnologia assistiva quando decorativos.

## Regras anti-template

- Não usar grids de três cartões iguais como composição padrão.
- Não usar glassmorphism em painéis de rolagem.
- Não usar gradientes roxo-azuis genéricos.
- Não misturar múltiplas cores de acento na mesma página.
- Não usar decoração paranormal em inputs, tabelas ou feedback destrutivo.
- Não animar elementos apenas para preencher espaço.
