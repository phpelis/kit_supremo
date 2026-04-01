# Knowledge Base: Chatwoot Integration

## Descrição
Este módulo fornece uma camada de integração robusta e tipada com a API v1 do Chatwoot. Foi projetado para ser reutilizável em qualquer projeto derivado do Kit Supremo.

## Componentes
- **`client.ts`**: Wrapper Axios para Contatos, Conversas e Mensagens.
- **`webhooks.ts`**: Validador de assinaturas HMAC-SHA256.
- **`types.ts`**: Interfaces TypeScript para todas as entidades principais.
- **`__tests__/`**: Suíte de testes baseada em mocks.

## Configuração Obrigatória (.env)
- `CHATWOOT_API_TOKEN`: Token de acesso à conta.
- `CHATWOOT_ACCOUNT_ID`: ID numérico da conta.
- `CHATWOOT_API_URL`: URL da instância (padrão: app.chatwoot.com).
- `CHATWOOT_WEBHOOK_SECRET`: Segredo para validação de webhooks.

## Fluxo de Sincronização Recomendado
1. **Identificação**: Use o `source_id` para vincular usuários do seu sistema a contatos no Chatwoot.
2. **Atualização**: Utilize atributos customizados (`custom_attributes`) para sincronizar metadados (como plano ou status de pagamento).
3. **Segurança**: Sempre utilize o `ChatwootWebhooks.validateSignature` nos seus handlers de expurgo/webhook.
