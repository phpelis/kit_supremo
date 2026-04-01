# Woovi API: Cobranças Pix (Charges)

Documentação técnica completa para criação e gestão de cobranças Pix Dinâmicas e Estáticas.

## Endpoint Principal
`POST /api/v1/charge`

## Payload de Criação (Mínimo)
```json
{
  "correlationID": "UUID-UNICO-DA-TRANSACAO",
  "value": 100 // Valor em centavos (mínimo 1 centavo)
}
```

## Payload de Criação (Completo)
| Campo | Tipo | Descrição |
|-------|------|-----------|
| `correlationID` | String | **Obrigatório**. Identificador único da transação no seu sistema. |
| `value` | Integer | **Obrigatório**. Valor em centavos. |
| `comment` | String | Comentário que aparecerá no extrato do cliente. |
| `customer` | Object | Dados do cliente (CNPJ/CPF, e-mail, nome). |
| `expiresIn` | Integer | Tempo de expiração em segundos (Padrão: 86400 / 24h). |
| `additionalInfo` | Array | Metadados extras (chave/valor). |

### Exemplo de Cliente (Customer)
```json
{
  "customer": {
    "name": "Cliente Exemplo",
    "email": "cliente@email.com",
    "taxID": "12345678909",
    "phone": "+5511999999999"
  }
}
```

## Resposta de Sucesso (201 Created)
```json
{
  "charge": {
    "status": "ACTIVE",
    "identifier": "ID-INTERNO-WOOVI",
    "correlationID": "UUID-ENVIADO",
    "brCode": "0002010102...", // Copia e Cola
    "qrCodeImage": "https://...", // Link da Imagem do QR Code
    "paymentLinkUrl": "https://...", // Link para checkout externo
    "expiresDate": "2024-...",
    "value": 100
  }
}
```

## Ciclo de Vida do Status
- `ACTIVE`: Cobrança aguardando pagamento.
- `COMPLETED`: Pagamento confirmado.
- `EXPIRED`: Tempo de expiração atingido sem pagamento.

## Consultar Cobrança
`GET /api/v1/charge/{id_ou_correlationID}`

---

> [!TIP]
> Use sempre o `correlationID` para evitar duplicidade de cobranças em caso de retentativas.
