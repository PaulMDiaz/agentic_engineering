# Agent Code Review — agentic_engineering

Reviewed by: Phobos (Claude Sonnet 4.6)
Date: 2026-02-21
Branch: dev → main

---

## Findings (ordered by severity)

---

### [HIGH] `/context-prime` command referenced in README but doesn't exist

**What is the issue?**
`docs/slash-commands/README.md` lists `/context-prime` as an available command, but there is no `context-prime.md` file in `docs/slash-commands/`. The command is a dead reference.

**Why is this an issue?**
Any agent or developer following the README index will try to use `/context-prime` and find nothing. It also undermines trust in the rest of the index.

**Consequences of not fixing:**
Agents reading the slash command index will attempt a command that doesn't exist. Confusion, wasted context, or silent fallback to generic behavior.

**Possible fixes:**
- Option A: Create `docs/slash-commands/context-prime.md` — now superseded by `load-second-brain`, so this could redirect there
- Option B: Remove `/context-prime` from the README index and replace with the three second brain commands (init/load/update)

**File(s):** `docs/slash-commands/README.md`

---

### [HIGH] Code examples in security docs contradict new rules — teach the wrong patterns

**What is the issue?**
`docs/llm-classifier-security.md` and `docs/prompt-injection-defense.md` contain `_validate_llm_output()` examples that:
1. Mutate the input dict in-place (`raw["is_space_event"] = ...`) — violates the new **pure functions** rule
2. Use untyped `dict` return signatures — violates the new **strict typing** rule
3. Use `.get()` with default values — violates the new **no default parameter values** rule

**Why is this an issue?**
These docs are explicitly intended as reference implementations for other projects. If an agent or developer follows them, they'll write code that directly contradicts `AGENTS.md`.

**Consequences of not fixing:**
Every new project bootstrapped from these docs inherits the wrong patterns. The rules say one thing, the reference code demonstrates the opposite.

**Possible fixes:**
- Update the code examples to match current rules: return a new dict, use `dict[str, Any]`, make all `.get()` calls explicit
- Add a note at the top of the docs: "See `AGENTS.md` Design section for current conventions"

**File(s):** `docs/llm-classifier-security.md`, `docs/prompt-injection-defense.md`

---

### [HIGH] `llm-classifier-security.md` explicitly recommends the pattern we just banned

**What is the issue?**
`docs/llm-classifier-security.md` contains: *"If parsing fails entirely, return a safe default extraction (all fields at lowest-risk values) rather than raising. The classifier should never crash the processing pipeline."*

This directly contradicts Issue 8 (decision A): **no silent fallbacks — let failures propagate**.

**Why is this an issue?**
The doc is authoritative reference material. Any agent following it will implement a silent fallback, undoing the explicit decision made in AGENTS.md.

**Consequences of not fixing:**
New projects built from this guide will have silent LLM failure masking — the exact pattern we removed from osint-alert-agent. The rule and the reference implementation disagree.

**Possible fixes:**
- Replace the fallback recommendation with: "Let the exception propagate. The outer processing loop (per-item try/except) catches it, logs it, and skips the item. Failures must be visible."
- Reference the reasoning from `AGENTS.md` Error Handling section

**File(s):** `docs/llm-classifier-security.md` — "Handling JSON Parsing Failures" section

---

### [MEDIUM] `AGENTS.md` Tools section duplicates `tools.md`

**What is the issue?**
`AGENTS.md` has a `## Tools` section documenting `gh`, `claude`, `trash`, and useful CLIs. `tools.md` is a dedicated tool catalog covering the same tools in more detail. Two sources of truth for the same information.

**Why is this an issue?**
If one is updated the other may drift. Agents loading both files receive redundant context.

**Consequences of not fixing:**
Inconsistencies will emerge over time (already: `AGENTS.md` mentions `uv` for Python, `tools.md` only mentions Python tooling in the stack section without `uv`). Agents burn unnecessary tokens reading duplicated content.

