# Chatwoot API Reference: App Automation (Webhooks, Rules, AgentBots)

This module covers ways to automate interactions and integrate with external systems.

## 1. Webhooks API

### List Webhooks
- **Endpoint**: `GET /api/v1/accounts/{account_id}/webhooks`

### Create a Webhook
- **Endpoint**: `POST /api/v1/accounts/{account_id}/webhooks`
- **Body**: `{ "url": "https://example.com/webhook", "subscriptions": ["message_created", "conversation_created"] }`

### Common Webhook Events
| Event Name | Trigger |
|------------|---------|
| `message_created` | New message in any conversation |
| `message_updated` | Message content/metadata changed |
| `conversation_created` | New conversation started |
| `conversation_status_changed` | Status toggled (open/resolved/pending) |
| `conversation_updated` | Attributes/Labels changed |
| `contact_created` | New contact profile created |
| `contact_updated` | Contact info/custom attributes changed |
| `webwidget_triggered` | Website widget opened |

---

## 2. Automation Rules API
- **List Rules**: `GET /api/v1/accounts/{account_id}/automation_rules`
- **Create Rule**: `POST /api/v1/accounts/{account_id}/automation_rules`
- **Components**:
  - `conditions`: List of filters (e.g., `contact_label == 'vip'`)
  - `actions`: List of effects (e.g., `assign_to_team(2)`)

---

## 3. AgentBots API
AgentBots are treated as "Agents" but communicate via an external URL.

### List AgentBots
- **Endpoint**: `GET /api/v1/accounts/{account_id}/agent_bots`

### Create AgentBot
- **Endpoint**: `POST /api/v1/accounts/{account_id}/agent_bots`
- **Body**:
  ```json
  {
    "name": "My AI Bot",
    "description": "Handles first response",
    "outgoing_url": "https://my-bot-server.com/api/chatwoot"
  }
  ```

### Assign Bot to Inbox
- **Endpoint**: `POST /api/v1/accounts/{account_id}/inbox_members` (Same as agents)
