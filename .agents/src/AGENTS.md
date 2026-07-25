# Regras do frontend

Estas regras se aplicam ao código em `src/`.

## TypeScript

- Preserve modo estrito.
- Não use `any` para contornar tipos.
- Prefira `unknown` com narrowing em fronteiras externas.
- Modele estados impossíveis como impossíveis.
- Não repita tipos gerados do Supabase manualmente.
- Valide dados externos quando a tipagem estática não for suficiente.

## Estrutura

- Organize código por feature.
- Componentes de UI genéricos não conhecem Supabase ou regras de negócio.
- Componentes de feature podem compor hooks e componentes de UI.
- Acesso a dados fica em funções ou hooks próprios.
- Query keys ficam centralizadas por domínio.
- Stores Zustand ficam próximas da feature proprietária.

## Escolha do estado

### Bom

```tsx
const campaignQuery = useQuery(campaignQueries.detail(campaignId));
const activePanel = useCampaignUiStore((state) => state.activePanel);
const [isConfirmDialogOpen, setConfirmDialogOpen] = useState(false);
```

- Query: dados remotos da campanha.
- Zustand: UI compartilhada.
- React: estado local efêmero.

### Ruim

```tsx
const campaigns = useCampaignStore((state) => state.campaigns);
const setCampaigns = useCampaignStore((state) => state.setCampaigns);

useEffect(() => {
  supabase.from('campaigns').select('*').then(({ data }) => setCampaigns(data));
}, [setCampaigns]);
```

Motivos:

- recria manualmente cache, loading e erro;
- duplica responsabilidade de TanStack Query;
- acopla o store ao transporte remoto.

## TanStack Query

- Use `useQuery` para leitura.
- Use `useMutation` para alteração.
- Use `useInfiniteQuery` para paginação incremental.
- Query functions devem lançar erros quando a operação falhar.
- Invalide a menor query key correta.
- Use atualização otimista apenas quando houver rollback seguro.
- Não dispare fetch manual em `useEffect` quando uma query representa o problema.
- Não copie query data para estado local sem necessidade de edição independente.
- Configure retry conscientemente para operações não idempotentes.

## Zustand

- Separe state e actions por tipo.
- Use selectors específicos.
- Não selecione o store inteiro em componentes.
- Não armazene objetos imperativos, elementos DOM ou respostas completas do Supabase.
- Não persista estado sensível.
- Use slices somente quando o store se tornar grande de fato.

### Bom

```ts
type CampaignUiState = {
  activePanel: 'details' | 'members' | null;
  setActivePanel: (panel: CampaignUiState['activePanel']) => void;
};

export const useCampaignUiStore = create<CampaignUiState>()((set) => ({
  activePanel: null,
  setActivePanel: (activePanel) => set({ activePanel }),
}));
```

### Ruim

```ts
export const useAppStore = create(() => ({
  currentCampaign: null,
  session: null,
  campaigns: [],
  characterSheets: [],
  modal: false,
  loading: false,
}));
```

Motivos:

- mistura domínios;
- cria cache paralelo;
- amplia rerenders e acoplamento;
- armazena recursos que exigem ciclo de vida próprio.

## Motion

- Importe de `motion/react`.
- Use Motion para elementos React.
- Prefira `transform` e `opacity`.
- Respeite redução de movimento.
- Não anime propriedades de layout caras sem necessidade.
- Não crie animações decorativas que bloqueiem interação.
- Mantenha duração e easing consistentes com o design existente.
- Use `AnimatePresence` apenas quando exit animations forem necessárias.

## MapLibre — somente para a feature de mapa

- Componentes de UI genéricos não conhecem MapLibre ou regras da feature de mapa.
- Crie a instância do mapa uma vez por montagem.
- Guarde a instância em `useRef`.
- Não armazene instâncias MapLibre em Zustand.
- Remova a instância no cleanup.
- Registre sources, layers e listeners somente quando o style estiver pronto.
- Remova listeners criados manualmente.
- Não recrie o mapa para responder a mudanças comuns de props.
- Use APIs do MapLibre para câmera e interação.
- Não use Motion para manipular a câmera ou o canvas do MapLibre.
- Não use Motion para animar o container enquanto o usuário interage com o mapa, salvo validação visual e de performance.
- Forneça nome acessível para controles do mapa.
- Evite rerenderizar toda a árvore do mapa por mudanças de UI.
- Não faça parsing de GeoJSON grande durante cada render.
- Não aplique `setData` sem mudança real dos dados.

### Bom

```tsx
const containerRef = useRef<HTMLDivElement>(null);
const mapRef = useRef<Map | null>(null);

useEffect(() => {
  if (!containerRef.current || mapRef.current) return;

  const map = new Map({
    container: containerRef.current,
    style: mapStyle,
    center: initialCenter,
    zoom: initialZoom,
  });

  mapRef.current = map;

  return () => {
    map.remove();
    mapRef.current = null;
  };
}, [initialCenter, initialZoom, mapStyle]);
```

O código real pode extrair a criação para um hook. O princípio é manter uma instância com cleanup explícito.

### Ruim

```tsx
const [map, setMap] = useState<Map>();

useEffect(() => {
  setMap(new Map({ container: 'map', style: mapStyle }));
});
```

Motivos:

- cria instâncias em múltiplos renders;
- usa state React para recurso imperativo;
- não executa cleanup.

## Supabase no frontend

- Exporte uma única instância configurada do cliente.
- Use variáveis validadas em um módulo de ambiente.
- Não espalhe `createClient` por componentes.
- Não use chave administrativa.
- Não assuma que esconder um botão é autorização.
- Trate erros retornados pelo cliente.
- Preserve a sessão gerenciada pelo SDK.

## UI e acessibilidade

- Preserve navegação por teclado.
- Elementos clicáveis devem ser controles semânticos quando aplicável.
- Não dependa apenas de cor para comunicar estado.
- Estados assíncronos devem ser perceptíveis.
- Tooltips não substituem labels obrigatórias.
- Respeite preferências de redução de movimento.

## Performance

- Memoize apenas quando houver benefício claro.
- Use imports compatíveis com tree-shaking.
- Considere lazy loading para telas e painéis pesados.
