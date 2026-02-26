# Project Agent Instructions

This project uses the agentic engineering playbook. Global rules and skills are
installed — see Cursor Settings → Rules and Skills.

## Skills (invoke with /skill-name)

| Skill | Use when |
|-------|----------|
| /agent-review | Reviewing a PR or branch |
| /diff-summary | Understanding what a diff does |
| /git-recap | Summarizing recent work |
| /implement | Working on a coding task methodically |
| /init-second-brain | Bootstrapping .claude/ for this project |
| /load-second-brain | Loading project context at session start |
| /security-check | Reviewing changes for security issues |
| /update-second-brain | Recording session work into .claude/ |

## Knowledge Base

If this project has a `.claude/` directory, run `/load-second-brain` at the start of
non-trivial sessions.

Update DECISIONS.md when making decisions, CODE_POINTERS.md when adding files/functions.
