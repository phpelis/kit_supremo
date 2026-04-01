# Node Configuration Rules Reference

## Property dependencies

Many nodes have properties that only appear when a parent property is set to a
specific value. Always check `get_node` for the full property tree before configuring.

```
Example — Slack node:
  resource: "message"         ← set this first
    operation: "post"         ← then this appears
      channel: required       ← then this appears
      text: required
```

**Sequence:** set `resource` → then `operation` → then fill required fields for that operation.

## Common node gotchas

| Node | Gotcha | Fix |
|------|--------|-----|
| HTTP Request | Auth not attached | Set `Authentication` to credential type |
| IF / Switch | Empty condition | Every branch needs at least one condition |
| Code | `return` missing | Always `return items` or `return [{json: {...}}]` |
| Webhook | Double data wrapping | Access data via `$json.body.field` |
| Set | Overwriting all fields | Check "Keep Only Set" checkbox only when intended |
| Merge | Mode not set | Explicitly set `mode`: "combine"/"append"/"chooseBranch" |

## Connections

- Each node has **input** (left) and **output** (right) connection points
- `IF` and `Switch` nodes have multiple output branches — connect ALL branches
- Error output is a special branch — always wire it somewhere (even just a Slack alert)
