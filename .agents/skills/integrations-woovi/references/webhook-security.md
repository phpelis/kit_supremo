# Woovi Webhook & Security

## 🛰️ Webhook Flow
Webhooks are essential for **Real-Time Payment Confirmation**. Without them, you'd have to poll the API (inefficient).

- **Events**:
  - `CHARGE_PAID`: The user finished the Pix payment.
  - `CHARGE_CREATED`: Confirmed creation of dynamic charge.
  - `CHARGE_OVERDUE`: Charge expired.

## 🛡️ Digital Signature Verification
To prevent **Man-in-the-Middle** attacks, Woovi sends a signature header. You MUST verify it using your Webhook Secret.

- **Header**: `x-woovi-signature` (HMAC SHA256 of the body).
- **Format**: `signature=<hash>`

## 📥 Sample Webhook Payload
```json
{
  "event": "OPENPIX:CHARGE_PAID",
  "charge": {
    "correlationID": "ORDER_123",
    "value": 1000,
    "status": "COMPLETED",
    "payment": {
      "value": 1000,
      "paidAt": "2026-04-01T16:00:00.000Z",
      "transactionID": "E1234..."
    }
  }
}
```

---

> [!IMPORTANT]
> **Idempotency**: Always check if the `transactionID` or `correlationID` has already been processed in your database to avoid double-crediting.
