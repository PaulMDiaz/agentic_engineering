---
summary: "Rules specific to contributing to agentic_engineering itself"
read_when: "Before editing, adding, or restructuring anything in this repo"
---
<!-- Format: ## Section headers → rules as prose, short bullet lists, or compact tables when they improve clarity. -->

# Conventions

## This Repo is a Playbook Repo

Mostly markdown, plus lightweight helper automation (for example workstation sync scripts
and GitHub Actions workflows). `CODING_STANDARDS.md` applies to other projects —
conventions below apply to changes *to this repo itself*.

---

## Doc Format

Every file under `docs/` must have YAML front-matter:

```yaml
---
summary: "One-line description"
read_when: "When an agent or human should load this doc"
---
```

Files without front-matter won't be discoverable by `load-second-brain`.

---

## Skill Format

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

Use explicit `git add` and `git commit -m` commands. Conventional Commits format is
expected. All commit types: `feat fix docs refactor style perf test chore wip remove security`

---

## Adding New Content

| Adding... | Goes in... |
|---|---|
| A universal coding rule | `CODING_STANDARDS.md` |
| A reference pattern (security, architecture, etc.) | `docs/<topic>.md` with front-matter |
| A reusable agent workflow | `skills/<name>/SKILL.md` |
| A project-level convenience script | `scripts/` |
| A CI automation | `.github/workflows/` |

## Skill Surface Changes

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

- OpenClaw-specific config — these go in the OpenClaw workspace AGENTS.md, not here
- Project-specific knowledge (`.claude/` content for other repos)
- Secrets or credentials
