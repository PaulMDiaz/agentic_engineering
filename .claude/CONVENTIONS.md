---
summary: "Rules specific to contributing to agentic_engineering itself"
read_when: "Before editing, adding, or restructuring anything in this repo"
---
<!-- Format: ## Section headers → rules as prose or short bullet lists. No tables. -->

# Conventions

## This Repo is a Docs Repo

No code, no dependencies, no build system. All content is markdown.
`CODING_STANDARDS.md` applies to other projects — conventions below apply
to changes *to this repo itself*.

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

## Slash Command Format

Files under `.claude/commands/` are the actual invokable slash commands:
- Plain markdown — no front-matter (Claude Code uses the filename as the command name)
- Must have a `# /command-name` heading and a `## Process` section with numbered steps
- Must be listed in `docs/slash-commands/README.md` (the index)

---

## Commits

Use `scripts/committer` for all commits. Conventional Commits format is enforced.
All commit types: `feat fix docs refactor style perf test chore wip remove security`

---

## Adding New Content

| Adding... | Goes in... |
|---|---|
| A universal coding rule | `CODING_STANDARDS.md` |
| A reference pattern (security, architecture, etc.) | `docs/<topic>.md` with front-matter |
| A reusable agent workflow | `skills/<name>/SKILL.md` |
| A slash command | `.claude/commands/<name>.md` + update `docs/slash-commands/README.md` |
| A project-level convenience script | `scripts/` |
| A CI automation | `.github/workflows/` |

---

## What Does NOT Belong Here

- OpenClaw-specific config — these go in the OpenClaw workspace AGENTS.md, not here
- Project-specific knowledge (`.claude/` content for other repos)
- Secrets or credentials
