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

- Route substantive implementation through `implement` automatically. Delegate substantive
  implementation by default, including sequential increments. Make trivial mechanical edits
  directly.
- Delegate bounded, noisy investigation when its result can be verified without importing the
  exploration. Keep small lookups local.
- Keep delegated reports concise: conclusions, evidence pointers, uncertainties, and validation
  results. Delegation reduces parent context, not necessarily total token use.
- Prefer GPT-5.6 Luna with Max reasoning for implementation and investigation. This is a
  preference, not a dependency. Respect session model choices. If the preferred model is
  unavailable, inspect supported models and recommend a suitable, cost-effective smaller model
  only with evidence for capability and cost. Ask once for a session fallback unless the session
  already authorizes a choice. Choose reviewer models separately; do not infer one from this
  preference.
- Include the task, selected model, and reasoning effort in user-visible subagent names when
  supported, for example `review_astra_high`. If names cannot carry these details, disclose them
  briefly before launch. Identify inherited settings and resolve them from runtime metadata when
  available; never infer a subagent's settings from the global default. Mark unavailable values
  `unknown` and distinguish requested settings from runtime-confirmed settings. Report model or
  effort changes when continuing an agent. These labels disclose configuration, not measured
  token usage or cost; do not change model selection merely to produce a label.
- Keep reusable skills model- and harness-neutral.
- The orchestrator must obtain independent review by a fresh agent before accepting substantive
  implementation as complete. If the harness cannot run subagents, follow `implement`'s
  direct-work fallback. Bounded implementation, investigation, and review workers return their
  assigned results without arranging another review or obtaining final acceptance.

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
