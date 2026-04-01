---
name: integrations-woovi
description: Woovi (OpenPix) Payment Integration Master Class - Pix, Charges, Webhooks, and Financial Lifecycle.
---

# Woovi Master Class Specialist

Este skill é o especialista definitivo em integrações com a Woovi (OpenPix) para o Kit Supremo. Ele contém conhecimento profundo e auto-suficiente sobre toda a API de pagamentos Pix, eliminando a necessidade de pesquisas externas.

## 🎯 Gatilhos de Ativação
- Usuário menciona "Woovi", "OpenPix", "Pix", "Cobrança Pix", "Pagamento Pix", "Webhook Woovi".
- Tarefas envolvendo criação de QR Codes dinâmicos ou estáticos.
- Necessidade de validar assinaturas de webhooks (`x-webhook-signature`).
- Implementação de estornos ou assinaturas recorrentes.

## 📚 Biblioteca de Referência Técnica (Master Class)

Para executar qualquer tarefa técnica, o agente **DEVE** consultar os módulos abaixo:

### 1. [Cobranças (Charges)](file:///c:/Users/phpel/OneDrive/Documentos/kit_supremo/.agents/skills/integrations-woovi/references/api-charges.md)
Detalhes sobre `POST /api/v1/charge`, payloads, respostas (`brCode`, `qrCodeImage`) e ciclo de vida.

### 2. [Webhooks e Eventos](file:///c:/Users/phpel/OneDrive/Documentos/kit_supremo/.agents/skills/integrations-woovi/references/api-webhooks.md)
Catálogo completo de eventos (`CHARGE_COMPLETED`, `MOVEMENT_CONFIRMED`) e payloads de processamento.

### 3. [Segurança e Assinaturas](file:///c:/Users/phpel/OneDrive/Documentos/kit_supremo/.agents/skills/integrations-woovi/references/api-security.md)
Guia crítico de validação **RSA-SHA256** com a Chave Pública da Woovi e validação **HMAC-SHA256**.

### 4. [Reembolsos (Refunds)](file:///c:/Users/phpel/OneDrive/Documentos/kit_supremo/.agents/skills/integrations-woovi/references/api-refunds.md)
Lógica de estorno total/parcial e idempotência de reembolsos.

### 5. [Assinaturas (Subscriptions)](file:///c:/Users/phpel/OneDrive/Documentos/kit_supremo/.agents/skills/integrations-woovi/references/api-subscriptions.md)
Configuração de pagamentos recorrentes e Pix Automático.

## 🛠️ Diretrizes de Implementação
- **Idempotência**: Sempre use `correlationID` gerado pelo cliente.
- **Segurança**: Nunca processe um webhook sem validar a assinatura RSA.
- **Ambiente**: Use `api.woovi.com` para produção e configure as keys via variáveis de ambiente.

### 1. Project Alignment (MANDATORY)
Before writing any code, consult:
- `c:\Users\phpel\OneDrive\Documentos\kit_supremo\.project-map\infrastructure\woovi\config.md` for environment details (Sandbox vs Prod).
- `c:\Users\phpel\OneDrive\Documentos\kit_supremo\.project-map\infrastructure\woovi\credentials.md` for `AppID` references.

### 2. Implementation Loop
1. **Define Charge**: Determine `value` (in cents) and `correlationID` (unique UUID/Internal ID).
2. **Handle Payload**: Ensure customer data (CPF/CNPJ) is valid.
3. **Webhook Setup**: Implement the listener first to catch the `CHARGE_PAID` event.
4. **Safety Check**: Always use `.env` for the `AppID`.

---

## 📚 Technical Reference Library

### 1. [API Core & Auth](file:///c:/Users/phpel/OneDrive/Documentos/kit_supremo/.agents/skills/integrations-woovi/references/api-core.md)
- **Header**: `Authorization: <AppID>`
- **Endpoints**: `https://api.woovi.com/` | `https://api.woovi-sandbox.com/`

### 2. [Charges & Pix](file:///c:/Users/phpel/OneDrive/Documentos/kit_supremo/.agents/skills/integrations-woovi/references/charges-pix.md)
- **POST `/api/v1/charge`**: Creating dynamic QR Codes.
- **Parameters**: `value`, `correlationID`, `type: PIX_CREDIT`.

### 3. [Webhook Security](file:///c:/Users/phpel/OneDrive/Documentos/kit_supremo/.agents/skills/integrations-woovi/references/webhook-security.md)
- **Signature Verification**: Validating parity with the secret.
- **Events**: `CHARGE_CREATED`, `CHARGE_PAID`, `CHARGE_OVERDUE`.

### 4. [Customers & Refunds](file:///c:/Users/phpel/OneDrive/Documentos/kit_supremo/.agents/skills/integrations-woovi/references/customers-refunds.md)
- **Refunds**: `/api/v1/refund`.
- **Metadata**: Attaching custom data to charges.

---

> [!IMPORTANT]
> **CorrelationID is your North Star**. Never create a charge without a `correlationID` that maps back to your internal database ID. This is the only way to ensure 100% reconciliation accuracy.

> [!WARNING]
> **Values are in Cents**. $10.00 is `1000`. Double-check all numerical inputs to avoid financial drift.
