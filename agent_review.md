# Agent Code Review — agentic_engineering

Reviewed by: Phobos (Claude Sonnet 4.6)
Date: 2026-02-21 (updated after CODING_STANDARDS.md refactor)
Branch: dev → main

---

## Resolved since initial review

- ~~[MEDIUM] Tool catalog duplication~~ — AGENTS.md is now ~40 lines, overlap eliminated
- ~~[LOW] Empty CLAUDE.md~~ — now a proper entry point with second brain checklist
- ~~[LOW] `hooks.json` placeholder~~ — removed from `init-second-brain` template
- ~~[HIGH] `@CODING_STANDARDS.md` import won't work in OpenClaw~~ — AGENTS.md deleted; repo is now Claude Code/Cursor only, no OpenClaw files
- ~~[MEDIUM] Pointer Pattern guides agents to wrong file~~ — AGENTS.md deleted; no longer applicable

---

## Findings (ordered by severity)

---

### [HIGH] `/context-prime` command referenced in README but doesn't exist

**What is the issue?**
`docs/slash-commands/README.md` lists `/context-prime` as an available command. No `context-prime.md` file exists. The three second brain commands (`init-second-brain`, `load-second-brain`, `update-second-brain`) are not listed even though they exist.

**Why is this an issue?**
Agents reading the slash command index will attempt a command that doesn't exist. The index is also incomplete — it omits commands that do exist.

**Consequences of not fixing:**
Dead command wastes agent context. The index can't be trusted as a reference.

**Possible fixes:**
- Remove `/context-prime` from the index
- Add the three second brain skills and `/agent-review` if it should be slash-invocable

**File(s):** `docs/slash-commands/README.md`

---

### [HIGH] Security docs teach patterns that contradict `CODING_STANDARDS.md`

**What is the issue?**
`docs/llm-classifier-security.md` and `docs/prompt-injection-defense.md` contain `_validate_llm_output()` examples that:
1. Mutate the input dict in-place (`raw["field"] = ...`) — violates the **pure functions** rule
2. Use `dict` without type parameters — violates the **strict typing** rule
3. Use `.get()` with inline defaults — violates the **no default parameter values** rule

**Why is this an issue?**
These docs are explicitly reference implementations. Agents following them write code that directly contradicts CODING_STANDARDS.md.

**Consequences of not fixing:**
Every project bootstrapped from these docs inherits wrong patterns — rules say one thing, reference code demonstrates the opposite.

**Possible fixes:**
- Update examples: return a new dict, use `dict[str, Any]`, make `.get()` calls explicit
- Add a notice: "Examples predate CODING_STANDARDS.md — see CODING_STANDARDS.md for current conventions"

**File(s):** `docs/llm-classifier-security.md`, `docs/prompt-injection-defense.md`

---

### [HIGH] `llm-classifier-security.md` explicitly recommends the pattern we banned

**What is the issue?**
The doc states: *"If parsing fails entirely, return a safe default extraction rather than raising. The classifier should never crash the processing pipeline."*

`CODING_STANDARDS.md` Error Handling now says: *"No silent fallbacks — never return a fake default when a dependency fails. Let it propagate. Failures must be visible."*

**Why is this an issue?**
The doc is authoritative reference material. Any agent following it will implement a silent fallback — the exact pattern we removed from `osint-alert-agent`.

**Consequences of not fixing:**
New projects built from this guide will have silent LLM failure masking. Rule and reference directly contradict each other.

**Possible fixes:**
- Replace: "Let the exception propagate. The outer processing loop catches it, logs it, and skips the item. Failures must be visible."
- Clarify the distinction: security-clamping valid-but-injected output is required; swallowing API failures is banned

**File(s):** `docs/llm-classifier-security.md` → "Handling JSON Parsing Failures" section

---

### [MEDIUM] `scripts/committer` doesn't validate Conventional Commits format

