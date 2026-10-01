# Sobrevivendo ao Horror v1 - pacote de contexto para agente

Este pacote **não contém uma migration**. Ele é uma extração estruturada do PDF fornecido, preparada para servir como contexto de um agente que posteriormente poderá modelar ou popular o banco.

## Cobertura

- PDF físico: 226 páginas.
- O suplemento declara 20 novas origens, 9 novas trilhas, mais de 60 opções de personagem somando poderes, dezenas de equipamentos/rituais e mais de 10 novas ameaças.
- O pacote inclui também as duas missões e os apêndices, porque elas contêm NPCs, locais, encontros, tabelas e regras que podem ser úteis em modelagem futura.
- `entities_index.yaml`: índice compacto e legível por máquina com nomes, relações básicas e páginas.
- `catalogs/`: catálogos normalizados e econômicos em tokens.
- `sections/`: extração textual extensa, separada por domínio.
- `sections/99_referencia_completa_paginas.md`: fallback de busca quando um detalhe não estiver nos catálogos.

## Ordem recomendada para enviar a outro agente

1. `00_README_AGENT_CONTEXT.md` + `entities_index.yaml`.
2. O catálogo do domínio que será implementado.
3. Apenas o(s) arquivo(s) de `sections/` necessário(s) para efeitos completos.
4. `99_referencia_completa_paginas.md` somente para busca pontual.

## Importante para a migration futura

Não inventar campos, valores ou normalizações silenciosas. Alguns conceitos têm múltiplas relações e regras condicionais (NEX, nível, afinidade, classe, trilha, elemento, custo em PE, ações, duração, resistência etc.). Antes de transformar texto em colunas, preserve o texto-fonte e a página de origem.

Há pelo menos uma inconsistência textual relevante detectada: a tabela de itens amaldiçoados lista **“Tablet do saber custoso”**, enquanto a descrição posterior usa **“Tábula do Saber Custoso”**. O pacote mantém a divergência em vez de corrigi-la silenciosamente.

## Limitações da extração

O PDF é diagramado em múltiplas colunas. A extração `-raw` preserva a ordem de leitura melhor que a extração por layout, mas ainda pode haver quebras de palavras, glifos especiais (`O` no lugar do símbolo de dado em alguns trechos) e pequenos artefatos. Para valores críticos de tabela, consulte a página indicada no PDF original.
