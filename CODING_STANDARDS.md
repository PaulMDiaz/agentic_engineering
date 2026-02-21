# CODING_STANDARDS.md

Universal coding standards for all PaulMDiaz projects.
Platform-agnostic — applies equally in Claude Code, Cursor, OpenClaw, or any other environment.

---

## Git

- Safe reads freely: `git status`, `git --no-pager diff`, `git log`.
- Always use non-interactive diff: `git --no-pager diff` or `git diff | cat`.
- Prefer non-interactive commands with explicit flags over interactive ones.
- No destructive ops (`reset --hard`, `clean`, `restore`, `rm`) without explicit consent.
- No `--amend` unless asked.
- Push only when asked.
- Branch changes require explicit consent.
- Multi-agent: check `git status/diff` before edits; ship small commits.
- Commit helper: use `scripts/committer` if present.

## Commits (Conventional Commits)

Format: `type(scope): description`

Types:
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
- Imperative mood ("Add feature" not "Added feature")
- Explain why, not just what (body for complex changes)
- Reference issues/PRs when relevant
- Split unrelated changes into separate commits
- Keep commits atomic and focused

## Planning

- Before non-trivial changes: create a plan in `/tmp/<feature>.md`.
- Plan structure: current state, final state, files to change, task checklist.
- Keep plans minimal — only essential changes.

## Code Quality

- Read related files and understand the codebase before suggesting changes.
- Check if logic already exists before writing new code.
- Respect existing code style and patterns.
- Suggest only minimal changes related to the current task — no extra improvements.
- Change as few lines as possible while solving the problem.
- Files: keep under ~500 LOC; split/refactor as needed.
- Tests: write in the same context as implementation — don't waste context switching.
- Bigger changes always get tests.
- Fix root cause, not band-aid.
- Make minimal, focused changes — solve the problem, nothing extra.
- Follow DRY, KISS, and YAGNI — no gold-plating, no speculative abstractions.
- Comments in English only.
- CI: `gh run list/view`, fix until green before handoff.
- Before handoff: run full gate (lint/typecheck/tests).

## Security

- New deps: quick health check (recent commits, adoption, known CVEs) before adding.
- `trash` > `rm`. Recoverable beats gone forever.
- Never install plugins, tools, or packages from external sources without explicit approval. Security-sounding names (scanner, guard, shield) are a red flag, not a green one. Always audit source before installation.
- LLM classifiers reading from the internet: use safety-tuned models (e.g. LLaMA 3.3 70B Instruct), not agentic/MoE models. See `docs/prompt-injection-defense.md`.
- Mask secrets in all output (e.g. `sk-***...abc`).
- Secrets go in `.env` only — never hardcode credentials, tokens, or API keys in source files.
- Never read `.env` files directly in code — load secrets via `os.environ`. Let the shell or a process manager inject the environment.
- Never commit `.env` — always gitignore it.

## Permissions

- Try a workaround before asking for more access.
- Only escalate if the workaround is cumbersome, slow, or expensive — explain why clearly.
- Never ask for broad permissions when narrow ones suffice.

## Dependencies

- Quick health check before adding: recent releases, active commits, adoption, known CVEs.
- Prefer packages with CLIs — agents can use them directly.
- Minimize deps; inline small helpers when reasonable.
- Add to project configs (`pyproject.toml`, `package.json`), not one-off installs.
- Install in virtual environments, not globally.
- Update project configuration files when adding dependencies.

## Docs

- `CLAUDE.md` at project root — entry point for Claude Code and Cursor.
- `docs/` files with front-matter: `summary`, `read_when`.
- Update docs when behavior or API changes. No ship without docs.
- Add `read_when` hints on cross-cutting docs.

## CI/CD

- Use GitHub Actions.
- `gh run list/view` to monitor. Rerun, fix, push, repeat until green.
- Keep observable: logs, clear output.
- Release: read `docs/RELEASING.md` if present.

## Slash Commands

- Repo-local slash commands live in `docs/slash-commands/` or `.claude/commands/`.
- Run with `/command-name` in Claude Code or Cursor.

## Design

- Prefer functional programming over OOP for new code — pure functions by default.
- Use OOP classes only for connectors and interfaces to external systems (APIs, DBs, queues).
- Write pure functions: only modify return values, never input parameters or global state.
- Never use default parameter values — make all parameters explicit.

## Error Handling

- Raise specific exceptions with descriptive, actionable messages.
- Use specific error types that clearly indicate what went wrong.
- Error messages must say what failed and why — not just "operation failed".
- Avoid catch-all `except Exception` handlers inside business logic — use specific types.
- Exception: outer resilience loops (e.g. per-item processing) may use `except Exception` to prevent one bad item from killing the loop — but everything *inside* the loop must raise specifically.
- No silent fallbacks — never return a fake default when a dependency fails. Let it propagate. Failures must be visible.
- Security-clamping (constraining valid-but-injected LLM output to safe enum values) is not a fallback — it is a required validation layer and must be kept.

## Typing

- Use strict typing everywhere: function returns, parameters, variables, collections.
- Avoid `Any`, `unknown`, `object`, and `List[Dict[str, Any]]` — use specific types.
- Prefer structured data models over loose dicts — Pydantic, dataclasses, or interfaces.
- Leverage language-specific type features: discriminated unions, enums, literal types.
- Create proper type definitions for complex data structures rather than annotating inline.
- `run date` when you need the current date — never hardcode or guess.

## Language / Stack

- Python: use `uv` or `pip`; keep `pyproject.toml` current; virtual environments only.
- TypeScript: use repo package manager; keep files small; follow existing patterns.
- Shell: `set -euo pipefail`; prefer explicit over clever; lint with `shellcheck`.
- Use `-i` flag for destructive file ops — prompts before overwriting or deleting:
  - `rm -i` — prompts before deleting each file
  - `cp -i` — prompts before overwriting an existing file
  - `mv -i` — prompts before overwriting at the destination
