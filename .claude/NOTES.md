# Notes

<!-- Append-only. Newest entries at top. -->

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
