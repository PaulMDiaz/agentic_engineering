# Notes

<!-- Append-only. Newest entries at top. -->

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
