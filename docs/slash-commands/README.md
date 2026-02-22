---
summary: "Index of available slash commands and skills"
read_when: "You want to know what slash commands or skills are available"
---

# Slash Commands

Command files live in `.claude/commands/` — Claude Code picks them up automatically.
Invoke with `/command-name` in Claude Code or Cursor.

| Command | Purpose |
|---|---|
| `/commit` | Create well-formatted conventional commit |
| `/check` | Run full code quality gate |
| `/implement` | Methodical task implementation |
| `/pr` | Create a pull request |
| `/security-check` | Review for security issues |

## Skills (invoke by name, not slash command)

The following are skills in `skills/` — invoke them by asking the agent to run the skill,
not as slash commands:

| Skill | Purpose |
|---|---|
| `agent-review` | Review current branch or PR for bugs, inconsistencies, and refactor opportunities |
| `diff-summary` | Walk through a diff — what it's trying to accomplish and the approach |
| `init-second-brain` | Bootstrap `.claude/` knowledge base for a project |
| `load-second-brain` | Load full project context at session start |
| `update-second-brain` | Record what was worked on this session |
