---
name: integrations-supabase
description: >
  CHILD SKILL — invoked ONLY by @core-master-orchestrator, do NOT auto-activate.
  Supabase database, auth, storage, edge functions, and realtime specialist for this
  project. Contains live documentation of ALL tables, columns, relationships, RLS
  policies, edge functions, and triggers. Use when ANY work involves database operations,
  authentication via Supabase Auth, file uploads via Supabase Storage, realtime
  subscriptions, edge functions, migrations, or queries. Also use when creating or
  modifying any feature that reads or writes data — the agent MUST consult this skill
  to know the exact table structure, column types, and relationships before writing
  any query. Invoke when user says "database", "table", "query", "supabase", "auth",
  "storage", "migration", "RLS", "edge function", "realtime", or when @implementation-safe-implementer
  detects a data operation in the subtask.
---

# Supabase — project database and backend

You are the Supabase specialist for this project. You know every table, every
column, every relationship, every RLS policy, and every edge function. You
consult the live reference files before writing ANY database-related code.

## Live reference files

These files are the source of truth for the database state. They live inside
the skill directory AND are mirrored to `.project-map/infrastructure/supabase/`
in the project for easy access.

```
.project-map/infrastructure/supabase/
├── schema.md              # ALL tables, columns, types, relationships
├── rls-policies.md        # Row Level Security policies per table
├── auth-config.md         # Supabase Auth setup (providers, redirects, hooks)
├── edge-functions.md      # Edge functions inventory and what each does
├── storage-buckets.md     # Storage buckets, policies, file types
├── realtime-channels.md   # Realtime subscriptions and what triggers them
├── triggers-and-hooks.md  # Database triggers, webhooks, scheduled functions
└── migrations-log.md      # Migration history (what changed and when)
```

## schema.md — the database bible

This is the most critical file. It documents EVERY table in exact detail.

```markdown
# Database schema

> Database: PostgreSQL (via Supabase)
> Last updated: {date}
> Total tables: {count}

## Table: users

> Purpose: Stores user accounts and profiles
> Auth: linked to auth.users via id
> RLS: enabled (see rls-policies.md)

| Column | Type | Nullable | Default | Description |
|--------|------|----------|---------|-------------|
| id | uuid | NO | auth.uid() | PK — links to auth.users |
| email | text | NO | — | User email (unique) |
| name | text | NO | — | Display name |
| avatar_url | text | YES | null | Profile picture URL (storage) |
| role | text | NO | 'user' | user / admin / manager |
| company_id | uuid | YES | null | FK → companies.id |
| chatwoot_contact_id | integer | YES | null | Chatwoot contact ID (sync) |
| created_at | timestamptz | NO | now() | Account creation date |
| updated_at | timestamptz | NO | now() | Last profile update |

Indexes:
- users_email_idx UNIQUE on (email)
- users_company_id_idx on (company_id)

Relationships:
- users.company_id → companies.id (many-to-one)
- users.id ← projects.owner_id (one-to-many)
- users.id ← payments.user_id (one-to-many)

---

## Table: projects

> Purpose: User projects
> RLS: enabled — users see only own projects or company projects

| Column | Type | Nullable | Default | Description |
|--------|------|----------|---------|-------------|
| id | uuid | NO | gen_random_uuid() | PK |
| name | text | NO | — | Project name |
| description | text | YES | null | Optional description |
| status | text | NO | 'active' | active / archived / deleted |
| owner_id | uuid | NO | — | FK → users.id |
| created_at | timestamptz | NO | now() | Creation date |
| updated_at | timestamptz | NO | now() | Last update |

Relationships:
- projects.owner_id → users.id (many-to-one)
- projects.id ← tasks.project_id (one-to-many)

---

## Table: payments

> Purpose: Payment records from Woovi (Pix, boleto)
> RLS: enabled — users see only own payments

| Column | Type | Nullable | Default | Description |
|--------|------|----------|---------|-------------|
| id | uuid | NO | gen_random_uuid() | PK |
| user_id | uuid | NO | — | FK → users.id |
| woovi_charge_id | text | NO | — | Woovi charge correlation ID |
| woovi_transaction_id | text | YES | null | Woovi transaction ID (after payment) |
| amount | integer | NO | — | Amount in cents (BRL) |
| status | text | NO | 'pending' | pending / paid / expired / refunded |
| method | text | NO | — | pix / boleto |
| paid_at | timestamptz | YES | null | When payment was confirmed |
| expires_at | timestamptz | YES | null | Payment expiry |
| metadata | jsonb | YES | '{}' | Extra data from Woovi webhook |
| created_at | timestamptz | NO | now() | Record creation |

Relationships:
- payments.user_id → users.id (many-to-one)

{... continue for ALL tables ...}
```

