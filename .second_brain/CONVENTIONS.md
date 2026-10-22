---
last_full_audit: 2026-08-22
---

# Conventions

## Repository purpose
Sources: `README.md`, `.second_brain/ARCHITECTURE.md`, `CODING_STANDARDS.md`

- Agentic Engineering is a reusable coding and agent-workflow playbook.
- It remains independently installable and documents ownership behavior for each
  installation surface, including the authoritative same-name Codex skill policy.
- Do not add a runtime dependency on another playbook repository.

## Documentation
Sources: `CODING_STANDARDS.md`, `AGENTS.md`, `AGENTS.local.md`, `CLAUDE.md`, `SECOND_BRAIN.md`, `README.md`, `docs/*.md`, normative repository policy

- `AGENTS.md` is repository-local, `AGENTS.local.md` is the portable shared-guidance
  template rendered by the installer, and `CLAUDE.md` is a compatibility shim to
  repository-local guidance.
- Files under `docs/` use `summary` and `read_when` YAML front matter.
- `CODING_STANDARDS.md` owns the plain-English, durable-prose rules for changed comments,
  documentation, and knowledge entries; preserve necessary evidence and technical detail.
- The marked `SECOND_BRAIN.md` portable baseline remains self-contained and
  repository-relative.
- Keep repository-specific durable knowledge in `.second_brain/`, not inside the marked
  portable baseline.

## Skill layout and inventory
Sources: `skills/*/SKILL.md`, `README.md`, `AGENTS.md`, `AGENTS.local.md`, `scripts/install`, normative repository policy

- Skills live in `skills/<name>/SKILL.md`; supporting files stay in the same skill folder.
- Skill front matter uses a name that matches the containing directory.
- Portable skill instructions do not rely on tool-specific argument interpolation.
- `README.md`, `AGENTS.md`, and `AGENTS.local.md` list every public skill.
- `unslop` applies to every agent-authored response and document while preserving exact
  quotations, code, commands, schemas, logs, and user-supplied copy.

## Implementation and review
Sources: `AGENTS.md`, `AGENTS.local.md`, `CODING_STANDARDS.md`, `skills/implement/SKILL.md`, `skills/agent-review/SKILL.md`, `skills/auto-review/SKILL.md`, `skills/pr-review-triage/SKILL.md`, `skills/test-audit/*.md`

- `AGENTS.local.md` owns model preferences, fallback authorization, and visible task, model,
  effort, and context disclosure. Delegation must justify its handoff costs through progress
  or context savings. `CODING_STANDARDS.md` owns context choice and tool compatibility;
  `implement` applies those rules before worker and reviewer launches.
- Delegation depends on independent progress or context savings that justify handoff costs;
  tightly coupled operational work can stay with one executor. Bounded workers do not recurse.
- `implement` applies to user-supplied or approved plans, material design decisions, coordination
  across behavior boundaries, identified risks needing staging, or explicit requests. Routine
  direct work follows the same scope and verification rules.
- `CODING_STANDARDS.md` defines independent-review triggers by changes to authorization, credentials,
  trust boundaries, stored-data formats, destructive writes, shared-interface behavior for
  identified callers, and the safeguard rules. Ordinary work permits self-review or focused
  validation as specified there. Reuse an existing non-author when independence is required;
  do not require both kinds of review. Preparation and reviewer requests do not expand scope.
- Scope limits apply regardless of review requirements. Consider deletion and suitable existing
  functionality before adding code; routine reasoning does not require a narrated artifact.
  Coding standards preserve precise types and existing model conventions without authorizing
  duplicate representations or unrelated design changes.
- `auto-review` is self-contained for orchestrators; `agent-review` serves human PR and branch
  reviews. Implementation review checks the smallest sufficient implementation, established
  contracts, correctness, and verification. Demonstrated scope excess blocks acceptance;
  hypothetical reuse and existing behavior alone do not justify abstractions or compatibility code.
- Implementation reviewers return concise evidence and gaps without a full PR ledger or raw logs. A missing
  required independent review remains pending; self-review cannot satisfy it.
- Existing authorization carries forward and still-valid verification can be reused under
  `CODING_STANDARDS.md`. Handoffs scale to the task.
- PR triage uses the specified checklist directory or repository-local `tmp/`, retains progress
  and valid response drafts, and permits already-authorized follow-up after its triage phase.
- `CODING_STANDARDS.md` owns Test quality rules. `implement` uses `test-audit` authoring
  mode when adding or changing tests, reusing its existing context and verification.
- `test-audit` resolves missing shared rules through its mirror source marker or source skill
  path. An unavailable standards file or Test quality section leaves the assessment incomplete;
  the skill does not carry a duplicate checklist.
- The authoring gate rejects low-value patterns without a named independent contract.
  Regression verification requires the intended failure before a fix and success afterward;
  blocked proof remains incomplete.
- Both review skills use bounded, read-only `test-audit` audit mode and incorporate evidence
  into their existing findings. Remediation returns to the caller's verification without
  recursively invoking a review. Removal recommendations require evidence of remaining
  protection or why none is needed; distinct contracts stay covered.
