---
summary: "Rules specific to contributing to agentic_engineering itself"
read_when: "Before editing, adding, or restructuring anything in this repo"
last_full_audit: 2026-07-18
---
<!-- Format: ## Section headers → rules as prose, short bullet lists, or compact tables when they improve clarity. -->

# Conventions

## This Repo is a Playbook Repo
Sources: `README.md`, `.claude/ARCHITECTURE.md`, `CODING_STANDARDS.md`

Mostly markdown, plus lightweight helper automation (for example workstation sync scripts
and GitHub Actions workflows). `CODING_STANDARDS.md` applies to other projects —
conventions below apply to changes *to this repo itself*.

---

## Doc Format
Sources: `docs/**/*.md`, normative repository policy

Every file under `docs/` must have YAML front-matter:

```yaml
---
summary: "One-line description"
read_when: "When an agent or human should load this doc"
---
```

The front matter supplies concise routing metadata so agents can decide when a document
is relevant without loading its full contents preemptively.

---

## Skill Format
Sources: `skills/*/SKILL.md`, normative repository policy

Skills live in `skills/<name>/SKILL.md` (folder per skill). Use front-matter:

```yaml
---
name: skill-name
description: "What the skill does"
---
```

**Do not use `$ARGUMENTS`** in skill bodies — it's Claude Code-specific.
Use plain English: "If the user provided a path when invoking this skill, use it."

---

## Commits
Sources: `CODING_STANDARDS.md`, `AGENTS.md`

Use explicit `git add` and `git commit -m` commands. Conventional Commits format is
expected. All commit types: `feat fix docs refactor style perf test chore wip remove security`

---

## Adding New Content
Sources: `.claude/ARCHITECTURE.md`, `CODING_STANDARDS.md`, normative repository policy

| Adding... | Goes in... |
| --- | --- |
| A universal coding rule | `CODING_STANDARDS.md` |
| A reference pattern (security, architecture, etc.) | `docs/<topic>.md` with front-matter |
| A reusable agent workflow | `skills/<name>/SKILL.md` |
| A project-level convenience script | `scripts/` |
| A CI automation | `.github/workflows/` |

## Skill Surface Changes
Sources: `scripts/sync-*-skills`, `AGENTS.md`, `README.md`, `docs/workstation-setup.md`, normative repository policy

When adding, renaming, or removing a skill, verify and update every repo surface that
exposes skill inventory or skill-usage guidance, including as needed:

- `AGENTS.md`
- `README.md`
- `docs/workstation-setup.md`
- `.claude/CODE_POINTERS.md`
- `.claude/ARCHITECTURE.md`
- Any setup, sync, uninstall, or example snippets that reference skill names

Prefer inferred directory-based setup snippets over hardcoded skill-name lists where
possible.

---

## What Does NOT Belong Here
Sources: `.claude/DECISIONS.md`, `CODING_STANDARDS.md`, normative repository policy

- OpenClaw-specific config — these go in the OpenClaw workspace AGENTS.md, not here
- Project-specific knowledge (`.claude/` content for other repos)
- Secrets or credentials

## Second-Brain Maintenance
Sources: `AGENTS.md`, `skills/audit-second-brain/SKILL.md`, `skills/load-second-brain/SKILL.md`, `skills/update-second-brain/SKILL.md`, normative repository policy

- Second-brain maintenance is agent-owned during change-producing work; users do not
  need to invoke a maintenance skill explicitly.
- Every top-level conventions section declares authoritative sources. Full audits use
  `last_full_audit` with a 90-day recovery cadence.
- Read-only tasks report stale or legacy guidance without modifying repository files.
- Partial audits do not advance `last_full_audit`.
