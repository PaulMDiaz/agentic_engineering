---
name: implement
description: Execute a user-supplied or approved implementation plan, or coordinate changes requiring a material design decision, multiple behavior boundaries, or risk-driven staging. Use when explicitly requested; routine edits with a clear approach use direct execution and focused verification.
---

# Implement Skill

Approach non-trivial coding tasks methodically. Think before coding, keep scope tight, and verify before handoff.

## When to Use

Use this skill when:
- executing an established implementation plan supplied or approved by the user
- a material design decision or coordination across behavior boundaries is needed
- execution must be staged to manage an identified risk
- the user explicitly requests it

Work directly when the change has a clear approach and can be completed with focused verification.
File count, task duration, and the need for tests do not by themselves justify this skill.
An agent-created routine to-do list is not an established implementation plan. Direct work still
follows the coding standards' scope, verification, and independent-review requirements.

## Process

When this skill is assigned to a bounded worker, plan within the supplied assignment as needed
and follow its paths, criteria, constraints, and validation. Do not expand the scope or delegate
further work. Perform self-review when assigned and return the result without launching a reviewer or obtaining
final acceptance. The orchestrator retains resolution and acceptance.

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
Derive acceptance criteria from the user's request and established affected contracts. Do not
add speculative robustness, flexibility, or future use cases as requirements. Establish the
necessary verification before editing.
Apply the coding standards' scope and deletion-first rules whether working directly or delegating.
Keep routine reasoning internal; explain material uncertainty or a proposed scope change.

Treat acceptance criteria as exhaustive for the requested behavior while preserving established
affected contracts unless the task explicitly changes them. Establish compatibility obligations
from support policy, supported callers, persisted data contracts, or explicit requirements.
Existing behavior alone does not justify legacy adapters, dual implementations, migration layers,
or fallback paths. Resolve material uncertainty before breaking an established contract. Ask the
user about scope, material unknowns, or required model choices when those block progress, and
preserve separate permission or approval requirements.

### 3. Plan proportionally
When executing a supplied or approved plan, follow its agreed scope and sequence. Do not create
a replacement plan or repeat settled decisions. Surface contradictions or new blockers instead.

Plan only enough to guide the work. Share a short plan when coordination or a material choice
benefits the user; do not produce a plan artifact merely to demonstrate compliance.

The orchestrator owns the plan, acceptance criteria, resolution of findings, and final
acceptance. Before assigning work, check for existing reusable functionality and identify the
contract owner for each affected behavior.

Choose direct execution or delegation based on useful work, not task size alone. Delegate a
bounded assignment when it can progress alongside other work or materially reduces parent
context after handoff costs. Keep small lookups and tightly coupled operational sequences with
one executor. Do not split a sequential task into worker handoffs merely to satisfy a process.
When delegating, supply owned paths, acceptance criteria, relevant evidence, constraints, and
validation steps. Workers do not recursively orchestrate. Reuse their verified results; inspect
only the evidence needed to resolve uncertainty rather than repeating their investigation.

When requirements change, redirect affected work and preserve valid progress. If a worker stalls,
obtain its exact state before taking over or reassigning; prevent overlapping mutations. Avoid
repeated status requests and unchanged checks. Use milestone reports or event-based waits.

For consequential changes, verify prerequisites and a recovery approach appropriate to the risk.
Use existing recovery mechanisms where sufficient; this assessment does not authorize building
additional infrastructure.

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
across files, pause to reassess scope. Ask what can be removed while preserving required behavior
and established contracts. Report production and test additions separately at this checkpoint.
These are backstops, not targets or permission to overbuild below them. Keep one coherent change
reviewable; do not hide growth with file splits or offsetting unrelated deletions.

### 5. Verify
- Run the repo-defined checks that match the change, following the verification reuse rule in
  `CODING_STANDARDS.md`
- Prefer exact workflow-derived verification when the repo defines it clearly
- If full verification is not practical, run the closest honest subset and say what was and was not verified
- Confirm the implementation matches the stated acceptance criteria

Follow the review requirements in `CODING_STANDARDS.md`, including reviewer eligibility and
when focused validation or self-review is sufficient.

`auto-review` is a skill, not a request to spawn an agent. Give the chosen reviewer the diff,
acceptance criteria, relevant contracts, and validation results. Keep handoffs compact and reuse
passing checks. Review early when findings could prevent costly or irreversible mistakes;
review later fixes only where they affect behavior or evidence. Follow session model and effort
authorization before any new reviewer launch.

The reviewer checks scope, correctness, and acceptance coverage. Resolve material findings before
accepting the change; passing tests alone does not establish that added scope is necessary.
Apply the same scope limits to review fixes. A reviewer suggestion does not authorize expanding
the task: verify that it addresses a demonstrated defect, unnecessary scope, or required contract.
If two attempts fail to resolve the same finding, reconsider the approach instead of repeating it.

If required review is unavailable or incomplete, report the exact changes, validation results,
and outstanding review. Label the result awaiting review, not accepted. Self-review cannot replace a required
independent check.

### 6. Close out
Before handoff:
- update existing docs only when the change affects documented public behavior, APIs, or workflows
- check added or changed comments, docstrings, repository docs, and knowledge entries against the
  coding standards' Comments and Durable Prose rules; remove session narration and unnecessary
  explanation before review
- perform source-aware second-brain maintenance if project knowledge or a declared
  convention source changed; the user does not need to invoke that maintenance explicitly
- accept the result only after the requested behavior, focused validation, and any required
  independent review are complete; otherwise state what remains

## Handoff

Report the result and relevant verification briefly. Explain failed checks, unresolved choices,
material risks, or pending review when present. Do not narrate routine planning, delegation,
scope checks, or acceptance steps. Honor explicit requests for more detail.
