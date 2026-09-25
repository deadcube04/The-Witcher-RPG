# Execução local

Requisitos: Go 1.26.6 ou superior na série 1.26, Bun e PostgreSQL local com o banco `rpg-manager` já restaurado. As credenciais ficam somente em `backend/.env`, ignorado pelo Git. Use `backend/.env.example` como referência; informe `DATABASE_URL`, o UUID do usuário ativo em `LOCAL_USER_ID`, `HTTP_ADDR=127.0.0.1:8080` e as origens locais permitidas em `CORS_ALLOWED_ORIGINS`. O frontend usa `frontend/.env.example` como referência: `VITE_API_MODE=real` e `VITE_API_BASE_URL=http://127.0.0.1:8080`.

No PowerShell, depois de preencher os `.env` locais:

```powershell
cd C:\rpg-project\backend
go run github.com/pressly/goose/v3/cmd/goose@v3.28.0 -dir migrations postgres $env:DATABASE_URL up
go run ./cmd/api
```

O Goose recebe `DATABASE_URL` do ambiente do processo; carregar `.env` no shell antes desse comando ou usar uma ferramenta local que exporte as variáveis. A API carrega `backend/.env` ao iniciar. Em outro terminal:

```powershell
cd C:\rpg-project\frontend
bun install
bun run dev
```

Abra a URL local apresentada pelo Vite. O MSW só é ativado quando `VITE_API_MODE=mock`; em `real`, a UI fala com a API separada. Se usar outra porta Vite, inclua sua origem em `CORS_ALLOWED_ORIGINS` e reinicie a API.

Verificação sem testes automatizados, conforme a regra do repositório:

```powershell
cd C:\rpg-project\backend
gofmt -l .
go build ./...
go vet ./...
cd C:\rpg-project\frontend
bun run typecheck
bun run lint
bun run build
```

`GET http://127.0.0.1:8080/api/ready` confirma conectividade com o banco. Não exponha a API na rede: a identidade configurada não é autenticação.
