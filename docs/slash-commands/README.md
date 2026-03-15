---
summary: "Index of available slash commands and skills"
read_when: "You want to know what slash commands or skills are available"
---

# Commands & Skills

Both commands and skills are invoked with `/name` in Cursor.

## Commands

| Command | Purpose |
|---------|---------|
| `/check` | Run full code quality gate |
| `/commit` | Create well-formatted conventional commit |
| `/implement` | Methodical task implementation |
| `/pr` | Create a pull request |
| `/security-check` | Review for security issues |

## Skills

| Skill | Purpose |
|-------|---------|
| `/agent-review` | Review current branch or PR for bugs and inconsistencies |
| `/check-ci` | Verify local CI-equivalent checks for changed files or the full repo |
| `/diff-summary` | Walk through a diff — what it does and how |
| `/git-recap` | Summarize recent work from git history |
| `/implement` | Methodical task approach — understand, plan, implement, verify |
| `/init-second-brain` | Bootstrap `.claude/` knowledge base for a project |
| `/load-second-brain` | Load full project context at session start |
| `/security-check` | Security review checklist |
| `/update-second-brain` | Record what was worked on this session |

## File Locations

- Commands: `.claude/commands/*.md` (symlinked to `~/.cursor/commands/`)
- Skills: `skills/*/SKILL.md` (symlinked to `~/.cursor/skills/`)
