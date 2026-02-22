---
summary: "Open items, planned improvements, and tech debt"
read_when: "Before starting new work — check if it's already planned"
---

# Backlog

## Open

- [x] **Fix stale `AGENTS.md` row in `CLAUDE.md`** — Updated description to reflect that
  `AGENTS.md` is now the global entry point for Codex and AGENTS.md-aware agents, not an
  OpenClaw-specific file. (`CLAUDE.md` → Structure section)

- [x] **Reconcile `trash > rm` vs `-i` flag rule** — Shell section now leads with `trash`
  preference and falls back to `rm -i` only if `trash` is unavailable. Cross-reference
  established; both sections are consistent. (`CODING_STANDARDS.md`)

- [x] **5 skills listed in slash command index have no backing command files** —
  Resolved by moving the 5 actual commands (`/check`, `/commit`, `/implement`, `/pr`,
  `/security-check`) from `docs/slash-commands/` to `.claude/commands/` (where Claude Code
  scans). The README index now clearly separates slash commands from skills, and the 5
  skill-based entries are labeled as "invoke by name, not slash command".

- [ ] **Verify Claude Code `settings.json` stop hook schema** — `docs/second-brain-hooks.md`
  shows the hook registration format but it should be tested against a real project to
  confirm the exact key names. Wrong config silently does nothing.

- [ ] **`.cursorrules` reference may be outdated** — `docs/second-brain-hooks.md` references
  `.cursorrules` for Cursor session-end reminder. Cursor has largely moved to `.cursor/rules/`.
  Should verify current Cursor convention.

## Done

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
