# Workflow File Organization Reference

Complex workflows in a single JSON become unmanageable fast — slow to read, slow
to edit, and expensive in tokens. The solution: **one folder per workflow**, with
auxiliary files that let you work on one piece at a time.

## This skill OWNS the n8n/ folder

The n8n skill is responsible for **creating, updating, and deleting** all files
inside `n8n/`. It does not wait to be asked — it proactively manages the folder
as part of every workflow task.

**On new workflow:** Create the full folder structure automatically.
**On node added/changed:** Update the corresponding node file + data-map.md.
**On node deleted:** Delete its node file. Do not leave orphan files.
**On workflow completed:** Assemble workflow.json, update CHANGELOG.md.
**On workflow deleted from n8n:** Delete the entire `n8n/<nome>/` folder.

The user should never need to manually manage files in `n8n/`. This skill does it.

## Standard folder structure

```
n8n/
  nome-do-fluxo/
    README.md              ← purpose, trigger, dependencies, credentials needed
    data-map.md            ← documents the data flow between all nodes
    nodes/
      01-trigger.json      ← one file per node or logical node group
      02-validate.json
      03-transform.json
      04-send.json
    workflow.json          ← assembled/deployed version (source of truth)
    CHANGELOG.md           ← history of changes
```

## What goes in each file

**README.md** — written FIRST, before any node is created:
```markdown
## Nome do Fluxo — descrição

**Trigger:** Webhook POST /payments/notify
**Purpose:** Receive payment notification, validate, save to Supabase, notify via Chatwoot
**Credentials needed:** supabase-prod, chatwoot-api, woovi-webhook-secret
**Pattern:** Webhook processing (Pattern 1)
**Estimated nodes:** 8
```

**data-map.md** — documents data between nodes (prevents expression errors):
```markdown
## Data flow

Webhook → $json.body.charge_id, $json.body.status, $json.body.amount
IF (validate) → true: $json.body (valid), false: error response
HTTP Request (Supabase) → $json.id, $json.updated_at
Set (transform) → $json.charge_id, $json.status, $json.notified_at
```

**nodes/XX-name.json** — one file per node or logical group (2-3 nodes max):
```json
{
  "name": "Validate Payload",
  "type": "n8n-nodes-base.if",
  "typeVersion": 2,
  "parameters": {
    "conditions": {
      "string": [{ "value1": "={{$json.body.charge_id}}", "operation": "isNotEmpty" }]
    }
  }
}
```

**workflow.json** — the full assembled workflow, updated after each node group is added.
Never edit this file directly — always edit the node files and re-assemble.

## Working pattern

**Building a new workflow:**
```
1. Create README.md → define purpose, pattern, node list
2. Create data-map.md → map data flow before writing any expression
3. For each node group (2-3 nodes at a time):
   a. Write nodes/XX-name.json
   b. Load ONLY that file + data-map.md when configuring
   c. Add to workflow via MCP (create or update_partial)
   d. Validate
4. After all nodes: assemble final workflow.json
```

**Editing an existing workflow:**
```
1. Read only the specific nodes/XX-file.json for the node being changed
2. Read data-map.md to understand what data is available
3. Make the edit in the node file
4. Apply via n8n_update_partial_workflow
5. Update data-map.md if data flow changed
6. Update workflow.json to reflect the change
```

## Why this saves tokens

- Editing one node → load 1 node file (~50 lines) instead of full workflow (~500+ lines)
- data-map.md replaces the need to re-read the entire workflow to find field names
- README.md answers "what does this workflow do?" without loading any JSON
- Node groups are independently understandable — no full context needed

## When to split into node files

| Workflow size | Strategy |
|--------------|----------|
| < 5 nodes | Single workflow.json is fine |
| 5-15 nodes | Split by logical group (trigger, validate, transform, output) |
| 15+ nodes | One file per node — mandatory |
| Sub-flows (reused patterns) | Separate folder under `n8n/` |

## Checklist — workflow folder setup

```
Before building:
  □ Create n8n/<nome-do-fluxo>/ folder
  □ Write README.md (pattern, trigger, credentials)
  □ Write data-map.md (input → output for each node group)

During build:
  □ Create one nodes/XX-name.json per node group
  □ Load only the relevant node file when editing
  □ Update data-map.md as data shapes are confirmed

After build:
  □ Assemble workflow.json (final deployed state)
  □ Run node version audit on assembled workflow
  □ Run validate_workflow on assembled workflow
```
