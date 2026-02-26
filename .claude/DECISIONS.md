---
summary: "Why things are the way they are in agentic_engineering"
read_when: "Before proposing a structural change or adding a new doc/skill"
---
<!-- Format per entry: ### Title / **When:** YYYY-MM-DD / **Why:** ... / **Trade-off:** ... / optional > ⚠️ Superseded — reason (immediately after the entry, before the next ---). Horizontal rule (---) between entries. -->

# Decisions

### Repo is Claude Code / Cursor only — no OpenClaw files

**When:** 2026-02-21
**Why:** AGENTS.md (OpenClaw identity, stealth mode, workspace paths) doesn't belong in a
public, platform-agnostic playbook. Mixing OpenClaw config would confuse any developer
not running OpenClaw.
**Trade-off:** OpenClaw users maintain their own AGENTS.md separately. Worth it for
true platform-agnosticism.

> ⚠️ Superseded — AGENTS.md added back (2026-02-22) as a global entry point for Codex and other AGENTS.md-aware agents. See decision below.

---

### Repo targets Claude Code, Cursor, and Codex (+ other AGENTS.md-aware agents)

**When:** 2026-02-22
**Why:** `AGENTS.md` is the native entry point for Codex and any agent that follows the
AGENTS.md convention. Adding it makes the playbook usable across all major coding agent
platforms without pulling in any OpenClaw-specific config.
**Trade-off:** OpenClaw users still maintain their own workspace AGENTS.md separately —
that file handles identity, stealth mode, and workspace paths which don't belong in a
public, platform-agnostic repo.

---

### Rules live in CODING_STANDARDS.md, not AGENTS.md

**When:** 2026-02-21
**Why:** AGENTS.md was the original home for everything. Splitting universal coding rules
into a dedicated file makes them portable — any project can `@import` CODING_STANDARDS.md
without pulling in OpenClaw-specific behavior.
**Trade-off:** One more file to maintain. Acceptable — concerns are clearly separated.

---

### committer: hard fail (non-interactive) vs. confirm prompt (interactive)

**When:** 2026-02-21
**Why:** `read` in the Conventional Commits check gets empty string in agent contexts
(no TTY → silent abort). Splitting on `[ -t 0 ]` gives agents a clear, actionable error
while humans keep the forgiving prompt.
**Trade-off:** Agents must format messages correctly on first attempt — the right behavior.

---

### Skills use plain instructions instead of `$ARGUMENTS`

**When:** 2026-02-21
**Why:** `$ARGUMENTS` is Claude Code interpolation syntax — it's a literal string in Cursor
and other environments. Plain instructions work everywhere.
**Trade-off:** Slightly less precise argument passing in Claude Code. Portability wins.

---

### `second-brain-hooks.md` covers Claude Code and Cursor only

**When:** 2026-02-21
**Why:** The OpenClaw section was inferred, not verified against the actual hook schema.
Wrong config silently does nothing — worse than no config at all.
**Trade-off:** OpenClaw users have no hook docs here. They can verify and contribute.

---

### `_validate_llm_output()` returns a new dict (pure function)

**When:** 2026-02-21
**Why:** In-place mutation violates the pure functions rule and makes the function harder
to test. Updated to `dict[str, Any]` return type and explicit key extraction.
**Trade-off:** More verbose. Worth it for correctness and rule consistency.

---

### JSON parse failures in classifiers propagate — no silent fallback

**When:** 2026-02-21
**Why:** Returning zero-valued defaults masks failures entirely. The outer loop handles
skipping bad items. Failures must be visible.
**Note:** Security-clamping (constraining injected enum values) is NOT a fallback — it is
required validation and must be kept.

---

### Second brain: slim down to DECISIONS + CODE_POINTERS as core files

**When:** 2026-02-25
**Why:** After several weeks of running the full second brain ritual (NOTES.md,
ARCHITECTURE.md, DECISIONS.md, CODE_POINTERS.md, CONVENTIONS.md, BACKLOG.md) on a
real project (osint-alert-agent), assessed what actually provides value vs ceremony:

- **DECISIONS.md** — most valuable file. Both human and agent forget *why* choices were
  made. This file prevents re-litigating settled decisions and catches "I was about to
  suggest X but we already rejected it for Y" moments.
- **CODE_POINTERS.md** — high value for agents. Fast lookups without grepping. Low
  maintenance since it only changes when files/functions are added or renamed.
- **NOTES.md** — redundant with git log. Descriptive commit messages are more accurate
  and zero maintenance. Session notes drift from reality and are rarely referenced.
- **ARCHITECTURE.md** — useful as a human onboarding doc but agents verify it against
  code anyway (staleness audit keeps catching drift). If you have to read the code to
  trust the docs, the docs aren't saving you much.
- **The full update ritual** — 5-10 minutes of tokens per session. The staleness audit
  (Pass A + Pass B) catches real drift but the fixes are mechanical, not insightful.

**New approach:** Update organically, not ceremonially.
- DECISIONS.md: update when a decision is made
- CODE_POINTERS.md: update when files/functions change
- ARCHITECTURE.md: update only when system shape changes (new component, new table, new
  data flow) — not every session
- NOTES.md: drop entirely, use git log
- BACKLOG.md: keep, update as items complete or are discovered
- CONVENTIONS.md: keep, update when patterns change
- Stop running the full update-second-brain skill every session

**Trade-off:** Risk of ARCHITECTURE.md going stale between structural changes. Acceptable —
agents can read the actual code, and humans can request an architecture refresh when needed.
Saves significant token cost and session time.

---

### review artifacts auto-deleted from main via GitHub Actions

**When:** 2026-02-21
**Why:** Review docs (`*_review.md`) are point-in-time audit artifacts. Having them live in
`main` permanently is noise. The cleanup workflow fires automatically post-merge.
**Trade-off:** Review content only preserved in git history of the review branch.
