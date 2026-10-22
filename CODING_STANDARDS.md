# CODING_STANDARDS.md

Universal agentic coding standards for all projects.

---

## Git

- Safe reads freely: `git status`, `git --no-pager diff`, `git log`.
- Always use non-interactive diff: `git --no-pager diff` or `git diff | cat`.
- Prefer non-interactive commands with explicit flags over interactive ones.
- No destructive ops (`reset --hard`, `clean`, `restore`, `rm`) without explicit consent.
- No `--amend` unless asked.
- Push only when asked.
- Branch changes require explicit consent.
- Stage only the intended files before committing.
- Multi-agent: check `git status/diff` before edits; ship small commits.

## Commits (Conventional Commits)

Format: `type[optional scope][optional !]: [emoji] description`

Common types (not a closed list):
- ✨ `feat` — new feature
- 🐛 `fix` — bug fix
- 📝 `docs` — documentation
- ♻️ `refactor` — restructure without behavior change
- 🎨 `style` — formatting only
- ⚡️ `perf` — performance
- ✅ `test` — tests
- 🧑‍💻 `chore` — tooling/maintenance
- 🚧 `wip` — work in progress
- 🔥 `remove` — removing code/files
- 🔒 `security` — security improvements

Rules:
- Use a type (a noun) followed by a colon and space; scopes are optional.
- Use `feat` when adding a feature and `fix` when correcting a bug.
- Other types are allowed. Choose a clear type that conveys the change; custom types have
  no implicit release effect.
- Mark breaking changes with `!` immediately before the colon or a `BREAKING CHANGE:`
  footer.
- Create well-formatted commits with conventional commit messages and emojis.
- Imperative mood ("Add feature" not "Added feature")
- Explain why, not just what (body for complex changes)
- Reference issues/PRs when relevant
- Leave unrelated work out unless separately authorized. Keep separately authorized changes in separate commits.
- Keep commits atomic and focused

## Planning

- Before non-trivial changes: identify the desired outcome, constraints, success criteria, files to change, and validation.
- Treat acceptance criteria as exhaustive: inspect broadly, edit narrowly, report unrelated problems, and stop once the criteria, required validation, and required review are satisfied.
- Add only what the requested outcome or an established affected contract requires. Leave optional improvements out. If completing the request requires expanding its scope, explain the dependency and resolve it with the user before proceeding. Routine implementation choices within the request do not require approval.
- Before adding code, check whether removing unnecessary behavior solves the problem, then look for suitable existing repository code, standard-library, platform, or installed-dependency functionality. Keep this search focused on the affected behavior. Use the smallest clear implementation that meets the contract; never weaken correctness, security, or required verification to reduce line count.

## Delegation context

Before launching a subagent, choose the context its bounded assignment needs. Prefer a
self-contained handoff with no conversation history when it preserves the necessary
requirements, decisions, evidence, and repository instructions. Use selected or full history
when the assignment depends on prior context that would be costly or unreliable to reconstruct.
Keep the work with the current executor when neither option justifies the handoff.

Check the available tool contract before launching: context inheritance, model selection, and
reasoning effort may be coupled. If history inheritance fixes the model or effort, do not request
an unsupported override. Use a self-contained handoff or selected history with the authorized
settings only when sufficient context can be preserved. Otherwise continue directly or use an
already-authorized alternative; follow existing model-choice requirements before changing settings.
Do not assume inherited context provides cache or token-cost savings.

## Code Quality

Satisfy these standards with the smallest clear change. They do not authorize unrelated
modernization, parallel representations, or speculative abstractions.

