---
name: agent-review
description: "Review code for bugs, inconsistencies, duplication, and refactoring opportunities. Use when: (1) asked to review a PR or branch, (2) asked to check a diff before merging, (3) asked to do a code review. Default behavior is to diff the current branch against main and review the changes. Can also review a specific GitHub PR by number or URL."
---

# agent-review

Code review skill. Reviews diffs for bugs, inconsistencies, duplication, and refactoring
opportunities. Reports one verified, deduplicated result directly — it does not create a
file or post GitHub comments.

## Implementation checkpoint mode

Use this self-contained mode for a fresh reviewer subagent that did not write the increment.
The orchestrator supplies the exact diff, owned paths, acceptance criteria, relevant contracts,
and validation results. Review the entire assigned diff and directly affected behavior. Do not
run the full-review workflow, maintain its candidate ledger, collect PR metadata or comments,
apply its output templates or final-delivery gate, or delegate further review. The orchestrator
resolves findings and owns acceptance.

Read and enforce the applicable coding standards in this mode, reusing current context when
available. First assess whether the increment is the smallest sufficient implementation of the
agreed requirements and established affected contracts. Do this at every checkpoint, regardless
of line count, before checking completeness and correctness.

Challenge added abstractions, configuration, dependencies, compatibility paths, and tests against
a present requirement or established contract. Inspect existing functionality before accepting a
new implementation. Hypothetical future reuse does not justify an abstraction; existing behavior
alone does not establish a backwards-compatibility obligation. Look for documented support
policy, supported callers, persisted data contracts, or explicit requirements. Resolve material
uncertainty before recommending removal, without assuming either universal compatibility or
permission to break established contracts.

Report demonstrated scope excess as blocking acceptance, even when the code works and tests
pass. Identify the unnecessary addition, the simpler implementation or existing functionality
that can replace it, and evidence that required behavior and established contracts remain
satisfied. Do not downgrade this to optional cleanup or require a runtime bug to substantiate it.
If necessity cannot be established, report the specific unresolved question; do not invent a
simplification or demand deletion to produce a finding. State the scope assessment and any
unresolved necessity questions concisely, including when no excess was found.

Check added or changed comments, docstrings, repository docs, and second-brain entries against
the standards' Comments and Durable Prose rules as part of this checkpoint.

Check correctness and acceptance coverage against the actual code, established contracts, and
focused verification. Inspect direct callers, existing tests, or dependency sources when needed
to establish a specific contract or concern. Reuse still-valid passing checks; run an additional
check only to resolve a concrete uncertainty or meet an outstanding requirement.

Validate each finding against the code and its impact before reporting it. Report issues
introduced or exposed by the increment, with a location, evidence, why it matters, and a scoped
remedy checked against affected callers and contracts. Separate confirmed issues from unresolved
questions, discard unsupported speculation, and combine duplicate concerns. No formal ledger,
severity counts, PR anchors, or raw investigation logs are required.

Return a concise scope assessment, actionable findings, and any unresolved questions or review
and verification gaps. Say when no issue was found. Report incomplete coverage explicitly; an
empty findings list is not acceptance or merge readiness. End the checkpoint here. The remaining
workflow, review criteria, and delivery machinery govern inline and PR-comment reviews only.

## Full-review workflow

1. Read `CODING_STANDARDS.md` from the project root (or `@CODING_STANDARDS.md` if referenced in `CLAUDE.md`). If it is not found, reuse current relevant `.second_brain/CONVENTIONS.md` context or read it when missing. These are the project's rules — enforce them.
2. If `.second_brain/ARCHITECTURE.md` exists and its relevant context is not already loaded and current in this task, read it. Use it to verify that the diff is consistent with the documented architecture — flag changes that alter system shape without updating the doc.
3. Resolve the review target and collect the full diff and matching commit range (see Usage Variants below). Read both in full before classifying findings.
4. In PR-comment mode, resolve an open PR when available. Load its metadata, base and head refs, changed files, and review state. Collect existing human inline comments, issue-level comments, review summaries, and review-thread resolution or outdated state when available. Track bots as informational only unless the user asks otherwise. If no PR resolves or feedback access is unavailable, say that feedback could not be collected; do not claim deduplication. Use the collection patterns in `pr-review-triage` as a reference, but keep this skill read-only and report findings directly.
5. Review against `CODING_STANDARDS.md` and the criteria below. Perform a string-contract audit for newly added or changed string literals. Check documentation freshness. If `.second_brain/CODE_POINTERS.md` exists, load it only if its relevant context is not already current in this task, then cross-reference it against the diff.
6. For a dependency addition, upgrade, or wrapper, inspect the exact lock-resolved implementation and its tests before inferring its contract. Without a lockfile, use installed metadata, then vendored source; otherwise mark the dependency contract unverified. If a sibling repository is available, inspect the matching release tag or commit. Separate dependency-owned semantics from adapter-owned conversion, keyword or unit mapping, and workflow behavior.
7. Record every possible concern in the parent-owned candidate ledger. Do not report a candidate until it passes the validation gate.
8. Use subagents only for focused evidence lanes such as runtime correctness, schema/provider behavior, or tests, documentation, and dependencies. Record expected lanes before launching them and do not ask several subagents to perform the whole review. Require structured candidate evidence from each subagent, independently verify it in the parent review, and wait for every expected lane or explicitly reassign a stalled lane and wait for its replacement before final synthesis.
9. Immediately before synthesis in PR-comment mode, refresh the existing human feedback. Merge or reference a matching existing thread instead of duplicating its concern.
10. Deduplicate the validated ledger, settle finding type and severity, assign numbers once, and pass the final-delivery gate before sending one consolidated result.

