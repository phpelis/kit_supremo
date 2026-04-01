# n8n Master Class: Validation Expert

Este guia define os protocolos para interpretação e correção de erros de validação no n8n. A validação não é um evento único, mas um **ciclo iterativo**.

## 🔄 O Ciclo de Validação Supremo

O padrão de sucesso para configurar um nó envolve geralmente 2 a 3 ciclos:
1.  **Configurar** o nó.
2.  **Validar** via `validate_node` (perfil `runtime`).
3.  **Ler** as mensagens de erro (elas contêm a solução).
4.  **Corrigir** as propriedades apontadas.
5.  **Re-validar** até que `valid: true`.

---

## 🚦 Níveis de Severidade

### 1. Erros (Must Fix) 🔴
Bloqueiam a execução do workflow. Devem ser resolvidos antes da ativação.
- `missing_required`: Falta um campo obrigatório.
- `type_mismatch`: Tipo de dado errado (ex: string em campo de número).
- `invalid_expression`: Erro de sintaxe na expressão `{{ }}`.

### 2. Avisos (Should Fix) 🟡
Não bloqueiam a execução, mas indicam problemas potenciais.
- Melhores práticas (ex: falta de tratamento de erro ou retry).
- Depreciação de recursos.

### 3. Sugestões (Optional) 🔵
Dicas de otimização para tornar o workflow mais eficiente.

---

## 🎭 Perfis de Validação

Sempre escolha o perfil adequado para a fase do seu projeto:

- **`minimal`:** Apenas campos obrigatórios. Use para rascunhos rápidos.
- **`runtime` (RECOMENDADO):** Valida tipos, valores e dependências. Ideal para pré-deploy.
- **`strict`:** Máxima segurança. Valida até performance e melhores práticas.

---

## 🛠️ Sistema de Auto-Sanitização

O n8n corrige automaticamente problemas estruturais de operadores ao salvar o workflow:
- **Operadores Binários (ex: equals):** Remove a propriedade `singleValue`.
- **Operadores Unários (ex: isEmpty):** Adiciona `singleValue: true`.
- **Nós IF/Switch:** Adiciona metadados de condições faltantes.

> [!TIP]
> Deixe o sistema de auto-sanitização cuidar da estrutura dos operadores. Foque na lógica de negócio e nos valores das expressões.

---

## 📋 Checklist de Validação Final

- [ ] O campo `valid` retornou `true`?
- [ ] Resolvi todos os erros críticos (`errors`)?
- [ ] Revisei os avisos (`warnings`) e decidi se são aceitáveis?
- [ ] Se for um nó de código, testei o formato de saída `[{ json: {} }]`?

---
*Referência consolidada para o Kit Supremo.*
