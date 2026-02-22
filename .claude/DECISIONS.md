---
summary: "Why things are the way they are in agentic_engineering"
read_when: "Before proposing a structural change or adding a new doc/skill"
---

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

### review artifacts auto-deleted from main via GitHub Actions

**When:** 2026-02-21
**Why:** Review docs (`*_review.md`) are point-in-time audit artifacts. Having them live in
`main` permanently is noise. The cleanup workflow fires automatically post-merge.
**Trade-off:** Review content only preserved in git history of the review branch.
