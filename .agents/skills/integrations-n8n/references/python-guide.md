# n8n Master Class: Python Guide (Code Node)

Este guia define os padrões para o uso do nó **Code (Python)** no n8n. Embora o JavaScript seja a primeira escolha no n8n, o Python é poderoso para manipulações lógicas e estatísticas avançadas.

## ⚠️ Regra de Ouro: JavaScript Primeiro
**Recomendação:** Use JavaScript para 95% dos casos. Use Python apenas se precisar de funções específicas da biblioteca padrão do Python ou se tiver lógica estatística complexa.

---

## 🚀 Diferenças Críticas de Sintaxe

No Python (versão Beta do n8n), os helpers usam **underline** (`_`) em vez de cifrão (`$`):

- ✅ `items = _input.all()` (Em JS: `$input.all()`)
- ✅ `body = _json["body"]` (Em JS: `$json.body`)
- ✅ `now = _now` (Em JS: `$now`)

---

## 🚫 Limitações de Bibliotecas
O n8n **NÃO** permite a importação de bibliotecas externas no nó de código Python.
- ❌ `import requests` (Não funciona)
- ❌ `import pandas` (Não funciona)
- ✅ `import json`, `import datetime`, `import re`, `import statistics` (Funcionam - Standard Library)

---

## 📦 Padrões de Acesso e Retorno

### Acesso a Dados
```python
# Todos os itens
items = _input.all()

# Primeiro item
first_item = _input.first()

# Webhook (Lembre-se do .body)
email = _json.get("body", {}).get("email")
```

### Formato de Retorno (Obrigatório)
Deve retornar uma lista de dicionários com a chave `"json"`.
```python
return [{
    "json": {
        "resultado": "sucesso",
        "valor": 100
    }
}]
```

---

## 🔄 Exemplo: Processamento estatístico
```python
import statistics

items = _input.all()
valores = [item["json"].get("valor", 0) for item in items]

if valores:
    return [{
        "json": {
            "media": statistics.mean(valores),
            "mediana": statistics.median(valores),
            "contagem": len(valores)
        }
    }]
return []
```

---

## 📋 Checklist de Code Review (Python)

- [ ] Usei `_input` em vez de `$input`?
- [ ] O retorno é uma lista `[]` de dicionários `{"json": ...}`?
- [ ] Usei `.get()` para acessar campos (evita erros se o campo não existir)?
- [ ] Removi qualquer importação de biblioteca externa?
- [ ] Verifiquei se o dado do Webhook vem de `["body"]`?

---
*Referência consolidada para o Kit Supremo.*
