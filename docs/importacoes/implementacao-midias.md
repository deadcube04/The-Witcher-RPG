# Mídias locais e importação do bestiário

## Resultado da execução em 27/09/2026

MinIO em execução, bucket rpg-media provisionado. Foram coletadas 149 entradas do índice completo, incluindo não canônicas, com 149 imagens identificadas por nome. A revisão confirmou 49 correspondências, 89 criaturas ausentes e 11 entradas duplicadas/aliases. O banco continua com 67 ameaças; 49 receberam somente foto e descrição anteriormente vazias. Nenhuma ameaça foi criada. Estatísticas, VD, ataques e referências do livro foram preservados.

Os Jacarés paranormais do Bioparque foram mantidos separados do Jacaré comum por decisão explícita do usuário. As evidências de todas as decisões, fontes, canonicidade e SHA-256 estão no manifesto.

- Relatório: [criaturas ausentes](bestiario-criaturas-ausentes.md).
- Problemas de coleta: [pendências](bestiario-pendencias.md); nenhuma pendência nesta execução.
- Backup final: [ZIP com 149 imagens, manifesto e 49 valores anteriores](../../local/backups/bestiario-20260927-034945.487.zip), 65.193.282 bytes.
- Manifesto de trabalho: local/bestiary-import/manifest.json.
- HTML de origem: local/bestiary-import/sources/ e index.html.

## Configuração

As variáveis estão descritas em backend/.env.example e frontend/.env.example. As credenciais reais ficam no backend/.env ignorado pelo Git; nunca use VITE_* para segredos. Configure DATABASE_URL, LOCAL_USER_ID e as variáveis S3. S3_PUBLIC_URL inclui o bucket; VITE_MEDIA_PUBLIC_URL deve apontar para a mesma URL pública. A configuração local usa http://127.0.0.1:9000/rpg-media.

Na raiz do repositório, com Docker Desktop ativo:

~~~powershell
docker compose --env-file backend/.env up -d --build
~~~

Nesta máquina, a rede exige certificados públicos de confiança já existentes no Windows. Eles foram exportados para local/build-ca.pem, ignorado pelo Git. O overlay local passa esse arquivo como segredo de build, sem desabilitar TLS:

~~~powershell
docker compose --env-file backend/.env -f compose.yaml -f local/build-ca.compose.yaml up -d --build
~~~

O serviço media-init termina com código zero após criar o bucket e conceder apenas GetObject anônimo. Listagem e escrita requerem credenciais. As portas 9000 e 9001 estão vinculadas a 127.0.0.1; o console está em http://127.0.0.1:9001. Os dados persistem no volume rpg-media_minio-data. Não remova o volume para reiniciar serviços.

