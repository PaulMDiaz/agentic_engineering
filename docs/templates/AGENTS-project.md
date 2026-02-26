# Coding Standards

Read `~/.cursor/CODING_STANDARDS.md` before doing any coding work.

## Skills

The following skills are available at `~/.cursor/skills/agentic/`:

| Skill | File | Use when |
|-------|------|----------|
| agent-review | agent-review.md | Reviewing a PR or branch |
| diff-summary | diff-summary.md | Understanding what a diff does |
| git-recap | git-recap.md | Summarizing recent work |
| init-second-brain | init-second-brain.md | Bootstrapping .claude/ for this project |
| load-second-brain | load-second-brain.md | Loading project context at session start |
| update-second-brain | update-second-brain.md | Recording session work into .claude/ |

To use a skill: "Run the agent-review skill from ~/.cursor/skills/agentic/agent-review.md"

## Knowledge Base

If this project has a `.claude/` directory, run `load-second-brain` at the start of
non-trivial sessions.

Update DECISIONS.md when making decisions, CODE_POINTERS.md when adding files/functions.
