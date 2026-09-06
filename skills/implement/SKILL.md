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
Scale planning to the task; a short inline plan is usually enough.

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
across files, pause for a scope checkpoint, consider if you are overbuilding and if the diff could be smaller, more elegant, and more easily reviewed by a human. Report production and test additions separately and
inspect necessity, reuse, contracts, and acceptance coverage. These thresholds are scope alarms,
not automatic rejection or splitting requirements. Do not game them with file splits.

### 5. Verify
- Run the repo-defined checks that match the change, following the verification reuse rule in
  `CODING_STANDARDS.md`
- Prefer exact workflow-derived verification when the repo defines it clearly
- If full verification is not practical, run the closest honest subset and say what was and was not verified
- Confirm the implementation matches the stated acceptance criteria

Require independent review for consequential changes: production services, security boundaries,
persisted-data migrations, broad behavior changes, and workflow rules governing these safeguards.
Honor stricter user or repository requirements. Small, reversible edits may finish with focused
validation; substantive work does not automatically require a separate reviewer for every step.

When review is required, use one fresh reviewer who did not implement the change. Review early
when findings could prevent costly or irreversible mistakes. Invoke `agent-review`'s checkpoint
mode with the changes, acceptance criteria, relevant contracts, and validation results. Keep the
handoff compact and reuse passing checks. Review later fixes only where they affect behavior or
evidence. Select the reviewer for the task, respecting session model choices.

The reviewer checks scope, correctness, and acceptance coverage. Resolve material findings before
accepting the change; passing tests alone does not establish that added scope is necessary.
If two attempts fail to resolve the same finding, reconsider the approach instead of repeating it.

If required review is unavailable or incomplete, report the exact changes, validation results,
and outstanding review. Label the result awaiting review, not accepted; self-review cannot
satisfy this gate.

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
