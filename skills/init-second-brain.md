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
├── NOTES.md          # Session log (append-only, newest first)
├── ARCHITECTURE.md   # How the codebase is shaped
├── DECISIONS.md      # Why things are the way they are
├── CODE_POINTERS.md  # Where to find important things (file:line references)
├── CONVENTIONS.md    # Rules and patterns to follow (gatekeeping)
└── BACKLOG.md        # Known issues, planned improvements, tech debt
```

Preserve any existing files (especially `settings.local.json`).

### Step 3: Populate knowledge files

Each file has a specific purpose. Populate with what you learned in Step 1:

**NOTES.md** — Session log. Append-only, newest entries at top. Each entry has:
- `## Session: YYYY-MM-DD`
- `### What we worked on` — bullet list of activities
- `### Decisions made` — choices and their rationale
- `### Still unresolved` — open questions, blocked items
- Seed with today's session: "Initialized second brain knowledge base"

**ARCHITECTURE.md** — How the codebase is shaped:
- Module/layer structure with key classes and their relationships
- Data flow diagrams (ASCII)
- Infrastructure (services, ports, compose files)
- Pipeline descriptions (build, deploy, data processing)
- Keep it scannable — tables and code blocks over prose

**DECISIONS.md** — Context behind settled choices. Each entry:
- `### Decision title`
- **When**: timeframe
- **Why**: rationale
- **Trade-off**: what was given up
- Seed with the most important architectural decisions visible in the code

**CODE_POINTERS.md** — Quick reference to important locations:
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
- A reminder: "Before ending any session, say 'update second brain'"
- A quick reference section with the most common dev commands (test, lint, build, infra)
- Key paths section pointing to the main source directories

Keep it short — this is a pointer and cheat sheet, not the full knowledge base. The detail lives in the .claude/ files. Do not include auto-load instructions or session start checklists — context should be loaded on demand, not automatically.

If a project-level CLAUDE.md already exists, add the Second Brain section to it rather than overwriting it and let the user know if it can be merged together.

### Step 5: Summary

Print a tree of everything created and a brief description of each file's contents. Remind the user:

> To update the knowledge base after a work session, say: "update the project notes with what we worked on"
>
> Over time, also update ARCHITECTURE.md, DECISIONS.md, CODE_POINTERS.md, CONVENTIONS.md, and BACKLOG.md as the project evolves.

## Guidelines

- **Bare bones first**: Don't over-populate. The knowledge base grows organically through sessions. Initial content should be accurate and useful, not exhaustive.
- **Scan, don't summarize**: These files should be quick to scan (tables, bullets, code blocks). Avoid long prose paragraphs.
- **File:line references**: Code pointers should be specific enough to navigate to, not vague.
- **No duplication**: Each file has its own concern. Architecture describes shape, Decisions explains why, Conventions says what to follow. Don't repeat the same info across files.
- **Adapt to the project**: A Python data pipeline needs different agents/skills than a React frontend or a Rust CLI tool. Tailor everything to the actual codebase.
