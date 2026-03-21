---
summary: "Why things are the way they are in agentic_engineering"
read_when: "Before proposing a structural change or adding a new doc/skill"
---
<!-- Format per entry: ### Title / **When:** YYYY-MM-DD / **Why:** ... / **Trade-off:** ... / optional > ⚠️ Superseded — reason (immediately after the entry, before the next ---). Horizontal rule (---) between entries. -->

# Decisions

### Codex sync is authoritative for repo-owned skill names

**When:** 2026-03-21
**Why:** The Codex mirror exists to keep this repo's `skills/` tree reflected in
`~/.codex/skills`, so a destination folder with the same skill name should converge to the
repo version instead of preserving divergent local contents. Existing sync behavior and
tests already refresh same-name folders to the repo copy.
**Trade-off:** Users cannot keep a different custom Codex skill under the same name as a
repo-managed skill. Custom skills need distinct names if they should survive sync.

---

### Codex mirror uninstall is owned by `sync-codex-skills`

**When:** 2026-03-21
**Why:** Codex skills are mirrored as real directories, so shelling out to ad hoc `rm`
commands in docs is both error-prone and unable to distinguish repo-managed mirrors from
user-owned custom skills. Reusing `scripts/sync-codex-skills` for uninstall keeps the
ownership logic and marker checks in one place.
**Trade-off:** The script now has two modes instead of one. That extra branch is worth it
to give setup and uninstall a single source of truth.

---

### Workstation scripts use a zero-dependency shell regression harness

**When:** 2026-03-21
**Why:** The repo's executable surface is almost entirely bash scripts, so the fastest
reliable test coverage is a small shell harness that runs in temp directories without
pulling in external frameworks. That keeps CI simple, avoids dependency health questions,
and directly exercises the documented workstation flows.
**Trade-off:** The harness is more minimal than a dedicated shell test framework, so it
provides fewer built-in matchers and reporting features. The reduced setup burden is worth
it for this repo's size and script-focused scope.

---

### Playbook repo git hooks drive workstation skill sync

**When:** 2026-03-21
**Why:** The source of truth for repo-local skills is the `agentic_engineering/skills`
directory, so the most reliable place to trigger workstation sync is from git events in
that repo itself. `post-checkout`, `post-merge`, and `post-commit` hooks run in the same
repo context that already has access to the skill source tree, which avoids the launchd
access and environment issues encountered when background jobs tried to read
`~/Documents/Development/agentic_engineering/skills` directly.
**Trade-off:** Sync now depends on this repo's git lifecycle rather than an OS-level file
watcher. That is acceptable because new skills only matter when this repo changes, and
manual fallback remains available via `scripts/sync-workstation-skills`.

---

### Cursor sync only creates missing symlinks

**When:** 2026-03-21
**Why:** Existing Cursor skill symlinks already reflect source-file edits automatically.
The sync job only needs to create links for newly added skill folders. Keeping the sync
narrow avoids unnecessary rewrites and matches the actual problem we need to solve.
**Trade-off:** If an existing Cursor symlink becomes stale or mispointed, it is not
auto-repaired by routine sync passes. Manual rerun or recreation is still straightforward.

---

### Codex cleanup only removes repo-managed mirrored skills

**When:** 2026-03-21
**Why:** The Codex mirror needs to converge when a repo-local skill is renamed or removed,
but `~/.codex/skills` may also contain `.system` or user-created skills that do not
belong to this repo. Tagging mirrored folders with a repo-managed marker lets sync clean
up stale mirrors without deleting unrelated Codex-specific skills.
**Trade-off:** The mirror carries a small hidden marker file in each repo-managed skill
folder. That extra bookkeeping is worth it to preserve user-owned Codex skills safely.

---

### Second-brain sync uses a dedicated `second-brain` worktree

**When:** 2026-03-21
**Why:** Syncing `.claude/` through a separate worktree keeps second-brain commits off
feature branches and makes the lifecycle explicit: copy, review, commit, push, remove,
return. The documented workflow avoids `rsync --delete` so deletions stay manual and
reviewable instead of being applied blindly.
**Trade-off:** Slightly more manual than a one-command mirror. Worth it for safer deletes
and cleaner branch hygiene across repos.

---

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

**New approach:** Scoped verification replaces full audit.
- DECISIONS.md + CODE_POINTERS.md = core files, always maintained
- NOTES.md: dropped — git log is the source of truth (`git-recap` skill for summaries)
- ARCHITECTURE.md: kept but only updated on structural changes, not every session
- BACKLOG.md + CONVENTIONS.md: kept, updated as needed
- update-second-brain still runs at end of session — but instead of Pass A/B full audit,
  it scopes verification to entries referencing files touched this session (`git diff --name-only`)
- This catches the most likely drift (things break where you just worked) at a fraction
  of the cost of verifying everything

**Trade-off:** Entries for untouched files won't be verified — could drift over time.
Acceptable because: (1) untouched files are unlikely to have changed, (2) they'll get
verified when someone eventually touches them, (3) full audits can be requested explicitly.
Significant token savings while keeping the knowledge base trustworthy for all agents
(Cursor, Codex, fresh Claude Code sessions) that rely on it without conversation history.

---

### Skills use folder-per-skill format (`skills/name/SKILL.md`)

**When:** 2026-02-26
**Why:** Cursor discovers skills from folders containing `SKILL.md`, not flat `.md` files.
The old flat format (`skills/agent-review.md`) worked for Claude Code but was invisible
to Cursor's skill discovery. Folder format works for both.
**Trade-off:** Slightly deeper nesting. Worth it — Cursor is the primary platform.

> Supersedes the implicit flat-file convention from initial setup.

---

### Parent-directory AGENTS.md replaces per-repo templates

**When:** 2026-02-26
**Why:** Cursor reads `AGENTS.md` from parent directories. Symlinking one `AGENTS.md` to
the development folder root (`~/Documents/Development/AGENTS.md`) applies coding standards
to every project underneath — no per-repo setup needed.
**Trade-off:** Removed `docs/templates/AGENTS-project.md`. Projects that aren't under the
development folder won't pick up the rules automatically (they can still reference
CODING_STANDARDS.md directly).

---

### AGENTS.md references CODING_STANDARDS.md without duplicating rules

**When:** 2026-02-26
**Why:** Earlier version inlined key rules (pure functions, no defaults, etc.) which would
go stale if CODING_STANDARDS.md evolves. Single source of truth is better.
**Trade-off:** Agent must read two files instead of one. Minimal cost.

---

### review artifacts auto-deleted from main via GitHub Actions

**When:** 2026-02-21
**Why:** Review docs (`*_review.md`) are point-in-time audit artifacts. Having them live in
`main` permanently is noise. The cleanup workflow fires automatically post-merge.
**Trade-off:** Review content only preserved in git history of the review branch.