A imagem é compilada do [código oficial do MinIO](https://github.com/minio/minio), revisão fixa 7aac2a2c5b7c882e68c1ce017d8256be2feea27f. O backend usa AWS SDK for Go v2 com endpoint e endereçamento por caminho. Para iniciar a aplicação, execute go run ./cmd/api dentro de backend e bun run dev dentro de frontend. A API desta execução foi iniciada com local/media-api.exe, com logs em local/media-api.log e local/media-api.err.

## Fotos de perfil e personagem

Escolher foto abre recorte quadrado com arraste e controles numéricos de posição e zoom acessíveis por teclado. O recorte é exportado como PNG de no máximo 1024 × 1024. JPEG, PNG e WebP estáticos são aceitos até 10 MiB e 25 megapixels. Cancelar ou falhar no envio conserva a foto anterior. Remover limpa a associação; o objeto imutável permanece no armazenamento.

POST /api/v1/media/images recebe multipart com file e purpose (profile ou character), valida conteúdo real e retorna imageUrl somente após gravar no MinIO. O perfil salva avatarUrl; personagens salvam imageUrl, inclusive pelo autosave existente. A associação valida o usuário local, a finalidade e a existência do objeto. O JSON conserva limite de 1 MiB; multipart tem limite próprio e não é registrado como corpo nos logs. URLs são permanentes, sem assinatura expiráveis. A interface mantém HTTPS e permite HTTP apenas na origem/caminho local configurados.

## Repetir coleta, revisão e aplicação

Execute os comandos dentro de backend. Todos consultam o PostgreSQL atual; dumps não são fonte de correspondência.

~~~powershell
go run ./cmd/bestiary-import -mode collect
go run ./cmd/bestiary-import -mode review -entry 'URL exata da página' -decision match -id 'UUID existente' -description 'Resumo conferido na fonte, com pelo menos 30 caracteres.' -evidence 'Evidência de identidade conferida no catálogo e na fonte.'
go run ./cmd/bestiary-import -mode apply
go run ./cmd/bestiary-import -mode report
~~~

review também aceita absent ou skip, sem -id. Nome ambíguo exige URL exata. Use skip para duplicatas, registrando sua equivalência na evidência. Similaridade textual só propõe candidatos; não confirma associação. Decisões ambíguas devem ser apresentadas ao responsável individualmente. Um erro de acesso ou imagem não comprova ausência.

collect lê apenas HTML e arquivos de imagem, sem API do Fandom. Retoma fontes e imagens já baixadas no diretório de trabalho. Para uma coleta nova da wiki, use -dir ../local/bestiary-import-NOVA em todos os comandos seguintes; ela exige nova revisão. A coleta distingue variantes que compartilham artigo e registra URLs canônicas. Imagens dos cards são preferidas para preservar a variante correta.

apply envia todas as imagens válidas, inclusive das criaturas ausentes, usando chaves por hash. Aplica apenas entradas revisadas como match, permitindo trabalhar enquanto outras ficam pendentes. Revalida o catálogo, trava cada linha e preenche somente campos ainda vazios em uma transação. Repetir não cria monstros nem sobrescreve dados preenchidos. Objetos com conteúdo igual reutilizam a mesma chave. O manifesto registra decisões e resultados; os arquivos before/ conservam os valores anteriores à primeira atualização. report recria Markdown e ZIP consultando o catálogo atual.

## Recuperação

Guarde o ZIP final fora desta máquina se desejar outra cópia. Ele contém images/, manifest.json e before/. Os ZIPs com sufixo incompleto são registros intermediários e não substituem o final.

Para recuperar imagens após perder o volume, provisione novamente o bucket, extraia o ZIP para um diretório local e execute apply usando -dir nesse diretório. Os hashes regeneram as mesmas chaves e URLs se S3_PUBLIC_URL for mantida. Essa operação preserva campos preenchidos no banco.

Para desfazer o enriquecimento, consulte before/<UUID>.json e compare o valor atual com o manifesto antes de restaurar description e image_url em transação PostgreSQL. Preserve edições posteriores; não há restauração destrutiva automática. Para restaurar somente os arquivos, um cliente S3 pode reenviar images/ para bestiary/<SHA-256>.<extensão>, conforme o manifesto. O ZIP não inclui credenciais.

## Validação registrada

- go build ./... e go vet ./... concluídos; gofmt/goimports aplicados.
- Typecheck, ESLint e build Vite concluídos. Há aviso de chunk existente de aproximadamente 825 KB em RpgControls.
- govulncheck: zero vulnerabilidades alcançáveis e zero em pacotes importados; três avisos em módulos requeridos sem chamadas afetadas.
- staticcheck encontrou duas sugestões S1016 preexistentes em backend/internal/observability/repository.go:228 e :276. A execução não foi declarada limpa.
- bun audit --json retornou {} usando NODE_EXTRA_CA_CERTS apontando para o certificado público local. Dependências verificadas: React 19.2.8, Ant Design 6.6.1, Zod 4.4.3, Motion 13.1.1, TanStack Query 5.102.0 e Form 1.33.5; consulta ao endpoint oficial de advisories do npm também retornou sem alertas.
- Conferência manual por HTTP: upload real, leitura pública de imagem, associação persistida em perfil e personagem e remoção/restauração dos valores anteriores. Indisponibilidade do MinIO devolveu falha sem mudar avatar; serviço reiniciado em seguida.
- Repetição da importação: 67 ameaças, 49 fotos e descrições, zero diferenças no retorno do bestiário após repetir apply. Há 49 arquivos com valores anteriores.
- ZIP aberto e todas as 149 imagens comparadas ao SHA-256 do manifesto: zero divergências; 49 backups before/ presentes.
- Revisão independente do código concluída; incorporada a inclusão dos valores anteriores no ZIP e preservado o estado do manifesto em rollback.
- Não foram criados nem executados testes automatizados. A ferramenta de navegador desta sessão não disponibilizou superfície utilizável: recorte visual, teclado, responsividade e autosave interativo permanecem sem conferência manual no navegador, embora implementação, tipos e fluxo tenham sido revisados.

O importador legado de dados locais não migra fotos; nenhuma foto legada existia conforme informado. O fluxo novo de mídia e a importação do bestiário são independentes dele.
