# AGENTS.md

<!-- Rendered by scripts/install; do not link this template directly. -->

Read and follow `{{AGENTIC_ENGINEERING_ROOT}}/CODING_STANDARDS.md` before
doing any work. Treat it as mandatory startup context for all tasks.

## Rules

- Follow repository-local `AGENTS.md` files in addition to these shared rules.
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

- Use `implement` for user-supplied or approved plans, material design decisions, coordination
  across behavior boundaries, identified risks needing staged execution, or explicit requests.
  Work directly for clear, routine changes.
- Delegate when a bounded assignment provides useful independent progress or saves enough parent
  context to justify the handoff. Keep tightly
  coupled operational work with one executor; sequential work alone is not a reason to delegate.
- Keep delegated reports concise: conclusions, evidence pointers, uncertainties, and validation
  results. Reuse verified findings instead of repeating the worker's investigation. Delegation
  reduces parent context, not necessarily total token use.
- Prefer GPT-5.6 Luna with Max reasoning for delegated implementation and investigation.
  Respect session model choices. If unavailable, pause delegation and ask the user to choose
  a supported alternative: a suitable smaller model, lower effort, or direct execution without
  subagents. Recommend based on available evidence; do not silently substitute. Reuse an
  already-authorized fallback and continue independent authorized work while awaiting a choice.
- For a new reviewer launch, use an already-authorized model and effort or ask before launching.
  Reuse an eligible existing agent under `CODING_STANDARDS.md` rather than launching by default.
- Include the task, model, and effort in subagent names where supported, or disclose them before
  launch. Distinguish requested settings from runtime-confirmed settings; mark unavailable
  metadata `unknown`. Report changes when continuing an agent. These labels do not measure cost.
- Keep reusable skills model- and harness-neutral.
- Follow the coding standards' review requirements for both direct and planned work.
  Bounded workers may self-review when assigned, but do not launch reviewers or own final acceptance.

## Skills

| Skill | When to use |
| --- | --- |
| agent-review | Reviewing a PR or branch |
| auto-review | Bounded implementation review for an orchestrator |
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

## Shared source

- `{{AGENTIC_ENGINEERING_ROOT}}/CODING_STANDARDS.md` — engineering and workflow rules
- `{{AGENTIC_ENGINEERING_ROOT}}/skills/` — reusable agent skills
- `{{AGENTIC_ENGINEERING_ROOT}}/docs/` — setup and operational guidance
- `{{AGENTIC_ENGINEERING_ROOT}}/tools.md` — workstation tool reference
