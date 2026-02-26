---
name: agent-review
description: "Review code for bugs, inconsistencies, duplication, and refactoring opportunities. Use when: (1) asked to review a PR or branch, (2) asked to check a diff before merging, (3) asked to do a code review. Default behavior is to diff the current branch against main and review the changes. Can also review a specific GitHub PR by number or URL."
---

# agent-review

Code review skill. Reviews diffs for bugs, issues, inconsistencies, and refactoring
opportunities. Reports findings directly — does not create a file.

## Workflow

1. Read `CODING_STANDARDS.md` from the project root (or `@CODING_STANDARDS.md` if referenced in `CLAUDE.md`). If not found, check the repo's `.claude/CONVENTIONS.md`. These are the project's rules — enforce them.
2. Get the diff (see Usage Variants below)
3. Read the commit log for the same range: `git log --oneline main..HEAD` (or equivalent). Commit messages clarify intent — use them to distinguish "intentional change" from "accidental regression."
4. Read the full diff
5. Review against CODING_STANDARDS.md + the criteria below
6. Report findings grouped by severity

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

**What:** Clear description of what is wrong.
**Why:** Why this is problematic.
**Fix:** Concrete suggestion (not vague advice).
**File(s):** `path/to/file` (line N if applicable)
```

Severity guide:
- `[HIGH]` — Bug, data loss risk, silent failure, security issue, blocks operation
- `[MEDIUM]` — Logic flaw, inconsistency, missing error handling, violated standard
- `[LOW]` — Dead code, refactor opportunity, style/naming, minor cleanup

End with a **Summary**: total findings by severity, overall quality assessment, merge readiness.

If there are no findings: "No issues found. Ready to merge."

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
- **Default parameter values**: new functions using defaults instead of explicit params
- **Typing**: `Any`, `Dict[str, Any]`, loose dicts where structured models belong
- **Error handling**: bare `except Exception` in business logic (not outer loops), silent fallbacks returning fake defaults
- **Security clamping vs fallback**: ensure LLM output validation is kept (not a fallback)
- **`.env` handling**: reading `.env` directly instead of `os.environ`, `.env` missing from `.gitignore`
- **Secrets**: credentials hardcoded instead of env vars, secrets visible in logs/output
- **File size**: files exceeding ~500 LOC that should be split
- **Dependencies**: new deps added without health check justification
- **Docs**: behavior/API changes shipped without doc updates

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
- Repeated logic that could be a shared function
- Inline constants that should be named
- Copy-pasted error handling that could be a decorator
- Functions doing too many things (split candidates)
- Modules with tangled responsibilities
- Overly complex conditionals that could be simplified
- Flag these as `[LOW]` unless the complexity is actively causing bugs or blocking changes (`[MEDIUM]`)

### Architecture & Design
- Components instantiated but never used
- State split across in-memory and persistent store without sync
- Objects created but not persisted
- Config loaded but never passed to the component that needs it

### Tests
- Tests that mock too much and don't test actual behavior
- Missing edge cases (empty input, None, network failure)
- Fixtures that don't match production shapes
- No test for the happy path of a critical component
