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
- Split unrelated changes into separate commits
- Keep commits atomic and focused

## Planning

- Before non-trivial changes: identify the desired outcome, constraints, success criteria, files to change, and validation.
- Create a `/tmp/<feature>.md` plan only for larger or multi-step work.
- Keep plans minimal — only essential changes.

## Code Quality

- Read related files and understand the codebase before suggesting changes.
- Check if logic already exists before writing new code.
- Before adding a new helper, wrapper, abstraction, or pattern, check whether the repo already has something that solves the same class of problem. Prefer extending the existing approach over creating a parallel one unless there is a clear reason not to.
- Do not import underscored/private helpers across module boundaries. Promote them to named internal APIs or keep usage within the defining module.
- Avoid behavior-bearing magic strings. Use named constants, enums, literal types, or structured config for repeated values, external identifiers, states, modes, and cross-module contracts; leave one-off display text inline when naming it adds no clarity.
- Respect existing code style and patterns.
- Keep proposed changes focused on the current task. Include obvious local refactors when they reduce real complexity, duplication, or bug risk without expanding behavior.
- Change as few lines as possible while solving the problem.
- Files: keep under ~500 LOC; split/refactor as needed.
- Tests: write in the same context as implementation — don't waste context switching.
- In tests, do not define `async def` helpers that contain no asynchronous operation. Use `AsyncMock`, a real awaited operation, or a synchronous helper wrapped by the code under test.
- In tests, do not compare floating-point values with exact equality. Use an appropriate tolerance or the test framework's approximate-comparison helper (for example, `pytest.approx`).
- When asserting an expected exception, scope the assertion to exactly one target operation that can raise. Arrange inputs and dependencies first so an earlier failure cannot satisfy the assertion.
- Prefer tests that validate observable behavior, public interfaces, and outcomes over tests tightly coupled to implementation details.
- Good tests should still pass after internal refactors that preserve behavior.
- Be suspicious of AI-generated tests that mirror code structure, mock too much, or only prove the current implementation path.
- Use `pytest.mark.parametrize` when cases share setup and assertions and differ only by inputs or expected outcomes. Keep behaviorally distinct scenarios as separate tests.
- Add or update tests when behavior, public APIs, bug fixes, edge cases, or shared logic change.
- Do not add tests for docs-only, formatting-only, or mechanically safe changes unless there is real regression risk.
- Fix root cause, not band-aid.
- Do not bundle unrelated cleanup into feature or bugfix work.
- Follow DRY, KISS, and YAGNI — no gold-plating, no speculative abstractions.
- Record intentionally deferred work in `.second_brain/DEFERRED.md` when present. Use a GitHub issue when the work is specific and actionable, outside the current pull request or feature branch, materially impactful, and needs team visibility beyond agent context. Reference an applicable issue from its deferred-work entry; do not create issues automatically.
- For research or source-backed answers, gather the smallest credible evidence set needed to answer correctly. If results are empty or suspiciously narrow, retry once with a different query/source before proceeding.
- Comments in English only.
- Comments and docstrings should capture verified behavior, constraints, or intent. Do not add explanatory text that merely paraphrases the code or describes what you assume it does. Misleading documentation is worse than sparse documentation.
- CI: `gh run list/view` for PR/CI-bound changes; fix until green when CI is in scope.
- Before committing source, test, or build-configuration changes, run the repository's formatter **check** across the complete CI lint scope, not only the files edited in the current task. Discover the exact command and scope from the repository's CI workflow or task runner; if it fails, format the reported files and re-run the full check before committing.
- Before committing or handing off: run the most relevant validation for the change (lint/typecheck/tests/build). Run the full gate for broad, risky, or pre-merge work. If validation cannot run, say exactly why.

## Security

- New deps: quick health check (recent commits, adoption, known CVEs) before adding.
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

## Dependencies

- Quick health check before adding: recent releases, active commits, adoption, known CVEs.
- Prefer packages with CLIs — agents can use them directly.
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
- Update docs when behavior or API changes. No ship without docs.
- Add `read_when` hints on cross-cutting docs.

## Knowledge Base (.second_brain/)

- Update `.second_brain/` only for durable project knowledge: decisions, architecture, conventions, important code pointers, or deferred-work items that future agents should know.
- Add a `.second_brain/DECISIONS.md` entry only when the decision is hard to reverse, would be surprising without context, and involved a real trade-off.
- Update `.second_brain/CODE_POINTERS.md` for important entry points, public APIs, cross-module contracts, workflows, commands, or files future agents need to find. Prefer repository-relative `path::symbol` references for stable code entry points and use `path:line` only when no stable symbol exists. Do not record every helper.
- Update `.second_brain/ARCHITECTURE.md` when the system shape changes (new module, table, data flow).
- Update `.second_brain/CONVENTIONS.md` or `.second_brain/DEFERRED.md` when patterns or tech debt change.
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
- `gh run list/view` to monitor. Rerun, fix, push, repeat until green.
- Keep observable: logs, clear output.
- Release: read `docs/RELEASING.md` if present.

## Skills

- Reusable agent workflows live in `skills/<name>/SKILL.md`.
- Prefer skills over slash commands. Cursor and Codex discover skills directly, and Cursor can manually invoke skills by typing `/skill-name`.

## Design

- Prefer functional programming over OOP for new code — pure functions by default.
- Use OOP classes only for connectors and interfaces to external systems (APIs, DBs, queues).
- Write pure functions: only modify return values, never input parameters or global state.
- Never use default parameter values — make all parameters explicit.
- Prefer explicit keyword/named arguments when calling functions with multiple same-type, boolean, optional, or non-obvious parameters. Positional arguments are fine for small, conventional calls where the meaning is clear.

## Error Handling

- Raise specific exceptions with descriptive, actionable messages.
- Use specific error types that clearly indicate what went wrong.
- Error messages must say what failed and why — not just "operation failed".
- Avoid catch-all `except Exception` handlers inside business logic — use specific types.
- Exception: outer resilience loops (e.g. per-item processing) may use `except Exception` to prevent one bad item from killing the loop — but everything *inside* the loop must raise specifically.
- No silent fallbacks — never return a fake default when a dependency fails. Let it propagate. Failures must be visible.
- Security-clamping (constraining valid-but-injected LLM output to safe enum values) is not a fallback — it is a required validation layer and must be kept.

## LLM Integrations

- Prefer API-level structured outputs, schemas, and tool/function contracts over prose-only output instructions.
- Keep tool-specific constraints near the tool contract instead of scattering them through general prompts.

## Typing

- Use strict typing everywhere: function returns, parameters, variables, collections.
- Avoid `Any`, `unknown`, `object`, and `List[Dict[str, Any]]` — use specific types.
- Prefer structured data models over loose dicts — Pydantic, dataclasses, or interfaces.
- Leverage language-specific type features: discriminated unions, enums, literal types.
- Create proper type definitions for complex data structures rather than annotating inline.
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