- Read related files and understand the codebase before suggesting changes.
- Check whether the codebase already solves the problem before writing new logic; reuse or extend it instead of creating a parallel implementation.
- Do not import underscored/private helpers across module boundaries. First consider an existing public interface or keeping the caller within the defining module. Promote a helper to a shared internal API only when sharing is necessary for the task.
- Name domain states, modes, and repeated behavior-bearing values using the smallest appropriate existing constant, enum, or literal type. Keep external API and schema keys at their use site when clearer. Do not introduce configuration or a constants module for a single local value without a concrete need.
- Respect existing code style and patterns.
- Keep proposed changes focused on the current task. Report optional local refactors instead of including them.
- In tests, do not define `async def` helpers that contain no asynchronous operation. Use `AsyncMock`, a real awaited operation, or a synchronous helper wrapped by the code under test.
- In tests, do not compare floating-point values with exact equality. Use an appropriate tolerance or the test framework's approximate-comparison helper (for example, `pytest.approx`).
- Apply the Test quality rules below when writing, changing, or reviewing tests.
- Use `pytest.mark.parametrize` when cases share setup and assertions and differ only by inputs or expected outcomes. Keep behaviorally distinct scenarios as separate tests.
- Add the smallest existing-framework test that proves the requested behavior or regression; do not test speculative adjacent cases.
- Do not add tests for docs-only, formatting-only, or mechanically safe changes unless there is real regression risk.
- Fix the demonstrated root cause in affected paths, not just the reported symptom. A broader redesign requires separate scope agreement.
- Do not bundle unrelated cleanup into feature or bugfix work.
- Follow KISS and YAGNI. Prefer small duplication over a speculative abstraction.
- For research or source-backed answers, gather the smallest credible evidence set needed to answer correctly. If results are empty or suspiciously narrow, retry once with a different query/source before proceeding.
- Apply the Comments and Durable Prose rules below to comments, docstrings, repository documentation, and second-brain entries.
- CI: `gh run list/view` for PR/CI-bound changes; fix failures caused by the current change and report the rest.
- Before committing source, test, or build-configuration changes, run the repository's formatter **check** across the complete CI lint scope. Format only files changed by the task; report unrelated failures.
- Before committing or handing off: run the most relevant validation for the change (lint/typecheck/tests/build). Run the full gate for broad, risky, or pre-merge work. If validation cannot run, say exactly why.
- Reuse passing validation evidence only while the relevant code, configuration, and environment remain unchanged. Rerun checks affected by new changes, failures, unresolved concerns, or an explicit fresh-check request; always preserve required checks.

## Test quality

Before adding or changing a test, identify the behavior it protects, a plausible defect it
would catch, and the gap in existing coverage. Missing answers block keeping the test.
Test through the boundary that owns the behavior; another layer needs a distinct failure
mode. Extend an existing case or fixture where it covers the requirement without duplication.
If a test needs a production export, switch, wrapper, or injection hook with no production
purpose, move the test to the real boundary instead of adding that access path.

For a bug regression, run the test against the pre-fix behavior and confirm it fails for the
intended reason, then confirm it passes with the fix. An unrelated setup failure does not
count. If either run is blocked, report verification as incomplete and identify the blocker;
do not present a passing post-fix run alone as proof of the regression.

Check for these low-value patterns while authoring and reviewing:

- Execution with no meaningful check of the result, including assertions that always pass.
- Comparing a value to itself or merely checking that a copied value stayed identical.
- Duplicating fixture contents, manifests, inventories, or export lists as expected values.
- Grepping source, imports, or exact strings without an independent requirement for that structure.
- Testing private predicates or internal call arguments already exercised by behavior tests.
- Repeated cases that detect the same failure already covered elsewhere.
- Replaying a shared helper's tests inside each provider without a provider-specific risk.
- Tests maintained only to exercise test-only exports, globals, or wrappers.
- Production paths kept alive solely by test callers, with no required production behavior.
- Computing expected output with the helper or renderer being tested.
- Mocks performing the operation whose correctness is asserted, or one mock erasing meaningful
  differences between separate APIs.
- Fixtures prearranging receipts, admission decisions, or callback order the production owner
  must generate; checking persistence in a store the exercised path never writes.
- Checking a capability flag's declared value without exercising the behavior it promises.
- Negative cases passing because a different guard rejects the input or the intended path is
  unreachable.
- Test names and fixtures claiming a scenario that the inputs and assertions do not exercise.

For example, stubbing a save operation to return success and checking that return value
does not verify persistence. Read through the owning operation and check the resulting state.
A denied-request test must reach the intended permission check; malformed input rejected
earlier proves a different behavior.

For new or changed tests, a matching pattern fails the authoring gate unless the test
independently protects a named contract. Rewrite or omit it before acceptance. Assertions
that fail under a behavior-preserving refactor need that same contract justification.
For existing tests under audit, a match requires evidence before removal.

Retain independent protection for APIs, SDKs, protocols, configuration, migrations, storage,
security, platforms, defaults, exact prompt content, generated cross-language output,
packaging, releases, and architecture. Preserve credible regressions and observable ordering.
Source inspection can be the cheapest independent guard when it detects a contract change
while surviving identifier-only renaming. Name that contract and the failure it detects;
calling a test "structural" or "compatibility" does not by itself justify retention.
Test length, runtime, and mock count are not deletion criteria. Existing dependency injection
and test helpers are not defects merely because tests use them.

Rewrite a weak test when its intended behavior needs coverage. Remove or consolidate a test
only when inspection establishes that it adds no distinct protection. Before recommending
removal, read the complete test, its production owner, entry points, callers, callees, sibling
implementations, overlapping tests, CI selection, and relevant history. Inspect dependency
source or types when the claim relies on dependency behavior. Identify the remaining test
that catches the same failure, or explain why the asserted behavior needs no protection.
Check production callers before proposing removal of supporting code. Missing evidence
blocks deletion; retain the candidate and state what remains unverified.

