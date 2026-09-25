# Importação opcional do mock local

Com API e frontend em modo real, abra **Configurações → Importar dados locais**. O painel lê o armazenamento local do navegador usado pelo MSW, identifica campanhas, fichas e conteúdo criados ou alterados em relação ao seed, e permite selecionar itens. Dependências, como campanha da ficha e definição do item, entram automaticamente na seleção.

Clique em **Prévia** para obter `ready`, `alreadyImported` e problemas por item. A prévia executa o processamento em uma transação revertida, sem gravar dados. Depois de revisar os itens, clique em **Aplicar**. A aplicação grava todos os itens selecionados numa transação; qualquer problema reverte o lote. O mapa `core.local_import_map` impede duplicação ao reenviar os mesmos IDs locais. O armazenamento local permanece no navegador e pode ser mantido como referência.

Conteúdo oficial do mock é resolvido por nome no catálogo do banco. Se não houver correspondência única, a prévia informa `CONTENT_NOT_FOUND`; ajuste a seleção ou o conteúdo local antes de aplicar. Definições alteradas ou homebrew são importadas como conteúdo do usuário. Os IDs de dependências são remapeados ao criar entradas da ficha. As fichas trazem seus valores atuais e temporários de recurso, sujeitos aos máximos calculados pelo backend.

A API correspondente é `POST /api/v1/local-import/preview` e `POST /api/v1/local-import/apply`; o corpo é `{ "items": [{ "kind": "campaign", "sourceId": "UUID", "name": "Nome", "payload": { ... } }] }`. O navegador monta o lote em `frontend/src/shared/api/local-import.ts` e exibe o resultado em `frontend/src/features/settings/LocalImportPanel.tsx`.
