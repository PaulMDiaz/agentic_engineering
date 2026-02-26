---
description: "Universal coding standards for all projects"
alwaysApply: true
---

# Coding Standards

This development folder uses the agentic engineering playbook.

## Rules

Read and follow `agentic_engineering/CODING_STANDARDS.md` for all coding work.

Key rules:
- Pure functions — return new objects, never mutate inputs
- No default parameter values
- Strong typing — avoid `Any`
- No silent fallbacks — propagate errors
- Conventional commits — `type(scope): description`
- `.env` first in `.gitignore`
- `trash` > `rm`
- Never install external tools without explicit approval

## Skills

Skills are available via `/skill-name` in Cursor:

| Skill | Use when |
|-------|----------|
| /agent-review | Reviewing a PR or branch |
| /diff-summary | Understanding what a diff does |
| /git-recap | Summarizing recent work |
| /implement | Working on a coding task methodically |
| /init-second-brain | Bootstrapping .claude/ for a project |
| /load-second-brain | Loading project context at session start |
| /security-check | Reviewing changes for security issues |
| /update-second-brain | Recording session work into .claude/ |

## Project-Specific Conventions

Check `.claude/CONVENTIONS.md` in the current project if it exists.
