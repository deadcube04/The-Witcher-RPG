# Refatoração visual do bestiário

## Intenção confirmada

O catálogo e os detalhes de ameaças devem favorecer exploração e descoberta. A apresentação anterior parecia pesada, embora suas funcionalidades fossem consideradas boas. A direção escolhida é editorial sóbria: imagens, tipografia e cor por elemento dão identidade; superfícies simples e espaçamento dão clareza. O sucesso é encontrar uma ameaça e entender suas informações sem se perder, tanto para quem conhece o sistema quanto para novatos.

## Decisões de experiência

- Catálogo com cabeçalho curto, busca evidente, filtros avançados recolhidos e cartões de altura moderada. Cada cartão mantém nome, elemento, tipo e VD em posições estáveis.
- Detalhe com cabeçalho comum de imagem, nome, elemento, tipo e VD. A aba **Informações** abre por padrão e contém Resumo, Aparência, Comportamento e História, todos visíveis. A aba **Ficha** concentra vida, defesa, atributos, testes, ações e demais dados de jogo.
- A seleção da aba é local. Abrir outra ameaça reinicia em Informações. Habilidades especiais e Enigma do Medo continuam protegidos por divulgação sob demanda.
- Termos como VD e NEX usam ajuda contextual, acessível por toque, mouse e teclado.
- Busca, filtros, ordenação, navegação anterior/próxima, retorno com filtros e posição de rolagem permanecem.

## Contrato com a outra frente

A outra frente adicionará e preencherá os textos narrativos no banco e na API. O frontend espera `creature.appearance`, `creature.behavior` e `creature.history`, cada um como `string | null` e opcional durante a transição. Ausência ou texto em branco exibe “Informação ainda não disponível.” na seção correspondente. A descrição atual (`creature.description`) é o Resumo. Não há alteração de backend nesta refatoração.

## Implementação e validação

Os componentes da tela ficam em `frontend/src/features/bestiary/`; abas e ajuda contextual estão encapsuladas em `frontend/src/components/primitives/`. O contrato Zod fica em `frontend/src/shared/contracts/bestiary.ts`. A antiga composição de páginas de livro foi removida. A identidade usa os tokens de tema existentes e fontes Geist, Newsreader e IBM Plex Mono já incluídas no projeto.

Validação prevista: typecheck, lint, build Vite e revisão manual em desktop e celular, incluindo teclado, estados de carregamento/vazio/erro, imagens ausentes e textos narrativos presentes/pendentes. O projeto proíbe criar, alterar ou executar testes automatizados sem pedido explícito do usuário.
