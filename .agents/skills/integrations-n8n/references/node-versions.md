# Node Version Management Reference

Every node in n8n has a `typeVersion` field. Older versions miss bug fixes and
features that newer versions provide. **Always check node versions before delivering
a workflow.**

## How to check if a node is on the latest version

```
1. get_node("<nodeType>")          → look at "defaultVersion" in the response
2. Compare against typeVersion in the workflow node definition
3. If workflow typeVersion < defaultVersion → node is outdated
```

Example:
```json
// In workflow — node definition
{ "type": "n8n-nodes-base.httpRequest", "typeVersion": 3 }

// get_node response shows: "defaultVersion": 4.2
// → Outdated! Needs upgrade.
```

## How to upgrade a node to the latest version

Use `n8n_update_partial_workflow` to update the `typeVersion` of a specific node:

```
intent: "upgrade httpRequest node to latest version"
change: set typeVersion of node "My HTTP Request" to 4.2
```

**After upgrading typeVersion:** Always run `validate_workflow` (profile: "runtime")
because newer versions sometimes change required properties or rename parameters.

## Nodes to check versions on EVERY workflow

| Node | Common issue with old version |
|------|-------------------------------|
| `n8n-nodes-base.httpRequest` | v3→v4 changed auth model and response parsing |
| `n8n-nodes-base.set` | v2→v3 changed field assignment interface |
| `n8n-nodes-base.code` | v1→v2 added Python support and sandbox changes |
| `n8n-nodes-base.if` | v1→v2 changed condition format |
| `n8n-nodes-base.switch` | v2→v3 changed routing mode |
| `n8n-nodes-base.merge` | v2→v3 changed merge mode options |
| `n8n-nodes-base.splitInBatches` | v2→v3 changed reset behavior |

## Version audit checklist

```
  □ For each node: run get_node and compare typeVersion vs defaultVersion
  □ If any node is outdated: upgrade typeVersion and re-validate
  □ After upgrading: run validate_workflow again to catch property changes
  □ Test with real data after version upgrades — behavior may differ
```

## Why this matters

- Old node versions may have known bugs silently corrupting data
- Missing features force workarounds that newer versions solve natively
- n8n cloud auto-suggests upgrades in the UI — via MCP you must check manually
- A workflow deployed with outdated nodes is a liability in production
