---
description: Realiza uma auditoria completa e alinhamento do projeto aos padrões Kit Supremo.
---

Este workflow deve ser acionado quando o usuário deseja "Suprematizar" um repositório existente.

### Passo 1: Auditoria Estrutural
- Analisar a hierarquia de pastas (`.agents`, `.context`, `.project-map`).
- Verificar a existência e validade de `CLAUDE.md`, `.cursorrules` e `MASTER.md`.

### Passo 2: Verificação de "Essência"
- Checar se o fluxo de TDD está configurado.
- Identificar arquivos que excedem o limite de 200 linhas (Standard Kit Supremo).

### Passo 3: Geração de Relatório de Ajustes
- Criar ou atualizar o arquivo `STATUS.md` com uma lista de TODOs de alinhamento.
- Sugerir refatorações imediatas para arquivos "God Files".

### Passo 4: Atualização do Mapa do Projeto
- Rodar o `ag-refresh` (se disponível) ou atualizar manualmente o `PROJECT_MAP.md`.

---
**Comando de Ativação Sugerido:** 
"Kit Supremo: Inicie o alinhamento total deste projeto."
