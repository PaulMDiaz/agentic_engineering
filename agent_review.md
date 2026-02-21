# Agent Code Review — agentic_engineering

Reviewed by: Phobos (Claude Sonnet 4.6)
Date: 2026-02-21
Branch: main (post-PR #1 merge) — full repo audit

---

## Context

This is the second review cycle. PR #1 resolved 8 findings from the initial review.
This pass reviews the repo as it stands on main after that merge.

---

## Findings (ordered by severity)

---

### [HIGH] `CLAUDE.md` Structure table references deleted `AGENTS.md`

**What is the issue?**
`CLAUDE.md` → Structure section contains:
```
| `AGENTS.md` | OpenClaw-specific overrides (identity, stealth mode, workspace paths) |
```
`AGENTS.md` was deleted in the PR #1 refactor. The file does not exist.

**Why is this an issue?**
`CLAUDE.md` is the first file Claude Code and Cursor load. Any agent reading the structure
table will think `AGENTS.md` exists, look for it, and either get confused or waste context.

**Consequences of not fixing:**
Every agent session starts with stale information in the entry point — the most-read file
in the repo.

**Possible fixes:**
- Remove the `AGENTS.md` row from the structure table

**File(s):** `CLAUDE.md` → Structure section

---

### [MEDIUM] `trash > rm` and `rm -i` rules don't cross-reference — agents will use the wrong one

**What is the issue?**
Two rules address file deletion:
1. `CODING_STANDARDS.md` → Security: *"`trash` > `rm`. Recoverable beats gone forever."*
2. `CODING_STANDARDS.md` → Language / Stack (Shell): *"Use `-i` flag for destructive file ops — `rm -i`..."*

They don't contradict each other, but they don't reference each other either. An agent
or developer reading only the Shell section will use `rm -i` — which permanently deletes
files with a prompt — when `trash` was the intended guidance.

**Why is this an issue?**
The Shell section is where agents look for shell scripting rules. It's the natural place
to check when writing a script with `rm`. Without a cross-reference, `trash` is invisible
to anyone reading that section.

**Consequences of not fixing:**
Agents write shell scripts using `rm -i` instead of `trash`, creating permanent deletions
where recoverable ones were possible.

**Possible fixes:**
- Add a note to the Shell `-i` rule: "Prefer `trash` over `rm` when available — see Security section."

**File(s):** `CODING_STANDARDS.md` → Language / Stack (Shell)

---

### [MEDIUM] Slash command index lists skills as commands — no backing command files

**What is the issue?**
`docs/slash-commands/README.md` lists three entries that are not slash commands:
```
| `/init-second-brain`  | Bootstrap `.claude/` knowledge base for a project |
| `/load-second-brain`  | Load full project context at session start         |
| `/update-second-brain`| Record what was worked on this session             |
```
These are skills in `skills/` — not files in `docs/slash-commands/` or `.claude/commands/`.
No corresponding command files exist.

**Why is this an issue?**
An agent following the slash command index will attempt to invoke `/init-second-brain` as
a slash command and find no command file. Cursor picks up slash commands from `.claude/commands/`
automatically; Claude Code runs them from `.claude/commands/` or `docs/slash-commands/`. Neither
finds anything for these three.

**Consequences of not fixing:**
Three of the eight indexed commands are non-functional as slash commands. The index
can't be fully trusted.

**Possible fixes:**
- Option A: Add thin command files in `.claude/commands/` that instruct the agent to
  read the corresponding skill file (e.g. "Read `skills/init-second-brain.md` and follow it.")
- Option B: Add a note in the README index clarifying these are invoked as skills,
  not slash commands: "Invoke by asking the agent to run the skill directly."

**File(s):** `docs/slash-commands/README.md`

---

### [LOW] `run date` tip stranded in Typing section

**What is the issue?**
`CODING_STANDARDS.md` → Typing section ends with:
> "`run date` when you need the current date — never hardcode or guess."

This is a useful agent tip but has nothing to do with typing. It appears after the
typing rules with no logical connection.

**Why is this an issue?**
Agents scanning the Typing section for type rules will find an unrelated instruction.
Agents scanning for "how to get the current date" won't think to look in Typing.

**Possible fixes:**
- Move to Planning section (before non-trivial changes) or add a brief "Agent Tips" section
  at the end of the file.

**File(s):** `CODING_STANDARDS.md` → Typing

---

### [LOW] `docs/second-brain-hooks.md` references `.cursorrules` — may be outdated

**What is the issue?**
The Cursor section of `second-brain-hooks.md` instructs adding a reminder to `.cursorrules`:
```
# Second Brain
At the end of any substantial work session, always run /update-second-brain
```
Cursor has been moving toward `.cursor/rules/` as the primary rules location.
`.cursorrules` still works but is considered legacy in current Cursor versions.

**Why is this an issue?**
Developers following this doc may set up the reminder in the wrong file and see no effect.

**Possible fixes:**
- Verify current Cursor convention and update to `.cursor/rules/` if applicable,
  or note both with a preference: "Prefer `.cursor/rules/` in current Cursor; `.cursorrules` still works."

**File(s):** `docs/second-brain-hooks.md` → Cursor section

---

### [LOW] `cleanup-review-artifacts.yml` triggers on `reviews/**` — unestablished pattern

**What is the issue?**
The cleanup workflow triggers on:
```yaml
paths:
  - 'agent_review.md'
  - '*_review.md'
  - 'reviews/**'
```
`reviews/**` implies a `reviews/` directory convention, but no such convention is
documented anywhere in the repo. The trigger path is dead — it will never fire.

**Why is this an issue?**
Dead trigger paths add noise and may mislead future contributors into thinking a
`reviews/` directory pattern exists.

**Possible fixes:**
- Remove `reviews/**` from the paths trigger, or document the `reviews/` convention
  if it's intended.

**File(s):** `.github/workflows/cleanup-review-artifacts.yml`

---

## Resolved Since Initial Review

All 8 findings from the first cycle were fixed in PR #1:
- ~~[HIGH] `/context-prime` dead reference~~ — removed, second brain skills added
- ~~[HIGH] Security docs teach wrong patterns~~ — pure functions, typed, no in-place mutation
- ~~[HIGH] Silent fallback recommendation in classifier doc~~ — replaced with propagate + note
- ~~[MEDIUM] `AGENTS.md` Tools section duplication~~ — AGENTS.md deleted entirely
- ~~[MEDIUM] `$ARGUMENTS` Claude Code-specific~~ — replaced with plain instructions
- ~~[MEDIUM] OpenClaw config snippet unverified~~ — OpenClaw section removed
- ~~[LOW] No `.gitignore`~~ — added
- ~~[LOW] `tools.md` missing `ruff format`~~ — added

---

## Summary

The repo is in significantly better shape than the initial review. The CODING_STANDARDS.md
refactor was the right call — clean, portable, no platform coupling. The security docs are
now consistent with the rules they're supposed to teach.

**6 new findings** — 1 HIGH, 2 MEDIUM, 3 LOW. None are blockers. The HIGH finding
(`CLAUDE.md` stale `AGENTS.md` row) is a quick one-line fix. The two MEDIUMs are
worth addressing before this repo gets widely used as a reference.

**Merge readiness:** Main is clean. These findings should be addressed in a follow-up
PR before pointing other projects at this as their canonical standards source.

---

## Init-Second-Brain Skill Assessment

This review cycle also ran `init-second-brain` on this repo. Observations:

**Worked well:**
- The skill produced accurate, scannable files — ARCHITECTURE, DECISIONS, CODE_POINTERS all
  reflect the actual repo state without fabrication
- The bare-bones-first guideline held — files are useful without being over-populated
- BACKLOG.md correctly captured open items including findings from this very review

**One friction point:**
- The skill currently has no `.claude/commands/` step — it creates `commands/` but leaves
  it empty. For this repo specifically, the second brain slash commands issue (MEDIUM finding
  above) means the commands directory remains empty. A future version of the skill could
  scaffold thin command files for init/load/update automatically.
