# Code Pointers

## Guidance and templates

| What | Where |
| --- | --- |
| Canonical repository guidance | `AGENTS.md` |
| Installable shared guidance | `AGENTS.local.md` |
| Claude compatibility entry point | `CLAUDE.md` |
| Universal engineering rules | `CODING_STANDARDS.md` |
| Portable second-brain baseline | `SECOND_BRAIN.md` |
| Portable project-guidance integration | `AGENTS.second-brain.snippet.md` |
| Repository conventions | `.second_brain/CONVENTIONS.md` |

## Second-brain workflows

| What | Where |
| --- | --- |
| Initialize or adopt committed knowledge | `skills/init-second-brain/SKILL.md` |
| Full audit, migration, and stable-pointer conversion | `skills/audit-second-brain/SKILL.md` |
| Portable-template validator | `skills/audit-second-brain/scripts/validate_portable_template.sh` |
| Selective context loading | `skills/load-second-brain/SKILL.md` |
| Source-aware scoped maintenance | `skills/update-second-brain/SKILL.md` |
| Dedicated-branch synchronization | `skills/sync-second-brain/SKILL.md` |

## Workstation integration

| What | Where |
| --- | --- |
| Install managed Git hooks | `scripts/install-skill-hooks::install_hook` |
| Remove managed Git hooks | `scripts/install-skill-hooks::uninstall_hook` |
| Remove Agentic-managed Cursor links | `scripts/sync-cursor-skills::remove_repo_managed_symlinks` |
| Remove Agentic-managed Codex mirrors | `scripts/sync-codex-skills::remove_repo_managed_skills` |
| Run both synchronization paths | `scripts/sync-workstation-skills` |
| Workstation procedure | `docs/workstation-setup.md` |
| Setup and synchronization diagnosis | `docs/TROUBLESHOOTING.md` |

## Verification

| What | Where |
| --- | --- |
| Test entry point | `tests/run` |
| Skill and durable-context contracts | `tests/skills.bash` |
| Portable-template migration and validation | `tests/second_brain_template.bash` |
| Shell assertion helpers | `tests/helpers/assert.sh` |
| GitHub Actions gate | `.github/workflows/ci.yml` |