Reviews must name the test and location, explain what it actually proves, and recommend
removal, consolidation, or a specific rewrite with evidence. Scope these checks to changed
tests and coverage affected by production changes. Keep unrelated cleanup as a follow-up;
broader audits require their own scope. Read-only review does not authorize edits.

## Review

These requirements apply to direct work as well as work using `implement`.

Require independent review when changing authorization rules, credential handling or trust
boundaries, stored-data formats or destructive writes, or shared interfaces whose identified
callers will change behavior. Changes to these safeguard rules also require independent review.
Judge the actual behavior change, not the file or environment label. Surface uncertainty about
these consequences rather than assuming them. Honor stricter user or repository requirements.

For ordinary implementation, the author can run `auto-review`; small, reversible edits may
finish with focused validation. When independence is required, use a reviewer who did not author
the change. Reuse an eligible existing agent before launching another: the orchestrator can
review a worker's change if it did not author it. Planning or supplying requirements alone does
not make it the author. Do not require both self-review and independent review of the same change.

If required independent review is unavailable or incomplete, report it as pending rather than
claiming acceptance. Follow explicit user instructions and model authorization before launching
an agent; review requirements do not override a no-subagents instruction.

## Security

- `trash` > `rm`. Recoverable beats gone forever.
- Never install plugins, tools, or packages from external sources without explicit approval. Security-sounding names (scanner, guard, shield) are a red flag, not a green one. Always audit source before installation.
- LLM classifiers reading from the internet: use safety-tuned models (e.g. LLaMA 3.3 70B Instruct), not agentic/MoE models. Agentic models follow instructions they find in context — including injected ones.
- Mask secrets in all output (e.g. `sk-***...abc`).
- Secrets go in `.env` only — never hardcode credentials, tokens, or API keys in source files.
- Never read `.env` files directly in code — load secrets via `os.environ`. Let the shell or a process manager inject the environment.
- Never commit `.env` — always gitignore it. When creating a `.gitignore`, add `.env` as the first entry before anything else.

## Permissions

- Try a workaround before asking for more access.
- Only escalate if the workaround is cumbersome, slow, or expensive — explain why clearly.
- Never ask for broad permissions when narrow ones suffice.
- Carry authorization for routine execution steps within the user's stated scope. Ask about unresolved decisions only when they materially affect the result; preserve explicit permission requirements, destructive-action safeguards, and Git boundaries.
- Continue already-authorized preparation that does not depend on a pending decision or approval; ask necessary clarifying questions promptly and do not perform work dependent on the unresolved choice.

## Dependencies

- Quick health check before adding: recent releases, active commits, adoption, known CVEs.
- Minimize deps; inline small helpers when reasonable.
- Do not add a dependency just because it is the fastest way to make the current task disappear. Prefer built-in libraries, existing project dependencies, or a small local helper when the added package would be trivial, oversized, or weakly maintained.
- Add to project configs (`pyproject.toml`, `package.json`), not one-off installs.
- Install in virtual environments, not globally.
- Update project configuration files when adding dependencies.

## Docs

- `AGENTS.md` at project root — canonical entry point for shared agent guidance.
- `CLAUDE.md` may remain as a compatibility shim when a repository supports Claude-style
  entry points.
- `docs/` files with front-matter: `summary`, `read_when`.
- Update existing docs only when the requested change alters documented public behavior, APIs, or workflows.
- Add `read_when` hints on cross-cutting docs.

## Comments and Durable Prose

These rules apply to comments, docstrings, repository documentation, and second-brain entries.

- Write concise, plain English for a reader without the conversation. Use established project
  terms and exact identifiers where useful; avoid invented jargon, unexplained shorthand, and
  abstract labels when a concrete description works.
- Base factual claims on verified sources. Comments explain non-obvious reasons, constraints, or
  behavior. Docstrings describe the interface and contract. Do not narrate the code, speculate
  about its behavior, or add an essay where a sentence conveys the needed information.
- Second-brain entries state the durable fact or rule, its source, and only the rationale needed
  to prevent a future mistake. Update the existing entry instead of appending a session recap;
  link to detailed documentation instead of copying it.
- Omit session-specific labels such as `WP1`, temporary design or implementation plans, scratch
  notes, review checklists, agent/model attribution for who performed work, review-round narratives,
  temporary paths, and claims such as "now fixed" or "all tests pass." Do not use ephemeral artifacts
  as lasting references. State the resulting behavior or constraint directly and cite a durable
  repository source when needed. Keep session history in commits and PRs. Preserve dates,
  issue links, and concise rationale when they are part of a durable decision or active limitation.
