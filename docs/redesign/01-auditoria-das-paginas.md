# Auditoria das páginas

## Problemas sistêmicos

- `PageHeader` repete eyebrow, título grande e divisor em quase todas as rotas.
- `RpgCard` dá o mesmo tratamento a campanhas, fichas, sistemas e preferências.
- Bordas, links sublinhados, CTAs retangulares e grids regulares possuem peso semelhante.
- Os temas alteram principalmente cinco cores, família genérica e uma decoração isolada.
- A imagem `hero.png` não é usada; quase toda a personalidade depende de texto e ícones.
- Loading, vazio e erro são caixas genéricas sem relação com a composição final.

## Shell

**Atual:** sidebar fixa, expansão por hover, sombra genérica e ícones de fantasia espessos.

**Destino:** rail de 72px no desktop, destino ativo inequívoco, tooltips, contexto do sistema e perfil; barra superior contextual com seção e página. No mobile, topo compacto e dock inferior com áreas de toque de pelo menos 44px.

## Início

**Atual:** o último acesso ainda parece um cartão semelhante às ações rápidas.

**Destino:** hero assimétrico com fotografia documental, identificação do último registro, metadados e CTA de retomada. Ações rápidas ficam em uma ilha menor; recentes viram índices editoriais.

## Campanhas

**Atual:** cartões equivalentes em duas colunas, texto de tamanho parecido e três ações com pouca hierarquia.

**Destino:** campanha mais recente em destaque horizontal e demais campanhas como linhas de dossier. Busca e sistema formam uma toolbar compacta. Abrir é a ação dominante; editar e excluir são secundárias.

## Editor de campanha

**Atual:** formulário estreito abaixo do mesmo cabeçalho das páginas de coleção.

**Destino:** divisão editorial com formulário e prévia do dossier. Campos, validações, bloqueio do sistema e salvamento não mudam.

## Detalhe da campanha

**Atual:** cabeçalho textual, descrição e lista simples de personagens.

**Destino:** masthead fotográfico com sistema e status, descrição em coluna editorial e personagens vinculados em índice visual. Editar, excluir e adicionar personagem permanecem disponíveis.

## Personagens

**Atual:** replica a composição e o cartão de campanhas.

**Destino:** destaque vertical para a ficha mais recente e índice compacto para as demais, com sistema e vínculo visíveis. Busca e filtros continuam na URL.

## Editor de personagem

**Atual:** longa sequência de campos com pouca orientação de progresso.

**Destino:** seções numeradas para identidade, associação, regras e narrativa, com resumo lateral no desktop. Todos os campos permanecem na mesma página; não haverá wizard.

## Ficha de personagem

**Atual:** identidade, recursos, perícias e gavetas já diferenciam a tela, mas bordas e painéis competem entre si.

**Destino:** manter coluna de identidade, estatísticas superiores, perícias centrais e gavetas laterais. Recursos recebem prioridade máxima; perícias ficam mais densas; narrativa é secundária. Inventário, rituais, ataques, dados e autosave preservam seus comportamentos.

## Sistemas

**Atual:** três cartões iguais fazem o sistema ativo e os previews parecerem equivalentes.

**Destino:** sistema ativo em destaque fotográfico amplo; previews aparecem como dossiers menores com estado explícito.

## Configurações

**Atual:** perfil e aparência são dois cartões genéricos.

**Destino:** índice editorial de preferências, com resumo e estado atual.

## Perfil

**Atual:** formulário isolado sem visualização da identidade resultante.

**Destino:** prévia de identidade ao lado do formulário, mantendo nome, usuário, URL de avatar e validações.

## Aparência

**Atual:** miniaturas demonstram principalmente cor e decoração.

**Destino:** showroom assimétrico com tema ativo em destaque e amostras menores de tipografia, mídia, superfícies e acento.

## Estados globais

**Atual:** loading, vazio, erro, 404 e modais usam caixas semelhantes ao conteúdo normal.

**Destino:** skeletons com a forma da página, vazios com composição editorial, erros diretos e confirmações destrutivas sóbrias.
