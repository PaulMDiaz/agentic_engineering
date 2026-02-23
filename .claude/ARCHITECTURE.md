---
summary: "Structure and layout of the agentic_engineering repo"
read_when: "You need to understand what lives where or where to add something new"
---
<!-- Format: ## What This System Does → ## Component Map (directory tree in code block) → ## Data Flow (flow diagram in code block) → additional ## sections as needed. Horizontal rules (---) between major sections. -->

# Architecture

## What This Repo Is

A pure markdown playbook — no code, no build system, no tests. It is the
source of truth for how PaulMDiaz projects are built and how agents operate
within them.

Two audiences:
1. **Claude Code / Cursor / Codex** — Claude Code and Cursor load `CLAUDE.md` automatically; Codex reads `AGENTS.md`; all three reference `CODING_STANDARDS.md`
2. **Humans** — reference for project conventions, security patterns, and tooling

---

## Directory Layout

> Note: this file lives in `.claude/` — the layout below shows the full repo from root.

```
agentic_engineering/
├── CLAUDE.md                        # Entry point — auto-loaded by Claude Code/Cursor
├── AGENTS.md                        # Entry point — read by Codex and AGENTS.md-aware agents
├── CODING_STANDARDS.md              # Universal rules (git, commits, design, errors, typing, shell...)
├── tools.md                         # Tool catalog (gh, git, claude CLI, Python/TS/Shell gates)
├── .gitignore
│
├── skills/                          # Reusable agent skill prompts (invoke by name, not slash command)
│   ├── init-second-brain.md         # Bootstrap .claude/ for a project
│   ├── load-second-brain.md         # Load .claude/ context at session start
│   ├── update-second-brain.md       # Record session work into .claude/
│   ├── agent-review.md              # Review a branch/PR — inline findings, no file output
│   └── diff-summary.md              # Walk through a diff — what it does and how
│
├── docs/
│   ├── llm-classifier-security.md   # Validated output pattern, model selection for classifiers
│   ├── prompt-injection-defense.md  # XML delimiters, output clamping, defense-in-depth stack
│   ├── second-brain-hooks.md        # Wiring session-start/end hooks (Claude Code + Cursor)
│   └── slash-commands/
│       └── README.md                # Index of slash commands and skills
│
├── scripts/
│   └── committer                    # Stage + commit helper; enforces Conventional Commits
│
├── .claude/
│   ├── commands/                    # Slash commands — auto-loaded by Claude Code/Cursor
│   │   ├── check.md                 # /check — full quality gate
│   │   ├── commit.md                # /commit — conventional commit
│   │   ├── implement.md             # /implement — methodical task flow
│   │   ├── pr.md                    # /pr — create pull request
│   │   └── security-check.md       # /security-check — pre-ship security review
│   └── ...                          # Second brain knowledge files — see this file (.claude/ARCHITECTURE.md)
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
