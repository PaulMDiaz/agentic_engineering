---
name: update-second-brain
description: Update the .claude/ knowledge base with changes from this session. Use at end of session or when asked to update project notes. Lightweight — only touches files that actually changed. No ceremonial audit.
argument-hint: "[optional: focus area or notes to include]"
---

# Update Second Brain

Record what changed this session into the .claude/ knowledge base. This is the lightweight complement to init-second-brain (creates it) and load-second-brain (reads it).

## Philosophy

Update organically, not ceremonially. Only touch files that actually need changes. The git log handles session history — the second brain handles decisions, pointers, and structure.

## Process

### Step 1: Reflect on the session

Review the conversation to identify what changed:

1. **Decisions made** — any choices about approach, architecture, tools, patterns, or trade-offs?
2. **New files or functions** — did we add, rename, or remove important code?
3. **Structural changes** — did the codebase shape change? New modules, services, data flow?
4. **Backlog changes** — items completed, new items discovered, priorities shifted?
5. **Convention changes** — new patterns established, rules changed?

If the user provided additional notes when invoking this skill, incorporate that context.

### Step 2: Update only what changed

For each file, only update if the session produced relevant changes:

**DECISIONS.md** (core — most likely to need updating)
- Append new entries when a non-trivial choice was made
- Format: `### Title` / `**When:** YYYY-MM-DD` / `**Why:** ...` / `**Trade-off:** ...`
- Horizontal rule (`---`) between entries
- If a previous decision was superseded, append `> ⚠️ Superseded — reason` below it

**CODE_POINTERS.md** (core — update when code moves)
- Add entries for new important files, functions, or entry points
- Remove entries for deleted files
- Fix stale paths/function names if you notice them (verify against actual files)

**ARCHITECTURE.md** (only on structural changes)
- Update when: new module, new service, new table, changed data flow
- Do NOT update for: bug fixes, small features, refactors within existing structure
- When updating, verify claims against actual code — this file drifts

**BACKLOG.md** (update as items change)
- Check off completed items: `- [x]`
- Add newly discovered items
- Remove items that are no longer relevant

**CONVENTIONS.md** (rarely needs updating)
- Only update when a new pattern is explicitly established or a rule changes

**Project-root files** (`AGENTS.md`, `CLAUDE.md`) — only if dev commands, stack, or entry point references changed.

### Step 3: Verify before writing

For any claim you're about to write:
- **Code pointers**: verify the file exists and the function is in it
- **Architecture claims**: read the actual source to confirm
- **Decision status claims**: check the code matches ("removed X", "replaced by Y")

Don't write things you haven't verified. A wrong entry is worse than no entry.

### Step 4: Commit the updates

After updating, commit the .claude/ changes with a descriptive message:

```bash
git add .claude/
git commit -m "docs: update second brain — <brief summary of what changed>"
```

### Step 5: Summary

Briefly tell the user what was updated:

```
Updated:
- DECISIONS.md — added entry for <decision>
- CODE_POINTERS.md — added <new file> references
```

If nothing needed updating, say so: "Nothing changed in the knowledge base this session."

## Guidelines

- **Skip files that didn't change** — don't touch ARCHITECTURE.md for a bug fix session.
- **No session notes** — the git log handles this. Don't recreate NOTES.md behavior.
- **Verify before writing** — check actual files for code pointers and architecture claims.
- **Be concise** — entries should be scannable. Tables and bullets over prose.
- **Minimal commits** — one commit for all .claude/ changes, not one per file.
- **Don't fabricate** — only record things that actually happened.
