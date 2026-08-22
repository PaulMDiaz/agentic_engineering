---
summary: "How Agentic Engineering keeps second-brain guidance current through source-aware agent work"
read_when: "Initializing, loading, updating, or auditing project memory"
---

# Second-Brain Workflow

## Session start

The delimited `Second Brain — Primary Repository Guidance` section in a repository-local
`AGENTS.md` is the primary guide for repository context and durable maintenance. It appears
immediately after front matter/title and remains self-contained for repositories without
Agentic Engineering installed. Shared guidance points to this local contract instead of
duplicating it.
The section does not override unrelated repository rules; source code, configuration, and
explicit user requests correct any stale second-brain claim before work continues.

Repository guidance should instruct agents to run or follow `load-second-brain` only when
relevant context is not already loaded and current in the task. Loading is intentional
rather than an automatic hook, so narrow tasks and repeated instructions do not pay the
context cost.

When another agent instruction or skill mentions the second brain, treat it as a
conditional prompt to load missing relevant context. Re-read only after a material scope
or branch change, a change to relevant knowledge files, loss of prior context, or an
explicit user request.

For bounded read-only work with a named file or symbol, inspect the direct
source and focused tests first. Load only the relevant `CODE_POINTERS.md` section when
location, scope, or a public contract remains unclear; do not read the whole file by default.

`init-second-brain` supports both fresh initialization and adoption of an existing committed
knowledge base. It preserves existing `.second_brain/` content and unrelated `AGENTS.md`
instructions while adding missing portable entry points.

When `CONVENTIONS.md` is relevant, loading performs a lightweight trust gate. It checks
for a `last_full_audit` date and a `Sources:` line under every top-level convention
section. It does not read every declared source unless the current task or audit state
requires that evidence.

## Organic maintenance

Second-brain maintenance is agent-owned; users do not need to invoke
`update-second-brain` explicitly. During change-producing work, changed files are matched
to convention sections through their declared sources. Only affected knowledge is
verified and updated.

Before completing change-producing work, agents assess whether decisions, architecture,
conventions, code pointers, deferred work, or declared convention sources changed. They
update relevant durable knowledge when it did; otherwise they state that no durable update
was needed.

For `CODE_POINTERS.md`, use `path/to/file.py::Symbol` for stable classes, functions,
methods, public APIs, and cross-module contracts. Use repository-relative
`path/to/file.py:L<line>` only for configuration, prose, module-level blocks, or locations
without a stable symbol. Verify either form because symbols can be renamed and line numbers
can drift.

During every change-producing audit, `audit-second-brain` migrates eligible legacy
pointers after verifying their source symbols. It retains ambiguous/configuration/prose
locations as `path:line` and reports unresolved fallbacks. A legacy alias may normalize
only when it uniquely verifies to a repository-relative source file; the audit does not
invent symbols or rewrite unsafe fallback pointers.

Intentional rules without an external configuration source use the reserved declaration
`Sources: normative repository policy`. Derived facts cite concrete paths or globs.

Committed knowledge stays repository-owned. Agents may follow inherited, global, or
user-local guidance during a task, but they do not copy it into `.second_brain/` or cite it as
convention evidence. Durable knowledge must not contain absolute, home-directory,
parent-directory, tool-home, or external shared-instruction paths. A rule that exists only
outside the repository must be made repository-owned before it can become a convention.

Read-only tasks preserve their mutation boundary: they may verify relevant claims and
report audit debt, but they do not migrate or update repository files.

## Full audit and legacy migration

Use `audit-second-brain` when conventions are legacy, partially migrated,
contradictory, explicitly requested, or more than 90 days past `last_full_audit`. A
change-producing task migrates legacy sections in place while preserving valid durable
content and project-specific section organization. A read-only task reports the required
migration instead.

Full audits verify every top-level section against authoritative repository evidence and
inspect meaningful top-level structure in declared source directories or globs for missing
durable workflow categories. Partial audits may correct verified sections, but
`last_full_audit` advances only after every section is verified or explicitly normative.
Missing evidence leaves the audit overdue and visible.

### Portable template migration

The root `SECOND_BRAIN.md` has a versioned portable baseline enclosed by
`second-brain-template` comments. Content after the closing marker is a repository-owned
extension area. During a change-producing audit, `audit-second-brain` migrates marked,
unversioned, or customized templates to the current portable baseline while preserving
repository-owned extensions. Ambiguous content is retained in a migration-review subsection
for the repository owner to resolve; it is never discarded. The audit also renames a legacy
`.second_brain/BACKLOG.md` to `DEFERRED.md`, preserving durable entries before updating
active references. It normalizes each existing core knowledge file to its canonical heading
and minimal presentation: only `CONVENTIONS.md` has audit front matter, and legacy
`summary`, `read_when`, and `<!-- Format: ... -->` presentation guidance is removed. Its
bundled read-only validator then requires the target's portable baseline to exactly match
the canonical template, validates the core-file presentation, and rejects a remaining legacy
backlog file.

The migration uses the canonical template supplied with the installed skill only as a
migration source. Target repositories continue to work without Agentic Engineering because their
committed `SECOND_BRAIN.md` remains the runtime policy and source of truth.

## Session end

After meaningful change-producing work, perform source-aware maintenance when durable
architecture, decisions, conventions, code pointers, deferred-work information, or a declared
convention source changed. Git history remains the source of truth for ordinary session
activity; do not add audit logs or session notes to `.second_brain/`.

## Cross-branch sync

Use `sync-second-brain` when a project intentionally maintains `.second_brain/` on a dedicated
branch. The skill uses a temporary worktree so product branches remain focused and
deletions stay reviewable.
