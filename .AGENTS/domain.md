# RPG Manager — Domain Rule

## 1. Objetivo

Esta rule descreve o domínio funcional do RPG Manager e deve servir como contexto para qualquer agente que implemente funcionalidades, entidades, APIs, migrations ou telas.

Ela explica **o que o sistema representa e como seus conceitos devem ser modelados**.

Detalhes de código, infraestrutura, banco, frontend e testes pertencem a rules específicas.

---

# 2. Visão do produto

O RPG Manager é uma aplicação privada para centralizar informações de diferentes sistemas de RPG e gerenciar campanhas.

O produto possui dois grandes módulos:

1. **Wiki estruturada**, contendo regras, criaturas, personagens, itens, locais, organizações e outros conteúdos dos sistemas;
2. **Gerenciamento de campanhas**, contendo personagens, inventários, NPCs, sessões, estados, descobertas e demais informações específicas de cada campanha.

A aplicação não deve ser tratada como uma wiki de páginas estáticas.

Os conteúdos representam entidades estruturadas e relacionadas.

---

# 3. Multi-system

O sistema deve suportar múltiplos RPGs.

Inicialmente:

* Ordem Paranormal;
* Dungeons & Dragons;
* The Witcher RPG.

A arquitetura deve permitir adicionar novos sistemas sem modificar profundamente o núcleo da aplicação.

O domínio é dividido em:

```text
core
ordem
dnd
witcher
```

O `core` contém apenas conceitos realmente compartilháveis.

Cada sistema possui seu próprio domínio para regras, entidades e mecânicas específicas.

---

# 4. Regra de generalização

Generalizar somente conceitos cuja semântica seja realmente compartilhada.

Não criar entidades genéricas gigantescas apenas para representar vários sistemas.

Exemplo ruim:

```text
character
- nex
- armor_class
- toxicity
- spell_slots
- sanity
```

Esses atributos pertencem a sistemas diferentes.

Também não duplicar conceitos claramente compartilháveis, como:

```text
users
campaigns
assets
permissions
tags
```

Princípio:

```text
generalizar o que é comum
especializar o que pertence ao sistema
```

---

# 5. Conteúdo de referência e estado de campanha

Essa separação é obrigatória.

## Conteúdo de referência

Representa informações do sistema ou universo.

Exemplos:

```text
Zumbi de Sangue
Espada Longa
Decadência
Novigrad
Fireball
```

Esses dados fazem parte da base de conhecimento e podem ser utilizados por várias campanhas.

## Estado de campanha

Representa uma ocorrência concreta dentro de uma campanha.

Exemplos:

```text
NPC criado pelo mestre
vida atual de uma criatura
inventário de um jogador
estado de uma missão
anotações da sessão
```

Nunca modificar dados de referência para representar estado de campanha.

Exemplo:

```text
Threat
hp = 120
```

pode gerar:

```text
CampaignThreat
reference = Threat
current_hp = 45
```

---

# 6. Entidades e relacionamentos

Informações estruturáveis devem ser armazenadas como dados estruturados, não apenas como texto.

Priorizar relacionamentos explícitos.

Exemplo ruim:

```text
elements = "Sangue, Morte"
```

Exemplo correto:

```text
threat
threat_element
element
```

Uma entidade deve possuir identidade própria independente do nome exibido.

Quando aplicável, considerar:

```text
id
canonical_name
slug
aliases
```

Nunca utilizar o nome como identidade principal da entidade.

---

# 7. Wiki estruturada

A wiki funciona como uma base de conhecimento navegável.

Entidades podem possuir relações como:

```text
Creature
 ├─ abilities
 ├─ elements
 ├─ locations
 ├─ organizations
 └─ related_entities
```

Textos descritivos podem existir, mas informações que precisam ser filtradas, pesquisadas ou reutilizadas devem permanecer estruturadas.

---

# 8. Busca

A busca é uma funcionalidade central.

Ela deve tolerar diferenças como:

