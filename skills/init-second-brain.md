---
name: init-second-brain
description: Bootstrap a .claude/ knowledge base ("second brain") for the current project. Explores the codebase, then creates structured knowledge files that accumulate context across sessions.
argument-hint: "[optional: path to existing analysis/review docs to ingest]"
---

# Initialize Second Brain

Bootstrap a .claude/ knowledge base for the current project. This creates a structured set of files that act as persistent memory across Claude Code sessions — capturing architecture, decisions, conventions, code pointers, backlog items, and session-by-session notes.

## Process

### Step 1: Explore the project

Before creating anything, thoroughly understand the project:

- Read pyproject.toml, package.json, Cargo.toml, or equivalent to understand the tech stack, dependencies, and package structure
- Scan the source directory structure to understand module organization
- Read key source files to understand architectural patterns and data flow
- Read the Makefile, scripts, or CI config to understand dev workflows
- Check for existing .claude/ content to preserve (especially `settings.local.json`)
- If the user provided a path or additional notes when invoking this skill, read those too

### Step 2: Create directory structure

```
.claude/
├── commands/         # Slash commands (Claude Code + Cursor)
├── ARCHITECTURE.md   # How the codebase is shaped (update on structural changes only)
├── DECISIONS.md      # Why things are the way they are (core file — always maintain)
├── CODE_POINTERS.md  # Where to find important things (core file — always maintain)
├── CONVENTIONS.md    # Rules and patterns to follow (gatekeeping)
└── BACKLOG.md        # Known issues, planned improvements, tech debt
```

Preserve any existing files (especially `settings.local.json`).

**No NOTES.md** — session history is tracked via git log. Use the `git-recap` skill to summarize recent work instead of maintaining manual session notes.

### Step 3: Populate knowledge files

Each file has a specific purpose. Populate with what you learned in Step 1:

**ARCHITECTURE.md** — How the codebase is shaped (update only when structural changes occur — new modules, new services, changed data flow. Not every session):
- Module/layer structure with key classes and their relationships
- Data flow diagrams (ASCII)
- Infrastructure (services, ports, compose files)
- Pipeline descriptions (build, deploy, data processing)
- Keep it scannable — tables and code blocks over prose

**DECISIONS.md** — Core file. The most valuable part of the second brain. Context behind settled choices. Each entry:
- `### Decision title`
- **When**: timeframe
- **Why**: rationale
- **Trade-off**: what was given up
- Seed with the most important architectural decisions visible in the code

**CODE_POINTERS.md** — Core file. Quick reference to important locations:
- Organized by subsystem/concern
- Tables with `| What | Where |` format
- Include file paths with line numbers where useful
- Include key constants, config classes, entry points

**CONVENTIONS.md** — Gatekeeping rules:
- Code style (linter, formatter, line length)
- Package/module structure patterns
- Testing patterns (markers, fixtures, test isolation)
- Git/versioning conventions
- Infrastructure conventions
- Any domain-specific conventions

**BACKLOG.md** — Known issues and planned work:
- Organized by priority or phase
- Checkbox format: `- [ ] Item description — impact, effort estimate`
- Include file:line references where the issue lives
- Sections for: planned improvements, tech debt, unresolved from sessions

### Step 4: Create project-level CLAUDE.md

Create a CLAUDE.md at the project root (not inside `.claude/`). This file is auto-loaded by Claude Code at the start of every session, so it acts as the entry point to the knowledge base. It should contain:

- Project name and one-line description
- A note: "If context is needed for a non-trivial session, run the `load-second-brain` skill explicitly."
- A reminder: "Update DECISIONS.md when making decisions, CODE_POINTERS.md when adding files/functions"
- A quick reference section with the most common dev commands (test, lint, build, infra)
- Key paths section pointing to the main source directories

Keep it short — this is a pointer and cheat sheet, not the full knowledge base. The detail lives in the .claude/ files. Do not include auto-load instructions or session start checklists — context should be loaded on demand, not automatically.

If a project-level CLAUDE.md already exists, add the Second Brain section to it rather than overwriting it and let the user know if it can be merged together.

### Step 5: Summary

Print a tree of everything created and a brief description of each file's contents. Remind the user:

> Update the knowledge base organically as you work:
> - **DECISIONS.md** — when a decision is made
> - **CODE_POINTERS.md** — when files/functions are added or renamed
> - **ARCHITECTURE.md** — when the system shape changes (new component, table, data flow)
> - **BACKLOG.md** — when items are completed or discovered
> - **CONVENTIONS.md** — when patterns change
>
> For session history, use the `git-recap` skill to summarize recent work from the git log.

## Guidelines

- **Bare bones first**: Don't over-populate. The knowledge base grows organically through sessions. Initial content should be accurate and useful, not exhaustive.
- **Scan, don't summarize**: These files should be quick to scan (tables, bullets, code blocks). Avoid long prose paragraphs.
- **File:line references**: Code pointers should be specific enough to navigate to, not vague.
- **No duplication**: Each file has its own concern. Architecture describes shape, Decisions explains why, Conventions says what to follow. Don't repeat the same info across files.
- **Adapt to the project**: A Python data pipeline needs different agents/skills than a React frontend or a Rust CLI tool. Tailor everything to the actual codebase.
