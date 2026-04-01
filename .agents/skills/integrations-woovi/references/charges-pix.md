# Woovi Charges & Pix Management

## 💸 Create Dynamic Charge (Pix)
The most common operation in the Woovi ecosystem:

- **Endpoint**: `POST /api/v1/charge`
- **Payload Structure**:
```json
{
  "correlationID": "ORDER_123",
  "value": 1000,
  "type": "DYNAMIC", // For unique per-order QR Codes
  "comment": "Pagamento Pedido #123",
  "expiresIn": 3600, // Seconds (1 hour)
  "customer": {
    "name": "Fulano de Tal",
    "taxID": "123.456.789-00", // CPF or CNPJ
    "email": "fulano@example.com"
  }
}
```

## 🏦 Charge Status Lifecycle
- **`ACTIVE`**: Waiting for payment.
- **`COMPLETED`**: Paid successfully.
- **`EXPIRED`**: Not paid within time.

## 🔄 Fetch Charge
- **GET `/api/v1/charge/:id`** or **GET `/api/v1/charge?correlationID=ORDER_123`**

---

> [!TIP]
> **Dynamic vs Static**: Always prefer **DYNAMIC** for e-commerce. Static is for physical stores or fixed-price donations.

> [!IMPORTANT]
> **CorrelationID Persistence**: Save the `correlationID` in your local database *before* calling the API.