**Possible fixes:**
- Option A: Remove the `## Tools` section from `AGENTS.md` entirely — replace with: "See `tools.md` for the full tool catalog."
- Option B: Keep a minimal pointer list in `AGENTS.md` (3-4 lines) and remove detail that's already in `tools.md`

**File(s):** `AGENTS.md` → `## Tools` section, `tools.md`

---

### [MEDIUM] `scripts/committer` doesn't validate Conventional Commits format

**What is the issue?**
`AGENTS.md` mandates Conventional Commits (`type(scope): description`). The `committer` script only checks that the message is non-empty. A commit like `"oops fixed thing"` passes without warning.

**Why is this an issue?**
The committer script is the designated commit helper — it's the obvious place to enforce the format. Currently it's a gatekeeper with no gate.

**Consequences of not fixing:**
Malformed commit messages get committed, breaking the consistency the convention is meant to provide. CI/CD tools that parse commit messages (changelog generators, semantic release) will fail or skip entries.

**Possible fixes:**
- Add a regex check: `^(feat|fix|docs|refactor|style|perf|test|chore|wip|remove|security)(\(.+\))?: .+`
- Print a warning (not a hard fail) if the format doesn't match, give the user a chance to proceed or abort

**File(s):** `scripts/committer`

---

### [MEDIUM] `$ARGUMENTS` is Claude Code-specific — breaks tool-agnostic claim

**What is the issue?**
`skills/init-second-brain.md` and `skills/update-second-brain.md` both reference `$ARGUMENTS` for optional user input. This is Claude Code's argument interpolation syntax and is not supported in Cursor or other environments.

**Why is this an issue?**
The skills are explicitly positioned as tool-agnostic, but `$ARGUMENTS` will appear as a literal string in Cursor or any environment that doesn't interpolate it.

**Consequences of not fixing:**
In Cursor, the agent may look for a file or argument named literally `$ARGUMENTS`, produce an error, or silently skip the optional ingestion step. The skills behave differently per platform without any indication.

**Possible fixes:**
- Option A: Replace `$ARGUMENTS` with a plain instruction: "If the user provided a path or notes when invoking this skill, use them as additional input"
- Option B: Add a platform note: "`$ARGUMENTS` is interpolated by Claude Code. In Cursor, pass context by mentioning it directly in the conversation."

**File(s):** `skills/init-second-brain.md`, `skills/update-second-brain.md`

---

### [MEDIUM] `second-brain-hooks.md` OpenClaw config snippet may not match actual key format

**What is the issue?**
`docs/second-brain-hooks.md` shows this config for `bootstrap-extra-files`:
```json
{
  "hooks": {
    "bootstrapExtraFiles": {
      "patterns": [".claude/ARCHITECTURE.md", ...]
    }
  }
}
```
The actual config key and structure for `bootstrap-extra-files` should be verified against the OpenClaw docs — `bootstrapExtraFiles` is inferred but not confirmed.

**Why is this an issue?**
If the key is wrong, users following the doc will enable the hook but it will silently do nothing. No error, no feedback.

**Consequences of not fixing:**
Broken setup guide for OpenClaw users. The session-start automation doesn't work, and there's no obvious failure signal.

**Possible fixes:**
- Verify the actual config key via `openclaw hooks info bootstrap-extra-files` and update the snippet
- Add a note: "Run `openclaw hooks info bootstrap-extra-files` to confirm the current config schema"

**File(s):** `docs/second-brain-hooks.md` — OpenClaw section

---

### [LOW] No `.gitignore` — runtime files would be committed

**What is the issue?**
The repo has no `.gitignore`. The `init-second-brain` skill creates `.claude/.pending-update` (a runtime marker) and tells users to add it to `.gitignore` — but the agentic_engineering repo itself has no `.gitignore` to demonstrate this.

**Why is this an issue?**
If someone runs `init-second-brain` on this repo, the marker file has no protection. Also `.claude/` SQLite files, logs, or other runtime artifacts from future tooling would be committed.