## How to read schema.md before ANY query

Before writing ANY Supabase query (select, insert, update, delete):

1. Open schema.md
2. Find the target table
3. Verify: column names, types, nullable, defaults
4. Check relationships: any FK to join?
5. Check RLS note: does the user have access?
6. THEN write the query

**Example — WRONG (without checking):**
```javascript
// Agent guesses column names — WILL BREAK
const { data } = await supabase
  .from('users')
  .select('username, profile_pic')  // WRONG: columns are "name" and "avatar_url"
```

**Example — CORRECT (after checking schema.md):**
```javascript
// Agent verified column names in schema.md
const { data } = await supabase
  .from('users')
  .select('name, avatar_url')  // Correct column names
```

## edge-functions.md format

```markdown
# Edge functions

## Function: process-woovi-webhook

- Location: supabase/functions/process-woovi-webhook/index.ts
- Trigger: POST /functions/v1/process-woovi-webhook
- Called by: Woovi webhook (payment status change)
- Input: Woovi webhook payload { event, charge, transaction }
- Actions:
  1. Validates Woovi webhook signature
  2. Finds payment by woovi_charge_id in payments table
  3. If event = "OPENPIX:CHARGE_COMPLETED":
     → Updates payments SET status='paid', paid_at=now(), woovi_transaction_id
     → Updates users SET plan='pro' WHERE id = payment.user_id (if subscription)
     → Sends Chatwoot message to contact: "Payment confirmed"
  4. If event = "OPENPIX:CHARGE_EXPIRED":
     → Updates payments SET status='expired'
- Errors: logs to edge function logs, returns 200 (to avoid Woovi retry loop)

## Function: sync-chatwoot-contact

- Location: supabase/functions/sync-chatwoot-contact/index.ts
- Trigger: Database trigger on users INSERT
- Actions:
  1. Creates contact in Chatwoot via API
  2. Updates users SET chatwoot_contact_id = {new contact id}
- Errors: logs error, does NOT block user creation
```

## triggers-and-hooks.md format

```markdown
# Database triggers and hooks

## Trigger: on_user_created

- Table: users
- Event: AFTER INSERT
- Calls: edge function sync-chatwoot-contact
- What it does:
  1. New user row is inserted
  2. Trigger fires the edge function
  3. Edge function creates Chatwoot contact
  4. Edge function updates users.chatwoot_contact_id

## Trigger: on_payment_updated

- Table: payments
- Event: AFTER UPDATE OF status
- Condition: NEW.status = 'paid' AND OLD.status = 'pending'
- Calls: edge function process-payment-confirmed
- What it does:
  1. Payment status changes from pending to paid
  2. Trigger fires the edge function
  3. Edge function activates user subscription
  4. Edge function sends confirmation via Chatwoot
```

## Update protocol — MANDATORY

When ANY database change happens, update the relevant file:

| Change | Update |
|--------|--------|
| New table | Add to schema.md with all columns, types, relationships |
| New column | Add to table in schema.md |
| Column removed | Remove from schema.md |
| Column type changed | Update in schema.md |
| New RLS policy | Add to rls-policies.md |
| New edge function | Add to edge-functions.md with full flow |
| New trigger | Add to triggers-and-hooks.md |
| New migration | Add to migrations-log.md |
| New storage bucket | Add to storage-buckets.md |

## Supabase client patterns

The project uses the Supabase JS client. Standard patterns:

```javascript
// Client setup — shared/config/supabase.ts
import { createClient } from '@supabase/supabase-js'
export const supabase = createClient(SUPABASE_URL, SUPABASE_ANON_KEY)

// SELECT with type safety
const { data, error } = await supabase
  .from('table_name')
  .select('column1, column2, relation(column3)')
  .eq('column', value)

// INSERT
const { data, error } = await supabase
  .from('table_name')
  .insert({ column1: value1, column2: value2 })
  .select()

// UPDATE
const { data, error } = await supabase
  .from('table_name')
  .update({ column1: newValue })
  .eq('id', recordId)
  .select()

// DELETE
const { error } = await supabase
  .from('table_name')
  .delete()
  .eq('id', recordId)

// REALTIME subscription
const channel = supabase
  .channel('channel-name')
  .on('postgres_changes', { event: 'UPDATE', schema: 'public', table: 'payments' },
    (payload) => { /* handle change */ })
  .subscribe()
```

Always handle { data, error } — never ignore the error.

## What NOT to do

- Never write a query without checking schema.md first
- Never guess column names or types
- Never create a table without documenting it in schema.md
- Never add a column without updating schema.md
- Never create an edge function without documenting its full flow
- Never modify RLS policies without updating rls-policies.md
- Never hardcode Supabase URL or keys — use shared/config
