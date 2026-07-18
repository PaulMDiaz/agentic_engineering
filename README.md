# Agentic Engineering

A coding playbook for Cursor and Codex — coding standards and skills that work across all your repos.

## What's Included

- **CODING_STANDARDS.md** — Universal rules for AI-assisted coding
- **Skills** — Reusable workflows (code review, git recap, second-brain management)

## Quick Start

See [Workstation Setup](docs/workstation-setup.md) for installation and uninstallation instructions.

## Skills

| Skill | Description |
| --- | --- |
| agent-review | Review code for bugs, inconsistencies, and refactoring opportunities |
| audit-second-brain | Fully verify or migrate second-brain conventions against repository sources |
| check-ci | Verify local CI-equivalent checks for changed files or the full repo |
| diff-summary | Explain what a diff is trying to accomplish |
| git-recap | Summarize recent work from git history |
| grill-with-docs | Stress-test a plan against code, project language, and docs |
| implement | Methodical task approach — understand, plan, implement, verify |
| init-second-brain | Bootstrap a `.claude/` knowledge base for a project |
| load-second-brain | Load project context when needed |
| pr-review-triage | Triage GitHub PR comments into a checklist before implementation (mainly useful in Paul's workstation flow) |
| security-check | Security review — what to check for, how to report findings |
| sync-second-brain | Sync `.claude/` through a dedicated `second-brain` branch/worktree |
| update-second-brain | Maintain durable project knowledge organically during change-producing work |
| work-items-analysis | Investigate Jira, GitHub, and local git work items over a date range (workstation-specific, with local Atlassian/GitHub tooling assumptions) |

## Agent-Owned Second-Brain Maintenance

Second-brain upkeep is part of ordinary agent work rather than a user-invoked ceremony.
Convention sections declare their authoritative `Sources:` so agents can update only the
guidance affected by a change. `load-second-brain` performs a lightweight trust check and
routes legacy or contradictory guidance—and audits older than 90 days—to
`audit-second-brain`.

Read-only tasks report stale guidance without editing it. Full audits advance
`last_full_audit` only when every convention section is verified or explicitly marked as
`normative repository policy`. See
[`docs/second-brain-hooks.md`](docs/second-brain-hooks.md) for the complete workflow.

## Philosophy

One shared playbook, symlinked everywhere. Update once, every repo benefits.

No per-repo configuration sprawl. No copy-pasting standards between projects. Just clone once, symlink, and go.

## License

MIT