- Audit candidates require complete evidence, including relevant history, non-test callers,
  and dependency source or types for dependency-backed claims. Remediation requires executable
  proof for removed source assertions, `auto-review`, and separate production/tooling and
  test/support LOC reporting. Existing implementation review satisfies the review requirement.
- `test-audit` campaign mode requires explicit subsystem scope and tracks coverage in a
  temporary working record. Baseline results, per-test dispositions, and a plan identifying
  retained coverage precede edits. Remediation requires independent preservation review,
  mutation proof for contracts restored after review, and final subsystem verification.
  Campaigns have no deletion targets or campaign state in the second brain.
- `test-audit` remediation batches follow one production owner or contract, remove obsolete
  test support, and prefer net-negative production LOC without sacrificing distinct coverage.
- Reviewer-response commit attributions require actual diff evidence for each claimed change.
  Checklist drafts are verified before use; consistency audits check commit/file references
  and distinguish initial review findings from unresolved findings.

## Workstation synchronization
Sources: `scripts/install`, `scripts/uninstall`, `docs/workstation-setup.md`, `tests/install.bash`, `tests/uninstall.bash`, `tests/skills.bash`

- Cursor and Claude Code use symlinks into this repository's `skills/` directory.
- Codex uses real directory mirrors marked with `.agentic-engineering-skill-source`.
- `scripts/install` and `scripts/uninstall` are the only public workstation scripts.
- Cursor and Claude Code synchronization rehomes links owned by an older
  `agentic_engineering` checkout and preserves unrelated destinations.
- Codex synchronization treats same-name skill directories as replaceable, including
  unmarked directories. Codex uninstall and stale cleanup remove only mirrors marked as
  Agentic-managed.
- Every sync surface no-ops when its agent home directory is absent.
- The installer renders `AGENTS.local.md` with its resolved checkout root into managed
  guidance files for Cursor, Codex, and Claude Code; root `AGENTS.md` remains
  repository-local.
- Shared guidance requires one explicit `scripts/install --with-agents` enrollment. The
  clone records that choice in local Git configuration, and later plain installs honor it.
- Guidance destinations are Cursor's development-folder `AGENTS.md`, `~/.codex/AGENTS.md`,
  and `~/.claude/CLAUDE.md`. Claude Code reads user-level `CLAUDE.md`, not `AGENTS.md`.
- The development folder is derived from the clone's parent directory, never a hardcoded
  path, and is skipped when it is the account home.
- Guidance sync migrates legacy links this repository owns, claims empty placeholder files,
  and transfers files with an Agentic Engineering ownership marker from an older checkout.
  It preserves user-owned regular files and foreign links.
- Managed guidance files are regenerated in full on every install, so edits made at a
  destination are lost. Overwriting a destination with content that omits the ownership
  marker returns it to the user and leaves other surfaces managed.
- Guidance enrollment is recorded per clone, so a new clone repeats the opt-in.
- Managed repository Git hooks rerun `scripts/install` after checkout, merge, and commit.
- Do not document concurrent installation with another distribution that manages the same
  destination names.

## Shell and tests
Sources: `CODING_STANDARDS.md`, `scripts/*`, `tests/run`, `tests/*.bash`, `tests/helpers/*.sh`

- Shell entry points use `set -euo pipefail`.
- Tests use the zero-dependency runner in `tests/run` and isolated temporary directories.
- Update regression tests whenever synchronization, uninstall, template migration, or
  validation behavior changes.
- Run shell syntax checks and the full test runner before handoff.

## Continuous integration
Sources: `.github/workflows/ci.yml`

- CI runs for pushes and pull requests targeting `main` or `dev`, and supports manual
  dispatch.
- Checkout actions use an immutable reviewed commit and do not persist credentials.
- CI runs shell tests, Markdown lint, link checking, and duplicate detection.

## Second-brain maintenance
Sources: `AGENTS.md`, `CODING_STANDARDS.md`, `SECOND_BRAIN.md`, `docs/second-brain-hooks.md`, `skills/audit-second-brain/SKILL.md`, `skills/init-second-brain/SKILL.md`, `skills/load-second-brain/SKILL.md`, `skills/update-second-brain/SKILL.md`, normative repository policy

- Second-brain maintenance is agent-owned during change-producing work.
- Load only missing relevant context and reuse context that remains current in the task.
- Every top-level convention section declares repository-owned sources.
- Full audits use `last_full_audit` as a 90-day recovery backstop; partial audits do not
  advance it.
- Prefer `path::symbol` for stable code entry points and use line-based fallbacks only when
  no stable symbol exists.
- Change-producing audits migrate verified legacy pointers, core-file presentation, root
  portable guidance, and legacy `BACKLOG.md` content without discarding repository-owned
  knowledge.
- Read-only work reports audit debt without modifying repository files.
- Scoped maintenance uses known task-owned changes and verifies current-state claims in deferred
  work. Source-verified factual corrections take priority while valid decision rationale remains.

## Excluded content
Sources: `README.md`, `AGENTS.md`, `skills/*/SKILL.md`, normative repository policy

- Do not add organization-specific systems, credentials, external work-tracking workflows,
  or private workstation assumptions to this repository.
- Do not persist inherited, global, shared, or user-local guidance as repository knowledge.