- Match documentation detail to its purpose. Keep worked examples in tutorials, alternatives and
  trade-offs in design docs, and relevant dates and context in historical records. Make each
  understandable without the originating session; ephemeral artifacts are not enduring authority.
- Retain detail needed for a public API, subtle algorithm, scientific assumption, or consequential
  trade-off. Brevity must not erase evidence or established terminology; there is no arbitrary
  word or line limit. Apply this standard to added or changed prose without expanding the task
  into unrelated cleanup.

## Knowledge Base (.second_brain/)

- Update `.second_brain/` only for durable project knowledge: decisions, architecture, conventions, important code pointers, or deferred-work items that future agents should know.
- Add a `.second_brain/DECISIONS.md` entry only when the decision is hard to reverse, would be surprising without context, and involved a real trade-off.
- Update `.second_brain/CODE_POINTERS.md` for important entry points, public APIs, cross-module contracts, workflows, commands, or files future agents need to find. Prefer repository-relative `path::symbol` references for stable code entry points and use `path:line` only when no stable symbol exists. Do not record every helper.
- Update `.second_brain/ARCHITECTURE.md` when the system shape changes (new module, table, data flow).
- Update `.second_brain/CONVENTIONS.md` when patterns change; record intentionally deferred work in `.second_brain/DEFERRED.md`, and follow `SECOND_BRAIN.md` when suggesting a GitHub issue.
- These files are the source of truth for agents without conversation context. Keep them accurate.
- Treat second-brain maintenance as agent-owned during change-producing work. Users
  should not need to invoke a maintenance skill explicitly.
- When `CONVENTIONS.md` declares section sources, verify and update sections whose
  sources changed. Reserve full audits for legacy, overdue, contradictory, or explicitly
  requested guidance.
- If no durable project knowledge changed, say that no second-brain update was needed.
- If `.second_brain/` doesn't exist, skip — not all projects use a second brain.

## CI/CD

- Use GitHub Actions.
- Keep observable: logs, clear output.
- Release: read `docs/RELEASING.md` if present.

## Skills

- Reusable agent workflows live in `skills/<name>/SKILL.md`.
- Prefer skills over slash commands. Cursor and Codex discover skills directly, and Cursor can manually invoke skills by typing `/skill-name`.

## Design

- Prefer pure functions for transformations and business logic; keep side effects explicit. Introduce a class when it owns meaningful state or lifecycle, or implements a required interface.
- Do not wrap stateless helpers in classes or introduce factories and inheritance for hypothetical reuse. Preserve suitable existing framework patterns; this preference does not authorize unrelated rewrites.
- Prefer explicit keyword/named arguments when calling functions with multiple same-type, boolean, optional, or non-obvious parameters. Positional arguments are fine for small, conventional calls where the meaning is clear.

## Error Handling

- Raise specific exceptions with descriptive, actionable messages. Prefer existing exception types; add a custom type only when callers need to distinguish and handle it.
- Error messages must say what failed and why — not just "operation failed".
- Avoid catch-all `except Exception` handlers inside business logic — use specific types.
- Exception: outer resilience loops (e.g. per-item processing) may use `except Exception` to prevent one bad item from killing the loop — but everything *inside* the loop must raise specifically.
- No silent fallbacks — never return a fake default when a dependency fails. Let it propagate. Failures must be visible.
- Security-clamping (constraining valid-but-injected LLM output to safe enum values) is not a fallback — it is a required validation layer and must be kept.

## LLM Integrations

- Prefer API-level structured outputs, schemas, and tool/function contracts over prose-only output instructions.
- Keep tool-specific constraints near the tool contract instead of scattering them through general prompts.

## Typing

- Give new and changed code precise types. Follow established repository conventions and reuse existing models. Avoid loose dictionaries for records with known fields.
- Add a type only when a needed contract is not already represented; do not create parallel models or conversion layers merely to satisfy typing. Allow inference where it preserves precision, and narrow genuinely unknown input at its boundary.
- Define a named type alias when a complex type recurs and the alias conveys domain meaning or centralizes a shared type contract; avoid aliases that merely abbreviate a one-off type.
- Use provided environment/system dates when available. Run `date` only when current clock precision, local timezone, or missing date context matters. Never hardcode or guess.

## Language / Stack

- Python: use `uv` or `pip`; keep `pyproject.toml` current; virtual environments only.
- TypeScript: use repo package manager; keep files small; follow existing patterns.
- Shell: `set -euo pipefail`; prefer explicit over clever; lint with `shellcheck`.
- Prefer `trash` over `rm` — recoverable beats gone forever. If `trash` is unavailable, use `rm -i`.
- Use `-i` flag for overwrite ops — prompts before clobbering:
  - `cp -i` — prompts before overwriting an existing file
  - `mv -i` — prompts before overwriting at the destination