**Consequences of not fixing:**
Runtime files pollute the git history. Future contributors forget to add `.gitignore` entries.

**Possible fixes:**
- Add a `.gitignore` with at minimum: `.claude/.pending-update`, `*.pyc`, `__pycache__/`, `.DS_Store`

**File(s):** (missing) `.gitignore`

---

### [LOW] `CLAUDE.md` is nearly empty — underused as an entry point

**What is the issue?**
`CLAUDE.md` contains only `@AGENTS.md` and four lines of structural description. It's the file Claude Code auto-loads first, but it doesn't contain the session start checklist or second brain instructions that we just built.

**Why is this an issue?**
The `init-second-brain` skill creates `CLAUDE.md` files with a full session start checklist for new projects. The agentic_engineering repo itself doesn't follow its own convention.

**Consequences of not fixing:**
Agents working in this repo won't get the second brain loading behavior. The repo doesn't eat its own cooking.

**Possible fixes:**
- Add the session start checklist to `CLAUDE.md`: check for `.pending-update`, load second brain if `.claude/` exists
- Run `init-second-brain` on this repo as a dogfood exercise

**File(s):** `CLAUDE.md`

---

### [LOW] `tools.md` missing `ruff format` from Python tooling

**What is the issue?**
`tools.md` Python section lists `ruff check .` but omits `ruff format --check .`. The check gate as documented is incomplete.

**Why is this an issue?**
Agents following `tools.md` to run the Python quality gate will miss format checking. Format issues get committed and caught by CI instead of locally.

**Consequences of not fixing:**
Minor: formatting failures in CI that could have been caught locally. Inconsistent code style across contributions.

**Possible fixes:**
- Add `ruff format --check .` to the Python section of `tools.md`

**File(s):** `tools.md` → Python section

---

### [LOW] `init-second-brain` `hooks.json` template is a placeholder with no actual purpose

**What is the issue?**
The skill creates `.claude/hooks.json` with `{ "hooks": [] }`. Claude Code doesn't read `hooks.json` from a project directory (it reads `~/.claude/settings.json` globally). OpenClaw uses its own hook system. The file does nothing.

**Why is this an issue?**
It adds clutter to the `.claude/` directory and implies a hook configuration mechanism that doesn't exist.

**Consequences of not fixing:**
Confusion for maintainers who see `hooks.json` and expect it to do something. They may spend time investigating why hook configuration isn't being picked up.

**Possible fixes:**
- Option A: Remove `hooks.json` from the `init-second-brain` template
- Option B: Replace with a `second-brain-hooks.md` symlink or pointer: "See docs/second-brain-hooks.md for platform-specific hook setup"

**File(s):** `skills/init-second-brain.md` → Step 5

---

## ✅ What's Solid

- **Security docs** (`prompt-injection-defense.md`, `llm-classifier-security.md`) — thorough, well-structured, genuinely useful reference implementations
- **`AGENTS.md`** — comprehensive after today's additions; covers security, permissions, git, commits, typing, error handling, design principles
- **`scripts/committer`** — clean, minimal, does exactly what it says; `set -euo pipefail` is correct
- **Slash commands** — well-scoped, each has a clear single responsibility, good `read_when` hints
- **Second brain skills** — tool-agnostic markdown, good structure, clear step-by-step processes
- **`second-brain-hooks.md`** — clean platform matrix, copy-paste ready for each tool

---

## Summary

This is a docs/config repo, so the findings are mostly consistency and correctness issues rather than runtime bugs. The three HIGH items are the most important: the dead slash command reference, the stale code examples that now contradict AGENTS.md rules, and the explicit recommendation to do the thing we just decided not to do. All three actively mislead agents working from this repo.

The MEDIUM items are mostly housekeeping — the tool duplication, missing format validation, and the `$ARGUMENTS` platform gap. The LOW items are polish.

| Severity | Count |
|----------|-------|
| [HIGH]   | 3     |
| [MEDIUM] | 4     |
| [LOW]    | 5     |
| **Total**| **12**|
