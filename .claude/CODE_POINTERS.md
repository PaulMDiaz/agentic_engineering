---
summary: "Quick reference to key locations in the repo"
read_when: "You need to find where something lives"
---
<!-- Format: ## Section headers → | What | Where | tables. Paths as inline code, functions as `file.py` → `FunctionName()`. -->

# Code Pointers

## Core Standards

| What | Where |
| --- | --- |
| All universal coding rules | `CODING_STANDARDS.md` |
| Design rules (pure functions, no default params) | `CODING_STANDARDS.md` → Design |
| Error handling (no silent fallbacks, clamping note) | `CODING_STANDARDS.md` → Error Handling |
| Shell rules (`set -euo pipefail`, `trash` > `rm`, `-i` flag) | `CODING_STANDARDS.md` → Language / Stack |
| Typing rules (`dict[str, Any]`, no `Any`) | `CODING_STANDARDS.md` → Typing |
| Git / commit rules | `CODING_STANDARDS.md` → Git + Commits |
| Security rules (`trash > rm`, no external installs) | `CODING_STANDARDS.md` → Security |
| LLM integration rules (structured outputs, tool contracts) | `CODING_STANDARDS.md` → LLM Integrations |

## Entry Point

| What | Where |
| --- | --- |
| Canonical agent instruction file | `AGENTS.md` |
| Claude Code / Cursor shim | `CLAUDE.md` |
| Codex / AGENTS.md-aware agent entry point | `AGENTS.md` |
| Standards-loading rule for agents | `AGENTS.md` → Rules |
| Repo structure overview | `AGENTS.md` → Repository Structure |
| Direct commit quick reference | `AGENTS.md` → Quick Reference |

## Skills

| What | Where |
| --- | --- |
| Bootstrap `.claude/` for a project | `skills/init-second-brain/SKILL.md` |
| Full conventions verification and legacy migration | `skills/audit-second-brain/SKILL.md` |
| Load context and run the lightweight conventions trust gate | `skills/load-second-brain/SKILL.md` |
| Sync `.claude/` via a dedicated `second-brain` branch/worktree | `skills/sync-second-brain/SKILL.md` |
| Source-aware scoped second-brain maintenance | `skills/update-second-brain/SKILL.md` |
| Review a branch or PR for bugs/inconsistencies | `skills/agent-review/SKILL.md` |
| Triage GitHub PR review comments into a checklist | `skills/pr-review-triage/SKILL.md` |
| Walk through a diff — goal + approach | `skills/diff-summary/SKILL.md` |
| Summarize recent work from git log | `skills/git-recap/SKILL.md` |
| Stress-test plans against code, language, and docs | `skills/grill-with-docs/SKILL.md` |
| Methodical task implementation | `skills/implement/SKILL.md` |
| Local CI-equivalent verification | `skills/check-ci/SKILL.md` |
| Security review checklist | `skills/security-check/SKILL.md` |
| Work-item analysis across Jira, GitHub, and local git | `skills/work-items-analysis/SKILL.md` |

## Reference Docs

| What | Where |
| --- | --- |
| Tool catalog (gh, git, claude CLI, quality gates) | `tools.md` |

## Scripts & CI

| What | Where |
| --- | --- |
| Install repo-local skill sync hooks | `scripts/install-skill-hooks` |
| Sync or uninstall repo-managed Cursor skill symlinks | `scripts/sync-cursor-skills [sync\|uninstall]` |
| Sync Codex mirrored skill folders | `scripts/sync-codex-skills` |
| Remove repo-managed Codex mirrored skill folders | `scripts/sync-codex-skills uninstall` |
| Sync both workstation skill surfaces | `scripts/sync-workstation-skills` |
| Zero-dependency shell test runner | `tests/run` |
| Shell test assertions | `tests/helpers/assert.sh` |
| Hook installer regression tests | `tests/install-skill-hooks.bash` |
| Skill inventory and second-brain contract tests | `tests/skills.bash` |
| Cursor skill sync regression tests | `tests/sync-cursor-skills.bash` |
| Codex skill sync regression tests | `tests/sync-codex-skills.bash` |
| Workstation sync wrapper regression tests | `tests/sync-workstation-skills.bash` |
| Shell script test job | `.github/workflows/ci.yml` → `shell-tests` |
| Auto-delete review artifacts post-merge | `.github/workflows/cleanup-review-artifacts.yml` |
