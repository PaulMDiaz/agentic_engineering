---
name: check-ci
description: Determine and run the local CI-equivalent checks for the current repo, then report results in a structured format. Use when the user asks to check CI, verify CI, reproduce GitHub Actions locally, or confirm whether a branch/PR is green before merge.
---

# Check CI

Determine and run the local CI-equivalent checks for the current repo, then report the outcome in a structured, merge-useful format.

## When to Use

Use this skill when the user asks to:
- "check CI"
- "verify CI"
- "run CI locally"
- "reproduce CI"
- "see if this branch/PR is green"
- "do a full CI check"

Pair naturally with `agent-review` when the user asks to both review code and verify CI.

## Core Principles

- Prefer **exact workflow-derived checks** when the repo defines them clearly.
- If exact local parity is not practical, fall back to the **closest useful local equivalent**.
- Prefer **repo evidence** over generic language/tool assumptions.
- Do **not stop on first failure** — run the full derived check set when practical and report the full picture.
- Default to **changed-files-oriented verification** when the user's request is generic (for example: "check CI" or "verify CI").
- If the user explicitly says **"full CI check"** or **"check full CI"**, run the full repo CI-equivalent path.

## Process

### Step 1: Determine intended scope from the request

Interpret user intent first:

- Generic requests like **"check CI"** / **"verify CI"** → default to **changed-files-oriented** verification when the repo/workflow supports that interpretation.
- Explicit requests like **"full CI check"** / **"check full CI"** → run the **whole repo** CI-equivalent path.

If the repo/workflow does not provide a meaningful changed-files mode, say so and fall back to the closest useful whole-repo local equivalent.

### Step 2: Inspect repo evidence before choosing commands

Look for CI/task definitions in this order:

1. `.github/workflows/*.yml` / `.yaml`
2. `Makefile`, `justfile`, `Taskfile.yml`
3. `pyproject.toml`, `package.json`, `tox.ini`, `noxfile.py`
4. `scripts/` or documented CI wrapper commands
5. docs (`README.md`, `CONTRIBUTING.md`) only if the workflow/config is incomplete

Goal: infer the local CI-equivalent commands from the repo itself.

### Step 3: Choose the command set

Follow this priority:

1. **Exact workflow-derived commands**
   - If the workflow clearly defines runnable local equivalents, use those.
2. **Repo-defined task wrappers**
   - For example: `make lint`, `just test`, `tox -e py`, `npm run lint`
3. **Closest useful local equivalent**
   - Only if exact parity cannot be determined or reproduced locally.

Be explicit in the final output about whether the result is:
- **exact workflow-derived**, or
- **closest useful local equivalent**

### Step 4: Run the checks in workflow order

Run the derived commands in the same order the workflow implies.

Do not stop on first failure unless a later command literally cannot run because of a missing prerequisite. When that happens, report later checks as not run and explain why.

### Step 5: Report in the required structure

Always use this structure.

## CI Check

**Status:** one of:
- `✅ Green`
- `❌ Failing`
- `⚠️ Partial / uncertain local CI verification`

**Scope:** one of:
- `changed files`
- `full repo`

**Parity:** one of:
- `exact workflow-derived`
- `closest useful local equivalent`

### Evidence Used

List the files/sources used to infer CI, for example:
- `.github/workflows/ci.yml`
- `pyproject.toml`
- `Makefile`

### Checks Run

Numbered list of commands in execution order.

### Results

One line per command:
- ``command`` — ✅ Passed
- ``command`` — ❌ Failed
- ``command`` — ⏭️ Not run

### Failures

Only include this section if something failed.

For each failure, use:

#### 1. `command`
**What failed:** short explanation  
**Why it matters:** why this blocks local CI / merge confidence  
**Suggested fix:** the most direct next step  

Number failures in the order they were encountered.

### Summary

End with a concise bottom line:
- exact local CI is green, or
- exact local CI is failing, or
- best-effort local CI is green but parity is not exact, or
- partial/uncertain verification only

## Green/Red Rules

### Green
Call the result **✅ Green** only when:
- all chosen checks passed, and
- parity is correctly labeled.

If exact workflow parity was possible and passed:
- `Status: ✅ Green`
- `Parity: exact workflow-derived`

If exact parity was not possible, but the best inferred checks all passed:
- still allow green, but make it explicit:
  - `Status: ✅ Green`
  - `Parity: closest useful local equivalent`

### Failing
Call the result **❌ Failing** when one or more checks fail.

### Partial / uncertain
Use **⚠️ Partial / uncertain local CI verification** when:
- the repo’s CI cannot be determined confidently,
- a major required check could not be run locally,
- or parity is too unclear to claim a trustworthy green/red result.

## Guidance

- Do not invent commands that are not grounded in repo evidence.
- Prefer clarity over pretending certainty.
- If changed-files-only verification is not well-defined for the repo, say so plainly.
- If GitHub Actions is red but local CI is green, note that this may indicate workflow mismatch, environment drift, or provider-specific issues.
- This skill reports CI state; it does not automatically fix failures unless the user asks.

## Examples

### If everything passes

```md
## CI Check

**Status:** ✅ Green
**Scope:** changed files
**Parity:** exact workflow-derived

### Evidence Used
- `.github/workflows/ci.yml`
- `pyproject.toml`

### Checks Run
1. `ruff check .`
2. `ruff format --check .`
3. `mypy osint_agent/`
4. `pytest tests/ -q -m "not integration"`

### Results
- `ruff check .` — ✅ Passed
- `ruff format --check .` — ✅ Passed
- `mypy osint_agent/` — ✅ Passed
- `pytest tests/ -q -m "not integration"` — ✅ Passed

### Summary
Local CI-equivalent checks are green.
```

### If some checks fail

```md
## CI Check

**Status:** ❌ Failing
**Scope:** full repo
**Parity:** exact workflow-derived

### Evidence Used
- `.github/workflows/ci.yml`
- `pyproject.toml`

### Checks Run
1. `ruff check .`
2. `ruff format --check .`
3. `mypy osint_agent/`
4. `pytest tests/ -q -m "not integration"`

### Results
- `ruff check .` — ✅ Passed
- `ruff format --check .` — ❌ Failed
- `mypy osint_agent/` — ✅ Passed
- `pytest tests/ -q -m "not integration"` — ✅ Passed

### Failures
#### 1. `ruff format --check .`
**What failed:** formatting drift in changed files  
**Why it matters:** the branch does not match the repo's formatting gate  
**Suggested fix:** run `ruff format` on the reported files and rerun the check  

### Summary
Exact local CI is failing because formatting is not clean.
```

### If CI can only be inferred partially

```md
## CI Check

**Status:** ⚠️ Partial / uncertain local CI verification
**Scope:** changed files
**Parity:** closest useful local equivalent

### Evidence Used
- `.github/workflows/ci.yml`
- `README.md`

### Checks Run
1. `pytest`

### Results
- `pytest` — ✅ Passed

### Summary
Partial local verification only; exact workflow parity could not be reproduced confidently.
```
