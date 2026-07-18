---
summary: "Structure and layout of the agentic_engineering repo"
read_when: "You need to understand what lives where or where to add something new"
---
<!-- Format: ## About This Repo → ## Directory Layout (directory tree in code block) → additional ## sections as needed. Horizontal rules (---) between major sections. -->

# Architecture

## What This Repo Is

A lightweight playbook repo — mostly markdown, plus a small set of helper scripts,
shell regression tests, and GitHub Actions workflows. It is the source of truth for how PaulMDiaz projects
are built and how agents operate within them.

Two audiences:
1. **Cursor / Codex agents** — `AGENTS.md` is the canonical instruction file, and both rely on `CODING_STANDARDS.md`
2. **Humans** — reference for project conventions, security patterns, and tooling

---

## Directory Layout

> Note: this file lives in `.claude/` — the layout below shows the full repo from root.

```
agentic_engineering/
├── CLAUDE.md                        # Compatibility shim — redirects Claude-style entry points to AGENTS.md
├── AGENTS.md                        # Canonical instruction file for agents in this repo
├── CODING_STANDARDS.md              # Universal rules (git, commits, design, errors, typing, shell...)
├── tools.md                         # Tool catalog (gh, git, claude CLI, Python/TS/Shell gates)
├── .gitignore
│
├── skills/                          # Agent Skills (folder per skill, each with SKILL.md)
│   ├── agent-review/SKILL.md        # Review a branch/PR — inline findings, no file output
│   ├── audit-second-brain/SKILL.md  # Full conventions verification and legacy migration
│   ├── check-ci/SKILL.md            # Local CI-equivalent verification with structured output
│   ├── diff-summary/SKILL.md        # Walk through a diff — what it does and how
│   ├── git-recap/SKILL.md           # Summarize recent work from git log (replaces NOTES.md)
│   ├── grill-with-docs/SKILL.md     # Stress-test plans against language, code, and docs
│   ├── implement/SKILL.md           # Methodical task implementation — understand, plan, implement, verify
│   ├── init-second-brain/SKILL.md   # Bootstrap .claude/ for a project
│   ├── load-second-brain/SKILL.md   # Load context and run the lightweight trust gate
│   ├── pr-review-triage/SKILL.md    # Triage GitHub PR comments into a checklist
│   ├── security-check/SKILL.md      # Security review — what to check, how to report
│   ├── sync-second-brain/SKILL.md   # Sync .claude/ on a dedicated second-brain worktree
│   ├── update-second-brain/SKILL.md # Source-aware maintenance during ordinary agent work
│   └── work-items-analysis/SKILL.md # Analyze Jira, GitHub, and local git work items
│
├── docs/
│   ├── second-brain-hooks.md        # Organic maintenance and full-audit workflow
│   └── workstation-setup.md         # Install playbook globally via symlinks
│
├── scripts/
│   ├── install-skill-hooks          # Installs repo-local git hooks that sync workstation skills
│   ├── sync-codex-skills            # Mirrors repo skills into ~/.codex/skills and can uninstall repo-managed mirrors
│   ├── sync-cursor-skills           # Syncs or removes repo-managed ~/.cursor skill symlinks
│   └── sync-workstation-skills      # Runs both workstation sync flows from one entry point
│
├── tests/
│   ├── run                          # Zero-dependency shell test runner
│   ├── helpers/assert.sh            # Small assertion helpers shared by test files
│   ├── install-skill-hooks.bash     # Regression tests for managed git hook installation
│   ├── skills.bash                  # Skill inventory and second-brain contract checks
│   ├── sync-cursor-skills.bash      # Regression tests for Cursor skill symlink sync
│   ├── sync-codex-skills.bash       # Regression tests for Codex skill mirroring and cleanup
│   └── sync-workstation-skills.bash # Integration test for the one-command workstation sync wrapper
│
├── .claude/
│   └── ...                          # Second brain knowledge files — see this file (.claude/ARCHITECTURE.md)
│
└── .github/workflows/
    ├── ci.yml                       # Shell regression tests plus docs/repo hygiene checks
    └── cleanup-review-artifacts.yml # Auto-deletes *_review.md from main after merge
```

---

## How CODING_STANDARDS.md Is Used in Other Repos

```
# In other project's CLAUDE.md:
@path/to/agentic_engineering/CODING_STANDARDS.md
```

Or copy locally and reference. The `@` import remains useful for Claude-style entry
points, while Cursor reads it as part of `CLAUDE.md` context when present.

---

## Doc Format Convention

All files under `docs/` carry YAML front-matter:

```yaml
---
summary: "One-line description"
read_when: "Condition that triggers loading this doc"
---
```

Skills under `skills/` carry name + description front-matter in a format compatible with current agent skill loaders.
