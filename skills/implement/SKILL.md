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
- If the repo has a `.claude/` directory, check the most relevant context files before changing code:
  - `DECISIONS.md` for prior trade-offs
  - `CONVENTIONS.md` for repo-specific rules
  - `CODE_POINTERS.md` when it helps locate files quickly
- If the task is non-trivial and the repo uses a second brain, run `load-second-brain`

### 2. Define the task precisely
Before editing, make the task concrete:
- what is changing
- what is not changing
- constraints
- acceptance criteria
- assumptions or unknowns that could affect implementation

Ask clarifying questions if the task is ambiguous enough that implementation would be guesswork.

### 3. Plan proportionally
Use the smallest planning process that is honest for the task size.

For small-to-medium tasks:
- make a short inline plan with the intended files/steps

For larger or multi-step tasks:
- create a lightweight plan in `/tmp/<feature>.md`
- include:
  - current state
  - desired final state
  - files to change
  - task checklist

Prefer the smallest correct plan. Do not create ceremony for trivial work.

### 4. Implement incrementally
- Follow existing repo patterns before introducing new ones
- Prefer the smallest correct change that solves the task
- Avoid speculative refactors or “while I’m here” cleanup
- If you notice refactoring opportunities, flag them instead of silently expanding scope
- Write tests in the same work context when the task warrants them
- Handle edge cases and error paths that are clearly in scope

### 5. Verify
- Run the repo-defined checks that match the change
- Prefer exact workflow-derived verification when the repo defines it clearly
- If full verification is not practical, run the closest honest subset and say what was and was not verified
- Confirm the implementation matches the stated acceptance criteria

### 6. Close out
Before handoff:
- update docs if behavior or workflow changed
- update second-brain files if project knowledge changed
- note any follow-up risks, open questions, or refactor opportunities

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
- [ ] Docs / second brain updated if needed
