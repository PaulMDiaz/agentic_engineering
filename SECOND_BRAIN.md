<!-- second-brain-template: portable-v5 -->

# Second Brain

This repository's committed, self-contained knowledge base preserves durable
context across coding sessions. Keep referenced repository paths relative.

## Load Context Selectively

Before non-trivial work, read this file and load only the `.second_brain/` files that
materially help with the task. Skip files that do not exist; do not load the
entire knowledge base by default.

| File | Read when |
| --- | --- |
| `.second_brain/DECISIONS.md` | A proposal could revisit a settled choice, trade-off, or project direction. |
| `.second_brain/CODE_POINTERS.md` | The relevant file or symbol is unknown or insufficiently specified, the task crosses subsystems, or a public contract may exist beyond the named code. |
| `.second_brain/ARCHITECTURE.md` | The task is broad or unfamiliar, changes system shape or data flow, or adds a component or integration. |
| `.second_brain/CONVENTIONS.md` | You are changing code, documentation, configuration, tests, automation, or repository workflow and need project-specific rules. |
| `.second_brain/DEFERRED.md` | You are assessing intentionally deferred work, known gaps, or future agent follow-ups. |

Use the smallest relevant set.

For broad, unfamiliar, architectural, or ambiguous work, read all available
`.second_brain/` files before concluding. For narrow work, stop once the loaded
context is enough to answer correctly.

For bounded read-only work with a named file or symbol, inspect source and focused tests
first; consult only the relevant `CODE_POINTERS.md` section if scope or contract remains
unclear.

## Guidance Authority

For repository context, conventions, architecture, decisions, code pointers, and
durable-maintenance workflow, this file and the selected `.second_brain/` knowledge are the
primary repository guidance. Other `AGENTS.md` content remains authoritative for unrelated
repository rules.

Current source code, configuration, and explicit user requests are factual authority. When
they disprove a second-brain claim, do not act on the stale claim: verify the evidence,
correct durable knowledge during change-producing work when permitted, then continue using
the corrected guidance.

### Code Pointer Syntax

Use repository-relative `path/to/file.py::Symbol` references for stable classes,
functions, methods, public APIs, and cross-module contracts. Use
`path/to/file.py:L<line>` only for configuration, prose, module-level blocks, or locations
without a stable symbol. Verify every pointer before relying on it: symbols can be renamed
and line numbers can drift.

## Keep Knowledge Repository-Owned

Durable knowledge is repository-owned, source-verifiable context a future agent needs to
avoid a wrong decision or repeated investigation. It is not a session log or a copy of
existing repository documentation.

Record only durable knowledge owned by this repository. Follow inherited, global, or
user-local agent guidance during the current task, but do not copy it into this file or
the `.second_brain/` knowledge files. Do not record absolute filesystem paths, home-directory
paths, parent-directory paths, tool-home paths, or external shared-instruction paths.

For derived convention claims, cite repository-relative files or globs. If a rule exists
only outside this repository, report that it must be made repository-owned before it can
become durable project knowledge.

## Reuse Loaded Context

Before reading `.second_brain/` files, check whether the relevant context has already
been loaded during the current task. Reuse it when the branch and relevant
knowledge files have not changed. Treat instructions in `AGENTS.md`, nested
agent instructions, and skills as conditional: load only missing relevant
context, not the entire knowledge base again.

Re-read context when the task scope materially changes, the branch changes, a
relevant knowledge file changes, the earlier context is no longer available, or
the user asks for a fresh read.

## Keep Durable Knowledge Current

During change-producing work, update the relevant knowledge file when the
change creates or alters durable project knowledge:

| File | Update when |
| --- | --- |
| `DECISIONS.md` | A hard-to-reverse, non-obvious choice with a real trade-off is settled. |
| `CODE_POINTERS.md` | Important entry points, interfaces, workflows, commands, or contracts are added, renamed, or moved. |
| `ARCHITECTURE.md` | The system shape changes, such as a component, boundary, integration, or data flow. |
| `CONVENTIONS.md` | A durable project rule, pattern, or workflow changes. |
| `DEFERRED.md` | Intentionally deferred work, known gaps, or future agent follow-ups are discovered, completed, or reprioritized. |

During change-producing work, agents maintain these files organically; no separate
per-entry request is needed. Each entry must still be verified against repository sources.
When a later decision replaces a valid earlier one, mark the earlier entry superseded
rather than deleting its rationale. Correct or remove an entry only when it is a
source-verified error or duplicate; do not move a decision to deferred work as a substitute
for preserving the decision record.

`DEFERRED.md` is a repository-local context index, not a delivery-tracking system. Preserve
the repository's established entry format. When a deferred item has an applicable GitHub
issue, reference that issue in the entry; do not create issues automatically.

Suggest a GitHub issue only when all of the following are true:

1. The work is a specific, actionable change rather than an observation or preference.
2. It is intentionally outside the scope of the current pull request or feature branch.
3. It has meaningful impact on correctness, security, maintainability, user value, or
   operational risk.
4. It needs team ownership, prioritization, or visibility beyond agent context.

Before recommending an issue, inspect issue links already present in the current pull
request or branch context and run one focused repository issue search. Do not assume no
issue exists, but do not perform an exhaustive search. Lower-confidence agent follow-ups
may remain in `DEFERRED.md` without an issue when the entry says that no issue is required.

Before updating a knowledge entry, verify it against the affected repository sources.
When a change alters a source described by the knowledge base, update only the
corresponding entries. If no durable knowledge changed, leave the knowledge base unchanged.

Keep entries concise, accurate, and specific to this repository. Do not use
the knowledge base as a session log or duplicate information that belongs in
source code or existing documentation. For read-only work, report stale
knowledge but do not modify it.

<!-- /second-brain-template -->

## Repository-Specific Extensions

Add repository-specific context-loading or maintenance rules here. Keep portable baseline
rules inside the marked template section so a future migration can verify them without
overwriting these repository-owned extensions.
