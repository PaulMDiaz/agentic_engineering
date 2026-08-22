---
summary: "Common setup and CI troubleshooting notes for the agentic engineering playbook"
read_when: "A setup step fails, a skill does not appear, or CI/docs checks are failing"
---

# Troubleshooting

## Cursor skills do not appear

- confirm symlinks exist under `~/.cursor/skills/<skill>`
- confirm the development-folder `AGENTS.md` points to
  `agentic_engineering/AGENTS.local.md`, not the repository-local `AGENTS.md`
- rerun `~/Documents/Development/agentic_engineering/scripts/sync-agent-guidance` if it is
  missing
- confirm `agentic_engineering/.git/hooks/post-checkout`, `post-commit`, and `post-merge` exist
- rerun `~/Documents/Development/agentic_engineering/scripts/sync-cursor-skills`
- restart Cursor if the settings UI still looks stale

## Codex skills do not appear

- confirm mirrored real folders exist under `~/.codex/skills/<skill>/SKILL.md`
- confirm `~/.codex/AGENTS.md` points to `agentic_engineering/AGENTS.local.md`
- confirm `agentic_engineering/.git/hooks/post-checkout`, `post-commit`, and `post-merge` exist
- if a hook printed a sync warning, rerun `~/Documents/Development/agentic_engineering/scripts/sync-workstation-skills` manually so the error fails loudly
- rerun `~/Documents/Development/agentic_engineering/scripts/sync-codex-skills`
- restart Codex after syncing

## Claude Code skills do not appear

- confirm symlinks exist under `~/.claude/skills/<skill>`
- confirm `agentic_engineering/.git/hooks/post-checkout`, `post-commit`, and `post-merge` exist
- rerun `~/Documents/Development/agentic_engineering/scripts/sync-claude-skills`
- start a new Claude Code session so it reindexes skills

## Shared guidance is not applied

- run `ls -l ~/Documents/Development/AGENTS.md ~/.codex/AGENTS.md ~/.claude/CLAUDE.md` and
  confirm each is a symlink to `agentic_engineering/AGENTS.local.md`
- a zero-byte file at any destination is claimed on the next sync; a non-empty file is
  preserved, so move it aside if you want the playbook to own that path
- `sync-agent-guidance` prints the destinations it skipped and why — read its stderr
- Claude Code reads `~/.claude/CLAUDE.md`, not `~/.claude/AGENTS.md`
- rerun `~/Documents/Development/agentic_engineering/scripts/sync-agent-guidance`
- start a new agent session so the guidance is reloaded

## CI link checks fail

- prefer fixing broken local links/assets over adding ignores
- if a path is intentionally absent, document why before excluding it
