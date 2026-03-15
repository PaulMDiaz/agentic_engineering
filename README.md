# Agentic Engineering

A coding playbook for Claude Code, Cursor, and Codex — coding standards, skills, and slash commands that work across all your repos.

## What's Included

- **CODING_STANDARDS.md** — Universal rules for AI-assisted coding
- **Skills** — Reusable workflows (code review, git recap, second-brain management)
- **Slash Commands** — `/check`, `/commit`, `/implement`, `/pr`, `/security-check`

## Quick Start

See [Workstation Setup](docs/workstation-setup.md) for installation and uninstallation instructions.

## Skills

| Skill | Description |
|-------|-------------|
| agent-review | Review code for bugs, inconsistencies, and refactoring opportunities |
| check-ci | Verify local CI-equivalent checks for changed files or the full repo |
| diff-summary | Explain what a diff is trying to accomplish |
| git-recap | Summarize recent work from git history |
| implement | Methodical task approach — understand, plan, implement, verify |
| init-second-brain | Bootstrap a `.claude/` knowledge base for a project |
| load-second-brain | Load project context at session start |
| security-check | Security review — what to check for, how to report findings |
| update-second-brain | Record session work into `.claude/` |

## Philosophy

One shared playbook, symlinked everywhere. Update once, every repo benefits.

No per-repo configuration sprawl. No copy-pasting standards between projects. Just clone once, symlink, and go.

## License

MIT
