---
name: load-second-brain
description: Load the .claude/ knowledge base ("second brain") for the current project to gain full context before working. Read when starting a non-trivial session, when the user mentions the second brain, or when you need project context like architecture, decisions, conventions, or backlog.
---

# Load Second Brain

Read the .claude/ knowledge base to internalize project context before doing work. This is the complement to init-second-brain (creates the knowledge base) and update-second-brain (records session work).

## When to Use

- At the start of a non-trivial session on a project that has a .claude/ directory
- When the user asks you to "load context", "read the second brain", or "get up to speed"
- Before making architectural decisions, to check existing decisions and conventions
- Before touching code, to check code pointers and conventions

## Process

### Step 1: Locate the knowledge base

Find the .claude/ directory in the current project root.

Important (ignore-safe detection):
- Do not rely on file discovery tools that respect .gitignore / ignore rules to decide whether .claude/ exists.
- Prefer direct path checks / direct reads at expected paths (for example: `<project-root>/.claude/ARCHITECTURE.md`).
- If discovery says "not found" but direct reads succeed, trust the direct reads.

If .claude/ truly doesn't exist, tell the user and suggest running the init-second-brain skill.

### Step 2: Read knowledge files (batch)

Read all of these files in a single parallel batch — do not read them one at a time:

| File | Purpose | Priority |
|------|---------|----------|
| ARCHITECTURE.md | Codebase shape, modules, data flow, infrastructure | High — read first |
| BACKLOG.md | Open items, planned work, tech debt | High — know what's pending |
| NOTES.md | Session history (newest first) | High — recent context |
| DECISIONS.md | Settled choices and their rationale | Medium — avoid re-litigating |
| CODE_POINTERS.md | File/function locations by subsystem | Medium — reference on demand |
| CONVENTIONS.md | Code style, patterns, gatekeeping rules | Medium — follow when editing |

Also check for:
- `commands/` — slash commands (read if about to use one)

Skip any files that don't exist — the knowledge base may be partial.

Implementation detail: attempt direct Read calls to each expected file path in parallel and treat "file not found" responses as missing files.

### Step 3: Internalize silently

After reading, do not produce a summary unless the user asks for one. Simply proceed with full project context loaded. The knowledge base is for your benefit — the user already knows their project.

If the user explicitly asks for a summary or asks "what do you know", then provide a structured overview:
- Project purpose (one line)
- Current state (what's working, what's in progress)
- Key open items from backlog
- Recent session activity (last 1-2 sessions from NOTES.md)

### Step 4: Apply context during the session

With the knowledge base loaded:
- Check DECISIONS.md before proposing approaches that may have been already evaluated
- Check CONVENTIONS.md before writing or editing code
- Check CODE_POINTERS.md before searching for code locations you might already have references for
- Check BACKLOG.md to understand if a task relates to planned work
- Check ARCHITECTURE.md to understand where new code should live

## Guidelines

- **Batch reads**: Always read files in parallel, never sequentially — minimizes latency.
- **Don't parrot back**: The user wrote these files. Don't summarize them back unprompted.
- **Trust the knowledge base**: If a decision is recorded, respect it unless the user explicitly wants to revisit.
- **Stale pointers**: CODE_POINTERS.md line numbers may drift after edits. Verify against actual files when navigating.
- **Session continuity**: The most recent NOTES.md entry tells you what happened last. Use it to pick up where things left off if the user asks.
