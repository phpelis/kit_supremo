# Chatwoot API Reference: App Core (Account, Inboxes, Agents, Teams)

This module covers the management of the structural elements of a Chatwoot account.

## 1. Account API
- **Get Account Details**: `GET /api/v1/accounts/{account_id}`
- **Update Account Settings**: `PATCH /api/v1/accounts/{account_id}`

---

## 2. Inboxes API

### List All Inboxes
- **Endpoint**: `GET /api/v1/accounts/{account_id}/inboxes`

### Create an Inbox
- **Endpoint**: `POST /api/v1/accounts/{account_id}/inboxes`
- **Supported Channels**: `web_widget`, `facebook_page`, `twitter_profile`, `whatsapp`, `sms`, `email`, `api`.

### Inbox Members
- **List Members**: `GET /api/v1/accounts/{account_id}/inbox_members/{inbox_id}`
- **Update Members**: `PATCH /api/v1/accounts/{account_id}/inbox_members`
  - Body: `{ "inbox_id": 1, "user_ids": [1, 2, 3] }`

---

## 3. Agents API

### List Agents
- **Endpoint**: `GET /api/v1/accounts/{account_id}/agents`

### Invite Agent
- **Endpoint**: `POST /api/v1/accounts/{account_id}/agents`
- **Body**: `{ "name": "Agent Name", "email": "agent@example.com", "role": "agent" }`
  - Roles: `agent`, `administrator`.

---

## 4. Teams API

### List Teams
- **Endpoint**: `GET /api/v1/accounts/{account_id}/teams`

### Create a Team
- **Endpoint**: `POST /api/v1/accounts/{account_id}/teams`
- **Body**: `{ "name": "Support Team", "description": "General support" }`

### Team Members
- **List Members**: `GET /api/v1/accounts/{account_id}/teams/{team_id}/team_members`
- **Update Members**: `PATCH /api/v1/accounts/{account_id}/teams/{team_id}/team_members`
  - Body: `{ "user_ids": [1, 2, 3] }`
