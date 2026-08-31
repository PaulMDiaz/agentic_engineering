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

Treat acceptance criteria as exhaustive; ask clarifying questions only when implementation would otherwise be guesswork.

### 3. Plan proportionally
Use the smallest planning process that is honest for the task size.

For small-to-medium tasks:
- make a short inline plan with the intended files/steps

Prefer the smallest correct plan. Do not create ceremony for trivial work.

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

Before adding a test, answer: which acceptance criterion does it verify, and would
existing tests miss this regression without it? If the test is longer or more complex
than the code it covers, the implementation is probably overbuilt.

### 5. Verify
- Run the repo-defined checks that match the change
- Prefer exact workflow-derived verification when the repo defines it clearly
- If full verification is not practical, run the closest honest subset and say what was and was not verified
- Confirm the implementation matches the stated acceptance criteria

### 6. Close out
Before handoff:
- update existing docs only when the change affects documented public behavior, APIs, or workflows
- perform source-aware second-brain maintenance if project knowledge or a declared
  convention source changed; the user does not need to invoke that maintenance explicitly
- once the requested behavior works and focused validation passes, stop

## Handoff Format

When reporting back after implementation, prefer this structure:

```md
## Plan
- ...

## Changes made
- ...

## Verification
- ...

## Risks / follow-ups
- ...
```

## Checklist
- [ ] Relevant repo context loaded
- [ ] Scope defined clearly
- [ ] Plan matched task size
- [ ] Change implemented with minimal scope
- [ ] Verification run honestly
- [ ] Docs / source-aware second-brain maintenance completed if needed
