---
summary: "Create a pull request with good description"
read_when: "Ready to open a PR"
---

# /pr

Create a well-described pull request.

## Pre-flight
1. All checks passing (`/check`)
2. CI green (`gh run list`)
3. Branch pushed

## Process
1. `gh pr view` — check if PR already exists
2. Summarize changes: what + why
3. `gh pr create --title "type(scope): description" --body "..."`

## PR Body Template
```
## Summary
Brief description of what changed and why.

## Changes
- Key change 1
- Key change 2

## Testing
How this was tested.

## Notes
Anything reviewers should know.
```

## Rules
- Title follows conventional commit format
- Link related issues: `Closes #123`
- Keep PRs focused — one concern per PR
