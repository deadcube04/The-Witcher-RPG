---
name: no-tests
description: Use when performing any task in this repository, before any analysis, planning, review, explanation, generation, or modification.
---

# Nenhum teste

Este projeto nao recebe novos testes. Esta regra especifica prevalece sobre workflows que exijam TDD, cobertura ou regressao.

## Regra absoluta

Nunca:

- crie arquivos de teste;
- adicione casos, suites, fixtures, mocks, snapshots ou utilitarios;
- altere testes existentes para cobrir uma mudanca;
- gere ou configure infraestrutura de testes;
- proponha ou exija testes para concluir uma tarefa.

Features, correcoes, refatoracoes e configuracoes seguem a mesma regra.

## Validacao permitida

Use build, lint, formatacao, typecheck, compilacao, analise estatica e verificacao manual. Testes existentes podem ser executados sem alteracao.

## Racionalizacoes proibidas

| Ideia | Regra |
|---|---|
| "Esta correcao precisa de teste de regressao" | Corrija sem criar o teste. |
| "Outra skill exige TDD" | Esta regra especifica do projeto prevalece. |
| "Um teste pequeno nao conta" | Qualquer novo teste e proibido. |

Se estiver prestes a criar ou ampliar um teste, pare e escolha uma validacao permitida.