**What is the issue?**
`CODING_STANDARDS.md` mandates Conventional Commits. The `committer` script only checks for non-empty message — `"oops fixed thing"` passes without warning.

**Why is this an issue?**
The committer script is the obvious enforcement point for the format rule. Currently it's a gatekeeper with no gate.

**Consequences of not fixing:**
Malformed commits get through. Changelog generators and semantic release tools fail or skip entries.

**Possible fixes:**
- Add regex check: `^(feat|fix|docs|refactor|style|perf|test|chore|wip|remove|security)(\(.+\))?: .+`
- Warn (not hard fail) on mismatch — let user proceed or abort

**File(s):** `scripts/committer`

---

### [MEDIUM] `$ARGUMENTS` is Claude Code-specific — breaks tool-agnostic claim

**What is the issue?**
`skills/init-second-brain.md` and `skills/update-second-brain.md` use `$ARGUMENTS` for optional user input. This is Claude Code's argument interpolation syntax — not supported in Cursor or other environments.

**Why is this an issue?**
The skills are positioned as tool-agnostic but use platform-specific syntax. In Cursor, `$ARGUMENTS` is a literal string.

**Consequences of not fixing:**
The optional argument ingestion step silently fails in non-Claude Code environments.

**Possible fixes:**
- Replace with plain instruction: "If the user provided a path or notes when invoking this skill, use them as additional input"

**File(s):** `skills/init-second-brain.md`, `skills/update-second-brain.md`

---

### [MEDIUM] OpenClaw `bootstrap-extra-files` config snippet is unverified

**What is the issue?**
`docs/second-brain-hooks.md` shows `"bootstrapExtraFiles": { "patterns": [...] }` as the config key. This is inferred — not verified against the actual OpenClaw hook schema.

**Why is this an issue?**
Wrong key = hook silently does nothing with no error.

**Possible fixes:**
- Verify via `openclaw hooks info bootstrap-extra-files` and update the snippet

**File(s):** `docs/second-brain-hooks.md` — OpenClaw section

---

### [LOW] No `.gitignore`

**What is the issue?**
The repo has no `.gitignore`. `init-second-brain` tells users to add `.claude/.pending-update` to `.gitignore` — the repo doesn't model this itself.

**Possible fixes:**
- Add `.gitignore`: `.claude/.pending-update`, `*.pyc`, `__pycache__/`, `.DS_Store`, `.env`

**File(s):** (missing) `.gitignore`

---

### [LOW] `tools.md` missing `ruff format` from Python quality gate

**What is the issue?**
The Python section lists `ruff check .` but omits `ruff format --check .`. Documented gate is incomplete.

**Possible fixes:**
- Add `ruff format --check .` to the Python section

**File(s):** `tools.md` → Python section

---

## ✅ What's Solid

- **`CODING_STANDARDS.md`** — clean, comprehensive, genuinely platform-agnostic
- **`CLAUDE.md`** — proper entry point with second brain checklist, structure table, quick reference
- **`AGENTS.md`** — dramatically cleaner; OpenClaw-specific only, ~40 lines
- **Second brain skills** — coherent `init`/`load`/`update` system; well-structured
- **`docs/second-brain-hooks.md`** — clean platform matrix; Claude Code Stop hook approach is solid
- **`scripts/committer`** — minimal, correct, `set -euo pipefail`
- **Slash commands** — well-scoped, good `read_when` hints

---

## Summary

Deleting AGENTS.md cleanly resolved two findings — the `@` import gap and the stale Pointer Pattern are moot since the repo is now Claude Code/Cursor only. The three remaining HIGH items are all about the security docs actively teaching patterns that now contradict CODING_STANDARDS.md.

| Severity | Count | vs. initial review |
|----------|-------|--------------------|
| [HIGH]   | 3     | −2 resolved (AGENTS.md deleted) |
| [MEDIUM] | 3     | −2 resolved (AGENTS.md deleted) |
| [LOW]    | 2     | −3 resolved        |
| **Total**| **8** | **−4 net**         |
