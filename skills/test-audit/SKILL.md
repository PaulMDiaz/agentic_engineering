---
name: test-audit
description: Apply test-quality rules while authoring tests, audit affected tests during implementation or PR review, or remediate an existing suite. Use campaign mode for an explicitly requested subsystem-wide audit across bounded batches.
---

# Test audit

Use the applicable `CODING_STANDARDS.md` Test quality section as the quality bar. Resolve it
through the project's instructions and reuse it when already loaded. If those instructions
do not locate the section, resolve the Agentic Engineering source that supplied this skill:

- For a mirrored skill, read the adjacent `.agentic-engineering-skill-source` marker as the source-root path.
- For a symlinked skill, resolve the symlink to its source folder. For that folder or a skill
  read directly from a checkout, locate the root above `skills/test-audit/`.
- Read that root's `CODING_STANDARDS.md` Test quality section. Verify the file and section exist;
  do not assume the target project's working directory is the Agentic Engineering root.

The checklist stays in the standards rather than a second copy bundled with this skill.
If neither route supplies it, report the quality assessment as incomplete and identify the
missing source. Continue independent inspection under project conventions, but do not claim
the authoring gate passed or remove tests under this skill without the shared rules.
Explicit user and project instructions still govern the task. Read scoped instructions before
inspecting or editing their files.

## Choose the mode and scope

| Context | Mode | Boundary |
| --- | --- | --- |
| Writing or changing tests | Authoring | Tests needed for the current implementation |
| Reviewing a diff | Audit | Changed tests and coverage affected by production changes |
| Assessing or cleaning up named tests or a module | Audit | The requested paths and relevant owners |
| Explicitly requested whole-subsystem assessment or cleanup | Campaign | A named subsystem, covered through bounded audit batches |

An assessment or review is read-only. A request to fix or remediate authorizes scoped edits;
carry that authorization forward without asking again for each candidate. Mode selection
does not expand permission to edit, delete files, change branches, commit, or publish.
Follow applicable repository safeguards. If scope is ambiguous, inspect the named area and
resolve the boundary before expanding. Do not start a campaign during ordinary implementation
or review. Read [CAMPAIGN.md](CAMPAIGN.md) only for campaign mode.

## Authoring

Before keeping a new or changed test:

1. Establish the acceptance criterion or contract, the defect that should make the test fail,
   the gap in existing coverage, and whether the test demands production access added only
   for tests. Missing answers block acceptance. Move tests needing such access to the real
   boundary; extend a suitable existing case when sufficient.
2. Trace the operation and assertions against every shared low-value pattern. A match blocks
   acceptance unless a named independent contract satisfies the retention rules. Rewrite or
   omit unjustified tests. Check fixtures reach the claimed behavior and expected results do
   not come from the implementation being tested.
3. Run focused verification. Regression tests must fail for the intended reason against the
   pre-fix behavior and pass with the fix. Record both results; blocked proof remains incomplete.

Keep this reasoning proportional. Routine authoring needs neither a separate report nor a
campaign record. Existing implementation context and current validation results are reusable.

## Audit

Start with the requested diff or paths. Read complete candidate tests, production owners,
entry points, callers, callees, sibling implementations, overlapping tests, and relevant
history. Check test discovery and CI selection before claiming that remaining coverage protects
the same configuration or platform. For dependency-backed claims, inspect the resolved dependency's
source or types; mark unavailable evidence as unverified. Search results identify candidates;
they do not prove a test is useless.

Record all of the following for each actionable candidate before editing. Missing evidence
blocks deletion, including when evidence cannot be retrieved:

- Exact test name and location, with diff provenance when reviewing a change.
- The failure its assertions actually detect and the specific quality concern.
- The distinct contract to preserve, or the remaining test and configuration covering the same
  failure. Explain when no protection is needed.
- A recommendation to remove, consolidate, or rewrite, with the expected effect on coverage.
- Non-test callers of the covered production path and support code, including a verified absence.
- Relevant history explaining why the test or support exists; distinguish unavailable history
  from a verified absence of rationale.
- Production or support code made removable by the change, or an explicit statement that none is.
- Removal risk, unresolved uncertainty, and the exact focused validation command.

Keep tests whose independent value is established. Retain uncertain candidates and name the
missing evidence. A failing baseline test may expose a product defect; do not remove it to
obtain a passing run. Report an out-of-scope product defect instead of expanding the cleanup.

In a review, return this evidence through the caller's existing findings format. The caller
owns severity, deduplication, and acceptance. Do not create a second ledger, launch another
review, or remediate from inside the review. With no actionable candidates, state the inspected
scope and material gaps rather than manufacturing cleanup suggestions.

## Remediation and verification

### Edit shape

When edits are authorized, establish candidate evidence and keep each batch focused on one
production owner or contract.

- Remove obsolete exports, globals, wrappers, and unreachable production paths that only
  supported the removed tests, after checking callers and compatibility requirements.
  Do not leave aliases that preserve support no remaining contract needs.
- Move retained regression coverage to the boundary that owns the behavior. Preserve any
  distinct integration, platform, or lifecycle protection at other layers.
- Consolidate repeated package or dependency assertions where one shared contract test can
  cover them. Keep adapter-specific behavior covered; avoid a new test framework for consolidation.
- Prefer net-negative production LOC by removing unnecessary test support. This is a
  preference, not a quota or acceptance requirement. Do not offset necessary additions with
  unrelated deletions or sacrifice required behavior and distinct coverage.
- Apply authoring mode to replacements so they do not repeat the same implementation-coupled
  assertions. Leave uncertain candidates intact and record what evidence is missing.

### Verification

Do not edit source or tests while a validation run using that checkout is active.
Run the owning and affected sibling tests, targeted formatting checks, `git diff --check`,
and the repository's required changed-file or full checks. When removing source-text or
plan assertions, execute the script or supported dry-run that owns the protected behavior.
If that proof cannot run, report it as incomplete rather than substituting passing unrelated tests.
Reuse unchanged validation evidence; rerun checks affected by edits. Passing tests alone do
not prove a deletion preserved coverage. Review the final diff against the evidence and
retained contracts, including each retention exception for a matching junk pattern.

After remediation edits, run `auto-review` with the evidence and retained contracts, following
the repository's reviewer eligibility requirements. When this skill is used inside `implement`,
its existing `auto-review` step satisfies this requirement; do not run it twice. When called
from a review skill, return findings directly and never invoke the caller recursively.
Campaign remediation also requires the independent preservation review and completion gates
in [CAMPAIGN.md](CAMPAIGN.md). An eligible existing review can satisfy both requirements
when it checks the required preservation evidence; self-review cannot satisfy that gate.

Report the changes or recommendations, retained contracts, validation actually run, and any
remaining uncertainty. After remediation, inspect the complete change, including new files,
and report added and removed LOC separately for production/tooling and tests/test support.
Use `git diff --numstat` for tracked changes and account for untracked additions. Keep unrelated
cleanup separate. Perform normal durable-knowledge maintenance after edits; temporary audit
notes do not belong in the second brain.

## Inspiration

The three-mode organization and remediation edit shape are inspired by
[OpenClaw's test-audit skill](https://github.com/openclaw/openclaw/blob/main/.agents/skills/test-audit/SKILL.md).
Agentic Engineering's coding standards define the quality rules; its implementation and review workflows
own execution and acceptance.
