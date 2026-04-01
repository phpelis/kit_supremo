# n8n-mcp Tools Expert Guide

Master the usage of n8n MCP tools to build, validate, and deploy workflows with high precision.

## 🔑 The Golden Rule: Official Prefixing

Getting the `nodeType` prefix right is the #1 requirement for success.

| Tool Category | Prefix Format | Example |
| :--- | :--- | :--- |
| **Discovery** (`search_nodes`, `get_node`) | **Short** | `nodes-base.httpRequest` |
| **Validation** (`validate_node`, `validate_workflow`) | **Short** | `nodes-base.slack` |
| **Management** (`create_workflow`, `update_workflow`) | **Full** | `n8n-nodes-base.httpRequest` |

---

## 🔄 Recommended Workflow Loop

1. **`search_nodes({ query: "slack" })`**
   - Find the correct `nodeType`. Returns both formats.
2. **`get_node({ nodeType: "nodes-base.slack", detail: "standard" })`**
   - Understand available operations and parameters.
3. **`validate_node({ nodeType: "nodes-base.slack", config: { ... }, profile: "runtime" })`**
   - Verify your configuration BEFORE deploying.
4. **`n8n_create_workflow({ name: "...", nodes: [...] })`**
   - Deploy using the **Full Prefix**.
5. **`n8n_update_partial_workflow({ id: "...", operations: [{ type: "activateWorkflow" }] })`**
   - Go live.

---

## 🛠️ Advanced Tool Features

### 1. Smart Connections
When connecting nodes like `IF` or `Switch`, use semantic parameters instead of `sourceIndex`:
```javascript
// Connection for an IF node
{
  type: "addConnection",
  source: "IF Node Name",
  target: "Next Node Name",
  branch: "true" // Use "true" or "false"
}
```

### 2. Validation Profiles
- **`minimal`**: Checks only required fields.
- **`runtime`**: (Recommended) Checks values, types, and dependencies.
- **`strict`**: Maximum validation for production environments.

### 3. Data Tables (`n8n_manage_datatable`)
Manage internal n8n data tables for persistent state:
- `createTable`, `listTables`, `getRows`, `upsertRows`.

---

## 🚫 Common Pitfalls

- **Wasting Tokens**: Avoid `detail: "full"` in `get_node` unless you are deep-debugging. `standard` is enough for 95% of cases.
- **Missing Intent**: Always include the `intent` parameter in `update_partial_workflow` to help the AI track the change history.
- **Incremental vs One-shot**: Never attempt to build a 20-node workflow in one call. Build it cluster by cluster.

---

> [!IMPORTANT]
> If a tool fails with "Node type not found", verify you are using the correct prefix format for that tool category.
