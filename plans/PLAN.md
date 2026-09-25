# Backend e integração local do RPG Manager

## Resumo

Implementar a API Go para todas as telas atuais e integrar o frontend ao PostgreSQL. A entrega usa o schema existente como base, preserva seus dados e completa apenas o que os contratos da interface exigem. Ordem Paranormal 1.1 terá campanhas, fichas, conteúdo e cálculos de ficha; D&D e The Witcher permanecerão em preview.

## Implementação

1. **Base e banco:** reorganizar o backend por domínio em `cmd/api` e `internal`, na direção Gin → serviço → repositório GORM → PostgreSQL. Configurar a identidade pelo usuário ativo existente, `DATABASE_URL` e `LOCAL_USER_ID` em `.env` ignorado pelo Git, exemplos sem segredo, pool de conexões, logs estruturados, limites HTTP, encerramento gracioso e API vinculada a `127.0.0.1`. Usar CORS com lista exata das origens locais e validar `Origin` e `Host`. A estrutura segue a documentação consultada via Context7 para [Gin](https://github.com/gin-gonic/gin/blob/master/docs/doc.md), [GORM](https://gorm.io/docs/context.html) e [CORS](https://github.com/gin-contrib/cors/blob/master/README.md).

2. **Migrações:** fazer backup do banco antes da primeira mudança e aplicar SQL versionado com [Goose v3.28.0](https://github.com/pressly/goose/releases/tag/v3.28.0), em etapa separada da inicialização da API. Criar campanhas e vínculo com fichas; extensões para ajustes de recursos, atributo escolhido por perícia, origem e propriedade de homebrew, detalhes de rituais e definições de ataques; acrescentar IDs e datas às entradas que hoje não os possuem. Preservar as 67 ameaças e todos os catálogos existentes. Adicionar The Witcher como preview e alinhar a restrição de username ao formulário atual.

3. **API orientada ao frontend:** implementar os métodos e caminhos já consumidos em `frontend/src/shared/api/domains.ts`: perfil, preferências, sistemas, campanhas, fichas, catálogos de Ordem, homebrew e entradas de inventário, rituais e ataques. Acrescentar `/api/v1/ordem/character-options`, `GET/PUT /api/v1/character-sheets/:id/skills` e prévia/aplicação da importação local. Manter respostas JSON diretas, `DELETE` com 204 e `{error:{code,message}}` com os códigos existentes. Validar JSON estritamente, IDs, propriedade, sistema e referências; agrupar escritas relacionadas em transações. Excluir campanha desvincula fichas; homebrew em uso retorna conflito; remoção de inventário ligado a ataque exige `detach` ou `remove`.

4. **Regras de Ordem 1.1:** exigir classe e NEX presente nas regras do banco. Calcular PV, PE e SAN a partir de classe, atributos e etapas de NEX, além do limite de PE. Cada máximo aceita ajuste `+/-`; a ficha nasce com recursos cheios, aumentos somam a diferença ao valor atual e reduções o limitam ao novo máximo. Expor as 28 perícias do banco, persistir treino, atributo escolhido e outros bônus, e calcular bônus e teste. Atributo positivo usa essa quantidade de d20 e escolhe o maior; atributo zero usa 2d20 e escolhe o menor. Derivar ataques oficiais das armas e calcular seu teste pela perícia da ficha; ataques homebrew novos escolhem uma perícia do catálogo. As rolagens continuam no cliente.

5. **Integração e importação:** configurar `VITE_API_BASE_URL` para a API local e um modo explícito para MSW, mantendo frontend e backend em processos separados. Persistir a edição inline e suas perícias com salvamento sequencial, indicador de erro real e atualização do cache. Trocar IDs fixos de classe e origem pelas opções do banco; impedir criação de campanhas e fichas nos sistemas preview. Adaptar contratos e telas para mostrar campos oficiais ausentes sem inventar efeitos de rituais nem datas inexistentes. Oferecer em configurações uma prévia dos dados criados ou alterados no mock, excluindo exemplos intactos; mapear referências para IDs do banco e aplicar os itens selecionados em uma única transação, sem apagar o `localStorage`.

## Interfaces e validação

- O contrato de recursos passa a distinguir valor atual, temporário, máximo base, ajuste e máximo calculado; o cliente não envia o máximo calculado. A resposta da ficha inclui o limite de PE.
- Definições oficiais podem ter detalhes e datas ausentes; entradas homebrew continuam exigindo os campos completos. O slug de D&D na API segue o banco: `dungeons-and-dragons`.
- Verificar formatação, compilação, `go vet`, análise estática e segurança do Go; no frontend, typecheck, lint e build. Fazer conferência manual de CORS, erros, CRUD, cálculos, importação repetida e contagens do banco antes/depois das migrações. **Não criar nem executar testes automatizados**, conforme as regras deste repositório.

## Premissas

A API é local, sem login e acessível apenas pela própria máquina. O usuário ativo já existente é a identidade da aplicação; os catálogos do PostgreSQL prevalecem sobre os mocks. Credenciais ficam somente em configuração local ignorada pelo Git, nunca em `VITE_*`. O dump é a base do schema, mas as migrações partem do estado real do banco.
