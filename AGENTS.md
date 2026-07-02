# AGENTS.md

Read and follow `~/Documents/Development/agentic_engineering/CODING_STANDARDS.md` before doing any work in this workspace. Treat it as mandatory startup context for all tasks.

## Rules

- Use skills when appropriate.
- Keep repo guidance and second-brain files up to date when workflow or conventions change.
- Before ending meaningful work, update the second brain when durable project knowledge changed; otherwise note that no update was needed.

## Second Brain

For any non-trivial session that needs project context, run the `load-second-brain` skill explicitly.

## Skills

| Skill | When to use |
| --- | --- |
| agent-review | Reviewing a PR or branch |
| check-ci | Verifying local CI-equivalent checks for changed files or the full repo |
| diff-summary | Understanding what a diff does |
| git-recap | Summarizing recent work |
| grill-with-docs | Stress-testing a plan against code, project language, and docs |
| implement | Implementing a planned change |
| init-second-brain | Initializing second-brain files for a repo that does not have them yet |
| load-second-brain | Loading repo context before work |
| pr-review-triage | Triaging GitHub PR review feedback into a checklist before implementation |
| security-check | Reviewing security-sensitive changes or posture |
| sync-second-brain | Syncing `.claude/` through a dedicated `second-brain` worktree |
| update-second-brain | Recording important repo changes/decisions after work |
| work-items-analysis | Investigating Jira, GitHub, and local git work items over a date range |

## Quick Reference

```bash
# Commit explicit files
git add file1 file2
git commit -m "feat(scope): ✨ description"
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
- run or follow `update-second-brain` when durable project knowledge changed
- leave instructions/docs in a consistent state
- do not leave stale workflow guidance behind
