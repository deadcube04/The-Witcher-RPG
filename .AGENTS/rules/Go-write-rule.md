# Go Write Rule

## Gatilho e principio

Esta rule e obrigatoria sempre que a tarefa receber, analisar, revisar, explicar, gerar ou alterar codigo Go, Gin ou GORM. Leia-a antes do primeiro trecho de codigo.

Escreva Go idiomatico, simples, explicito e verificavel. Use Gin apenas na camada HTTP e GORM apenas na camada de persistencia. Prazo, benchmark, codigo legado, autoridade ou trabalho ja realizado nao autorizam ignorar erros, misturar camadas, vazar detalhes internos, abrir SQL injection ou perder atomicidade.

## Go idiomatico

- Formate com `gofmt` e organize imports com `goimports`. Siga os nomes e a estrutura ja existentes; evite packages genericos como `util`, stuttering e abstracoes prematuras.
- Mantenha funcoes pequenas e fluxo claro. Retorne cedo em erros; nao use `panic` para erros esperados nem `log.Fatal` fora de `main`.
- Nunca ignore erros. Adicione contexto com `%w` e classifique com `errors.Is`/`errors.As`; nao compare texto de erro.
- Passe `context.Context` como primeiro parametro nas fronteiras de request/I/O. Nao armazene context em structs e nao substitua o contexto da request por `context.Background()`.
- Interfaces devem ser pequenas e definidas pelo consumidor. Injete dependencias explicitamente; evite globals, service locator e singletons mutaveis.
- O dono de uma goroutine tambem e responsavel por cancelamento, limite, erros e encerramento. Nao inicie trabalho solto em handlers.
- Proteja estado concorrente, documente ownership e execute testes relevantes com `-race`.

## Arquitetura obrigatoria

Use a direcao `transport/Gin -> service/use case -> repository/GORM -> database`.

- Handler: decodifica e valida DTO, extrai identidade/parametros, chama um use case e traduz resultado em HTTP.
- Service/use case: contem regras de negocio e fronteiras transacionais; nao depende de `*gin.Context`.
- Repository: encapsula queries GORM e retorna erros de dominio/infraestrutura; nao conhece respostas HTTP.
- Separe DTOs HTTP, entidades de dominio e models GORM quando suas responsabilidades divergirem. Nunca serialize um model de persistencia por conveniencia se isso expuser campos internos.
- Dependencies entram por construtores. `main` compoe configuracao, logger, DB, repositories, services, handlers e lifecycle.

## Gin

- Em producao use release mode e `gin.New()` com middlewares escolhidos explicitamente: recovery, logging estruturado, request ID, autenticacao/autorizacao, limites e metricas/tracing aplicaveis.
- Agrupe rotas versionadas e registre-as por feature. Nao coloque regra de negocio ou acesso direto ao GORM no handler.
- Use `ShouldBind*` com DTOs e tags de validacao; limite body antes do bind. No startup, habilite `gin.EnableJsonDecoderDisallowUnknownFields()` (ou use decoder estrito equivalente) para rejeitar campos desconhecidos, alem de campos/tipos invalidos.
- Respostas de erro possuem envelope e codigos estaveis. Registre a causa no servidor, mas nunca retorne `err.Error()`, SQL, stack, credenciais ou detalhes internos ao cliente.
- Configure CORS por allowlist, `TrustedProxies` com IPs/CIDRs conhecidos, timeouts do `http.Server`, limites de request, TLS no boundary correto e graceful shutdown com `signal.NotifyContext`.
- Propague `c.Request.Context()` para services e DB. Defina timeouts onde ha I/O e respeite cancelamento.

## GORM

- Injete `*gorm.DB`; nao use DB global. Em cada request/query use `db.WithContext(ctx)` ou a API generics com context.
- Verifique sempre `Error` e, quando a semantica exigir, `RowsAffected`. Trate `gorm.ErrRecordNotFound` com `errors.Is`; habilite `TranslateError` quando erros portaveis de constraint forem uteis.
- Use transacao para toda unidade de negocio com multiplas escritas. Todas as operacoes internas devem usar o `tx` recebido; qualquer erro deve provocar rollback.
- Prefira `Create`, `Updates`, `Update` e selecao explicita de campos. Evite `Save`, updates globais e comportamento ambiguo com zero values.
- Parametrize valores com placeholders. Nunca use `fmt.Sprintf` com entrada externa em SQL. Campos de `Order`, `Select`, `Group`, `Table`, `Joins` e similares vindos do cliente devem passar por allowlist fechada.
- Converta e valide IDs antes da query. Nao passe primary keys textuais nao confiaveis diretamente ao GORM.
- Carregue apenas associacoes necessarias com `Preload`/`Joins` explicitos; evite N+1 e `clause.Associations` indiscriminado.
- Nao execute `AutoMigrate` automaticamente no startup de producao. Use migrations versionadas, revisadas, observaveis e executadas como etapa de deploy.
- Configure o pool via `sql.DB` (`MaxOpenConns`, `MaxIdleConns`, lifetimes) conforme banco/carga, e feche-o no shutdown.

## Exemplo de fronteira

```go
type Creator interface {
	Create(ctx context.Context, input CreateUserInput) (User, error)
}

type UserHandler struct {
	creator Creator
}

func (h UserHandler) Create(c *gin.Context) {
	var req createUserRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		writeAPIError(c, http.StatusBadRequest, "invalid_request")
		return
	}

	user, err := h.creator.Create(c.Request.Context(), req.toInput())
	if err != nil {
		writeDomainError(c, err)
		return
	}

	c.JSON(http.StatusCreated, newUserResponse(user))
}
```

O handler depende de uma interface pequena definida pelo consumidor; validacao, dominio, persistencia e HTTP permanecem separados.

## Verificacao antes de concluir

- Rode `gofmt`, `goimports`, `go vet ./...`, `staticcheck ./...`, `govulncheck ./...` e `go test ./...`; inclua `go test -race ./...` quando houver concorrencia. Se uma ferramenta nao estiver instalada, instale-a quando autorizado ou reporte o bloqueio; nunca declare a verificacao limpa sem executa-la. Falhas de testes, analise estatica ou vulnerabilidades aplicaveis nao resolvidas bloqueiam a conclusao.
- Teste handlers com `httptest`, services por comportamento e repositories com integracao no mesmo banco/dialeto de producao quando a semantica SQL importar.
- Cubra sucesso, validacao, campo JSON desconhecido, not found, conflito/constraint, falha interna sem vazamento, timeout/cancelamento e rollback. Teste autorizacao na fronteira adequada.
- Verifique graceful shutdown, logs estruturados sem segredos e migrations separadas do startup.

## Racionalizacoes proibidas e red flags

| Desculpa | Regra |
| --- | --- |
| "E mais rapido consultar o DB no handler" | Mantenha handler, service e repository separados. |
| "GORM escapa tudo" | Metodos com fragmentos SQL e nomes de coluna exigem placeholders ou allowlist. |
| "Sao apenas tres writes" | Uma unidade de negocio usa uma transacao unica. |
| "O proxy protege a API" | Gin ainda exige proxies confiaveis, limites, timeouts e CORS explicito. |
| "Logar/retornar o erro ajuda a depurar" | Logue internamente com contexto e devolva erro publico estavel. |

Pare e corrija se encontrar erro ignorado, global DB, `*gin.Context` fora do transport, `err.Error()` em resposta, SQL interpolado, goroutine sem lifecycle, multiplas escritas sem transacao, `AutoMigrate` em producao ou servidor sem graceful shutdown.
