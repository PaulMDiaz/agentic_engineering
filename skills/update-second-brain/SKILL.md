---
name: update-second-brain
description: Update the .claude/ knowledge base when durable project knowledge changed. Verifies accuracy of entries related to touched files, then updates. Works with any agent (Claude Code, Cursor, OpenClaw).
argument-hint: "[optional: focus area or notes to include]"
---

# Update Second Brain

Record durable project knowledge into the .claude/ knowledge base. Verifies accuracy of
affected entries before writing — keeps the knowledge base trustworthy for all agents,
including those without conversation history (e.g. Cursor).

Do not add session notes. If no decisions, architecture, conventions, important code
pointers, or backlog items changed, report that no second-brain update was needed.

## Why Accuracy Matters

Agents without full conversation context (Cursor, Codex, fresh Claude Code sessions) rely
on these files as their primary source of truth. A stale CODE_POINTERS.md entry or wrong
ARCHITECTURE.md claim actively misleads. Every update pass must verify what it touches.

## Process

### Step 1: Identify what changed

Get the list of files modified this session:

```bash
git diff --name-only main
```

Or if working on the same branch across sessions:
```bash
git diff --name-only HEAD~N  # where N = approximate commits this session
```

This scopes the verification — you only need to verify entries related to files you touched.

### Step 2: Reflect on the session

Review the conversation (or git log if conversation is unavailable) to identify durable
knowledge changes:

1. **Decisions made** — choices that were hard to reverse, surprising without context,
   and involved a real trade-off
2. **Important code pointers** — entry points, public APIs, cross-module contracts,
   workflows, commands, or files future agents need to find
3. **Structural changes** — new modules, services, tables, data flow changes
4. **Backlog changes** — items completed, discovered, or reprioritized
5. **Convention changes** — new patterns established or rules changed

If none of those changed, stop after scoped verification and tell the user:
"No durable second-brain update was needed."

### Step 3: Scoped verification

For each knowledge base file, verify entries that reference the changed files. Do not
verify the entire file — only the intersection of "what the file claims" and "what you
touched."

**CODE_POINTERS.md** (most likely to drift)
- For each changed file: find CODE_POINTERS entries referencing it
- Verify: file still exists, function/class names are correct, line numbers are approximately right
- Fix stale entries, add new entries only for important entry points, public APIs,
  cross-module contracts, workflows, commands, or files future agents need to find
- Remove entries for deleted code or tools
- If line numbers shifted significantly, update them

**ARCHITECTURE.md** (verify claims about touched areas)
- For each changed module/component: find ARCHITECTURE.md sections describing it
- Verify: module descriptions match actual code, data flow steps are in the right order, component names match reality
- Only update when structural shape changed (new component, new table, new data flow step)
- Do NOT update for bug fixes or minor features within existing structure

**DECISIONS.md** (verify status claims)
- For entries that reference changed files: verify status claims ("removed X", "replaced by Y", "not yet implemented") against actual code
- Mark superseded decisions: append `> ⚠️ Superseded — reason` below the entry
- Add new entries only for decisions where all three are true:
  1. The decision is hard to reverse.
  2. The choice would be surprising without context.
  3. The decision involved a real trade-off.
- Format: `### Title` / `**When:** YYYY-MM-DD` / `**Why:** ...` / `**Trade-off:** ...`

**CONVENTIONS.md** (rarely drifts)
- Only verify if conventions-related files changed (linter config, CI, Makefile, pyproject.toml)
- Verify tool commands still match config (e.g. `ruff check .` still works)
- Update when patterns change

**BACKLOG.md** (update as items change)
- Check off completed items: `- [x]`
- Add newly discovered items
- Remove items no longer relevant
- No verification needed — backlog is forward-looking

**Project-root files** (`AGENTS.md`, `CLAUDE.md`)
- Only update if dev commands, stack references, or entry points changed

### Step 4: Write updates

Apply all changes in one pass per file. Verify before writing — read the actual source
file to confirm any claim you're about to add or correct.

If the user asked you to commit the second-brain updates, stage the `.claude/` files and
commit directly:
```bash
git add .claude/
git commit -m "docs(second-brain): 📝 update <brief summary>"
```

### Step 5: Summary

Tell the user what was updated and what was verified:

```
Updated:
- CODE_POINTERS.md — added cli.py entries, fixed store line numbers
- DECISIONS.md — added batch commits decision

Verified (no changes needed):
- ARCHITECTURE.md — data flow still accurate for touched modules
```

If nothing needed updating: "Verified entries for touched files — knowledge base is current."

## Guidelines

- **Always verify what you touch** — the scoped check is cheap and prevents rot.
- **Don't verify everything** — full-file audits are expensive and rarely catch issues in untouched areas.
- **No session notes** — git log handles session history. Use the `git-recap` skill.
- **Durable knowledge only** — skip updates for transient progress, obvious/reversible
  choices, and implementation details future agents do not need.
- **Verify before writing** — read actual source files to confirm claims. Don't write from memory.
- **Be concise** — entries should be scannable. Tables and bullets over prose.
- **One commit** for all .claude/ changes, not one per file.
- **Don't fabricate** — only record things that actually happened.
- **When in doubt, check the code** — a Cursor agent will trust what you write here. Get it right.
