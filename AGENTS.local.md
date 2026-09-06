# AGENTS.md

<!-- Rendered by scripts/install; do not link this template directly. -->

Read and follow `{{AGENTIC_ENGINEERING_ROOT}}/CODING_STANDARDS.md` before
doing any work. Treat it as mandatory startup context for all tasks.

## Rules

- Follow repository-local `AGENTS.md` files in addition to these shared rules.
- Use skills when appropriate.
- Follow explicit user instructions over skill guidance within higher-priority system and tool
  constraints. If a skill blocks authorized work, requires extra approval, or causes a material
  departure from requested work, name and link its exact `SKILL.md` and quote the relevant
  clause; deliberate interview questions are part of that work and need no such explanation.
  Keep routine reconciliation silent.
- Apply `unslop` to every agent-authored response and document. Preserve quotations, code
  blocks, commands, schemas, logs, and user-supplied copy unless the user asks to edit them.
- When a repository-local `AGENTS.md` contains `Second Brain — Primary Repository Guidance`,
  follow that section for repository context and durable-knowledge maintenance. If the
  repository has `SECOND_BRAIN.md` without that section, follow its root policy directly.

## Personal workflow

- Route substantive implementation through `implement` automatically. Choose direct execution
  or delegation according to the task. Delegate when a bounded assignment provides useful
  independent progress or saves enough parent context to justify the handoff. Keep tightly
  coupled operational work with one executor; sequential work alone is not a reason to delegate.
- Keep delegated reports concise: conclusions, evidence pointers, uncertainties, and validation
  results. Reuse verified findings instead of repeating the worker's investigation. Delegation
  reduces parent context, not necessarily total token use.
- Prefer GPT-5.6 Luna with Medium reasoning for bounded implementation and investigation.
  Increase effort when uncertainty or failed attempts justify it. Respect session model choices;
  if the preferred model is unavailable, disclose a suitable fallback within existing
  authorization. Ask only when a user constraint prevents it. Select reviewers for the task.
- Include the task, model, and effort in subagent names where supported, or disclose them before
  launch. Distinguish requested settings from runtime-confirmed settings; mark unavailable
  metadata `unknown`. Report changes when continuing an agent. These labels do not measure cost.
- Keep reusable skills model- and harness-neutral.
- Follow `implement`'s risk-based review gate and honor stricter user or repository requirements.
  Bounded workers return their assigned results without arranging review or final acceptance.

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
