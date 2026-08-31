# AGENTS.md

<!-- Rendered by scripts/install; do not link this template directly. -->

Read and follow `{{AGENTIC_ENGINEERING_ROOT}}/CODING_STANDARDS.md` before
doing any work. Treat it as mandatory startup context for all tasks.

## Rules

- Follow repository-local `AGENTS.md` files in addition to these shared rules.
- Use skills when appropriate.
- Apply `unslop` to every agent-authored response and document. Preserve quotations, code
  blocks, commands, schemas, logs, and user-supplied copy unless the user asks to edit them.
- When a repository-local `AGENTS.md` contains `Second Brain — Primary Repository Guidance`,
  follow that section for repository context and durable-knowledge maintenance. If the
  repository has `SECOND_BRAIN.md` without that section, follow its root policy directly.

## Project-local second brain

Repository-local second-brain guidance is self-contained so agents continue to maintain
durable knowledge when Agentic Engineering is unavailable. Keep this shared guidance as a
pointer rather than duplicating its loading and maintenance rules.

## Skills

| Skill | When to use |
| --- | --- |
| agent-review | Reviewing a PR or branch |
| audit-second-brain | Fully verifying or migrating second-brain conventions when trust is due |
| check-ci | Verifying local CI-equivalent checks for changed files or the full repo |
| diff-summary | Understanding what a diff does |
| git-recap | Summarizing recent work |
| grill-with-docs | Stress-testing a plan against code, project language, and docs |
| implement | Implementing a planned change |
| init-second-brain | Initializing or adopting committed second-brain files and entry points |
| load-second-brain | Loading repository context before work |
| pr-review-triage | Triaging GitHub PR review feedback into a checklist before implementation |
| security-check | Reviewing security-sensitive changes or posture |
| summarize-transcript | Turning meeting transcripts into concise summaries and action items |
| sync-second-brain | Syncing `.second_brain/` through a dedicated `second-brain` worktree |
| unslop | Removing AI tells from every agent-authored response and document |
| update-second-brain | Recording important repository changes and decisions after work |

## Quick reference

```bash
# Commit explicit files
git add file1 file2
git commit -m "feat(scope): ✨ description"
```

## Shared source

- `{{AGENTIC_ENGINEERING_ROOT}}/CODING_STANDARDS.md` — engineering and workflow rules
- `{{AGENTIC_ENGINEERING_ROOT}}/skills/` — reusable agent skills
- `{{AGENTIC_ENGINEERING_ROOT}}/docs/` — setup and operational guidance
- `{{AGENTIC_ENGINEERING_ROOT}}/tools.md` — workstation tool reference

## Session end

Before ending meaningful work:

- leave instructions and docs consistent with the implementation
- do not leave stale workflow guidance behind