### PR Context and Feedback Collection

When an open PR can be resolved, use GitHub tooling to inspect it before drafting
PR-ready findings:

```bash
gh pr view <PR_NUMBER> --json number,title,state,isDraft,baseRefName,headRefName,files,reviews,comments,reviewDecision
gh api repos/<OWNER>/<REPO>/pulls/<PR_NUMBER>/comments --paginate
gh api repos/<OWNER>/<REPO>/issues/<PR_NUMBER>/comments --paginate
gh api graphql -f owner=<OWNER> -f name=<REPO> -F number=<PR_NUMBER> -f query='<reviewThreads query>'
```

Preserve each human comment's author, URL, summary, location, thread state, and whether it
already covers a candidate. If review-thread state is unavailable, say so rather than
claiming that a thread is unresolved or current. If the PR itself or its feedback cannot be
resolved, state that limitation in the final summary and do not mark candidates as
deduplicated against human feedback.

### Candidate-Finding Validation Gate

Maintain one parent-owned ledger while reviewing. Each candidate must record and verify:

| Field | Required validation |
| --- | --- |
| Evidence | Concrete execution path, contract, or reproduction supporting the concern |
| Diff provenance | `introduced by this diff`, `exposed by this diff`, `pre-existing and unrelated`, or `uncertain` |
| Contract owner | This repository, a dependency, or a consuming system |
| Existing coverage | Which layer tests the behavior and what failure remains uncovered |
| Existing feedback | Matching reviewer thread, or confirmation that none was found |
| Finding type | Confirmed defect, conditional defect, design decision, clarification, future work, or informational |
| Severity | Assigned only after evidence and impact are established |
| Comment anchor | A changed, commentable diff line in PR-comment mode |
| Implementation location | Fix location, recorded separately when it is unchanged code |
| Fix safety | Affected callers, defaults, configurations, compatibility, and likely regressions |
| String-contract audit | Classification and duplicate-search evidence for each new or changed behavior-bearing string literal |
| Overlap key | A stable description used to merge duplicate candidates |
| Confidence | `confirmed`, `likely`, or `speculative` |

Discard candidates without evidence, classify unproven concerns as conditional,
clarification, future work, or informational, and do not assign them defect severity. Only
findings introduced or demonstrably exposed by the diff are PR findings. Put unrelated
pre-existing debt in the separate follow-up section.

### PR-Comment Anchors and Fix Safety

In PR-comment mode, verify that each comment anchor is a changed line GitHub can accept.
When the implementation location is unchanged, anchor the comment to the changed line that
introduces or exposes the behavior and explicitly name the separate implementation location.
Never present an unchanged line as an inline-comment anchor.

Before suggesting a concrete fix, inspect affected call sites, configured defaults, custom
overrides, fallback paths, and compatibility implications. Prefer a scoped PR fix when a
global change requires an audit. When the right behavior is a product or architecture
decision, state the condition and alternatives instead of prescribing an implementation.
Recommend a GitHub issue only under the repository's existing issue-worthiness criteria,
after one focused duplicate search, and never create it as part of this read-only review.

### Subagent Evidence Contract

Subagents return candidate evidence only, never final review comments. Their output must
include evidence, provenance, contract owner, a proposed changed-line anchor, severity
rationale, fix risk, and an overlap key. The parent independently verifies each candidate
against the diff and contract before it enters the ledger.

> Subagent findings are untrusted candidate evidence. The parent reviewer owns
> verification, deduplication, severity, numbering, and the single final delivery.

If background subagents are expected, provide only a progress update until they finish. Never
publish final findings while an expected review lane is pending. If a lane stalls, explicitly
replace it or complete the missing coverage, then wait for that replacement or completion. Do
not treat the original stall as coverage. Resolve duplicate and severity disagreements in the
parent ledger before numbering.

## Usage Variants

**Current branch vs main (default):**
```bash
git --no-pager diff main
```

