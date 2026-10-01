# Integridade, ambiguidades e pontos para validação manual

Este arquivo registra divergências **do próprio PDF** e artefatos de extração que não devem ser corrigidos silenciosamente ao montar a migration.

## Divergências do texto-fonte

- **Tablet/Tábula do Saber Custoso:** a Tabela 1.6 (página PDF 59) usa “Tablet do saber custoso”; a descrição na página PDF 61 usa “Tábula do Saber Custoso”.
- **Categorias de equipamentos:** a Tabela 1.5 (página PDF 41) imprime `1` para Paraquedas e Traje de mergulho e `2` para Traje espacial, enquanto grande parte do restante do sistema usa categorias romanas (`I`, `II`, etc.). O catálogo preserva os números exatamente como aparecem nessa tabela.
- **Espectro Inesquecido:** é uma ameaça-template derivada de um Marcado, com VD `4 × NEX`; não existe uma única ficha canônica. O livro fornece um exemplo de VD 220.

## Artefatos de extração textual

- O símbolo de dado/bônus aparece em vários pontos como `O` ou glifo privado (``, ``, ``, ``, ``). Não interpretar automaticamente `O` como zero.
- Algumas palavras podem permanecer coladas ou quebradas em locais onde a diagramação usa duas colunas ou caixas laterais.
- Elementos compostos de criaturas podem aparecer em linhas separadas; para dados críticos, conferir o bloco da criatura na página indicada.
- Algumas tabelas e boxes são melhor interpretados pela imagem da página do que pelo texto extraído.

## Regra de segurança para o agente

Quando houver conflito entre catálogo e seção textual, use a seção textual e a página do PDF como fonte prioritária. Quando houver conflito dentro do próprio PDF, preserve ambas as variantes e marque a decisão de normalização explicitamente na migration futura.
