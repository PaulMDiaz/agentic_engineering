---
name: load-second-brain
description: Load the .second_brain/ knowledge base ("second brain") for the current project to gain full context before working. Read when starting a non-trivial session, when the user mentions the second brain, or when you need project context like architecture, decisions, conventions, or deferred work.
---

# Load Second Brain

Read the missing relevant `.second_brain/` knowledge to internalize project context before doing
work. This is the complement to `init-second-brain` (creates or adopts the knowledge base),
`update-second-brain` (performs source-aware scoped maintenance), and
`audit-second-brain` (restores full trust when needed).

## Session Guard

Before reading anything, check whether the relevant context is already available in the
current task. Reuse it when the branch and relevant knowledge files have not changed.
Skills and agent instructions that mention this workflow are conditional prompts to load
missing context, not reasons to reload the entire knowledge base.

Read again only when the task scope materially changes, the branch changes, a relevant
knowledge file changes, the earlier context is unavailable, or the user asks for a fresh
read. This guard does not suppress an audit or other task that must inspect current files
as direct evidence.

## When to Use

- At the start of a non-trivial session that needs project context not already loaded in the current task on a project with a `.second_brain/` directory
- When the user asks you to "load context", "read the second brain", or "get up to speed"
- Before making architectural decisions, to check existing decisions and conventions
- Before changing code, when code pointers or conventions are needed to locate or shape work

A bounded read-only task with a named file or symbol is not, by itself, a
reason to load the knowledge base. Inspect the named source and focused tests first; load
only context that resolves material uncertainty about location, scope, or contract.

## Process

### Step 1: Read the repository policy and locate the knowledge base

Before selecting `.second_brain/` files, directly check for `SECOND_BRAIN.md` in the
target repository root. If it exists, read it fully: it is the repository-owned policy
for context selection, knowledge ownership, and maintenance. Follow repository-specific
rules it defines; use this skill's generic workflow only where that policy is silent.

If `SECOND_BRAIN.md` does not exist, continue with this workflow normally.

Find the `.second_brain/` directory in the current project root.

Important (ignore-safe detection):
- Do not rely on file discovery tools that respect .gitignore / ignore rules to decide whether `.second_brain/` exists.
- Prefer direct path checks / direct reads at expected paths (for example: `<project-root>/.second_brain/ARCHITECTURE.md`).
- If discovery says "not found" but direct reads succeed, trust the direct reads.

If `.second_brain/` truly doesn't exist, tell the user and suggest running the init-second-brain skill.

### Step 2: Read knowledge files by relevance

For most non-trivial work, first identify which core files are relevant, then read any
missing selected files in one parallel batch:

| File | Purpose | Read when |
|------|---------|----------|
| DECISIONS.md | Settled choices and their rationale | A proposal could revisit a settled choice or trade-off |
| CODE_POINTERS.md | File/function locations by subsystem | The relevant file or symbol is unknown or insufficiently specified |

Then read additional files only when they are relevant to the task:

| File | Read when |
|------|-----------|
| DEFERRED.md | Assessing intentionally deferred work, triaging refactors, or checking known gaps |
| ARCHITECTURE.md | Broad changes, new modules/components, data flow, infrastructure, or unfamiliar system shape |
| CONVENTIONS.md | Editing code, docs, commands, skills, CI, or repo workflow |

For broad, unfamiliar, architectural, or ambiguous work, read all available knowledge files
in one parallel batch. For narrow tasks, stop once the loaded context is enough to work
correctly.

For a bounded task with a named file or symbol, do not read all of `CODE_POINTERS.md` by
default. Inspect the named code and focused tests first, then locate and read only the
relevant pointer section if it still materially reduces uncertainty.

Skip any files that don't exist — the knowledge base may be partial.

Implementation detail: attempt direct Read calls to each selected file path in parallel
and treat "file not found" responses as missing files.

### Step 3: Run the lightweight conventions trust gate

When `CONVENTIONS.md` is relevant, inspect only its front matter and section source lines
before trusting its claims:

- every top-level `##` section should have a `Sources:` line
- front matter should contain `last_full_audit: YYYY-MM-DD`
- the full audit is overdue when that date is more than 90 days before the current system
  date

Missing source lines indicate a legacy or partially migrated file. A missing or overdue
date indicates that full verification is due.

Respond according to the current task boundary:

- **Change-producing task:** run or follow `audit-second-brain` and migrate or refresh the
  conventions before handoff.
- **Read-only task:** verify only claims needed for the request, report the audit debt,
  and do not edit repository files.

For a current change, compare the changed file paths with the relevant section's declared
sources. Verify that section before relying on it and ensure the change-producing workflow
updates stale claims. Do not load unrelated configuration merely to perform this check.

### Step 4: Internalize silently

After reading, do not produce a summary unless the user asks for one. Simply proceed with full project context loaded. The knowledge base is for your benefit — the user already knows their project.

If the user explicitly asks for a summary or asks "what do you know", then provide a structured overview:
- Project purpose (one line)
- Current state (what's working, what's in progress)
- Key open deferred items
- Recent activity (from git log: `git log --oneline -10`)

### Step 5: Apply context during the session

With the knowledge base loaded:
- Check DECISIONS.md before proposing approaches that may have been already evaluated
- Check CONVENTIONS.md before writing or editing code
- Check CODE_POINTERS.md before searching for code locations you might already have references for
- Check DEFERRED.md to understand if a task relates to intentionally deferred work
- Check ARCHITECTURE.md to understand where new code should live

## Guidelines

- **Batch reads**: Read selected files in parallel, never sequentially — minimizes latency.
- **Load enough, then stop**: Use the smallest context set that materially improves correctness.
- **Reuse before reading**: Do not reload context already available and still current in
  this task merely because another instruction mentions the second brain.
- **Direct source first**: A named file or symbol and focused tests are sufficient for a
  bounded read-only task unless location, scope, or contract remains unclear.
- **Trust before use**: Treat missing source annotations or an overdue audit date as
  visible audit debt, not as permission to assume the claims are current.
- **Don't parrot back**: The user wrote these files. Don't summarize them back unprompted.
- **Trust the knowledge base**: If a decision is recorded, respect it unless the user explicitly wants to revisit.
- **Pointer syntax**: Treat `path/to/file.py::Symbol` as the preferred reference for a
  stable class, function, method, public API, or cross-module contract. Treat
  repository-relative `path/to/file.py:L<line>` as the fallback for configuration, prose,
  module-level blocks, or locations without a stable symbol.
- **Stale pointers**: Verify every pointer against actual files when navigating: line
  numbers can drift and symbols can be renamed.
- **Session continuity**: If you need to know what happened recently, run `git-recap` or check `git log --oneline -20`.
- **Missing files are okay**: Not every project will have all files. Work with what exists.
