# /commit

Create well-formatted conventional commit. Runs checks by default.

## Usage
- `/commit` — standard commit with pre-commit checks
- `/commit --no-verify` — skip checks

## Process
1. `git status` — check what's changed
2. Stage appropriate files if none staged
3. Run checks unless `--no-verify`
4. Analyze changes → determine type + scope
5. Write message: `type(scope): description`
6. Add body for complex changes (explain *why*)
7. Execute commit

## Types
- ✨ feat / 🐛 fix / 📝 docs / ♻️ refactor / 🎨 style
- ⚡️ perf / ✅ test / 🧑‍💻 chore / 🚧 wip / 🔥 remove / 🔒 security

## Rules
- Imperative mood
- Split unrelated changes
- Reference issues/PRs when relevant
- Never `--amend` unless asked
