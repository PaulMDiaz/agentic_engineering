---
summary: "Tool catalog — CLIs and helpers available to agents"
read_when: "You need to know what tools are available in this environment"
---

# Tools

## Core

### gh
GitHub CLI. PRs, issues, CI runs, releases.
```bash
gh pr list / view / create / merge
gh issue list / view / create
gh run list / view / rerun
gh api /repos/owner/repo/...
```

### git
Version control. Safe ops freely; destructive ops require explicit consent.
- Safe: `status`, `diff`, `log`, `show`, `fetch`
- Consent required: `reset --hard`, `clean`, `restore`, `rm`

### claude
Claude Code CLI.
```bash
claude -p "task" --dangerously-skip-permissions   # non-interactive
claude  # interactive
```

### trash
Safe file deletion. Always prefer over `rm`.
```bash
trash path/to/file
```

## Scripting

### scripts/committer
Stage specific files + commit. Enforces non-empty message.
```bash
./scripts/committer "feat: add thing" src/thing.py tests/test_thing.py
```

## Platform

### Python
- Package manager: `uv` (preferred) or `pip`
- Linting: `ruff check .`
- Format check: `ruff format --check .`
- Types: `mypy .`
- Tests: `pytest`
- Format (apply): `ruff format .`

### Node/TypeScript
- Package manager: `pnpm` (preferred), `npm`, `yarn`
- Types: `tsc --noEmit`
- Lint: `eslint .`
- Test: `vitest` / `jest`

### Shell
- Always: `set -euo pipefail`
- Lint: `shellcheck`
