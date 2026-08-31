---
name: audit-second-brain
description: Fully audit .second_brain/CONVENTIONS.md against authoritative repository sources and safely migrate the versioned portable SECOND_BRAIN.md baseline when it is eligible.
argument-hint: "[optional: focus area or additional evidence sources]"
---

# Audit Second Brain

Perform a claim-by-claim audit of `.second_brain/CONVENTIONS.md` and, when eligible,
migrate the portable baseline in the repository-root `SECOND_BRAIN.md`. This is the
full-verification counterpart to the scoped maintenance in `update-second-brain`: use it
to establish or restore trust, not as an unconditional session hook.

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

- **Change-producing task** — audit and update `.second_brain/CONVENTIONS.md` and any
  eligible portable root-template migration in the same task.
- **Read-only task** — inspect and report stale or legacy guidance, but do not edit files.
  Identify the migration or correction as audit debt for the next change-producing task.

An audit trigger does not broaden a read-only request into permission to modify the repo.

## Portable Root-Template Migration

`SECOND_BRAIN.md` remains a repository-owned file. During a change-producing audit, this
skill migrates its portable policy to the current baseline; read-only tasks report the
needed migration. Repository-specific extensions are never synchronized from the source
playbook.

### Canonical template and boundary

Locate the Agentic Engineering source root using the same procedure as
`init-second-brain`: resolve a symlinked skill or read the adjacent
`.agentic-engineering-skill-source` marker for a mirrored Codex skill. Read that root's
`SECOND_BRAIN.md`. If the canonical source is unavailable, continue
the conventions audit normally and report that portable-template migration could not run.

The current managed portable baseline is delimited by these exact HTML comments:

```markdown
<!-- second-brain-template: portable-v5 -->
...
<!-- /second-brain-template -->
```

Content after the closing marker is repository-specific and must be preserved. The
canonical source begins at the portable marker so adopting repositories can copy it
directly.

### Migration rules

Migrate every existing root template, whether it is unversioned, carries an older marker,
or has target-owned changes inside the portable text. Do not keep prior template copies or
version-specific migration branches.

During a change-producing audit:

1. Read the target and the canonical template in full.
2. Inspect `.second_brain/` for `BACKLOG.md` and `DEFERRED.md`. When only `BACKLOG.md`
   exists, rename it to `DEFERRED.md` without losing its entries or durable content. When
   both exist, merge verified legacy entries into the established `DEFERRED.md` format
   without overwriting either file; preserve ambiguous entries for migration review, then
   remove `BACKLOG.md` only after all of its content is accounted for. Update active
   repository references from `BACKLOG.md` to `DEFERRED.md`.
3. Normalize each existing core knowledge file according to the canonical presentation
   below, then automatically migrate eligible legacy code pointers according to the
   confidence-gated rules below. Preserve target-owned durable content and project-specific
   section organization; only migrate legacy presentation and verified pointers.
4. Migrate the root `AGENTS.md` second-brain integration according to the canonical
   primary-guidance rules below. Preserve unrelated project instructions and ambiguous
   legacy wording.
5. Identify target-owned rules, context, or extensions. Preserve them verbatim when their
   ownership is clear.
6. Replace the portable policy with the current canonical baseline.
7. Put preserved target-owned content after the closing marker in the repository-specific
   extension area. Do not retain obsolete portable wording there.
8. If ownership of text is ambiguous, preserve it verbatim under a clearly labeled
   migration-review subsection in the extension area and call it out in the handoff.
9. Inspect the diff to confirm the current marker appears once, the portable baseline is
   current, all deferred-work content is preserved, and no target-owned content was
   discarded. Then run the bundled validator:

   ```bash
   <skill-dir>/scripts/validate_portable_template.sh \
     --target SECOND_BRAIN.md \
     --template <agentic-engineering-root>/SECOND_BRAIN.md
   ```

   Require `status=valid`. The validator checks the exact portable baseline, rejects a
   remaining legacy `BACKLOG.md`, and validates each existing core knowledge file's
   canonical heading and presentation; it does not modify repository files.

For an unversioned file that contains only portable guidance, replace the whole file with
the current adopted template. A portable-template migration is idempotent and does not by
itself advance `CONVENTIONS.md`'s `last_full_audit` date.

### AGENTS.md primary-guidance integration

Use the canonical `AGENTS.second-brain.snippet.md` from the Agentic Engineering source root resolved
above. Its `second-brain-guidance` markers delimit the portable integration.

During a change-producing audit:

1. Read the root `AGENTS.md` when it exists and preserve all unrelated instructions.
2. Place the canonical delimited integration immediately after any YAML front matter and
   repository title, before all other guidance.
3. When the existing file contains the canonical markers or a clearly delimited
   `## Second Brain` section, replace that section and move it to the primary position.
4. When second-brain wording is embedded or its boundaries are ambiguous, insert the
   canonical section at the primary position and preserve the ambiguous wording. Do not
   delete or rewrite text whose ownership cannot be established.
5. When `AGENTS.md` is missing, create it with the canonical section. When the file has no
   front matter or title, put the section at the beginning.
6. Inspect the diff to confirm exactly one canonical marked section appears, unrelated
   instructions remain, and a second unchanged audit produces no diff.

The integration makes second-brain policy primary for repository context and durable
maintenance only. It does not override unrelated repository rules. Current source code,
configuration, and explicit user requests disprove stale claims; correct durable knowledge
when permitted before continuing.

