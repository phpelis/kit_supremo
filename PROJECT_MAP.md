# PROJECT MAP: Kit Supremo Architecture

Este mapa serve como o "Cinto de Utilidades" para Agentes de IA operarem neste repositório com máxima precisão.

---

## 📂 Pasta Principal: `.agents/`

| Diretório | Conteúdo e Função |
|-----------|-------------------|
| `skills/` | **Capabilities.** Biblioteca de Habilidades Master (Especialistas). |
| `skills/methodology/` | **Process.** Fluxo Superpowers (Brainstorm, Plan, TDD, Verify). |
| `workflows/` | **Commands.** Slash commands para Claude Code e Antigravity. |
| `rules/` | **Policy.** Regras mestre ([MASTER.md](file:///c:/Users/phpel/OneDrive/Documentos/kit_supremo/.agents/rules/MASTER.md)). |
| `engine/` | **Brains.** Scripts Python para indexação e consultas (`ag-refresh`, `ag-ask`). |

---

## 📂 Pasta de Contexto: `.context/`

| Arquivo | Função |
|---------|--------|
| `ARCHITECTURE.md` | Detalhes da integração técnica dos Três Pilares. |
| `chatwoot.md` | Contexto de negócio específico da integração Chatwoot. |
| `*.md` | Conhecimento especializado ad-hoc do projeto. |

---

## 🛠️ Comandos de Fluxo de Trabalho (Workflows)

| Comando | Gatilho | Objetivo |
|---------|---------|----------|
| `/brainstorm` | `methodology/brainstorming` | Iniciar Socratic Gate e Specs. |
| `/plan` | `methodology/writing-plans` | Gerar Implementation Plan detalhado. |
| `/test` | `methodology/test-driven-development` | Iniciar ciclo RED-GREEN-REFACTOR. |
| `/align` | `workflows/align` | Auditoria completa e alinhamento do projeto. |
| `/verify` | `methodology/verification-re-completion` | Check final de qualidade. |

---

## 📏 Regras Mestre (Master Rules)

1.  **Limites de Arquivo:** Máximo de 200 linhas per file (Refatoração obrigatória).
2.  **Segurança e Infra:** Dados de instância em `references/infrastructure.md` dentro de cada Skill.
3.  **Clean Code:** SOLID, DRY, KISS em todas as gerações.
4.  **TDD:** NUNCA escreva código de produção sem um teste que falha primeiro.

---
*Assinado: Arquiteto Supremo*
