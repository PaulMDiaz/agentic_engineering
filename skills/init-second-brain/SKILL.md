---
name: init-second-brain
description: Initialize or adopt a committed .second_brain/ knowledge base ("second brain") for the current project. Explores the codebase, preserves existing knowledge, and creates missing durable context.
argument-hint: "[optional: path to existing analysis/review docs to ingest]"
---

# Initialize Second Brain

Initialize or adopt a committed `.second_brain/` knowledge base for the current project. This
creates or completes a structured set of files that act as persistent memory across coding
agent sessions — capturing architecture, decisions, conventions, code pointers, and deferred work
items.

## Process

### Step 1: Assess existing state + explore the project

Check the existing knowledge base and entry points:

- **No `.second_brain/`** — fresh init. Proceed normally.
- **Has `.second_brain/`** — already initialized or partially initialized. Preserve existing files, create only missing current files, and don't overwrite content.
- **Has committed `.second_brain/` but no `SECOND_BRAIN.md` or has a legacy detailed `AGENTS.md` section** — adopt the portable entry points in Step 4 without replacing unrelated instructions or knowledge.

Always preserve `settings.local.json`.

For committed adoption, verify that `.second_brain/` is not ignored before creating or migrating
knowledge files. If it is ignored, remove only the matching ignore rule; do not disturb
unrelated ignore rules.

Treat the repository root as the evidence boundary while seeding knowledge. Inherited,
global, and user-local guidance can govern the current task, but do not copy it into
`.second_brain/` or cite it as a convention source. Never seed absolute filesystem paths,
home-directory paths, parent-directory paths, tool-home paths, or external
shared-instruction paths.

Then explore the project:

- Read pyproject.toml, package.json, Cargo.toml, or equivalent to understand the tech stack, dependencies, and package structure
- Scan the source directory structure to understand module organization
- Read key source files to understand architectural patterns and data flow
- Read the Makefile, scripts, or CI config to understand dev workflows
- If the user provided a path or additional notes when invoking this skill, read those too

### Step 2: Create directory structure

```
.second_brain/
├── ARCHITECTURE.md   # How the codebase is shaped (update on structural changes only)
├── DECISIONS.md      # Why things are the way they are (core file — always maintain)
├── CODE_POINTERS.md  # Where to find important things (core file — always maintain)
├── CONVENTIONS.md    # Rules and patterns to follow (gatekeeping)
└── DEFERRED.md       # Intentionally deferred work, known gaps, agent follow-ups
```

Only create files that don't already exist — never overwrite existing content.

**No NOTES.md** — session history is tracked via git log. Use the `git-recap` skill to summarize recent work.

### Canonical knowledge-file presentation

Use this minimal presentation for newly created files and when an audit migrates eligible
legacy formatting:

| File | Required top-level heading | Front matter |
| --- | --- | --- |
| `ARCHITECTURE.md` | `# Architecture` | None |
| `CODE_POINTERS.md` | `# Code Pointers` | None |
| `CONVENTIONS.md` | `# Conventions` | Only required audit metadata, including `last_full_audit` after a complete audit |
| `DECISIONS.md` | `# Decisions` | None |
| `DEFERRED.md` | `# Deferred Work` | None |

Do not add `summary` or `read_when` metadata, embedded `<!-- Format: ... -->` comments,
or other template-presentation guidance to knowledge files. Keep project-owned sections
and durable content intact.

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
- Seed only decisions visible in the code or docs where all three are true:
  1. The decision is hard to reverse.
  2. The choice would be surprising without context.
  3. The decision involved a real trade-off.

**CODE_POINTERS.md** — Core file. Quick reference to important locations:
- Organized by subsystem/concern
- Tables with `| What | Where |` format
- Prefer a stable symbol pointer in the form `path/to/file.py::Class.method` or
  `path/to/file.py::function_name` for classes, methods, functions, public APIs, and
  cross-module contracts
- Use repository-relative `path/to/file.py:L<line>` only for configuration, prose,
  module-level blocks, or locations without a stable symbol
- Include important entry points, public APIs, cross-module contracts, workflows,
  commands, config classes, and files future agents need to find. Do not record every helper.

For example:

| What | Where |
| --- | --- |
| Main workflow entry point | `src/package/workflow.py::PlannerWorkflow.run` |
| Environment configuration | `config/defaults.yaml:L12-L28` |

**CONVENTIONS.md** — Gatekeeping rules:
- Include `last_full_audit: YYYY-MM-DD` in front matter only after the initial full audit
- Add a `Sources:` line immediately after every top-level `##` section heading
- Cite repository-relative paths or globs for derived facts
- Do not copy or cite inherited, global, shared, or user-local guidance; it must be made
  repository-owned before it can become a durable convention
- Use the exact reserved value `normative repository policy` for intentional rules whose
  authority is the convention itself
