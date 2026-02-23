# Notes

<!-- Append-only. Newest entries at top. -->
<!-- Format per session: ## Session: YYYY-MM-DD (add "(continued)" if second entry same day) → ### What we worked on / ### Decisions made / ### Still unresolved. Never edit or delete past entries. -->

## Session: 2026-02-22 (continued)

### What we worked on
- **Pass B added to `update-second-brain`** — staleness audit now has two passes: Pass A (session-scope, existing behaviour) + Pass B (code-verification: read actual source files to catch latent inaccuracies from prior sessions — wrong env vars, stale module descriptions, mismatched function names)
- **Two-copy skill drift resolved** — OpenClaw workspace `SKILL.md` files for the 4 shared skills (agent-review, init-second-brain, load-second-brain, update-second-brain) replaced with symlinks pointing to `agentic_engineering/skills/*.md`. Single source of truth; Pi auto-reflects dev branch on `git pull`.
- Dev branch synced with main (two accumulated PR merge commits)

### Decisions made
- `agentic_engineering/skills/` is the canonical source of truth for shared skills; OpenClaw workspace copies are symlinks, not independent files
- Pass B (code-verification) is now a required part of the staleness audit — session memory alone misses latent inaccuracies

### Still unresolved
- Claude Code stop hook schema not yet verified against a real project
- `.cursorrules` reference in `second-brain-hooks.md` may be outdated

## Session: 2026-02-22

### What we worked on
- Updated `update-second-brain` skill — added staleness audit (read-back) step: before
  writing, audit existing knowledge files for accuracy; correct stale entries first, then
  append new. NOTES.md stays append-only (log, not state). Applied to both workspace copy
  and this repo's `skills/update-second-brain.md`
- Added `AGENTS.md` — thin global entry point for Codex and AGENTS.md-aware agents,
  pointing to `CODING_STANDARDS.md`
- Moved slash commands from `docs/slash-commands/` → `.claude/commands/`, stripped
  doc front-matter — now invokable as `/command-name` in Claude Code/Cursor
- Fixed `trash` vs `rm -i` inconsistency in `CODING_STANDARDS.md` — Shell section
  now leads with `trash` preference, falls back to `rm -i` if unavailable
- Fixed stale `AGENTS.md` description in `CLAUDE.md` structure table
- Superseded "Claude Code/Cursor only" decision in `DECISIONS.md`, added updated decision
- Updated `ARCHITECTURE.md` — audience line, directory layout, added Codex
- Ran `agent-review` twice; applied all findings (1 MEDIUM, 6 LOW total)
- Opened PR #4 (`dev` → `main`)

### Decisions made
- `update-second-brain` is now write-forward AND read-back — staleness audit is mandatory
- Repo now targets Claude Code, Cursor, AND Codex (+ AGENTS.md-aware agents); OpenClaw excluded
- Slash commands belong in `.claude/commands/`, not `docs/slash-commands/`
- Keep second brain in this repo — dogfooding value outweighs the overhead
- Empty `CONVENTIONS.md` / `CODE_POINTERS.md` are acceptable — redundancy is fine

### Still unresolved
- Claude Code stop hook schema not yet verified against a real project
- `.cursorrules` Cursor reference in `second-brain-hooks.md` may be outdated
- Two-copy skill drift (OpenClaw workspace vs this repo) — to be addressed separately

## Session: 2026-02-21 (continued)

### What we worked on
- Ported `agent-review` skill from OpenClaw to repo (`skills/agent-review.md`) — inline
  output only, no file creation, criteria embedded, uses `git --no-pager diff` directly
- Added `diff-summary` skill (`skills/diff-summary.md`) — explains what a diff is trying
  to accomplish and the approach, conversational output
- Added both to slash command index (`docs/slash-commands/README.md`)
- Updated `.claude/ARCHITECTURE.md` and `.claude/CODE_POINTERS.md` to reflect new skills
- Confirmed agent-review OpenClaw skill previously created `.md` files — new repo version does not

### Decisions made
- `agent-review` in this repo outputs inline only — no `.md` file — keeping reviews ephemeral
  unless explicitly saved. Review artifacts belong in PRs (or nowhere), not in the working tree.
- `diff-summary` is conversational by design — high-level explanation, not a structured report

### Still unresolved
- `CLAUDE.md` Structure table still has stale `AGENTS.md` row (fix pending in PR #2)
- All 5 skills listed in slash command index have no backing command files in `.claude/commands/`
- `trash > rm` vs `rm -i` rules not cross-referenced in CODING_STANDARDS.md
- Claude Code stop hook schema not yet verified against a real project
- `.cursorrules` Cursor reference may be outdated

## Session: 2026-02-21

### What we worked on
- Merged PR #1 — full review cycle: CODING_STANDARDS.md refactor, security doc fixes,
  committer improvements, skills cleanup, CI workflow, .gitignore
- Cleanup workflow fired correctly post-merge, removing `agent_review.md` from main
- Bootstrapped this `.claude/` second brain (init-second-brain skill, inception run)
- Ran agent-review on the repo itself (second review cycle)

### Decisions made
- Review artifacts (`*_review.md`) auto-deleted from main via GitHub Actions — no manual cleanup needed
- `.claude/` second brain lives in the repo — grows organically with each session
- Skills in `skills/` listed in slash command index but not wired as command files — to be resolved

### Still unresolved
- `CLAUDE.md` Structure table still has stale `AGENTS.md` row (fix pending)
- Second brain slash commands listed in index but have no backing command files
- `trash > rm` vs `rm -i` rules not cross-referenced in CODING_STANDARDS.md
- Claude Code stop hook schema not yet verified against a real project
- `.cursorrules` Cursor reference may be outdated
