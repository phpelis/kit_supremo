# n8n Master Class: Node Configuration

Este guia define a estratégia de descoberta e configuração de nós para garantir workflows válidos e eficientes. A configuração no n8n é **contextual**: campos aparecem ou desaparecem baseados na operação selecionada.

## 🎯 Filosofia de Configuração
**Divulgação Progressiva:** Comece com o mínimo necessário e adicione complexidade conforme a necessidade. Não tente configurar todos os campos opcionais de uma vez.

---

## 🛠️ Fluxo de Trabalho de Configuração

### 1. Identificação (Recurso + Operação)
A combinação de **Resource** (O que?) e **Operation** (Como?) define quais campos serão obrigatórios.
- **Exemplo Slack:**
    - Recurso `message` + Operação `post` → Exige `channel` e `text`.
    - Recurso `message` + Operação `update` → Exige `messageId` e `text`.

### 2. Descoberta de Propriedades
Sempre consulte os detalhes do nó antes de configurar:
- Ao usar ferramentas MCP, use `get_node` para ver os campos obrigatórios da operação escolhida.

### 3. Dependências de Propriedades
Cuidado com campos "invisíveis" que se tornam obrigatórios:
- **Exemplo HTTP:** Mudar o método para `POST` fará o campo `sendBody` aparecer. Ativar `sendBody` fará o campo `body` se tornar obrigatório.

---

## 🚦 Padrões por Tipo de Nó

| Categoria | Exemplo | Dependência Comum |
| :--- | :--- | :--- |
| **Recurso/Op** | Slack, Google Sheets | Operação define os campos de entrada. |
| **HTTP-Based** | HTTP Request, Webhook | Método define se há corpo (`body`) ou query params. |
| **Database** | Postgres, Supabase | Operação `insert` exige tabela; `query` exige SQL. |
| **Lógica** | IF, Switch | Operador (`isEmpty` vs `equals`) define se precisa de 1 ou 2 valores. |

---

## 💡 Dicas de Especialista

- **Validação Iterativa:** Configure o Recurso/Operação → Valide → Corrija erros → Adicione opcionais.
- **Autenticação:** Nunca configure chaves de API em expressões. Use o sistema de **Credentials** do n8n.
- **Fallback:** Para campos obrigatórios que podem vir vazios, use o padrão de default: `{{ $json.campo || 'valor_padrao' }}`.

---

## 📋 Checklist de Configuração

- [ ] Selecionei o recurso e a operação corretos?
- [ ] Preenchi todos os campos marcados como obrigatórios para esta operação?
- [ ] Verifiquei se existem dependências (ex: ativei `sendBody` se vou enviar um JSON)?
- [ ] Validei a configuração antes de tentar rodar o workflow?

---
*Referência consolidada para o Kit Supremo.*
