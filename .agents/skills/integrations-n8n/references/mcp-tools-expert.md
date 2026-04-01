# n8n Master Class: MCP Tools Expert

Este guia define os protocolos de uso das ferramentas n8n-mcp. O uso correto dessas ferramentas garante que as automações sejam construídas com precisão cirúrgica e sem erros de infraestrutura.

## 🛠️ Categorias de Ferramentas

1.  **Descoberta:** `search_nodes`, `get_node`.
2.  **Validação:** `validate_node`, `validate_workflow`.
3.  **Gestão:** `n8n_create_workflow`, `n8n_update_partial_workflow`.
4.  **Modelos:** `search_templates`, `n8n_deploy_template`.

---

## 🚨 REGRA CRÍTICA: Formatos de `nodeType`

Existem dois formatos diferentes para os nomes dos nós. Usar o formato errado resultará em erro "Node not found".

### 1. Formato Curto (Busca e Validação)
Usado em: `search_nodes`, `get_node`, `validate_node`.
- ✅ `nodes-base.slack`
- ✅ `nodes-base.httpRequest`

### 2. Formato Longo (Criação e Update de Workflow)
Usado em: `n8n_create_workflow`, `n8n_update_partial_workflow`.
- ✅ `n8n-nodes-base.slack`
- ✅ `n8n-nodes-base.httpRequest`

---

## 🚦 Protocolos de Validação

Sempre especifique o **perfil de validação** para evitar falsos positivos.

- **`minimal`:** Apenas campos obrigatórios (rápido).
- **`runtime`:** Valida tipos e valores (Recomendado para pré-deploy).
- **`strict`:** Máxima validação (Produção).

```javascript
// Exemplo de uso correto:
validate_node({
  nodeType: "nodes-base.slack",
  config: { ... },
  profile: "runtime"
});
```

---

## 🔄 Fluxo de Trabalho Iterativo

Não tente construir um workflow complexo em um único passo. O padrão de sucesso do Kit Supremo segue:

1.  **Busca:** Encontrar o nó correto via `search_nodes`.
2.  **Detalhes:** Consultar `get_node` (detalhe `standard`) para ver os campos da operação.
3.  **Configuração:** Montar o JSON de configuração.
4.  **Validação:** Testar via `validate_node` até ficar verde.
5.  **Aplicação:** Criar ou atualizar o workflow via `n8n_update_partial_workflow`.
6.  **Ativação:** Usar a operação `activateWorkflow`.

---

## 💡 Dicas de Especialista

- **Intent:** Sempre use o parâmetro `intent` em atualizações de workflow. Isso ajuda a rastrear o propósito de cada mudança.
- **Auto-Fix:** Se houver erros chatos de estrutura, use `n8n_autofix_workflow`.
- **Search Metadata:** Use `search_templates` com `searchMode: "by_task"` para encontrar exemplos prontos de webhooks ou integrações específicas.

---
*Referência consolidada para o Kit Supremo.*
