---
name: implement
description: Methodical task implementation — understand, plan, implement, verify. Use when given a non-trivial coding task so the work is scoped clearly, implemented deliberately, and verified before handoff.
---

# Implement Skill

Approach non-trivial coding tasks methodically. Think before coding, keep scope tight, and verify before handoff.

## When to Use

Use this skill when the user asks for:
- a non-trivial coding change
- a multi-file implementation
- a task that needs planning before edits
- a change that should be verified before handoff

Do not use this skill for:
- tiny one-line fixes
- pure documentation edits
- simple code reading / inspection tasks

## Process

When this skill is assigned to a bounded worker, plan within the supplied assignment as needed
and follow its paths, criteria, constraints, and validation. Do not expand the scope or delegate
further work. Return the assigned result without arranging another review or obtaining final
acceptance. The orchestrator retains resolution and acceptance.

### 1. Load relevant repo context
- Read `CODING_STANDARDS.md`
- If the repo has a `.second_brain/` directory and the relevant context is not already loaded
  and current in this task, check only the most relevant files before changing code:
  - `DECISIONS.md` for prior trade-offs
  - `CONVENTIONS.md` for repo-specific rules
  - `CODE_POINTERS.md` when it helps locate files quickly
- If the task is non-trivial and the repo uses a second brain, run or follow
  `load-second-brain` only to load missing relevant context.

### 2. Define the task precisely
Before editing, make the task concrete:
- what is changing
- what is not changing
- constraints
- acceptance criteria
- assumptions or unknowns that could affect implementation

Treat acceptance criteria as exhaustive for the requested behavior while preserving established
affected contracts unless the task explicitly changes them. Establish compatibility obligations
from support policy, supported callers, persisted data contracts, or explicit requirements.
Existing behavior alone does not justify legacy adapters, dual implementations, migration layers,
or fallback paths. Resolve material uncertainty before breaking an established contract. Ask the
user about scope, material unknowns, or required model choices when those block progress, and
preserve separate permission or approval requirements.

### 3. Plan proportionally
Use the smallest planning process that is honest for the task size.

For small-to-medium tasks:
- make a short inline plan with the intended files/steps

Prefer the smallest correct plan. Do not create ceremony for trivial work.

The orchestrator owns the plan, acceptance criteria, resolution of findings, and final
acceptance. Before assigning work, check for existing reusable functionality and identify the
contract owner for each affected behavior.

For substantive implementation, delegate one bounded, coherent increment at a time. Give each
worker owned paths, relevant criteria, constraints, and validation steps. Delegate sequential
increments by default; run work in parallel only when the increments are independent. A worker
assigned bounded implementation or review does not recursively orchestrate more work.

When the user corrects or changes requirements during work, update the affected worker and
reviewer assignments and stop or redirect conflicting work. Preserve completed work and
verification that remain valid under the revised requirements. Answer status and side questions
without abandoning the objective unless the user cancels or replaces it.

If the harness cannot run subagents, implement and validate directly. This defers independent
review; it does not waive it. Return a handoff with the exact diff, acceptance criteria,
validation results, and outstanding review for a separate agent-capable session. Label the work
as awaiting independent review, not accepted or complete. Self-review does not satisfy that gate.

Delegate bounded, noisy investigation when its result can be verified without importing the
exploration. Keep small lookups local. Ask workers for concise conclusions, evidence pointers,
uncertainties, and validation results rather than raw logs.

### 4. Implement incrementally
- Follow existing repo patterns before introducing new ones
- Prefer the smallest correct change that solves the task
- Avoid speculative refactors or “while I’m here” cleanup
- If you notice refactoring opportunities, flag them instead of silently expanding scope
- Write tests in the same work context when the task warrants them
- Handle only edge cases and error paths required by an acceptance criterion or affected contract

Stop and re-plan smaller if you catch yourself:
- adding an abstraction, config layer, or framework the task did not ask for
- designing for a use case that does not exist yet
- writing a second implementation to keep the old logic alive
- editing files unrelated to the task
- using "add tests" as the reason to keep building

Before adding a test, identify the acceptance criterion or affected contract it verifies and
what existing tests would miss. Test size is a prompt to inspect scope and setup, not evidence
that the implementation is overbuilt.

When a changed file crosses about 500 lines, or an increment reaches about 1,000 added lines
across files, pause for a scope checkpoint. Report production and test additions separately and
inspect necessity, reuse, contracts, and acceptance coverage. These thresholds are scope alarms,
not automatic rejection or splitting requirements. Do not game them with file splits or
deletions.

### 5. Verify
- Run the repo-defined checks that match the change, following the verification reuse rule in
  `CODING_STANDARDS.md`
- Prefer exact workflow-derived verification when the repo defines it clearly
- If full verification is not practical, run the closest honest subset and say what was and was not verified
- Confirm the implementation matches the stated acceptance criteria

Every substantive increment needs review by a fresh reviewer agent that did not write the change.
Review the first coherent slice early, then invoke `agent-review`'s implementation checkpoint
mode with the exact increment diff, owned paths, criteria, relevant contracts, and validation
results. Where supported, start the reviewer with this bounded handoff and required repository
instructions instead of inheriting the full conversation. Keep investigation in the reviewer
context and request only the checkpoint's concise assessment, findings, and gaps. The
orchestrator checks evidence needed to resolve findings and accepts or rejects the increment;
it does not import raw logs or repeat the whole review. Select a suitable reviewer independently
of the implementation-model preference, respecting session model choices.

Have the reviewer first assess the smallest sufficient implementation under the checkpoint's
scope rules, then check acceptance completeness and correctness. Speculative
abstractions and unsupported compatibility machinery are scope concerns even below the size
thresholds. The orchestrator must resolve demonstrated scope excess and material necessity
questions before accepting the increment; passing tests or deferring simplification is not a
substitute. The orchestrator resolves findings and accepts the increment. Do not repeat a full
review of unchanged accepted code. Review changed fixes and the behavior they affect.

If two fix attempts fail for the same finding, stop repeating the local fix and re-plan, narrow
the scope, clarify the requirement, or reconsider the model. This is a finding-level trigger,
not a two-round cap on the whole task. A stalled reviewer cannot silently pass: replace the
reviewer or complete the missing coverage, and report any review that remains incomplete.

### 6. Close out
Before handoff:
- update existing docs only when the change affects documented public behavior, APIs, or workflows
- check added or changed comments, docstrings, repository docs, and knowledge entries against the
  coding standards' Comments and Durable Prose rules; remove session narration and unnecessary
  explanation before review
- perform source-aware second-brain maintenance if project knowledge or a declared
  convention source changed; the user does not need to invoke that maintenance explicitly
- for the orchestrator's delivery of substantive implementation, stop only after the requested
  behavior, focused validation, and required independent review are complete, with the
  orchestrator's acceptance recorded
- if the harness cannot run subagents, return the pending-review handoff described above;
  this ends the current session without claiming final acceptance
- bounded implementation, investigation, and review workers may return their assigned result
  after completing its required validation; they do not arrange another review or obtain final
  acceptance

## Handoff Format

Report the outcome, supporting evidence, and material limits or follow-ups in concise prose. Use
a structured format when it is useful or required by the task, caller, or repository.

## Checklist
- [ ] Relevant repo context loaded
- [ ] Scope defined clearly
- [ ] Plan matched task size
- [ ] Change implemented with minimal scope
- [ ] Verification run honestly
- [ ] Docs / source-aware second-brain maintenance completed if needed