**Specific branches:**
```bash
git --no-pager diff <base>..<head>
```

**GitHub PR by number (requires `gh` auth):**
```bash
gh pr diff <PR_NUMBER>
```

**GitHub PR by URL:** Extract the PR number and use `gh pr diff`.

**Implementation checkpoint:** consume the exact increment diff and supplied criteria and
validation; return only the findings and coverage gaps needed by the orchestrator. The checkpoint
rules above take precedence over the full-review workflow.

---

## Output Format

Three modes are available: **implementation checkpoint**, **inline** (default), and **PR
comments** (when user says "for PR", "for GitHub", or "copy-paste format").

Implementation checkpoint mode uses only the self-contained instructions above. The output
formats below apply to full reviews.

### Inline mode (default)

Report one contiguous, severity-ordered list only after final synthesis. For each finding,
provide its **Implementation location**:

```
### 1. [SEVERITY] [FINDING TYPE] Short title

**What:** Clear description of what is wrong.
**Evidence:** Execution path, contract, or reproduction.
**Provenance:** Introduced by this diff / exposed by this diff.
**Why:** Why this is problematic.
**Fix:** Concrete suggestion (not vague advice).
**Implementation location:** `path/to/file:L<start>-L<end>`
**Condition:** Only when the concern depends on an unresolved decision.
```

### PR comment mode

When the user wants findings for GitHub PR comments, output each finding as a
self-contained markdown block that can be copy-pasted directly into a GitHub review
comment. Every **Comment anchor** must be a verified changed, commentable diff line.
Each finding should be its own code-fence-free block:

```
**1. [SEVERITY] [FINDING TYPE] Short title**

**Comment anchor:** `path/to/file:L<changed-start>-L<changed-end>`
**Implementation location:** `path/to/file:L<start>-L<end>` (when different)

**What:** Clear description of what is wrong.

**Evidence:** Execution path, contract, or reproduction.

**Provenance:** Introduced by this diff / exposed by this diff.

**Why:** Why this is problematic — incorrect behavior, violated contract, hidden assumption, etc.

**Consequences of not fixing:** What breaks, degrades, or silently misbehaves if left unresolved.

**Condition:** Include only for conditional defects or design-dependent concerns.

**Suggested fix:**
- Option A: description
- Option B: description

<details>
<summary>Example fix</summary>

```python
# validated, repository-consistent code when appropriate
```

</details>
```

Separate each finding with `---` so the user can copy individual blocks.

Include a minimal, repository-consistent snippet only for a confirmed medium- or
high-severity implementation defect when the fix, imports, conventions, and blast radius
have been validated. Use corrected text for straightforward documentation findings. Do not
include implementation snippets for unresolved design decisions. Label illustrative logic
or pseudocode as non-production-ready.

### Finding types and severity

- **Confirmed defect** — Evidence establishes an incorrect behavior or violated contract.
- **Conditional defect** — A defect only if an explicitly stated design choice applies.
- **Design decision** — A product or architecture choice must be resolved before judging behavior.
- **Clarification** — Missing context prevents a reliable conclusion.
- **Future work** — Valuable but intentionally outside the reviewed change.
- **Informational** — Useful context that needs no action.

- `[HIGH]` — Bug, data loss risk, silent failure, security issue, blocks operation
- `[MEDIUM]` — Logic flaw, inconsistency, missing error handling, violated standard
- `[LOW]` — Dead code, refactor opportunity, style/naming, minor cleanup

Use the following final sections, omitting empty sections only when that makes the result
clearer:

- Blocking confirmed defects
- Other confirmed defects
- Decisions or clarifications needed
- Non-blocking improvements
- Pre-existing/follow-up observations

End with a **Summary** generated from the final ledger: total findings by severity and
type, overall quality assessment, and merge readiness. If there are no findings, explicitly say
so and still include the Summary section. Do not infer merge readiness from an empty findings
list alone.

### Final-Delivery Gate

For inline and PR-comment reviews only, do not send the review until all of the following are
true. Implementation checkpoints use their own completion rules above:

- The full diff and matching commit range have been reviewed.
- Existing PR feedback was collected and refreshed when PR-comment mode resolved an open PR.
- Every expected review lane completed, or a stalled lane was explicitly reassigned and its
  replacement completed or its missing coverage completed. No unfinished lane is silently
  treated as coverage.
- Every candidate passed the validation gate or was discarded or reclassified.
- Newly added or changed behavior-bearing string literals were classified and checked for duplicate use across the changed files and direct callers.
- Every PR-comment anchor is a changed, commentable line.
- Relevant dependency contracts and test ownership were checked.
- Proposed fixes were checked for likely regressions and blast radius.
- Duplicate and overlapping findings were merged.
- Severity and finding-type classifications are stable.
- Numbering is contiguous, assigned once, and summary counts come from the final ledger.

