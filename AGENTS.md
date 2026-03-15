# AGENTS.md

Read and follow `~/Documents/Development/agentic_engineering/CODING_STANDARDS.md` before doing any work in this workspace. Treat it as mandatory startup context for all tasks.

## Rules

- Read and follow `~/Documents/Development/agentic_engineering/CODING_STANDARDS.md` before doing any work in this workspace, not just coding work.
- Use skills when appropriate.
- Keep repo guidance and second-brain files up to date when workflow or conventions change.
- Before ending meaningful work, update the second brain.

## Skills

| Command | When to use |
| --- | --- |
| /agent-review | Reviewing a PR or branch |
| /check-ci | Verifying local CI-equivalent checks for changed files or the full repo |
| /diff-summary | Understanding what a diff does |
| /git-recap | Summarizing recent work |
| /load-second-brain | Loading repo context before work |
| /update-second-brain | Recording important repo changes/decisions after work |

## Quick Reference

```bash
# Commit
./scripts/committer "✨ feat(scope): description" file1 file2
```

## Repository Structure

- `CODING_STANDARDS.md` — universal coding/workflow rules
- `AGENTS.md` — canonical agent instruction file for this repo
- `CLAUDE.md` — shim that redirects Claude to `AGENTS.md`
- `skills/` — reusable repo-specific agent skills
- `docs/` — repo documentation
- `.claude/` — second-brain context files

## Session End

Before ending meaningful work:
- run or follow `update-second-brain`
- leave instructions/docs in a consistent state
- do not leave stale workflow guidance behind
