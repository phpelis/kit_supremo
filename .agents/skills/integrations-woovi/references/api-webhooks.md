# Woovi API: Webhooks e Eventos

Guia de integração para recebimento de notificações em tempo real.

## Configuração Necessária
Os webhooks devem ser configurados no dashboard da Woovi, apontando para sua URL de callback.

## Catálogo de Eventos Principais
| Evento | Gatilho |
|--------|---------|
| `OPENPIX:CHARGE_COMPLETED` | Cobrança Pix paga com sucesso. |
| `OPENPIX:CHARGE_EXPIRED` | Cobrança expirou sem pagamento. |
| `OPENPIX:TRANSACTION_RECEIVED` | Transação Pix recebida (geral ou QR Estático). |
| `PIX_AUTOMATIC_APPROVED` | Autorização de Pix Automático concedida. |

## Estrutura do Payload (`CHARGE_COMPLETED`)
```json
{
  "event": "OPENPIX:CHARGE_COMPLETED",
  "charge": {
    "status": "COMPLETED",
    "value": 100, // em centavos
    "correlationID": "SEU-UUID-UNICO",
    "transactionID": "ID-DA-TRANSACAO-PIX",
    "paidAt": "2024-03-24T15:07:50.891Z",
    "customer": {
      "name": "Nome do Cliente",
      "taxID": { "taxID": "12345678909", "type": "BR:CPF" }
    }
  },
  "pix": {
    "endToEndId": "Efa8df...", // ID único do Banco Central
    "time": "2024-03-24T15:07:50.891Z"
  }
}
```

## Regras de Processamento (Idempotência)
1. **Sempre verifique o `correlationID`**: Garanta que você não está processando o mesmo pagamento duas vezes.
2. **Responda `200 OK` rapidamente**: A Woovi tem um timeout de 5-10 segundos. Faça o processamento pesado em background.
3. **Retentativas**: Se o seu servidor falhar (não retornar 2xx), a Woovi tentará reenviar o webhook seguindo um backoff exponencial.

---

> [!IMPORTANT]
> Nunca confie apenas no payload. **Sempre valide a assinatura** do webhook (veja `api-security.md`).
