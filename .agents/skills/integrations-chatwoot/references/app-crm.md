# Chatwoot API Reference: CRM (Contacts & Conversations)

This module covers the management of customer profiles and their interactions.

## Base URL
`https://{domain}/api/v1/accounts/{account_id}/`

---

## 1. Contacts API

### List All Contacts
- **Endpoint**: `GET /contacts`
- **Query Params**: `page` (default: 1)
- **Response**: Array of Contact objects.

### Create a Contact
- **Endpoint**: `POST /contacts`
- **Body**:
  ```json
  {
    "inbox_id": 1,
    "name": "John Doe",
    "email": "john@example.com",
    "phone_number": "+1234567890",
    "identifier": "internal_id_123",
    "custom_attributes": {
      "plan": "premium",
      "managed_by": "agent_1"
    }
  }
  ```

### Search Contacts
- **Endpoint**: `GET /contacts/search`
- **Query Params**: `q` (string search in name, email, phone, or identifier)
- **Response**: Paginated list of matching contacts.

### Update a Contact
- **Endpoint**: `PUT /contacts/{contact_id}`
- **Body**: Partial updates allowed (e.g., just `custom_attributes`).

---

## 2. Conversations API

### List Conversations
- **Endpoint**: `GET /conversations`
- **Query Params**: `status` (all, open, resolved, pending), `assignee_type` (all, me, unassigned), `labels` (array).

### Create a Conversation
- **Endpoint**: `POST /conversations`
- **Body**:
  ```json
  {
    "source_id": "{contact_inbox_id}",
    "contact_id": 123,
    "inbox_id": 1,
    "additional_attributes": {}
  }
  ```

### Update Conversation Status
- **Endpoint**: `POST /conversations/{conversation_id}/toggle_status`
- **Body**: `{ "status": "resolved" }`

### Assign Conversation
- **Endpoint**: `POST /conversations/{conversation_id}/assignments`
- **Body**: `{ "assignee_id": 1, "team_id": 2 }`

---

## 3. Messages API

### List Messages
- **Endpoint**: `GET /conversations/{conversation_id}/messages`

### Create a Message
- **Endpoint**: `POST /conversations/{conversation_id}/messages`
- **Body**:
  ```json
  {
    "content": "Hello World",
    "message_type": "outgoing",
    "private": false,
    "content_type": "text"
  }
  ```
- **Message Types**: `incoming` (from user), `outgoing` (from agent/bot).

---

## 4. Contact Labels
- **Endpoint**: `GET /contacts/{contact_id}/labels`
- **Endpoint**: `POST /contacts/{contact_id}/labels` (Body: `{ "labels": ["vip", "urgent"] }`)
