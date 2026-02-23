---
name: update-second-brain
description: Update the .claude/ knowledge base with what was worked on this session. Audits existing entries for staleness (read-back), corrects or supersedes stale content, then appends new session notes and updates architecture, decisions, conventions, code pointers, and backlog as needed.
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

### Step 2: Staleness audit (read-back)

Before writing anything new, audit each knowledge file for accuracy. Two passes are required:

**Pass A — Session-scope audit**
For each entry in **DECISIONS.md**, **ARCHITECTURE.md**, **CONVENTIONS.md**, **CODE_POINTERS.md**, and **BACKLOG.md**, ask:
- **Is this still true?** — Did the session reverse, supersede, or contradict it?
- **Is this still accurate?** — Did a rename, refactor, or dependency change make it wrong?
- **Is this still relevant?** — Did we remove the feature/module this entry describes?

**Pass B — Code-verification audit**
For any claim that can be checked against the actual codebase, read the relevant source file and verify it. Don't rely on session memory alone — latent inaccuracies from prior sessions won't surface otherwise. Specifically:

- **ARCHITECTURE.md** — verify env var names against the main entry point, component names against the source directory, module descriptions against actual module docstrings, data flow steps against the main processing function
- **CODE_POINTERS.md** — verify every file path exists, every function name exists in that file; check that status annotations ("not yet wired", "mocked in tests") still match reality
- **DECISIONS.md** — verify status claims against code (e.g. "removed from X", "replaced by Y", "not yet implemented") by reading the referenced files
- **CONVENTIONS.md** — verify tool commands still work (check that referenced CLI commands and flags match `pyproject.toml`, `Makefile`, or equivalent)
- **BACKLOG.md** — for checked-off items `- [x]`, verify the work is actually present in the codebase; for open items, verify descriptions still match current state

Flag anything that needs correction. You'll fix it in Step 5 (NOTES.md in Step 4 is append-only and is not subject to either audit pass).

Also check **project-root files** that are in scope but outside `.claude/`:
- `AGENTS.md` (if it exists) — stack, dev commands, test commands
- `CLAUDE.md` (if it exists) — entry point references

### Step 3: Reflect on the session

Review the full conversation to identify:

1. **What we worked on** — features built, bugs fixed, refactors done, explorations, reviews
2. **Decisions made** — any choices about approach, architecture, tools, patterns, or trade-offs
3. **Still unresolved** — open questions, blocked items, things deferred to later
4. **Architecture changes** — did the codebase shape change? New modules, new services, changed data flow?
5. **New decisions** — any settled choices that future sessions should know about?
6. **Code pointer updates** — new important files/functions, or did line numbers shift due to edits?
7. **Convention changes** — new patterns established, rules changed?
8. **Backlog updates** — items completed (check them off), new items discovered, priorities shifted?
9. **Stale carry-forward** — incorporate any entries flagged in Step 2 into your plan for Step 5 corrections.

If the user provided additional notes or a focus area when invoking this skill, incorporate that context too.

### Step 4: Update NOTES.md

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

### Step 5: Update other files (normalize format, correct stale entries, then add new)

For each file, check its format against the canonical structure below. If it's missing
front matter, has inconsistent heading levels, or uses a different structure — normalize
it in the same pass as the staleness corrections. Then append new content.

**Canonical formats:**

*All files except NOTES.md* — must open with YAML front matter, followed immediately by an embedded format comment:
```
---
summary: "One-line description of what this file contains"
read_when: "When a future agent should read this file"
---
<!-- Format: [one-line spec for this file — see per-file specs below] -->
```

*ARCHITECTURE.md*
```
<!-- Format: ## What This System Does → ## Component Map (directory tree in code block) → ## Data Flow (flow diagram in code block) → additional ## sections as needed. Horizontal rules (---) between major sections. -->
```
Sections: `# Architecture` → `## What This System Does` → `## Component Map` → `## Data Flow` → additional sections. Horizontal rules (`---`) between major sections.

