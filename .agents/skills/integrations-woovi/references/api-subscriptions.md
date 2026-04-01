# Woovi API: Assinaturas e Recorrência

Guia para implementar pagamentos recorrentes (Pix Automático ou Cobranças Recorrentes).

## Endpoint Principal
`POST /api/v1/subscriptions`

## Fluxo de Funcionamento
1. **Criação da Assinatura**: Você define o valor, o cliente e o dia de faturamento.
2. **Geração automática**: A Woovi gera uma nova cobrança Pix no dia configurado (`dayGenerateCharge`).
3. **Notificação**: Sua aplicação recebe webhooks de `PIX_AUTOMATIC_COBR_CREATED` e `PIX_AUTOMATIC_COBR_COMPLETED`.

## Payload de Criação
```json
{
  "value": 5000, // Valor em centavos (Ex: R$ 50,00)
  "dayGenerateCharge": 5, // Dia do mês (0-27)
  "customer": {
    "name": "Assinante Exemplo",
    "email": "assinante@email.com",
    "taxID": "12345678909",
    "phone": "+5511999999999"
  }
}
```

## Resposta de Sucesso
```json
{
  "subscription": {
    "globalID": "ID-UNICO-ASSINATURA",
    "value": 5000,
    "customer": {
      "name": "Assinante Exemplo",
      "email": "assinante@email.com",
      "taxID": { "taxID": "12345678909", "type": "BR:CPF" }
    },
    "dayGenerateCharge": 5
  }
}
```

## Gestão da Assinatura
- **Listar Assinaturas**: `GET /api/v1/subscriptions`
- **Detalhar Assinatura**: `GET /api/v1/subscriptions/{id}`
- **Cancelar Assinatura**: `DELETE /api/v1/subscriptions/{id}`

---

> [!IMPORTANT]
> O dia de geração (`dayGenerateCharge`) deve ser entre **0 e 27**. Para cobranças que venceriam no dia 28, 29, 30 ou 31, a Woovi recomenda configurar o dia 27 ou o dia 1 do mês seguinte para evitar problemas com fevereiro.
