# Kit Supremo — Master Rules

Estas regras são **OBRIGATÓRIAS** e inegociáveis para qualquer Agente de IA operando neste projeto.

## 🛠️ Metodologia de Engenharia

Você deve seguir o fluxo de trabalho do `superpowers` em TODAS as tarefas:

1.  **Discovery & Brainstorming**: Use a skill `methodology/brainstorming/SKILL.md`. Não escreva código sem antes entender o contexto completo e obter aprovação do design.
2.  **Implementation Planning**: Use a skill `methodology/writing-plans/SKILL.md`. Divida a tarefa em micro-etapas (2 a 5 minutos) com critérios de aceitação.
3.  **Test-Driven Development**: Use a skill `methodology/test-driven-development/SKILL.md`. Escreva o teste que falha antes de qualquer código funcional.
4.  **Systematic Verification**: Use a skill `methodology/verification-before-completion/SKILL.md`. Nunca diga que uma tarefa está pronta sem verificar efeitos colaterais e logs.

### 🧩 Gestão de Skills (Novo)

Sempre que for solicitado para **revisar, melhorar, atualizar ou criar uma skill**, você DEVE primeiro ler e seguir as diretrizes em `.agents/skills/skill-creator/SKILL.md`. Isso garante que as skills sejam eficientes, tenham frontmatter correto e triggers precisos.

## 🏗️ Padrões de Código

-   **Limite de 200 Linhas**: Se um arquivo (especialmente componentes UI ou serviços) ultrapassar 200 linhas, ele DEVE ser refatorado e dividido.
-   **Separation of Concerns**: Camadas de UI, Lógica de Negócio e Infraestrutura devem ser isoladas.
-   **Clean Code**: Siga os princípios SOLID, DRY e KISS.
-   **Type Safety**: Use tipos fortes (TypeScript/Python Type Hints). NUNCA use `any`.

## 🌐 Conhecimento e Contexto

-   **Zero Alucinação**: Se não souber a estrutura de um arquivo ou API, use `ag-ask` ou `grep` para encontrar.
-   **Memória do Projeto**: Consulte `.context/` regularmente para ver lições aprendidas e mapas de arquitetura.
-   **Atualização de Docs**: Após qualquer mudança estrutural, sugira ao usuário rodar `ag-refresh`.

## ⚠️ Red Flags (Rejeição Imediata)

-   Ignorar erros de lint ou testes.
-   Criar arquivos sem consultar o mapa do projeto (duplicidade).
-   "Implementar primeiro, planejar depois".
-   Placeholder code (TODOs sem dono ou data).

---
*Assinado: Arquiteto Supremo*