*DECISIONS.md*
```
<!-- Format per entry: ### Title / **When:** YYYY-MM-DD / **Why:** ... / **Trade-off:** ... / optional > ⚠️ Superseded — reason (immediately after the entry, before the next ---). Horizontal rule (---) between entries. -->
```
Structure: `# Decisions` → one `### Title` block per decision, horizontal rule between entries.

*CODE_POINTERS.md*
```
<!-- Format: ## Section headers → | What | Where | tables. Paths as inline code, functions as `file.py` → `FunctionName()`. -->
```
Structure: `# Code Pointers` → grouped `## Section` headers → `| What | Where |` tables.

*CONVENTIONS.md*
```
<!-- Format: ## Section headers → rules as prose or short bullet lists. No tables. -->
```
Structure: `# Conventions` → `## Section` headers → prose or bullets.

*BACKLOG.md*
```
<!-- Format: ## Next Up → ## Known Gaps / Tech Debt → ## Done. Items as: - [ ] **Title** — description (open) or - [x] **Title** — description (done). -->
```
Structure: `# Backlog` → `## Next Up` → `## Known Gaps / Tech Debt` → `## Done`.

*NOTES.md* — no front matter. Opens with:
```
# Notes

<!-- Append-only. Newest entries at top. -->
<!-- Format per session: ## Session: YYYY-MM-DD (add "(continued)" if second entry same day) → ### What we worked on / ### Decisions made / ### Still unresolved. Single-line bullets only. Never edit or delete past entries. -->
```

---

For each file, **correct or remove stale entries identified in Step 2 before appending anything new**. Stale entries that survive are worse than no entries — they actively mislead future sessions.

**ARCHITECTURE.md** — Correct stale descriptions, then update if:
- New modules, services, or pipelines were added
- Data flow changed
- Infrastructure changed
- A significant refactor altered the codebase shape

**DECISIONS.md** — Mark superseded decisions as such (append `> ⚠️ Superseded — [brief reason]` immediately below the superseded entry's last line, before the next `###` heading), then append new entries if:
- A non-trivial choice was made about approach, tool, pattern, or trade-off
- Format: `### Title` / **When** / **Why** / **Trade-off**

**CODE_POINTERS.md** — Fix stale line numbers and removed files, then update if:
- New important files or functions were created
- Existing pointers have stale line numbers from significant edits
- Don't update line numbers for minor shifts — only when they'd be misleading

**CONVENTIONS.md** — Remove or correct overridden rules, then update if:
- A new coding pattern was established
- A rule was changed or added
- A new tool/process convention was adopted

**BACKLOG.md** — Update if:
- Backlog items were completed (check them off: `- [x]`)
- New issues or improvements were discovered
- Priorities shifted based on what we learned

**Project-root files** (`AGENTS.md`, `CLAUDE.md`) — Correct stale stack info, dev commands, test commands if the session changed them.

### Step 6: Summary

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

- **Don't skip the staleness audit** — write-forward without read-back lets old entries rot silently. A stale DECISIONS.md entry is actively worse than no entry.
- **Do the code-verification pass (Pass B)** — session memory only catches regressions introduced this session. Latent inaccuracies from earlier sessions (wrong env vars, stale module descriptions, mismatched function names) only surface when you check the actual files.
- **Don't fabricate** — only record things that actually happened in the conversation. If unsure, be conservative.
- **Be concise** — session notes should be scannable, not exhaustive. One line per bullet.
- **Preserve NOTES.md history** — never edit or delete previous session entries in NOTES.md. It's append-only. (Other files *should* be corrected when stale.)
- **Minimal updates** — don't touch files that didn't change. If the session was just a bug fix with no architectural impact, only NOTES.md and maybe BACKLOG.md need updating.
- **Accurate pointers** — if updating CODE_POINTERS.md, verify line numbers against the actual files before writing them.
- **Normalize on first touch** — if a file's format doesn't match the canonical structure, fix it in the same pass. Don't leave old formatting for "later". A poorly formatted second brain is nearly as bad as no second brain.
- **No busywork entries** — skip trivially obvious things. Focus on what a future session would benefit from knowing.