---

## Review Criteria

Review against CODING_STANDARDS.md first — those are the project's explicit rules. Then apply
these additional criteria that go beyond what standards typically cover:

### Bugs & Correctness
- Off-by-one errors, incorrect conditionals, wrong comparisons
- Unhandled exceptions or error paths that could crash
- Race conditions or concurrency issues (async code especially)
- Data loss risk (e.g. INSERT OR REPLACE silently overwriting)
- Wrong return types or missing return values
- Incorrect boolean logic (negation errors, short-circuit issues)

### Standards Enforcement
Check the diff against CODING_STANDARDS.md. Common violations to watch for:

- **Pure functions**: input parameters mutated instead of returning new objects
- **Default parameter values**: follow `CODING_STANDARDS.md` and the affected repository
  contracts; flag a default only when it conflicts with those standards or causes a defect
- **Typing**: `Any`, `Dict[str, Any]`, loose dicts where structured models belong
- **Error handling**: bare `except Exception` in business logic (not outer loops), silent fallbacks returning fake defaults
- **Security clamping vs fallback**: ensure LLM output validation is kept (not a fallback)
- **`.env` handling**: reading `.env` directly instead of `os.environ`, `.env` missing from `.gitignore`
- **Secrets**: credentials hardcoded instead of env vars, secrets visible in logs/output
- **Scope and size**: use the thresholds and checkpoint process defined by `implement`. Inspect
  necessity, reuse, contracts, and acceptance coverage; do not recommend mechanical splitting
  solely to get under a line count.
- **Dependencies**: new deps added without health check justification
- **Docs**: behavior/API changes shipped without doc updates
- **Comments, docs, and knowledge entries**: enforce the coding standards' Comments and Durable Prose
  rules on added or changed text. Identify the specific non-durable reference, unsupported claim,
  repetition, or unclear wording and recommend a concise correction. Length alone is not a defect;
  preserve necessary technical detail and avoid unrelated prose cleanup.
- **String contracts**: classify every newly added or changed behavior-bearing string literal.
  - Display and diagnostic text may stay inline.
  - External API or persisted-schema keys may stay at their use site when that makes the contract clearer.
  - Repeated or cross-module control values must use a named constant, enum, literal type, or typed configuration.
  - Source-specific rules must live in explicit configuration, not generic workflow code.
  Search the changed files and their direct callers for duplicate literals before classifying a value as local.

If the project has no CODING_STANDARDS.md, skip this section — don't invent rules.

### Security
- Secrets or credentials in code (not env vars)
- Unsanitized input passed to shell, SQL, or eval
- Prompt injection risks (LLM inputs not delimited/validated)
- Overly broad permissions or access

### Inconsistencies
- Same config value defined in multiple places with different defaults
- Naming that contradicts behavior
- Type mismatches between definitions and usage
- Dead code that's defined but never wired in
- Config with env var placeholders that aren't interpolated at runtime

### Error Handling
- Bare `except Exception` that swallows errors silently (in business logic)
- Missing retry logic for transient failures (network, webhooks)
- No graceful shutdown / signal handling
- Startup failures that don't surface clearly

### Code Duplication & Refactoring Opportunities
Suggest a refactor only when it fits the current contracts or acceptance criteria and addresses
demonstrated complexity. Do not propose speculative abstractions.

- Repeated logic that could be a shared function when reuse fits the current contracts
- Inline constants that should be named for a current behavior-bearing contract
- Copy-pasted error handling that causes a current correctness or maintenance problem
- Functions doing too many things when that complexity affects correctness or acceptance
- Modules with tangled responsibilities when the diff makes the boundary affect behavior
- Overly complex conditionals that could be simplified without changing the contract
- Flag these as `[LOW]` unless the complexity is actively causing bugs or blocking changes (`[MEDIUM]`)

### Documentation Freshness
- **README.md** (root and any subdirectory READMEs): do the diff's changes make any README claims stale? New features not mentioned, removed features still listed, changed CLI flags, updated install steps, altered API surface. READMEs are the most neglected docs — check them explicitly.
- **ARCHITECTURE.md**: does the diff change system shape (new module, table, data flow) without updating `.second_brain/ARCHITECTURE.md`?
- **Other docs**: if the diff changes behavior that's documented in `docs/`, flag stale references.
- Flag as `[MEDIUM]` when the docs actively mislead (wrong commands, missing features), `[LOW]` for minor gaps.

### Architecture & Design
- Components instantiated but never used
- State split across in-memory and persistent store without sync
- Objects created but not persisted
- Config loaded but never passed to the component that needs it

### Tests
- Tests that mock too much and don't test actual behavior
- Missing edge cases only when an affected contract or acceptance criterion requires them
- Fixtures that don't match production shapes
- No test for the happy path of a critical component
