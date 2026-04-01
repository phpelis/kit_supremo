# Woovi API: Reembolsos (Refunds)

Guia para estornos totais ou parciais de cobranças pagas via Pix.

## Endpoint Principal
`POST /api/v1/charge/{identifier_ou_correlationID}/refund`

## Requisitos de Idempotência
Diferente das cobranças, o reembolso requer um `correlationID` gerado por você para identificar a **operação de estorno**, evitando que o mesmo reembolso seja processado duas vezes.

## Payload de Criação
```json
{
  "correlationID": "ID-UNICO-DO-ESTORNO",
  "value": 100, // Opcional. Se omitido, estorna o valor total ou restante.
  "comment": "Motivo do estorno" // Opcional (max 140 chars).
}
```

## Resposta de Sucesso
```json
{
  "refund": {
    "status": "IN_PROCESSING",
    "value": 100,
    "correlationID": "ID-UNICO-DO-ESTORNO",
    "endToEndId": "E23114...", // Referência bancária do estorno
    "time": "2024-03-02T17:28:51.882Z",
    "comment": "Motivo do estorno"
  }
}
```

## Webhooks de Conferência
O ciclo de vida do reembolso é notificado via:
- `PIX_TRANSACTION_REFUND_SENT_CONFIRMED`: Reembolso enviado com sucesso.
- `PIX_TRANSACTION_REFUND_SENT_REJECTED`: Falha no envio do reembolso.

---

> [!CAUTION]
> Reembolsos são irreversíveis. Certifique-se de validar o saldo da conta antes de solicitar via API.
