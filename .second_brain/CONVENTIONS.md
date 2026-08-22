---
last_full_audit: 2026-08-22
---

# Conventions

## Repository purpose
Sources: `README.md`, `.second_brain/ARCHITECTURE.md`, `CODING_STANDARDS.md`

- Agentic Engineering is a reusable coding and agent-workflow playbook.
- It remains independently installable and documents ownership behavior for each
  installation surface, including the authoritative same-name Codex skill policy.
- Do not add a runtime dependency on another playbook repository.

## Documentation
Sources: `AGENTS.md`, `AGENTS.local.md`, `CLAUDE.md`, `SECOND_BRAIN.md`, `README.md`, `docs/*.md`, normative repository policy

- `AGENTS.md` is repository-local, `AGENTS.local.md` is the portable shared-guidance
  template rendered by the installer, and `CLAUDE.md` is a compatibility shim to
  repository-local guidance.
- Files under `docs/` use `summary` and `read_when` YAML front matter.
- The marked `SECOND_BRAIN.md` portable baseline remains self-contained and
  repository-relative.
- Keep repository-specific durable knowledge in `.second_brain/`, not inside the marked
  portable baseline.

## Skill layout and inventory
Sources: `skills/*/SKILL.md`, `README.md`, `AGENTS.md`, `AGENTS.local.md`, `scripts/install`, normative repository policy

- Skills live in `skills/<name>/SKILL.md`; supporting files stay in the same skill folder.
- Skill front matter uses a name that matches the containing directory.
- Portable skill instructions do not rely on tool-specific argument interpolation.
- `README.md`, `AGENTS.md`, and `AGENTS.local.md` list every public skill.
- `unslop` applies to every agent-authored response and document while preserving exact
  quotations, code, commands, schemas, logs, and user-supplied copy.

## Workstation synchronization
Sources: `scripts/install`, `scripts/uninstall`, `docs/workstation-setup.md`, `tests/install.bash`, `tests/uninstall.bash`, `tests/skills.bash`

- Cursor and Claude Code use symlinks into this repository's `skills/` directory.
- Codex uses real directory mirrors marked with `.agentic-engineering-skill-source`.
- `scripts/install` and `scripts/uninstall` are the only public workstation scripts.
- Cursor and Claude Code synchronization leaves existing destinations untouched.
- Codex synchronization treats same-name skill directories as replaceable, including
  unmarked directories. Codex uninstall and stale cleanup remove only mirrors marked as
  Agentic-managed.
- Every sync surface no-ops when its agent home directory is absent.
- The installer renders `AGENTS.local.md` with its resolved checkout root into managed
  guidance files for Cursor, Codex, and Claude Code; root `AGENTS.md` remains
  repository-local.
- Shared guidance requires one explicit `scripts/install --with-agents` enrollment. The
  clone records that choice in local Git configuration, and later plain installs honor it.
- Guidance destinations are Cursor's development-folder `AGENTS.md`, `~/.codex/AGENTS.md`,
  and `~/.claude/CLAUDE.md`. Claude Code reads user-level `CLAUDE.md`, not `AGENTS.md`.
- The development folder is derived from the clone's parent directory, never a hardcoded
  path, and is skipped when it is the account home.
- Guidance sync migrates only legacy links this repository owns, claims empty placeholder
  files, and preserves user-owned regular files and foreign links.
- Managed guidance files are regenerated in full on every install, so edits made at a
  destination are lost. Overwriting a destination with content that omits the ownership
  marker returns it to the user and leaves other surfaces managed.
- Guidance enrollment is recorded per clone, so a new clone repeats the opt-in.
- Managed repository Git hooks rerun `scripts/install` after checkout, merge, and commit.
- Do not document concurrent installation with another distribution that manages the same
  destination names.

## Shell and tests
Sources: `CODING_STANDARDS.md`, `scripts/*`, `tests/run`, `tests/*.bash`, `tests/helpers/*.sh`

- Shell entry points use `set -euo pipefail`.
- Tests use the zero-dependency runner in `tests/run` and isolated temporary directories.
- Update regression tests whenever synchronization, uninstall, template migration, or
  validation behavior changes.
- Run shell syntax checks and the full test runner before handoff.

## Continuous integration
Sources: `.github/workflows/ci.yml`

- CI runs for pushes and pull requests targeting `main` or `dev`, and supports manual
  dispatch.
- Checkout actions use an immutable reviewed commit and do not persist credentials.
- CI runs shell tests, Markdown lint, link checking, and duplicate detection.

## Second-brain maintenance
Sources: `AGENTS.md`, `CODING_STANDARDS.md`, `SECOND_BRAIN.md`, `docs/second-brain-hooks.md`, `skills/audit-second-brain/SKILL.md`, `skills/init-second-brain/SKILL.md`, `skills/load-second-brain/SKILL.md`, `skills/update-second-brain/SKILL.md`, normative repository policy

- Second-brain maintenance is agent-owned during change-producing work.
- Load only missing relevant context and reuse context that remains current in the task.
- Every top-level convention section declares repository-owned sources.
- Full audits use `last_full_audit` as a 90-day recovery backstop; partial audits do not
  advance it.
- Prefer `path::symbol` for stable code entry points and use line-based fallbacks only when
  no stable symbol exists.
- Change-producing audits migrate verified legacy pointers, core-file presentation, root
  portable guidance, and legacy `BACKLOG.md` content without discarding repository-owned
  knowledge.
- Read-only work reports audit debt without modifying repository files.

## Excluded content
Sources: `README.md`, `AGENTS.md`, `skills/*/SKILL.md`, normative repository policy

- Do not add organization-specific systems, credentials, external work-tracking workflows,
  or private workstation assumptions to this repository.
- Do not persist inherited, global, shared, or user-local guidance as repository knowledge.
