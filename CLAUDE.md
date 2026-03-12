@CODING_STANDARDS.md

## Project: agentic_engineering

Central coding standards, skills, slash commands, and scripts for all PaulMDiaz projects.
Owner: Paul Diaz (@PaulMDiaz)

## Second Brain

If context is needed for a non-trivial session, run the `load-second-brain` skill explicitly.

Before ending any session: say "update second brain" to record what we worked on.

## Structure

| Path | Purpose |
|---|---|
| `CODING_STANDARDS.md` | Universal rules — source of truth for all projects |
| `AGENTS.md` | Global entry point for Codex and other AGENTS.md-aware agents — points to `CODING_STANDARDS.md` |
| `skills/` | Reusable skill prompts (init/load/update second brain, etc.) |
| `.claude/commands/` | Slash commands — auto-loaded by Claude Code and Cursor |
| `docs/slash-commands/README.md` | Index of slash commands and skills |
| `docs/` | Reference docs with `summary` and `read_when` front-matter |
| `scripts/` | Helper scripts (`committer`, etc.) |

## Quick Reference

Create well-formatted commits with conventional commit messages and emojis.

```bash
# Commit
./scripts/committer "feat(scope): description" file1 file2

# Quality gate (per project)
ruff check . && ruff format --check . && mypy . && pytest

# PRs / CI
gh pr view
gh run list
```

## Using in other repos

Add to project `CLAUDE.md`:
```
@path/to/agentic_engineering/CODING_STANDARDS.md
```
Or copy `CODING_STANDARDS.md` into the repo and reference locally.
