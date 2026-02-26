---
name: git-recap
description: "Summarize recent work from the git log. Use when asked for a recap, changelog, session notes, what's been worked on, or project activity summary. Replaces manual session notes with the source of truth (git history). Supports filtering by time range, author, and branch."
---

# git-recap

Generate a human-readable summary of recent work from the git log.

## Process

### Step 1: Gather parameters

Parse the user's request for:
- **Time range** — default: `2 weeks`. Accept natural language ("last month", "since Monday", "this sprint")
- **Author(s)** — default: all authors. `--mine` or "my work" filters to the configured git user. Specific names filter to those authors.
- **Branch** — default: current branch. Can specify `main`, `dev`, or any branch.

### Step 2: Pull the log

```bash
git log --since="<time range>" --format="%h|%ai|%an|%s" --no-merges [--author="<filter>"] [<branch>]
```

If no commits found, say so and exit.

### Step 3: Parse and group

1. Parse each commit: `hash | datetime | author | subject`
2. Extract conventional commit prefix from subject (`feat`, `fix`, `refactor`, `test`, `docs`, `perf`, `chore`, `style`, `ci`, `config`, `deploy`, `security`, `review`, `backlog`). Commits without a recognized prefix go under "Other".
3. Strip the prefix and optional scope from the display text (e.g., `feat(nitter): UA rotation` → `UA rotation`)
4. Group commits by date (newest first), then by type within each date

### Step 4: Filter noise

By default, exclude these commit types from the output:
- `docs` — second brain updates, README tweaks (usually noise in a recap)
- `style` — formatting-only changes
- `review` — review artifacts
- `backlog` — backlog file updates

If the user asks for `--all` or "include everything", show all types.

### Step 5: Format output

Use this format (Option C — date sections with type grouping):

```
📋 git-recap: <repo-name> (<date range>)
[Author: <filter or "all"> · Branch: <branch>]

── <Date> ──────────────────────────────────────

  Features:
    • <commit message>
    • <commit message>

  Fixes:
    • <commit message>

  Refactors:
    • <commit message>

  Tests:
    • <commit message>

  Performance:
    • <commit message>

── <Earlier Date> ──────────────────────────────

  ...

──────────────────────────────────────────
<total> commits [by <author(s)>] over <N> days
```

**Display name mapping** for commit types:
- `feat` → Features
- `fix` → Fixes
- `refactor` → Refactors
- `test` → Tests
- `perf` → Performance
- `chore` → Chores
- `ci` → CI/CD
- `config` → Configuration
- `deploy` → Deployment
- `security` → Security
- Other/unrecognized → Other

Only show type sections that have commits for that date. Skip empty sections.

### Step 6: Multi-author attribution (when not filtered)

When showing all authors and there are multiple contributors:
- Add `(<author first name>)` after each commit message
- Add a contributors line at the bottom: `Contributors: Alice (N), Bob (M)`

When there's only one author, omit attribution — it's obvious.

## Guidelines

- **Git log is the source of truth** — don't embellish or infer beyond what the commits say.
- **Strip scopes for readability** — `feat(nitter): UA rotation` becomes just `UA rotation` under Features. The grouping provides enough context.
- **Merge commits excluded** — `--no-merges` keeps the output clean. The actual work commits tell the story.
- **Docs filtered by default** — most doc commits are bookkeeping. The interesting work is in feat/fix/refactor. Users can opt in with `--all`.
- **Keep it scannable** — this replaces session notes. If someone can't skim it in 30 seconds, it's too verbose.
