---
summary: "Open items, planned improvements, and tech debt"
read_when: "Before starting new work — check if it's already planned"
---
<!-- Format: ## Next Up → ## Known Gaps / Tech Debt → ## Done. Items as: - [ ] **Title** — description (open) or - [x] **Title** — description (done). -->

# Backlog

## Next Up

## Known Gaps / Tech Debt

## Done

- [x] **Stop hook mechanism** — Won't implement. Auto-loading context reduces task success rates and increases inference cost (Gloaguen et al. 2602.11988). Context loaded on demand via `load-second-brain` skill instead. `second-brain-hooks.md` updated accordingly.
- [x] **`.cursorrules` stop hook reference** — Moot; entire Cursor stop hook section removed alongside the mechanism.
- [x] **Fix stale `AGENTS.md` row in `CLAUDE.md`** — Updated description to reflect that
  `AGENTS.md` is now the global entry point for Codex and AGENTS.md-aware agents, not an
  OpenClaw-specific file. (`CLAUDE.md` → Structure section)
- [x] **Reconcile `trash > rm` vs `-i` flag rule** — Shell section now leads with `trash`
  preference and falls back to `rm -i` only if `trash` is unavailable. (`CODING_STANDARDS.md`)
- [x] **5 skills listed in slash command index have no backing command files** — Moved to
  `.claude/commands/`; README index now separates slash commands from skills.
- [x] Remove dead `/context-prime` from slash command index
- [x] Fix `_validate_llm_output()` — pure function, `dict[str, Any]`, no in-place mutation
- [x] Replace silent LLM parse failure fallback with propagate + clamping distinction note
- [x] Remove OpenClaw section from `second-brain-hooks.md`
- [x] Add Conventional Commits regex to `scripts/committer`; TTY split for agent vs human
- [x] Replace `$ARGUMENTS` with plain instructions in skills
- [x] Add `ruff format --check .` to `tools.md`
- [x] Add `.gitignore`
- [x] Add `-i` flag rule to Shell section
- [x] Auto-delete review artifacts via GitHub Actions on merge to main
- [x] Delete AGENTS.md — repo is Claude Code/Cursor only
- [x] Refactor AGENTS.md → CODING_STANDARDS.md
- [x] Bootstrap `.claude/` second brain
- [x] Port `agent-review` skill from OpenClaw — inline output, no file creation, self-contained
- [x] Add `diff-summary` skill — conversational diff walkthrough