During a read-only audit, report the exact integration migration needed without editing
`AGENTS.md`.

### Core knowledge-file presentation

Use this canonical, minimal presentation while initializing or auditing:

| File | Exact top-level heading | Allowed front matter |
| --- | --- | --- |
| `ARCHITECTURE.md` | `# Architecture` | None |
| `CODE_POINTERS.md` | `# Code Pointers` | None |
| `CONVENTIONS.md` | `# Conventions` | Required audit metadata only, including `last_full_audit` after a complete audit |
| `DECISIONS.md` | `# Decisions` | None |
| `DEFERRED.md` | `# Deferred Work` | None |

Remove optional `summary` and `read_when` front matter from core knowledge files, remove
embedded `<!-- Format: ... -->` comments that duplicate portable presentation guidance, and
normalize the top-level heading. In `CONVENTIONS.md`, retain only audit metadata in front
matter. Before removing any other front-matter value, preserve durable repository-owned
facts in the appropriate body section or a migration-review subsection when ownership is
ambiguous. Do not rewrite target-owned sections merely for style.

For `CODE_POINTERS.md`, prefer `path/to/file.py::Symbol` for stable classes, functions,
methods, public APIs, and cross-module contracts. Keep repository-relative
`path/to/file.py:L<line>` as the fallback for configuration, prose, module-level blocks,
or locations without a stable symbol. Verify either form because symbols can be renamed and
line numbers can drift.

### Automatic code-pointer migration

During every change-producing audit, inventory and migrate eligible legacy code pointers.
The migration is deliberately conservative: convert only verified symbols and retain every
fallback that cannot safely become a symbol pointer.

During the audit:

1. Inventory each legacy code pointer in `CODE_POINTERS.md` and classify it as a confirmed
   code symbol, configuration/prose/module-level location, or ambiguous.
2. Inspect the referenced source. When a legacy path is an alias or unprefixed, normalize
   it only if exactly one repository-relative source file can be verified as its target.
   Record the resolved path in the converted pointer. Do not guess between matching files,
   infer a directory from a display label, or normalize an alias that cannot be proven.
3. Convert a pointer only when its repository-relative path exists and its class, function,
   method, public API, or cross-module contract is verified. Use
   `path/to/file.py::Symbol`; separate multiple confirmed symbols with commas.
4. Retain configuration, prose, module-level blocks, missing paths, and ambiguous references
   without changing their fallback syntax. They may use legacy `path/to/file.py:<line>` or
   canonical `path/to/file.py:L<line>` notation. Do not invent a symbol, normalize a
   fallback pointer, or convert an entry merely because its line number is near code.
5. Preserve the entry's descriptive text and all non-pointer content. Do not alter source
   code, tests, or other second-brain files solely to complete a pointer conversion.
6. Inspect the resulting diff and re-check every converted symbol against source. Run the
   relevant repository validation and repeat the audit unchanged to confirm it is
   idempotent.

Report the number of converted, retained, and unresolved pointers. For each unresolved
pointer, include the path and the reason it could not safely migrate. Do not create a
session log or issue solely for unresolved fallback pointers.

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

### Repository ownership and portability

`CONVENTIONS.md` is a committed repository artifact. Its claims and `Sources:` entries
must be repository-owned: use repository-relative files or globs, repository configuration,
or `normative repository policy`. Never use absolute filesystem paths, `~`, parent-directory
paths, tool-home paths, or global/shared/user-local instruction files as durable evidence.

An inherited `AGENTS.md` or shared standard can govern the agent working now, but it is not
repository evidence and must not be copied into `CONVENTIONS.md`. A repository-local
`AGENTS.md` may be a source only for instructions it declares itself. If a needed rule exists
only outside the repository, report that it must be committed or otherwise made
repository-owned before it can become a convention.

## Process

### 1. Determine audit state

Read `.second_brain/CONVENTIONS.md` directly. Treat it as legacy or partially migrated if:

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

When a declared source is a directory or glob, inspect its meaningful top-level structure
as well as the claims already recorded. Add missing context only when it establishes a
durable workflow or category—for example, an evaluation-test suite with a distinct way of
running or interpreting tests. Do not inventory every file or record a directory merely
because it exists.

Common evidence includes:

| Claim | Prefer |
| --- | --- |
| Runtime, dependencies, build, lint, typing | package manifests and tool configuration |
| CI, release branches, automation | repository workflows and live repository settings |
| Commands and destructive behavior | Makefiles, task runners, scripts, and safe help output |
| Package exports and module layout | source tree and package entry points |
| Fixtures and test patterns | test configuration, shared fixtures, and representative tests |
| Licensing | license configuration and CI commands |
| Agent workflow policy | Repository-local `AGENTS.md` and durable decisions |

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
  `DECISIONS.md` or `DEFERRED.md` when it belongs there.
- **Blocked** — required evidence could not be inspected or conflicts need user judgment.

Do not treat a plausible claim as verified. Run safe commands only when their output is
necessary to establish behavior; otherwise inspect the command definition.

### 4. Migrate or update

During a change-producing task:

- preserve valid content, headings, front matter, and local formatting
- add or correct one `Sources:` line per top-level section
- correct or remove stale claims in the same pass
- remove claims or sources copied from global, shared, or user-local guidance; do not
  replace them with an unverified repository rule
- before writing, scan the intended edit for absolute, home-directory, parent-directory,
  and tool-home paths; remove nonportable references and report any external-only rule
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
