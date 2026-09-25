# Migrações e preservação dos dados

O dump de referência é `dumps/rpg-manager-backup-shema.sql`. Antes das alterações desta implementação foi criado um backup customizado em `local/backups/rpg-manager-before-backend.dump`, com inventário validado por `pg_restore -l`; `local/` está ignorado pelo Git. O backup contém dados, ao contrário do arquivo de schema de referência. Guarde uma cópia externa antes de operações destrutivas.

As migrações são SQL versionado em `backend/migrations`:

1. `202609250001_backend_foundation.sql`: campanhas, vínculo opcional da ficha, ajustes de recurso, atributo de perícia, metadados de entradas, proprietário de homebrew, níveis de ritual e definições de ataque; inclui The Witcher em preview e ajuste de username.
2. `202609250002_official_attacks.sql`: deriva 36 definições de ataque das armas oficiais existentes.
3. `202609250003_local_import.sql`: mapa de importação idempotente por usuário, tipo e ID local.

Não rode migrações na inicialização da API. Após carregar `DATABASE_URL` no PowerShell:

```powershell
cd C:\rpg-project\backend
go run github.com/pressly/goose/v3/cmd/goose@v3.28.0 -dir migrations postgres $env:DATABASE_URL status
go run github.com/pressly/goose/v3/cmd/goose@v3.28.0 -dir migrations postgres $env:DATABASE_URL up
```

Para criar outro backup antes de uma futura migração, use `pg_dump --format=custom --file=<destino.dump> --dbname=<URL local>` e valide com `pg_restore -l <destino.dump>`. Evite colocar URLs com senha em histórico de shell ou documentação. O procedimento de restauração deve usar um banco de destino separado e ser planejado conforme o estado que se deseja recuperar. As tabelas oficiais e as 67 ameaças preexistentes não foram substituídas por seed.
