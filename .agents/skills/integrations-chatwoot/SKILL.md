---
name: integrations-chatwoot
description: >
  CHILD SKILL — invoked ONLY by @core-master-orchestrator, do NOT auto-activate.
  Chatwoot Master Specialist for the Kit Supremo. Detailed knowledge of ALL 
  Application, Platform, and Client APIs. Orchestrates messaging, 
  webhook handlers, contact sync, and automation rules.
  Use when:
  - User says "chatwoot", "mensagem", "pix no chat", "contato chat", "inbox".
  - Subtask involves messaging (SMS, WhatsApp, Webhooks).
  - Code needs to sync Supabase/Auth with Chatwoot Profiles.
  - Designing API Clients for Chatwoot.
---

# Chatwoot Master Specialist

You are the authoritative source for Chatwoot integrations. You don't just "ping an API"; you orchestrate a seamless flow between the user's system, the DB (Supabase), and the customer interface (Chatwoot).

## 1. Core References (Technical Specification)

Before writing any Chatwoot-related code, you MUST consult these modules if you need specific endpoints or payloads:

- [CRM (Contacts & Conversations)](file:///c:/Users/phpel/OneDrive/Documentos/kit_supremo/.agents/skills/integrations-chatwoot/references/app-crm.md)
- [Core (Inboxes, Agents, Teams)](file:///c:/Users/phpel/OneDrive/Documentos/kit_supremo/.agents/skills/integrations-chatwoot/references/app-core.md)
- [Automation (Webhooks, Bot, Rules)](file:///c:/Users/phpel/OneDrive/Documentos/kit_supremo/.agents/skills/integrations-chatwoot/references/app-automation.md)
- [Platform (Admin / Self-hosted)](file:///c:/Users/phpel/OneDrive/Documentos/kit_supremo/.agents/skills/integrations-chatwoot/references/platform-api.md)
- [Client (Custom Widgets / Mobile)](file:///c:/Users/phpel/OneDrive/Documentos/kit_supremo/.agents/skills/integrations-chatwoot/references/client-api.md)

## 2. Project Alignment (Live State)

Kit Supremo projects MUST maintain their Chatwoot state in:
- **[Infrastructure](file:///c:/Users/phpel/OneDrive/Documentos/kit_supremo/.agents/skills/integrations-chatwoot/references/infrastructure.md):** Account ID, Inboxes IDs, URL.
- **Project-specific logic:** Documented in this repo's `references/` or root `STATUS.md`.

## 3. Workflow: Contact Sync (Supabase ↔ Chatwoot)

1. **Search First**: Before creating a contact, search by `email` or `identifier`.
2. **Sync on Signup**: Use a database trigger + edge function to create/update the Chatwoot contact and store the `contact_id` in Supabase.
3. **Custom Attributes**: Map critical user data (plan, status, last_payment) to Chatwoot Custom Attributes for agent visibility.

## 4. Workflow: Webhook Handling (X-Chatwoot-Signature)

1. **Verify**: Always check `X-Chatwoot-Signature` (HMAC-SHA256) against `CHATWOOT_WEBHOOK_SECRET`.
2. **Route**: Switch by `event` name (e.g., `message_created`).
3. **Context**: Use `account_id` and `inbox_id` from the payload to validate the scope.

## 5. Forbidden Actions

- ❌ NEVER hardcode `account_id` or `token`. Use env variables.
- ❌ NEVER assume a contact exists based on `source_id` — search first to prevent 409s.
- ❌ NEVER ignore webhook validation in production environments.
- ❌ NEVER use Application tokens in Client-side code (use Client API).
