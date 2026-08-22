# Agentic Engineering

A reusable coding and agent-workflow playbook for Cursor, Codex, Claude-style entry
points, and other `AGENTS.md`-aware tools.

## What's included

- `CODING_STANDARDS.md` — portable engineering and workflow rules.
- `AGENTS.md` — repository-local guidance for Agentic Engineering itself.
- `AGENTS.local.md` — shared guidance installed for Cursor, Codex, and Claude Code use.
- `CLAUDE.md` — compatibility shim that redirects to `AGENTS.md`.
- `SECOND_BRAIN.md` — directly copyable portable policy for repository-owned durable
  context.
- `AGENTS.second-brain.snippet.md` — merge-safe project guidance for second-brain adopters.
- `skills/` — reusable implementation, review, documentation, security, CI, and context
  workflows.
- `scripts/install` and `scripts/uninstall` — the complete workstation lifecycle for
  Cursor, Codex, and Claude Code skills and shared guidance.

## Workstation setup

See [Workstation Setup](docs/workstation-setup.md) for installation, synchronization, and
uninstallation instructions.

The recommended personal setup is `scripts/install --with-agents`. The flag enrolls the
clone as the shared-guidance source once; later plain installs and managed Git hooks remember
that choice. Run `scripts/install` without the flag when you want skills only.

Agentic Engineering is a complete independent distribution. Do not install it concurrently
with another playbook that manages the same shared guidance paths or skill names.

## Portable second-brain adoption

`SECOND_BRAIN.md` begins at the versioned `portable-v5` marker and has no dependency on
this repository after adoption. A repository adopting the framework owns and commits:

- `SECOND_BRAIN.md`
- the delimited primary-guidance section in `AGENTS.md`
- `.second_brain/ARCHITECTURE.md`
- `.second_brain/CODE_POINTERS.md`
- `.second_brain/CONVENTIONS.md`
- `.second_brain/DECISIONS.md`
- `.second_brain/DEFERRED.md`

Use `init-second-brain` to initialize or adopt existing committed knowledge. Use
`audit-second-brain` for full source verification, portable-baseline migrations, legacy
deferred-work migration, and confidence-gated conversion of code pointers to stable
symbols.

## Skills

| Skill | Description |
| --- | --- |
| agent-review | Review a branch or PR with validated, deduplicated findings |
| audit-second-brain | Fully verify conventions and migrate portable second-brain policy |
| check-ci | Determine and run local CI-equivalent checks |
| diff-summary | Explain what a diff is trying to accomplish |
| git-recap | Summarize recent work from git history |
| grill-with-docs | Stress-test plans against code, project language, and docs |
| implement | Plan, implement, and verify non-trivial changes |
| init-second-brain | Initialize or adopt committed durable repository context |
| load-second-brain | Load only the repository context needed for a task |
| pr-review-triage | Convert GitHub review feedback into an implementation checklist |
| security-check | Perform an evidence-based security review |
| summarize-transcript | Summarize meeting transcripts, actions, and durable decisions |
| sync-second-brain | Sync `.second_brain/` through a dedicated worktree |
| unslop | Remove AI tells from agent-authored prose |
| update-second-brain | Maintain source-verified durable repository knowledge |

`unslop` is the default for original agent prose. It does not rewrite quotations, code,
commands, schemas, logs, or user-supplied copy unless the user asks.

## Second-brain maintenance

Second-brain upkeep is part of ordinary change-producing work. Convention sections declare
their repository-owned `Sources:` so agents update only guidance affected by a change.
`load-second-brain` performs a lightweight trust check; full audits handle legacy,
contradictory, or older-than-90-day guidance.

Read-only tasks report stale guidance without modifying it. Full audits advance
`last_full_audit` only when every convention section is verified or explicitly normative.
See [Second-Brain Workflow](docs/second-brain-hooks.md) for the complete contract.

## Philosophy

One versioned playbook, installed deliberately where it is the chosen distribution. The
public workstation interface is two scripts: install and uninstall. Cursor and Claude Code
skill sync leave existing destinations untouched. Codex treats a directory with the same
name as an Agentic skill as replaceable; uninstall and stale cleanup remove only mirrors
marked as Agentic-managed.

## License

MIT
