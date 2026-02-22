# /check

Run full quality gate. Fix all issues. Do NOT commit during this process.

## Process
1. Run `npm run check` / `make check` / project-specific gate
2. Fix in priority order:
   - Build-breaking errors
   - Test failures
   - Type errors
   - Lint errors
   - Warnings
3. Re-run after each fix
4. Continue until clean

## By Stack
- JS/TS: `npm run check` or `pnpm check`
- Python: `ruff`, `mypy`, `pytest`
- Rust: `cargo check`, `cargo clippy`, `cargo test`
- Shell: `shellcheck`