- Code style (linter, formatter, line length)
- Package/module structure patterns
- Testing patterns (markers, fixtures, test isolation)
- Git/versioning conventions
- Infrastructure conventions
- Any domain-specific conventions

After populating a new conventions file, run or follow `audit-second-brain`. Set
`last_full_audit` only when every section is verified or explicitly normative. If an
existing conventions file is legacy, preserve it first, then migrate it through the audit
workflow during a change-producing task; a read-only invocation reports the migration
debt without writing.

**DEFERRED.md** — Intentionally deferred work and agent follow-ups:
- Organized by priority or phase
- Checkbox format: `- [ ] Item description — impact, effort estimate`
- Include file:line references where the issue lives
- Preserve an existing repository format rather than imposing this suggested shape
- Reference an applicable GitHub issue in the entry; do not create issues automatically

### Step 4: Establish portable root entry points

Before copying either canonical template, locate the Agentic Engineering source root that
supplied this skill. For a mirrored Codex skill, read its adjacent
`.agentic-engineering-skill-source` marker; for a symlinked skill, resolve the symlink and
infer the source root from the source skill path. Then read
`<agentic-engineering-root>/SECOND_BRAIN.md` and
`<agentic-engineering-root>/AGENTS.second-brain.snippet.md`. If the source root or either template is
unavailable, stop and ask the user for the canonical template location; do not recreate it
from memory.

Create `SECOND_BRAIN.md` at the repository root from the framework's canonical template if
it is missing. The source template begins with the portable marker and is directly
copyable. The copied portable baseline is versioned and
bounded by `second-brain-template` comments; repository-specific extensions belong after
the closing marker. Keep the adopted copy self-contained: use repository-relative paths and
do not require this skill, a particular agent, service, or local filesystem layout after
adoption. Preserve an existing `SECOND_BRAIN.md` unless the user asks to revise it; use
`audit-second-brain` for an eligible versioned-baseline migration rather than replacing an
existing file wholesale.

Then integrate the delimited `Second Brain — Primary Repository Guidance` section from
`AGENTS.second-brain.snippet.md` into `AGENTS.md`. Place it immediately after any YAML
front matter and repository title, before all other guidance:

- **Existing `AGENTS.md` with the `second-brain-guidance` markers or a clearly delimited
  `## Second Brain` section** — replace that section with the canonical portable
  integration and move it to the primary position. Preserve every unrelated instruction.
- **Existing `AGENTS.md` with no safely delimited second-brain section** — insert the
  canonical integration in the primary position and preserve ambiguous legacy wording.
  Do not guess which broader instructions to delete.
- **No `AGENTS.md`** — create a concise file containing the portable integration from the
  snippet.

The integration must require agents to read and follow `SECOND_BRAIN.md` before relevant
work, selectively load its knowledge, assess durable knowledge before every
change-producing handoff, and correct stale claims when source or user evidence disproves
them.

`CLAUDE.md` is optional and tool-specific. If the repository already uses one, add a short
pointer to `SECOND_BRAIN.md` without overwriting unrelated content. Do not create it solely
for second-brain adoption.

### Step 5: Summary

Print a tree of everything created or adopted and a brief description of each file's
contents. Remind the user:

> Update the knowledge base organically as you work:
> - **DECISIONS.md** — when a decision is hard to reverse, surprising without context, and involved a real trade-off
> - **CODE_POINTERS.md** — when important entry points, public APIs, workflows, or commands are added or renamed
> - **ARCHITECTURE.md** — when the system shape changes (new component, table, data flow)
> - **DEFERRED.md** — when intentionally deferred items are completed or discovered
> - **CONVENTIONS.md** — when patterns change
> - **SECOND_BRAIN.md** and `AGENTS.md` — when the second-brain loading or maintenance
>   contract changes
>
> For session history, use the `git-recap` skill to summarize recent work from the git log.

## Guidelines

- **Bare bones first**: Don't over-populate. The knowledge base grows organically through sessions. Initial content should be accurate and useful, not exhaustive.
- **Scan, don't summarize**: These files should be quick to scan (tables, bullets, code blocks). Avoid long prose paragraphs.
- **Pointer stability**: Prefer symbols for stable code entry points. Use `path:line` only
  when no stable symbol exists, and verify either form because symbols can be renamed and
  lines can drift.
- **No duplication**: Each file has its own concern. Architecture describes shape, Decisions explains why, Conventions says what to follow. Don't repeat the same info across files.
- **Preserve legacy guidance carefully**: Replace a clearly delimited second-brain section
  and move the canonical integration to the primary position. When the boundary is
  unclear, insert the marked canonical section there and preserve ambiguous wording.
- **Adapt to the project**: A Python data pipeline needs different agents/skills than a React frontend or a Rust CLI tool. Tailor everything to the actual codebase.
- **Audit the initial state**: Initialization is the first full conventions audit, not a
  license to write plausible but unverified guidance.
