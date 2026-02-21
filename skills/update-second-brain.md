---
name: update-second-brain
description: Update the .claude/ knowledge base with what was worked on this session. Appends a session entry to NOTES.md and updates other knowledge files if architecture, decisions, conventions, code pointers, or backlog changed.
argument-hint: "[optional: focus area or notes to include]"
---

# Update Second Brain

Record what happened this session into the .claude/ knowledge base. This should be run at the end of a work session (or whenever the user asks to "update the project notes").

## Process

### Step 1: Read current knowledge base

Read all knowledge files to understand current state:
- `.claude/NOTES.md` — recent session history
- `.claude/ARCHITECTURE.md` — current architecture understanding
- `.claude/DECISIONS.md` — existing decision log
- `.claude/CODE_POINTERS.md` — current code references
- `.claude/CONVENTIONS.md` — current rules
- `.claude/BACKLOG.md` — current backlog state

If any file doesn't exist, skip it (the knowledge base may be partial).

### Step 2: Reflect on the session

Review the full conversation to identify:

1. **What we worked on** — features built, bugs fixed, refactors done, explorations, reviews
2. **Decisions made** — any choices about approach, architecture, tools, patterns, or trade-offs
3. **Still unresolved** — open questions, blocked items, things deferred to later
4. **Architecture changes** — did the codebase shape change? New modules, new services, changed data flow?
5. **New decisions** — any settled choices that future sessions should know about?
6. **Code pointer updates** — new important files/functions, or did line numbers shift due to edits?
7. **Convention changes** — new patterns established, rules changed?
8. **Backlog updates** — items completed (check them off), new items discovered, priorities shifted?

If the user provided additional notes or a focus area when invoking this skill, incorporate that context too.

### Step 3: Update NOTES.md

Prepend a new session entry at the top (after the header, before the previous entries):

```markdown
## Session: YYYY-MM-DD

### What we worked on
- Bullet points of what was done

### Decisions made
- Choices made and brief rationale

### Still unresolved
- Open items, blockers, deferred work
```

Rules:
- Use today's date (`run date` to get it)
- If there's already an entry for today, add a "(continued)" suffix to distinguish
- Be specific — mention file names, function names, feature names
- Keep each bullet to one line
- Decisions should capture the "why" not just the "what"

### Step 4: Update other files (only if something changed)

Only touch files where the session produced meaningful changes:

**ARCHITECTURE.md** — Update if:
- New modules, services, or pipelines were added
- Data flow changed
- Infrastructure changed
- A significant refactor altered the codebase shape

**DECISIONS.md** — Append new entries if:
- A non-trivial choice was made about approach, tool, pattern, or trade-off
- Format: `### Title` / **When** / **Why** / **Trade-off**

**CODE_POINTERS.md** — Update if:
- New important files or functions were created
- Existing pointers have stale line numbers from significant edits
- Don't update line numbers for minor shifts — only when they'd be misleading

**CONVENTIONS.md** — Update if:
- A new coding pattern was established
- A rule was changed or added
- A new tool/process convention was adopted

**BACKLOG.md** — Update if:
- Backlog items were completed (check them off: `- [x]`)
- New issues or improvements were discovered
- Priorities shifted based on what we learned

### Step 5: Summary

Show the user what was updated:

```
Updated session notes:

## Session: YYYY-MM-DD

### What we worked on
- ...

### Decisions made
- ...

### Still unresolved
- ...
```

If other files were also updated, briefly note what changed:
```
Also updated:
- ARCHITECTURE.md — added new X pipeline section
- BACKLOG.md — checked off item Y, added item Z
```

## Guidelines

- **Don't fabricate** — only record things that actually happened in the conversation. If unsure, be conservative.
- **Be concise** — session notes should be scannable, not exhaustive. One line per bullet.
- **Preserve history** — never edit or delete previous session entries in NOTES.md. It's append-only.
- **Minimal updates** — don't touch files that didn't change. If the session was just a bug fix with no architectural impact, only NOTES.md and maybe BACKLOG.md need updating.
- **Accurate pointers** — if updating CODE_POINTERS.md, verify line numbers against the actual files before writing them.
- **No busywork entries** — skip trivially obvious things. Focus on what a future session would benefit from knowing.
