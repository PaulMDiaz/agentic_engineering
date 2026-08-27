---
summary: "Common setup and CI troubleshooting notes for the agentic engineering playbook"
read_when: "A setup step fails, a skill does not appear, or CI/docs checks are failing"
---

# Troubleshooting

## Cursor skills do not appear

- confirm symlinks exist under `~/.cursor/skills/<skill>`
- confirm the development-folder `AGENTS.md` is a rendered file whose first line names this
  `agentic_engineering` checkout, not a link to the repository-local `AGENTS.md`
- confirm `agentic_engineering/.git/hooks/post-checkout`, `post-commit`, and `post-merge` exist
- rerun `<clone>/scripts/install`
- restart Cursor if the settings UI still looks stale

## Codex skills do not appear

- confirm mirrored real folders exist under `~/.codex/skills/<skill>/SKILL.md`
- confirm `~/.codex/AGENTS.md` is a rendered file whose first line names this
  `agentic_engineering` checkout
- confirm `agentic_engineering/.git/hooks/post-checkout`, `post-commit`, and `post-merge` exist
- if a hook printed a sync warning, rerun `<clone>/scripts/install` so the error fails loudly
- restart Codex after syncing

## Claude Code skills do not appear

- confirm symlinks exist under `~/.claude/skills/<skill>`
- confirm `agentic_engineering/.git/hooks/post-checkout`, `post-commit`, and `post-merge` exist
- rerun `<clone>/scripts/install`
- start a new Claude Code session so it reindexes skills

## Shared guidance is not applied

- inspect `~/Documents/Development/AGENTS.md`, `~/.codex/AGENTS.md`, and
  `~/.claude/CLAUDE.md`; each should be a regular file whose first line names this clone and
  whose standards path points into this checkout
- a zero-byte file at any destination is claimed on the next sync; a non-empty user file is
  preserved, so move it aside if you want the playbook to own that path
- `scripts/install` prints the destinations it skipped and why; read its stderr
- Claude Code reads `~/.claude/CLAUDE.md`, not `~/.claude/AGENTS.md`
- run `<clone>/scripts/install --with-agents` once if this clone has not been enrolled for
  guidance sync
- if the first-line ownership marker names an obsolete checkout, rerun
  `<clone>/scripts/install --with-agents` from the checkout that should own the installation
- rerun `<clone>/scripts/install`
- start a new agent session so the guidance is reloaded

## Edits to global guidance keep disappearing

- managed guidance files are regenerated on every install, including hook-driven runs, so
  edits made directly to `~/.claude/CLAUDE.md`, `~/.codex/AGENTS.md`, or the
  development-folder `AGENTS.md` are overwritten
- confirm the file is managed by checking its first line for
  `<!-- agentic-engineering-guidance-source: ... -->`
- make the change in the clone's `AGENTS.local.md` so every surface receives it
- to own one destination yourself, overwrite that file with content that does not carry the
  marker line; the installer then preserves it and keeps managing the other surfaces

## CI link checks fail

- prefer fixing broken local links/assets over adding ignores
- if a path is intentionally absent, document why before excluding it
