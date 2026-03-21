---
summary: "Common setup and CI troubleshooting notes for the agentic engineering playbook"
read_when: "A setup step fails, a skill does not appear, or CI/docs checks are failing"
---

# Troubleshooting

## Cursor commands do not appear
- confirm `.claude/commands/*.md` is symlinked into `~/.cursor/commands/`
- restart Cursor if commands were added while it was running

## Cursor skills do not appear
- confirm symlinks exist under `~/.cursor/skills/<skill>`
- confirm `agentic_engineering/.git/hooks/post-checkout`, `post-commit`, and `post-merge` exist
- rerun `~/Documents/Development/agentic_engineering/scripts/sync-cursor-skills`
- restart Cursor if the settings UI still looks stale

## Codex skills do not appear
- confirm mirrored real folders exist under `~/.codex/skills/<skill>/SKILL.md`
- confirm `agentic_engineering/.git/hooks/post-checkout`, `post-commit`, and `post-merge` exist
- if a hook printed a sync warning, rerun `~/Documents/Development/agentic_engineering/scripts/sync-workstation-skills` manually so the error fails loudly
- rerun `~/Documents/Development/agentic_engineering/scripts/sync-codex-skills`
- restart Codex after syncing

## CI link checks fail
- prefer fixing broken local links/assets over adding ignores
- if a path is intentionally absent, document why before excluding it
