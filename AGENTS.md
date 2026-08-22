# AGENTS.md

This file is repository-local guidance for agents working on Agentic Engineering. Do not
install it as development-wide or home-level guidance. The installable shared source is
`AGENTS.local.md`.

<!-- second-brain-guidance: portable-v1 -->
## Second Brain — Primary Repository Guidance

For repository context, conventions, architecture, decisions, code pointers, and
durable-maintenance workflow, this section and `SECOND_BRAIN.md` are the primary repository
guidance. Other `AGENTS.md` content remains authoritative for unrelated repository rules.

Before non-trivial work, or read-only work needing repository context beyond the prompt and
a named file or symbol, read and follow `SECOND_BRAIN.md`. Load only the relevant
`.second_brain/` files it selects, and reuse context that remains current.

Before completing change-producing work, assess whether decisions, architecture,
conventions, code pointers, deferred work, or declared convention sources changed. Update
the relevant durable knowledge when it did; otherwise state that no durable update was
needed.

When source code, configuration, or an explicit user request disproves a second-brain
claim, do not act on the stale claim. Verify the source, correct durable knowledge when
permitted, then continue using the corrected guidance.
<!-- /second-brain-guidance -->

Read and follow `CODING_STANDARDS.md` before doing any work in this repository. Treat it as
mandatory startup context for all tasks.

## Rules

- Use skills when appropriate.
- Apply `unslop` to every agent-authored response and document. Preserve quotations, code
  blocks, commands, schemas, logs, and user-supplied copy unless the user asks to edit them.
- Keep repo guidance and second-brain files up to date when workflow or conventions change.
- Before ending meaningful work, update the second brain when durable project knowledge changed; otherwise note that no update was needed.

## Skills

| Skill | When to use |
| --- | --- |
| agent-review | Reviewing a PR or branch |
| audit-second-brain | Fully verifying or migrating second-brain conventions |
| check-ci | Verifying local CI-equivalent checks for changed files or the full repo |
| diff-summary | Understanding what a diff does |
| git-recap | Summarizing recent work |
| grill-with-docs | Stress-testing a plan against code, project language, and docs |
| implement | Implementing a planned change |
| init-second-brain | Initializing or adopting committed second-brain files and entry points |
| load-second-brain | Loading repo context before work |
| pr-review-triage | Triaging GitHub PR review feedback into a checklist before implementation |
| security-check | Reviewing security-sensitive changes or posture |
| summarize-transcript | Turning meeting transcripts into concise summaries and action items |
| sync-second-brain | Syncing `.second_brain/` through a dedicated `second-brain` worktree |
| unslop | Removing AI tells from agent-authored prose |
| update-second-brain | Maintaining durable project knowledge organically during change-producing work |

## Quick Reference

```bash
# Commit explicit files
git add file1 file2
git commit -m "feat(scope): ✨ description"
```

## Repository Structure

- `CODING_STANDARDS.md` — universal coding/workflow rules
- `AGENTS.md` — canonical agent instruction file for this repo
- `AGENTS.local.md` — shared-guidance source for Cursor, Codex, and Claude Code
- `CLAUDE.md` — shim that redirects Claude to `AGENTS.md`
- `skills/` — reusable repo-specific agent skills
- `scripts/install` and `scripts/uninstall` — complete workstation installation lifecycle
- `docs/` — repo documentation
- `SECOND_BRAIN.md` — portable repository-owned second-brain policy
- `.second_brain/` — durable repository context files

## Session End

Before ending meaningful work:

- run or follow `update-second-brain` when durable project knowledge or a declared
  convention source changed
- leave instructions/docs in a consistent state
- do not leave stale workflow guidance behind
