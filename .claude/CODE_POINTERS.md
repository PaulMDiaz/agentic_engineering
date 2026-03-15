---
summary: "Quick reference to key locations in the repo"
read_when: "You need to find where something lives"
---
<!-- Format: ## Section headers → | What | Where | tables. Paths as inline code, functions as `file.py` → `FunctionName()`. -->

# Code Pointers

## Core Standards

| What | Where |
|---|---|
| All universal coding rules | `CODING_STANDARDS.md` |
| Design rules (pure functions, no default params) | `CODING_STANDARDS.md` → Design |
| Error handling (no silent fallbacks, clamping note) | `CODING_STANDARDS.md` → Error Handling |
| Shell rules (`set -euo pipefail`, `trash` > `rm`, `-i` flag) | `CODING_STANDARDS.md` → Language / Stack |
| Typing rules (`dict[str, Any]`, no `Any`) | `CODING_STANDARDS.md` → Typing |
| Git / commit rules | `CODING_STANDARDS.md` → Git + Commits |
| Security rules (`trash > rm`, no external installs) | `CODING_STANDARDS.md` → Security |

## Entry Point

| What | Where |
|---|---|
| Canonical agent instruction file | `AGENTS.md` |
| Claude Code / Cursor shim | `CLAUDE.md` |
| Codex / AGENTS.md-aware agent entry point | `AGENTS.md` |
| Standards-loading rule for agents | `AGENTS.md` → Rules |
| Repo structure overview | `AGENTS.md` → Repository Structure |
| Commit helper quick reference | `AGENTS.md` → Quick Reference |

## Skills

| What | Where |
|---|---|
| Bootstrap `.claude/` for a project | `skills/init-second-brain/SKILL.md` |
| Load `.claude/` context at session start | `skills/load-second-brain/SKILL.md` |
| Record session work into `.claude/` | `skills/update-second-brain/SKILL.md` |
| Review a branch or PR for bugs/inconsistencies | `skills/agent-review/SKILL.md` |
| Walk through a diff — goal + approach | `skills/diff-summary/SKILL.md` |
| Summarize recent work from git log | `skills/git-recap/SKILL.md` |
| Methodical task implementation | `skills/implement/SKILL.md` |
| Local CI-equivalent verification | `skills/check-ci/SKILL.md` |
| Security review checklist | `skills/security-check/SKILL.md` |

## Slash Commands

| Command | File |
|---|---|
| `/check` | `.claude/commands/check.md` |
| `/commit` | `.claude/commands/commit.md` |
| `/implement` | `.claude/commands/implement.md` |
| `/pr` | `.claude/commands/pr.md` |
| `/security-check` | `.claude/commands/security-check.md` |
| Index | `docs/slash-commands/README.md` |

## Reference Docs

| What | Where |
|---|---|
| Claude Code Stop hook registration | `docs/second-brain-hooks.md` → Claude Code |
| Cursor session-end automation | `docs/second-brain-hooks.md` → Cursor |
| Tool catalog (gh, git, claude CLI, quality gates) | `tools.md` |

## Scripts & CI

| What | Where |
|---|---|
| Stage + commit helper | `scripts/committer` |
| Conventional Commits regex | `scripts/committer` ~line 17 |
| TTY detection (agent hard fail vs human prompt) | `scripts/committer` ~line 22 |
| Auto-delete review artifacts post-merge | `.github/workflows/cleanup-review-artifacts.yml` |
