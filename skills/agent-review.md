---
name: agent-review
description: "Review code for bugs, inconsistencies, duplication, and refactoring opportunities. Use when: (1) asked to review a PR or branch, (2) asked to check a diff before merging, (3) asked to do a code review. Default behavior is to diff the current branch against main and review the changes. Can also review a specific GitHub PR by number or URL."
---

# agent-review

Code review skill. Reviews diffs for bugs, issues, inconsistencies, and refactoring
opportunities. Reports findings directly — does not create a file.

## Default Workflow

1. Get the diff (see Usage Variants below)
2. Read the diff output
3. Review against the criteria in this file
4. Report findings grouped by severity, directly in the response

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

---

## Output Format

Report findings ordered by severity (highest first). Tag each with `[HIGH]`, `[MEDIUM]`,
or `[LOW]`. Use this structure:

```
### [SEVERITY] Short title

**What is the issue?**
Clear description of what is wrong.

**Why is this an issue?**
Why this is problematic — incorrect behavior, violated contract, hidden assumption, etc.

**Consequences of not fixing:**
What breaks, degrades, or silently misbehaves if left unresolved.

**Possible fixes:**
- Option A: ...
- Option B: ...

**File(s):** `path/to/file` (line N if applicable)
```

Severity guide:
- `[HIGH]` — Bug, data loss risk, silent failure, security issue, blocks operation
- `[MEDIUM]` — Logic flaw, inconsistency, missing error handling, misleading behavior
- `[LOW]` — Dead code, refactor opportunity, style/naming, minor cleanup

End with a **Summary**: overall quality assessment and merge readiness.

If there are no findings, say so clearly — "No issues found. Ready to merge."

---

## Review Criteria

### Bugs & Correctness
- Off-by-one errors, incorrect conditionals, wrong comparisons
- Unhandled exceptions or error paths that could crash
- Race conditions or concurrency issues (async code especially)
- Data loss risk (e.g. INSERT OR REPLACE silently overwriting)
- Wrong return types or missing return values
- Incorrect boolean logic (negation errors, short-circuit issues)

### Security
- Secrets or credentials in code (not env vars)
- Unsanitized input passed to shell, SQL, or eval
- Prompt injection risks (LLM inputs not delimited/validated)
- Overly broad permissions or access

### Inconsistencies
- Same config value defined in multiple places with different defaults
- Naming that contradicts behavior (e.g. `update_event` that does insert)
- Type mismatches between definitions and usage
- Dead code that's defined but never wired in
- Config files with env var placeholders that aren't interpolated at runtime

### Error Handling
- Bare `except Exception` that swallows errors silently
- Missing retry logic for transient failures (network, webhooks)
- No graceful shutdown / signal handling
- Startup failures that don't surface clearly

### Code Duplication
- Repeated logic that could be a shared function/class
- Inline constants that should be named
- Copy-pasted error handling that could be a decorator

### Architecture & Design
- Components that are instantiated but never used
- State split across in-memory and persistent store without sync
- Alert/result objects created but not persisted anywhere
- Config loaded but never passed to the component that needs it

### Tests
- Tests that mock too much and don't test actual behavior
- Missing edge cases (empty input, None, network failure)
- Test fixtures that don't match production shapes
- No test for the happy path of a critical component