* singular/plural;
* acentos;
* aliases;
* sinônimos;
* termos relacionados;
* pequenos erros de digitação.

Exemplo:

```text
lamina
```

deve poder localizar:

```text
lâmina
```

Sinônimos e aliases devem ser tratados como dados e não hardcoded na aplicação.

Diferença:

```text
alias = outro nome da mesma entidade
sinônimo = termo equivalente ou relacionado usado na busca
```

---

# 9. Campanhas

Uma campanha representa uma execução concreta de um sistema de RPG.

Conceitualmente:

```text
Campaign
- id
- name
- system
- owner
- status
```

Uma campanha pertence a um sistema específico.

Não misturar regras de múltiplos RPGs automaticamente.

Campanhas podem conter:

* jogadores;
* personagens;
* NPCs;
* criaturas;
* itens;
* missões;
* sessões;
* inventários;
* anotações;
* estados e descobertas.

---

# 10. Usuários e acesso

A aplicação é privada.

Usuários recebem acesso explicitamente.

Papéis podem incluir:

```text
ADMIN
GM
PLAYER
VIEWER
```

Permissões podem existir tanto no nível global quanto no contexto de uma campanha.

Revogar acesso não deve exigir apagar o usuário ou seu histórico.

---

# 11. Visibilidade de campanha

Nem toda informação existente em uma campanha deve ser automaticamente visível aos jogadores.

O domínio deve distinguir:

```text
informação existente
```

de:

```text
informação conhecida/revelada
```

Isso permite funcionalidades como:

* conteúdo secreto;
* descobertas;
* fog of war;
* informação visível apenas para o mestre;
* visibilidade por jogador ou grupo.

---

# 12. Assets

Imagens e outros arquivos são entidades externas ao conteúdo principal.

Entidades devem referenciar um asset lógico, não caminhos absolutos do sistema operacional.

Exemplo:

```text
Threat
  -> image_asset
```

A forma física de armazenamento não faz parte do domínio.

---

# 13. Domínios específicos

Cada RPG pode possuir suas próprias entidades e regras.

Exemplos:

```text
ordem
- threats
- elements
- rituals
- NEX
- agents

dnd
- monsters
- spells
- classes
- species
- feats

witcher
- monsters
- professions
- signs
- alchemy
- crafting
```

Conceitos semelhantes entre sistemas não devem ser unificados automaticamente.

Por exemplo:

```text
Ordem Ritual
D&D Spell
Witcher Sign
```

podem possuir finalidade semelhante para o usuário, mas continuam sendo conceitos diferentes de domínio.

---

# 14. Fonte operacional

Dados importados de livros, wikis ou outras fontes devem ser adaptados para o modelo interno.

O sistema não deve depender dessas fontes em runtime.

Fluxo esperado:

```text
fonte
  ↓
extração/adaptação
  ↓
validação
  ↓
banco
  ↓
aplicação
```

A estrutura do banco deve representar o domínio, não a estrutura visual da fonte original.

---

# 15. Regras para implementação

Antes de criar ou alterar uma funcionalidade, determinar:

1. O conceito pertence ao `core` ou a um RPG específico?
2. É conteúdo de referência ou estado de campanha?
3. É uma entidade, atributo ou relacionamento?
4. Precisa ser pesquisável?
5. Possui impacto de permissão ou visibilidade?
6. Já existe conceito equivalente no domínio?
7. A implementação cria acoplamento desnecessário entre sistemas?

Não criar abstrações multi-system apenas para eliminar duplicação superficial.

---

# 16. Princípio central

O RPG Manager deve ser tratado como uma plataforma de domínio composta por:

```text
entidades
+
relacionamentos
+
regras
+
estado de campanha
+
permissões
```

O `core` fornece infraestrutura e conceitos compartilhados.

Cada sistema de RPG permanece responsável por suas próprias regras e entidades.

A prioridade é preservar essa separação durante toda a evolução da aplicação.
