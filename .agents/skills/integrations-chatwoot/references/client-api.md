# Chatwoot API Reference: Client API (Custom Widgets)

This module is for building custom chat interfaces for end-users (e.g., custom web widgets or mobile app integrations).

## Base URL
`https://{domain}/public/api/v1/inboxes/{inbox_identifier}/`

## Authentication
Uses **Public Identifiers**:
- `inbox_identifier`: Found in Inbox Settings -> Configuration.
- `contact_identifier` (source_id): Generated when a contact is created.

---

## 1. Client Contacts API

### Create/Retrieve Contact
- **Endpoint**: `POST /public/api/v1/inboxes/{inbox_identifier}/contacts`
- **Body**:
  ```json
  {
    "source_id": "unique_user_id_123",
    "name": "User Name",
    "email": "user@example.com",
    "custom_attributes": {}
  }
  ```
- **Response**: Returns contact details including `source_id`.

### Get Contact Details
- **Endpoint**: `GET /public/api/v1/inboxes/{inbox_identifier}/contacts/{contact_identifier}`

---

## 2. Client Conversations API

### List Conversations
- **Endpoint**: `GET /public/api/v1/inboxes/{inbox_identifier}/contacts/{contact_identifier}/conversations`

### Create a Conversation
- **Endpoint**: `POST /public/api/v1/inboxes/{inbox_identifier}/contacts/{contact_identifier}/conversations`

---

## 3. Client Messages API

### List Messages
- **Endpoint**: `GET /public/api/v1/inboxes/{inbox_identifier}/contacts/{contact_identifier}/conversations/{conversation_id}/messages`

### Send a Message
- **Endpoint**: `POST /public/api/v1/inboxes/{inbox_identifier}/contacts/{contact_identifier}/conversations/{conversation_id}/messages`
- **Body**:
  ```json
  {
    "content": "Message text",
    "echo_id": "client_uuid_for_optimistic_update"
  }
  ```

---

## 4. Realtime (WebSockets)
Clients can subscribe to realtime events using the `pubsub_token` returned in the Contact object.
- **WebSocket URL**: `wss://{domain}/cable`
- **Channel**: `RoomChannel`
- **Params**: `{ "pubsub_token": "{token}" }`
