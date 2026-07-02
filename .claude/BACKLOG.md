---
summary: "Open items, planned improvements, and tech debt"
read_when: "Before starting new work — check if it's already planned"
---
<!-- Format: ## Next Up → ## Known Gaps / Tech Debt → ## Done. Items as: - [ ] **Title** — description (open) or - [x] **Title** — description (done). -->

# Backlog

## Next Up

- [ ] **Verify Claude Code stop hook schema** — `docs/second-brain-hooks.md` simplified to manual-only, but the schema was never tested against a real project. Low priority since we moved away from hooks.
- [ ] **Verify `.cursorrules` convention** — Cursor has moved to `.cursor/rules/`. `second-brain-hooks.md` reference may be outdated. Check current Cursor docs.

## Known Gaps / Tech Debt

## Done

- [x] **Restructure skills to folder format** — `skills/name.md` → `skills/name/SKILL.md` for Cursor discovery
- [x] **Rewrite workstation-setup.md** — shorter, loop-based symlinks, parent-directory AGENTS.md approach
- [x] **Remove per-repo template** — `docs/templates/AGENTS-project.md` deleted, parent-directory approach replaces it
- [x] **AGENTS.md deduplication** — removed inlined rules, references CODING_STANDARDS.md only
- [x] **Stop hook mechanism** — Won't implement. Auto-loading context reduces task success rates and increases inference cost (Gloaguen et al. 2602.11988). Context loaded on demand via `load-second-brain` skill instead. `second-brain-hooks.md` updated accordingly.
- [x] **`.cursorrules` stop hook reference** — Moot; entire Cursor stop hook section removed alongside the mechanism.
- [x] **Fix stale `AGENTS.md` row in `CLAUDE.md`** — Updated description to reflect that
  `AGENTS.md` is now the global entry point for Codex and AGENTS.md-aware agents, not an
  OpenClaw-specific file. (`CLAUDE.md` → Structure section)
- [x] **Reconcile `trash > rm` vs `-i` flag rule** — Shell section now leads with `trash`
  preference and falls back to `rm -i` only if `trash` is unavailable. (`CODING_STANDARDS.md`)
- [x] **Remove repo-managed slash command surface** — Cursor workflows now use skills
  directly; `.claude/commands/` and `docs/slash-commands/` were removed.
- [x] Fix `_validate_llm_output()` — pure function, `dict[str, Any]`, no in-place mutation
- [x] Replace silent LLM parse failure fallback with propagate + clamping distinction note
- [x] Remove OpenClaw section from `second-brain-hooks.md`
- [x] Remove committer helper — direct `git add` / `git commit -m` workflow now relies on
  `CODING_STANDARDS.md` for Conventional Commit rules
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
