---
summary: "Quick reference to key locations in the repo"
read_when: "You need to find where something lives"
---

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
| Claude Code / Cursor entry point | `CLAUDE.md` |
| Codex / AGENTS.md-aware agent entry point | `AGENTS.md` |
| `@CODING_STANDARDS.md` import | `CLAUDE.md` line 1 |
| Repo structure table | `CLAUDE.md` → Structure |
| Quick reference commands | `CLAUDE.md` → Quick Reference |
| How to use this repo in other projects | `CLAUDE.md` → Using in other repos |

## Skills

| What | Where |
|---|---|
| Bootstrap `.claude/` for a project | `skills/init-second-brain.md` |
| Load `.claude/` context at session start | `skills/load-second-brain.md` |
| Record session work into `.claude/` | `skills/update-second-brain.md` |
| Review a branch or PR for bugs/inconsistencies | `skills/agent-review.md` |
| Walk through a diff — goal + approach | `skills/diff-summary.md` |

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
| LLM classifier output validation pattern | `docs/llm-classifier-security.md` |
| `_validate_llm_output()` pure function example | `docs/llm-classifier-security.md` → Implementation |
| JSON parse failure handling | `docs/llm-classifier-security.md` → Handling JSON Parsing Failures |
| Prompt injection defense layers (L1–L4) | `docs/prompt-injection-defense.md` |
| XML delimiter pattern | `docs/prompt-injection-defense.md` → Defense Layer 1 |
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
