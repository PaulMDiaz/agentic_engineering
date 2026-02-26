---
name: diff-summary
description: "Walk through a diff and explain what it's trying to accomplish and the approach taken. Use when you want to understand a branch or PR before reviewing or merging. Defaults to diff against main unless another branch is specified."
---

# diff-summary

Walk through the diff and explain what it's trying to accomplish and how.

## Process

1. Get the diff:

   **Default (current branch vs main):**
   ```bash
   git --no-pager diff main
   ```

   **Specific branch:**
   ```bash
   git --no-pager diff <base>..<head>
   ```

   **GitHub PR:**
   ```bash
   gh pr diff <PR_NUMBER>
   ```

2. Read the commit log for the same range (e.g. `git log --oneline main..HEAD`). Commit messages state intent directly — use them to explain *what* and *why* more accurately than inferring from code alone.

3. Read the diff in full before responding.

4. Answer two questions:
   - **What is this trying to accomplish?** — the goal, in plain language
   - **What is the approach?** — how it achieves that goal; key decisions and patterns used

## Output Format

Keep it conversational — this is an explanation, not a report.

**Structure:**
```
## What it's doing
One or two sentences on the goal.

## The approach
How it gets there. Walk through the significant changes:
- What changed and why (infer from context)
- Any notable patterns, trade-offs, or techniques used
- What was intentionally left out (if apparent)
```

Stay high-level unless a specific detail is worth calling out. The goal is to give
someone enough context to understand and evaluate the diff quickly — not to list every
changed line.
