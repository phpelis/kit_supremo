# Kit Supremo — Master Configuration

Este é o cérebro do Kit Supremo, integrando `superpowers`, `antigravity-workspace-template` e `antigravity-kit`.

## 🛠️ Environment Setup
- **Work Directory**: `.agents/`
- **Cognitive Engine**: Python 3.10+ (scripts em `.agents/engine/`)
- **Knowledge Base**: `.context/`
- **IDEs Suportadas**: Antigravity, Cursor, Claude Code Extension

## 🚀 Commands
- **Install/Init**: `powershell -ExecutionPolicy Bypass -File setup-kit.ps1`
- **Knowledge Refresh**: `python .agents/engine/ag-refresh.py`
- **Intelligent Ask**: `python .agents/engine/ag-ask.py "<query>"`
- **Test Execution**: `npm test` ou `pytest` (dependendo do projeto)

## 🧠 AI System (Skills & Agents)
Este repositório utiliza o sistema de Habilidades (Skills) do Antigravity.
- **Location**: `.agents/skills/`
- **Skill Management**: Always use `skill-creator` (`.agents/skills/skill-creator/SKILL.md`) when modifying or creating skills.
- **Usage**: A IA descobre e ativa habilidades automaticamente com base na tarefa.
- **Methodology**: Seguimos o rigor do `superpowers`:
    1. **Brainstorming** (`/brainstorm` ou skill `methodology/brainstorming`)
    2. **Planning** (`/plan` ou skill `methodology/writing-plans`)
    3. **Implementation** (TDD obrigatório via skill `methodology/test-driven-development`)
    4. **Verification** (Skill `methodology/verification-before-completion`)

## 📝 Coding Standards
- **DRY/KISS/YAGNI**: Otimização máxima, evitar sobre-engenharia.
- **Separation of Concerns**: Arquivos focados, limite ideal de 200 linhas.
- **Type Safety**: TypeScript obrigatório para projetos JS.
- **Documentation**: Todo novo recurso deve ser documentado em `.context/` via `ag-refresh`.
- **skill-creator**: Skill design and maintenance expert.

## ⚠️ Strong Rules
- **Não pule o Brainstorming**: Mesmo para tarefas "simples".
- **Não pule o Plano**: Garanta que o usuário aprovou o caminho antes de escrever.
- **TDD Estrito**: Escreva o teste que falha primeiro.
- **Respeite o Contexto**: Sempre verifique o mapa do projeto antes de criar novos arquivos para evitar duplicidade.

---
*Kit Supremo — Powered by Antigravity*
