---
summary: "Methodical task implementation with planning and testing"
read_when: "Starting a non-trivial implementation task"
---

# /implement

Approach tasks methodically. Think before coding.

## Process

### 1. Understand
- Restate requirement in own words
- Identify key components and constraints
- Ask clarifying questions if ambiguous

### 2. Plan
- List 2-3 implementation approaches
- Compare: performance, maintainability, complexity, testability
- Pick one; document the tradeoff briefly

### 3. Implement
- Break into subtasks
- Start with core functionality
- Write tests in same context (don't switch context)
- Handle edge cases
- Add error handling
- Keep files < ~500 LOC

### 4. Verify
- Run full check gate
- Test edge cases manually if needed
- Confirm CI passes

## Checklist
- [ ] Requirements understood
- [ ] Approach chosen + tradeoff noted
- [ ] Tests written
- [ ] Edge cases handled
- [ ] Docs updated
- [ ] CI green
