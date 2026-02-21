---
summary: "Structure and layout of the agentic_engineering repo"
read_when: "You need to understand what lives where or where to add something new"
---

# Architecture

## What This Repo Is

A pure markdown playbook — no code, no build system, no tests. It is the
source of truth for how PaulMDiaz projects are built and how agents operate
within them.

Two audiences:
1. **Claude Code / Cursor** — loads `CLAUDE.md` automatically; pulls in `CODING_STANDARDS.md` via `@` import
2. **Humans** — reference for project conventions, security patterns, and tooling

---

## Directory Layout

```
agentic_engineering/
├── CLAUDE.md                        # Entry point — auto-loaded by Claude Code/Cursor
├── CODING_STANDARDS.md              # Universal rules (git, commits, design, errors, typing, shell...)
├── tools.md                         # Tool catalog (gh, git, claude CLI, Python/TS/Shell gates)
├── .gitignore
│
├── skills/                          # Reusable agent skill prompts
│   ├── init-second-brain.md         # Bootstrap .claude/ for a project
│   ├── load-second-brain.md         # Load .claude/ context at session start
│   └── update-second-brain.md       # Record session work into .claude/
│
├── docs/
│   ├── llm-classifier-security.md   # Validated output pattern, model selection for classifiers
│   ├── prompt-injection-defense.md  # XML delimiters, output clamping, defense-in-depth stack
│   ├── second-brain-hooks.md        # Wiring session-start/end hooks (Claude Code + Cursor)
│   └── slash-commands/
│       ├── README.md                # Index of all available slash commands
│       ├── check.md                 # /check — full quality gate
│       ├── commit.md                # /commit — conventional commit
│       ├── implement.md             # /implement — methodical task flow
│       ├── pr.md                    # /pr — create pull request
│       └── security-check.md       # /security-check — pre-ship security review
│
├── scripts/
│   └── committer                    # Stage + commit helper; enforces Conventional Commits
│
└── .github/workflows/
    └── cleanup-review-artifacts.yml # Auto-deletes *_review.md from main after merge
```

---

## How CODING_STANDARDS.md Is Used in Other Repos

```
# In other project's CLAUDE.md:
@path/to/agentic_engineering/CODING_STANDARDS.md
```

Or copy locally and reference. The `@` import is Claude Code's native include
mechanism — Cursor reads it as part of CLAUDE.md context.

---

## Doc Format Convention

All files under `docs/` carry YAML front-matter:

```yaml
---
summary: "One-line description"
read_when: "Condition that triggers loading this doc"
---
```

Skills under `skills/` carry name + description front-matter (Claude Code skill format).
