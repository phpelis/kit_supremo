# n8n Master Class: JavaScript Guide (Code Node)

Este guia define os padrões de excelência para o uso do nó **Code (JavaScript)** no n8n. O uso de código permite transformações complexas que seriam impossíveis com nós padrão.

## 🚀 Regras de Ouro (Quick Start)

1. **Modo de Execução:** Use preferencialmente "Run Once for All Items" (executa uma vez para todos os itens).
2. **Acesso a Dados:** Use `$input.all()` para pegar todos os itens ou `$input.first()` para o primeiro.
3. **Formato de Retorno:** O n8n EXIGE que você retorne um array de objetos no formato `[{ json: { ... } }]`.
4. **Sem Chaves:** NUNCA use `{{ }}` dentro do nó de código. Use JavaScript puro.

---

## 📦 Padrões de Acesso a Dados

### Acessar Todos os Itens (Lote)
```javascript
const items = $input.all();
// items[0].json.campo_exemplo
```

### Acessar Dados de Outros Nós
```javascript
const dadosWebhook = $node["Webhook"].json.body;
```

### 🚨 Webhook Nesting
Lembre-se: dados de Webhook estão SEMPRE dentro de `.body`.
- ✅ `const email = $json.body.email;`
- ❌ `const email = $json.email;` (retornará undefined)

---

## 🛠️ Helpers Integrados

### Luxon (Datas)
O n8n já traz o `DateTime` do Luxon para você.
```javascript
const hoje = DateTime.now().toFormat('yyyy-MM-dd');
const amanha = DateTime.now().plus({ days: 1 }).toISO();
```

### HTTP Requests via Código
Útil para chamadas de API customizadas dentro da lógica.
```javascript
const response = await $helpers.httpRequest({
  method: 'GET',
  url: 'https://api.exemplo.com/dados',
  headers: { 'Authorization': 'Bearer ...' }
});
```

---

## 🔄 Exemplo: Transformação de Lote (Padrão de Elite)

```javascript
// 1. Captura todos os itens de entrada
const items = $input.all();

// 2. Filtra e Transforma de forma funcional
const result = items
  .filter(item => item.json.status === 'ativo')
  .map(item => ({
    json: {
      id: item.json.id,
      nome_upper: item.json.nome.toUpperCase(),
      processado_em: DateTime.now().toISO()
    }
  }));

// 3. Retorna o array no formato exigido
return result;
```

---

## 📋 Checklist de Code Review

- [ ] Usei `return [{ json: { ... } }]`?
- [ ] Verifiquei se o dado do Webhook vem de `.body`?
- [ ] Adicionei verificações de "null/undefined" para evitar que o workflow pare?
- [ ] Preferi métodos de array (`map`, `filter`) sobre loops `for` manuais?
- [ ] Removi qualquer tentativa de usar `{{ }}`?

---
*Referência consolidada para o Kit Supremo.*
