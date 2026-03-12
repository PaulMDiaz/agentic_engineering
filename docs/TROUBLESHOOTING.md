---
summary: "Common setup and CI troubleshooting notes for the agentic engineering playbook"
read_when: "A setup step fails, a skill does not appear, or CI/docs checks are failing"
---

# Troubleshooting

## Cursor commands do not appear
- confirm `.claude/commands/*.md` is symlinked into `~/.cursor/commands/`
- restart Cursor if commands were added while it was running

## Codex skills do not appear
- confirm mirrored real folders exist under `~/.codex/skills/<skill>/SKILL.md`
- rerun `~/.codex/scripts/sync-codex-skills.sh`
- restart Codex after syncing

## CI link checks fail
- prefer fixing broken local links/assets over adding ignores
- if a path is intentionally absent, document why before excluding it
