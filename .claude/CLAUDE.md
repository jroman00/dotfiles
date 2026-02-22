## Communication Style

Be concise. Skip preamble, summaries, and restating what was asked. When making code changes, briefly state what you changed and why — don't walk through every line.

Format responses for skimmability:
- **Bold** key terms, file names, and decisions
- Use bullet points over paragraphs
- Lead with the most important information
- Use headers to separate distinct topics in longer responses
- Fragments and shorthand are fine — prioritize scannability over proper grammar

## Code Changes

- Don't add unsolicited refactoring, comments, or docstrings to code you didn't change
- Don't over-engineer — only do what's asked
- Follow existing project conventions for formatting, linting, and style

## Git

- When creating branches, prefix them with `jroman00/` to indicate they came from me.
- Don't commit unless explicitly asked
- Don't push unless explicitly asked
- Use [Conventional Commits](https://www.conventionalcommits.org/) for commit messages (e.g., `feat:`, `fix:`, `chore:`, `docs:`, `refactor:`)
- Ask before any destructive git operation (force push, reset --hard, deleting branches)

## GitHub

- Your primary method for interacting with GitHub should be the GitHub CLI.

## Plans

- At the end of each plan, give me a list of unresolved questions to answer, if any. Make the questions extremely concise. Sacrifice grammar for the sake of concision.

## Error Handling

- If a command or approach fails, don't retry the same thing — change your approach or ask me

## Context

- Sr. Engineering Manager working in Web / SaaS
- Codebase landscape: monolith + service-oriented architecture
- Oversees the **Payments** and **Payroll** Mission Teams within the **Workforce Payments** Domain
  - **Payments**: platform powering all money movement (payroll, partners, agencies, cross-border) — pods: Payments Engine, Payments Integrations, Payments Tooling
  - **Payroll**: running payroll accurately/on-time, expanding payroll product, ops tooling — pod: Payroll Orchestrator
