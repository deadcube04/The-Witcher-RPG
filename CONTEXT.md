# Vocabulário do RPG Manager

- **Sistema de RPG:** conjunto de catálogos e regras identificado por `rpg_system_id`. A seleção ativa do usuário muda o contexto da interface; não altera dados já criados.
- **Sistema em preview:** sistema visível e selecionável para exploração, sem criação de campanhas ou fichas nesta entrega. D&D e The Witcher estão nessa condição.
- **Ordem Paranormal 1.1:** único sistema com campanhas, fichas editáveis e cálculos de regras nesta entrega.
- **Usuário local:** registro ativo de `public.users` escolhido explicitamente para a aplicação local. É o proprietário dos dados criados pela interface.
- **Preferências:** sistema ativo, tema ativo e estado da barra lateral do usuário local.
- **Campanha:** agrupamento opcional de fichas, pertencente ao usuário local e a um único sistema de RPG.
- **Ficha:** personagem do tipo `PLAYER` com vínculo em `core.character_sheet` e proprietário. Ameaças e NPCs não são fichas do usuário.
- **Ficha avulsa:** ficha sem campanha.
- **NEX:** valor de progressão de Ordem presente em `ordem.nex_rule`; a ficha salva exige um dos valores cadastrados.
- **Recurso:** PV, PE ou SAN. Possui valor atual, valor temporário, máximo base calculado, ajuste manual e máximo efetivo.
- **Perícia:** definição do catálogo do sistema. A ficha escolhe treinamento, atributo modificador e bônus adicional; o bônus final é calculado.
- **Catálogo oficial:** conteúdo existente no PostgreSQL sem proprietário individual. Dados não cadastrados permanecem ausentes na API e na interface.
- **Homebrew:** definição criada pelo usuário local. Só seu proprietário pode alterar ou remover essa definição.
- **Entrada de ficha:** vínculo de uma ficha a uma definição de inventário, ritual ou ataque. Tem identidade própria e pode guardar quantidade, estado ou notas conforme o tipo.
- **Ataque derivado:** definição de ataque criada a partir de uma arma oficial, ligada à definição do item de origem.
- **Importação do mock:** migração opcional de dados criados ou alterados pelo usuário no armazenamento do navegador para o PostgreSQL, precedida de prévia e aplicada de modo atômico.
