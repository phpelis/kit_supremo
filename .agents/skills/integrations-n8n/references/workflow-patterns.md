# n8n Master Class: Workflow Patterns

Este módulo define os padrões arquiteturais de elite para a construção de workflows no n8n. **SEMPRE** consulte este guia antes de projetar a estrutura de uma nova automação.

## 🏗️ Os 5 Padrões Core

### 1. Webhook Processing (Mais Comum)
Recepção de gatilhos externos e processamento imediato.
- **Fluxo:** `Webhook → Validate → Transform → Respond/Notify`
- **Uso:** Integrações de pagamento (Woovi), Comandos Slack, Form submissions.
- **Detalhes:** [webhook_processing.md](file:///c:/Users/phpel/OneDrive/Documentos/kit_supremo/.agents/skills/integrations-n8n/references/webhook-processing.md)

### 2. HTTP API Integration
Busca e sincronização de dados entre serviços REST.
- **Fluxo:** `Trigger → HTTP Request → Transform → Action → Error Handler`
- **Uso:** Sincronização CRM (Chatwoot), enriquecimento de dados via APIs externas.

### 3. Database Operations
Sincronização e manipulação direta de dados (Postgres/Supabase).
- **Fluxo:** `Schedule → Query → Transform → Write → Verify`
- **Uso:** ETLs, backups, sincronização de estados complexos.

### 4. AI Agent Workflow
Workflows inteligentes com agentes, ferramentas e memória.
- **Fluxo:** `Trigger → AI Agent (Model + Tools + Memory) → Output`
- **Uso:** Chatbots dinâmicos, análise de sentimentos, automação cognitiva.

### 5. Scheduled Tasks
Automações recorrentes e manutenção de sistema.
- **Fluxo:** `Schedule → Fetch → Process → Deliver → Log`
- **Uso:** Relatórios diários, limpeza de dados, verificações de integridade.

---

## 🚦 Guia de Seleção de Padrões

| Necessidade | Padrão Recomendado |
| :--- | :--- |
| Receber dados externos instantaneamente | **Webhook Processing** |
| Sincronizar ferramentas de terceiros | **HTTP API Integration** |
| Processar grandes volumes de dados (ETL) | **Database Operations** |
| Automação com raciocínio multi-etapa | **AI Agent Workflow** |
| Tarefas de manutenção ou relatórios periódicos | **Scheduled Tasks** |

---

## 📋 Checklist de Criação Supremo

### Fase de Planejamento
- [ ] Identificar o padrão correto.
- [ ] Listar nós necessários (use `search_nodes`).
- [ ] Planejar a estratégia de tratamento de erros (Error Trigger ou Continue On Fail).

### Fase de Implementação
- [ ] Configurar Gatilho (Webhook/Schedule).
- [ ] Isolar autenticação em Credenciais (NUNCA em parâmetros).
- [ ] Adicionar nós de transformação (Set, Code, IF).

### Fase de Validação
- [ ] Validar nós individualmente (`validate_node`).
- [ ] Validar workflow completo (`validate_workflow`).
- [ ] Testar com dados reais em ambiente de sandbox.

---

## ⚠️ Gotchas & Regras de Ouro

1. **Estrutura Webhook:** Lembre-se que dados de Webhook entram em `$json.body`.
2. **Execute Once:** Se um nó processa múltiplos itens mas você só quer o primeiro, use `{{$json[0].field}}`.
3. **Erros:** Nunca ignore o ramo de erro. Conecte-o a um `Error Trigger` ou logue o erro.
4. **Iteração:** Não tente construir tudo de uma vez. Evolua o fluxo nó a nó.

---

*Baseado no conhecimento consolidado do Kit Supremo e n8n-skills community.*
