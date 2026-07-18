---
name: audit-second-brain
description: Fully audit .claude/CONVENTIONS.md against authoritative repository sources, migrate legacy conventions to source annotations, and refresh stale guidance without adding a full scan to every session.
argument-hint: "[optional: focus area or additional evidence sources]"
---

# Audit Second-Brain Conventions

Perform a claim-by-claim audit of `.claude/CONVENTIONS.md`. This is the full-verification
counterpart to the scoped maintenance in `update-second-brain`: use it to establish or
restore trust, not as an unconditional session hook.

## When to Use

Run or follow this skill when:

- `init-second-brain` creates the initial conventions file
- `load-second-brain` finds a legacy conventions file without source annotations
- `last_full_audit` is missing or more than 90 days old
- a documented convention conflicts with repository behavior
- the user requests a conventions or second-brain audit
- a major merge or release warrants an explicit trust check

Routine changes should use source-aware scoped maintenance from `update-second-brain`.

## Permission Boundary

Classify the current task before writing:

- **Change-producing task** — audit and update `.claude/CONVENTIONS.md` in the same task.
- **Read-only task** — inspect and report stale or legacy guidance, but do not edit files.
  Identify the migration or correction as audit debt for the next change-producing task.

An audit trigger does not broaden a read-only request into permission to modify the repo.

## Convention Source Contract

The current format has two requirements:

1. YAML front matter contains `last_full_audit: YYYY-MM-DD` after a complete audit.
2. Every top-level `##` convention section has a `Sources:` line immediately after its
   heading. `###` subsections inherit the nearest parent source line unless they declare
   a more specific one.

Use concrete repository paths or globs for derived facts:

```markdown
## Code Style
Sources: `pyproject.toml`, `.github/workflows/ci.yml`
```

Use the exact reserved value `normative repository policy` for intentional rules whose
authority is the convention itself rather than a derived configuration fact:

```markdown
## Safety
Sources: normative repository policy, `AGENTS.md`
```

A normative policy still must not contradict higher-priority agent instructions,
documented decisions, or actual safety behavior. Do not use the reserved value to avoid
finding evidence for a factual claim.

## Process

### 1. Determine audit state

Read `.claude/CONVENTIONS.md` directly. Treat it as legacy or partially migrated if:

- `last_full_audit` is absent, or
- any top-level `##` section lacks a `Sources:` line.

Treat a complete file as overdue when `last_full_audit` is more than 90 days before the
current system date. Do not guess the date or run a clock command when the environment
already provides it.

### 2. Inventory claims and proposed sources

For each top-level section:

- enumerate actionable facts, commands, paths, versions, branches, workflows, safety
  behavior, and normative rules
- read declared sources when present
- for legacy sections, identify the smallest authoritative evidence set that could
  verify every claim
- distinguish derived facts from normative repository policy

Common evidence includes:

| Claim | Prefer |
| --- | --- |
| Runtime, dependencies, build, lint, typing | package manifests and tool configuration |
| CI, release branches, automation | repository workflows and live repository settings |
| Commands and destructive behavior | Makefiles, task runners, scripts, and safe help output |
| Package exports and module layout | source tree and package entry points |
| Fixtures and test patterns | test configuration, shared fixtures, and representative tests |
| Licensing | license configuration and CI commands |
| Agent workflow policy | `AGENTS.md`, shared standards, and durable decisions |

Prefer executable configuration and code over prose that repeats it. Use live repository
metadata for claims that can change without a local commit. If external evidence is not
available, mark that section blocked rather than silently falling back to an assumption.

Never execute destructive commands merely to verify their behavior. Inspect the
implementation or use an explicitly safe help, check, or dry-run path.

### 3. Verify every section

Classify each section:

- **Verified** — every claim matches its declared evidence or is a valid normative policy.
- **Corrected** — stale claims were updated to match authoritative evidence.
- **Unsupported** — a claim lacks authority and should be removed, narrowed, or moved to
  `DECISIONS.md` or `BACKLOG.md` when it belongs there.
- **Blocked** — required evidence could not be inspected or conflicts need user judgment.

Do not treat a plausible claim as verified. Run safe commands only when their output is
necessary to establish behavior; otherwise inspect the command definition.

### 4. Migrate or update

During a change-producing task:

- preserve valid content, headings, front matter, and local formatting
- add or correct one `Sources:` line per top-level section
- correct or remove stale claims in the same pass
- avoid broad rewrites unrelated to verification
- keep source lists concise; prefer a meaningful glob over a long file enumeration

Migration must be idempotent: a second complete audit against unchanged sources should
not produce formatting or source-list churn.

During a read-only task, report the exact changes that would be needed without applying
them.

### 5. Advance the audit date only on complete success

Set `last_full_audit` to the current date only when every top-level section is verified,
corrected, or explicitly classified as `normative repository policy` and all corrections
allowed by the task have been applied.

Partial audits may correct verified sections during a change-producing task, but they
must leave `last_full_audit` unchanged. Missing external access, unresolved conflicts, or
unverified sections keep the audit overdue.

### 6. Report evidence and results

Summarize:

```text
Verified:
- Code Style — pyproject.toml, .github/workflows/ci.yml

Corrected:
- Git / Versioning — removed stale dev branch guidance

Blocked:
- Repository default branch — live settings unavailable

Audit date:
- unchanged; full audit remains overdue
```

List the sources actually inspected, not every potential source. Git history records the
durable corrections; do not add a separate session-history or audit-log file.

## Guidelines

- **Source-driven, not schedule-driven:** source annotations handle ordinary maintenance;
  the 90-day cadence is a recovery backstop.
- **No procedural hooks:** agents evaluate the trust gate while loading context and
  completing change-producing work.
- **No false freshness:** an incomplete audit never advances `last_full_audit`.
- **No fabricated authority:** unresolved evidence stays visible.
- **Keep durable context small:** source lines and one front-matter date are enough.
