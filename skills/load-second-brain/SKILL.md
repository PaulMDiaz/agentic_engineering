---
name: load-second-brain
description: Load the .claude/ knowledge base ("second brain") for the current project to gain full context before working. Read when starting a non-trivial session, when the user mentions the second brain, or when you need project context like architecture, decisions, conventions, or backlog.
---

# Load Second Brain

Read the .claude/ knowledge base to internalize project context before doing work. This is the complement to init-second-brain (creates the knowledge base) and update-second-brain (records session work).

## When to Use

- At the start of a non-trivial session that needs project context on a project with a `.claude/` directory
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

### Step 2: Read knowledge files by relevance

For most non-trivial work, first read these core files in one parallel batch:

| File | Purpose | Priority |
|------|---------|----------|
| DECISIONS.md | Settled choices and their rationale | Core — avoid re-litigating |
| CODE_POINTERS.md | File/function locations by subsystem | Core — fast navigation |

Then read additional files only when they are relevant to the task:

| File | Read when |
|------|-----------|
| BACKLOG.md | Planning work, triaging refactors, or checking known gaps |
| ARCHITECTURE.md | Broad changes, new modules/components, data flow, infrastructure, or unfamiliar system shape |
| CONVENTIONS.md | Editing code, docs, commands, skills, CI, or repo workflow |

For broad, unfamiliar, architectural, or ambiguous work, read all available knowledge files
in one parallel batch. For narrow tasks, stop once the loaded context is enough to work
correctly.

Skip any files that don't exist — the knowledge base may be partial.

Implementation detail: attempt direct Read calls to each selected file path in parallel
and treat "file not found" responses as missing files.

### Step 3: Internalize silently

After reading, do not produce a summary unless the user asks for one. Simply proceed with full project context loaded. The knowledge base is for your benefit — the user already knows their project.

If the user explicitly asks for a summary or asks "what do you know", then provide a structured overview:
- Project purpose (one line)
- Current state (what's working, what's in progress)
- Key open items from backlog
- Recent activity (from git log: `git log --oneline -10`)

### Step 4: Apply context during the session

With the knowledge base loaded:
- Check DECISIONS.md before proposing approaches that may have been already evaluated
- Check CONVENTIONS.md before writing or editing code
- Check CODE_POINTERS.md before searching for code locations you might already have references for
- Check BACKLOG.md to understand if a task relates to planned work
- Check ARCHITECTURE.md to understand where new code should live

## Guidelines

- **Batch reads**: Read selected files in parallel, never sequentially — minimizes latency.
- **Load enough, then stop**: Use the smallest context set that materially improves correctness.
- **Don't parrot back**: The user wrote these files. Don't summarize them back unprompted.
- **Trust the knowledge base**: If a decision is recorded, respect it unless the user explicitly wants to revisit.
- **Stale pointers**: CODE_POINTERS.md line numbers may drift after edits. Verify against actual files when navigating.
- **Session continuity**: If you need to know what happened recently, run `git-recap` or check `git log --oneline -20`.
- **Missing files are okay**: Not every project will have all files. Work with what exists.
