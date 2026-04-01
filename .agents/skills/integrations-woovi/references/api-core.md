# Woovi API Core & Authentication

## 🔐 Auth Protocol
Woovi uses an **AppID** (Application ID) for all requests. Generate this in the [Woovi Dashboard](https://app.woovi.com/) under "API Configuration".

- **Header**: `Authorization: <AppID>`
- **Content-Type**: `application/json`

## 🌍 Environments
| Environment | Base URL | Verification |
| :--- | :--- | :--- |
| **Production** | `https://api.woovi.com/` | Real money |
| **Sandbox** | `https://api.woovi-sandbox.com/` | Sandbox testing |

---

## 🔢 Data Standards
- **Values**: Integers in **cents**. R$ 1.00 = `100`.
- **Dates**: ISO 8601 UTC.
- **IDs**: 
  - `correlationID`: **YOUR** unique ID (UUID recommended).
  - `chargeID`: **Woovi's** unique ID.

---

## ⚡ Quick Test (Node.js)
```javascript
const response = await fetch('https://api.woovi.com/api/v1/charge', {
  method: 'POST',
  headers: {
    'Authorization': process.env.WOOVI_APP_ID,
    'Content-Type': 'application/json'
  },
  body: JSON.stringify({
    correlationID: crypto.randomUUID(),
    value: 1000, // R$ 10.00
    type: 'DYNAMIC'
  })
});
```
