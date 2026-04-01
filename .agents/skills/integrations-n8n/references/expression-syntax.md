# n8n Master Class: Expression Syntax

Este guia é a autoridade máxima para a escrita de expressões dinâmicas no n8n. **ERROS DE SINTAXE SÃO A CAUSA #1 DE FALHAS EM WORKFLOWS.**

## 💠 Formato das Expressões

Todo conteúdo dinâmico no n8n DEVE ser envolvido por **chaves duplas**:

```javascript
{{ expressão }}
```

- ✅ `{{ $json.email }}`
- ✅ `{{ $json.body.name }}`
- ✅ `{{ $node["HTTP Request"].json.data }}`
- ❌ `$json.email` (será tratado como texto literal)

---

## 🔑 Variáveis Core

### 1. `$json` - Saída do Nó Atual
Acessa os dados processados pelo nó onde a expressão está sendo escrita.
- `{{ $json.field }}`
- `{{ $json['field com espaco'] }}`
- `{{ $json.items[0].name }}`

### 2. `$node` - Referência a Outros Nós
Acessa dados de qualquer nó anterior no workflow.
- **Nomes de nós são Case-Sensitive.**
- **Nomes com espaços EXIGEM aspas e colchetes.**
- ✅ `{{ $node["HTTP Request"].json.data }}`
- ✅ `{{ $node["Webhook"].json.body.email }}`

### 3. `$now` - Timestamp Atual (Luxon)
- `{{ $now.toFormat('yyyy-MM-dd') }}`
- `{{ $now.plus({days: 7}) }}`

---

## 🚨 REGRA DE OURO: Estrutura de Webhook

**O ERRO MAIS COMUM:** Os dados do Webhook **NÃO** estão na raiz do JSON.

Os dados enviados pelo cliente ficam SEMPRE dentro da propriedade `.body`.

```javascript
// Estrutura de saída do nó Webhook:
{
  "headers": { ... },
  "params": { ... },
  "body": {          // ⚠️ SEUS DADOS ESTÃO AQUI
    "email": "user@exemplo.com"
  }
}

// Acesso Correto:
❌ ERRADO: {{ $json.email }}
✅ CORRETO: {{ $json.body.email }}
```

---

## 🚫 Onde NÃO usar {{ }}

### Nós de Código (Code Nodes)
Nós de código usam JavaScript puro. Usar `{{ }}` dentro de um Code Node causará erro de sintaxe.
- ❌ `const email = '{{ $json.email }}';`
- ✅ `const email = $json.email;` ou `const email = $input.item.json.email;`

---

## 🛠️ Manipulação de Dados (Dicas Rápidas)

| Tipo | Exemplo de Expressão |
| :--- | :--- |
| **String** | `{{ $json.name.toUpperCase() }}` |
| **Data** | `{{ $now.plus({hours: 24}).toISO() }}` |
| **Número** | `{{ ($json.price * 1.1).toFixed(2) }}` |
| **Condicional** | `{{ $json.status === 'pago' ? '✅' : '❌' }}` |
| **Default** | `{{ $json.email || 'contato@exemplo.com' }}` |

---

## 📋 Checklist de Validação

- [ ] A expressão está entre `{{ }}`?
- [ ] Se o nó de origem tem espaço, usei `["Nome do No"]`?
- [ ] Se é um Webhook, acessei via `.body`?
- [ ] Verifiquei o case-sensitive dos nomes dos campos?

---
*Referência consolidada para o Kit Supremo.*
