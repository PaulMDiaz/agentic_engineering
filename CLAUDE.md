# CLAUDE.md

@AGENTS.md

## Project: agentic_engineering
Central guardrails, skills, slash commands, and scripts for all PaulMDiaz projects.

## Structure
- `AGENTS.md` — canonical agent guardrails (source of truth)
- `CLAUDE.md` — this file; Claude Code entry point
- `docs/slash-commands/` — shared slash commands
- `docs/` — reference docs with `read_when` hints
- `scripts/` — helper scripts (committer, etc.)
- `skills/` — reusable skill definitions

## Usage in other repos
Add to project `AGENTS.md`:
```
READ ~/Projects/agentic_engineering/AGENTS.md BEFORE ANYTHING (skip if missing).
```
Add to project `CLAUDE.md`:
```
@AGENTS.md
```
Then add project-specific context below.
