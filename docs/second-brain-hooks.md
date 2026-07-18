---
summary: "How agents keep second-brain guidance current without automatic context hooks"
read_when: "Initializing, loading, updating, or auditing project memory"
---

# Second-Brain Workflow

## Session start

Repository guidance should instruct agents to run `load-second-brain` explicitly for
non-trivial work that needs project context. Loading is intentional rather than an
automatic hook so narrow tasks do not pay the context cost.

When `CONVENTIONS.md` is relevant, loading performs a lightweight trust gate. It checks
for a `last_full_audit` date and a `Sources:` line under every top-level convention
section. It does not read every declared source unless the current task or audit state
requires that evidence.

## Organic maintenance

Second-brain maintenance is agent-owned; users do not need to invoke
`update-second-brain` explicitly. During change-producing work, changed files are matched
to convention sections through their declared sources. Only affected knowledge is
verified and updated.

Intentional rules without an external configuration source use the reserved declaration
`Sources: normative repository policy`. Derived facts cite concrete paths or globs.

Read-only tasks preserve their mutation boundary: they may verify relevant claims and
report audit debt, but they do not migrate or update repository files.

## Full audit and legacy migration

Use `audit-second-brain` when conventions are legacy, partially migrated,
contradictory, explicitly requested, or more than 90 days past `last_full_audit`. A
change-producing task migrates legacy sections in place while preserving valid content
and formatting. A read-only task reports the required migration instead.

Full audits verify every top-level section against authoritative repository evidence.
Partial audits may correct verified sections, but `last_full_audit` advances only after
every section is verified or explicitly normative. Missing evidence leaves the audit
overdue and visible.

## Session end

After meaningful change-producing work, perform source-aware maintenance when durable
architecture, decisions, conventions, code pointers, backlog information, or a declared
convention source changed. Git history remains the source of truth for ordinary session
activity; do not add audit logs or session notes to `.claude/`.

## Cross-branch sync

Use `sync-second-brain` when a project intentionally maintains `.claude/` on a dedicated
branch. The skill uses a temporary worktree so product branches remain focused and
deletions stay reviewable.
