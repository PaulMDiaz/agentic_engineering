---
summary: "How to install the agentic engineering playbook on a workstation so all repos get coding standards, skills, and slash commands"
read_when: "Setting up a new machine or onboarding the playbook to a work laptop"
---

# Workstation Setup

Install the agentic engineering playbook once so every repo on your machine gets access to
coding standards, skills, and slash commands — no per-repo configuration needed.

## Prerequisites

- Git installed
- Cursor IDE (primary) and/or Claude Code
- A `~/Documents/development/` folder (or equivalent) where repos live

## Step 1: Clone the repo

```bash
cd ~/Documents/development
git clone https://github.com/PaulMDiaz/agentic_engineering.git
```

Your folder structure should look like:

```
~/Documents/development/
├── agentic_engineering/      # ← the playbook (shared infrastructure)
├── osint-alert-agent/        # ← a project repo
├── work-project-a/           # ← another project repo
└── work-project-b/           # ← etc.
```

## Step 2: Install global slash commands (Cursor)

Cursor reads slash commands from `~/.cursor/commands/` (global) and
`.cursor/commands/` (per-project). Symlink the global ones once:

```bash
# Create the global commands directory if it doesn't exist
mkdir -p ~/.cursor/commands

# Symlink each command
ln -sf ~/Documents/development/agentic_engineering/.claude/commands/check.md ~/.cursor/commands/check.md
ln -sf ~/Documents/development/agentic_engineering/.claude/commands/commit.md ~/.cursor/commands/commit.md
ln -sf ~/Documents/development/agentic_engineering/.claude/commands/implement.md ~/.cursor/commands/implement.md
ln -sf ~/Documents/development/agentic_engineering/.claude/commands/pr.md ~/.cursor/commands/pr.md
ln -sf ~/Documents/development/agentic_engineering/.claude/commands/security-check.md ~/.cursor/commands/security-check.md
```

Now `/check`, `/commit`, `/implement`, `/pr`, and `/security-check` are available in
every Cursor project.

## Step 3: Install global skills (symlink)

Skills live in the playbook's `skills/` folder. There's no global skills directory in
Cursor, so we make them available via a known path that AGENTS.md can reference:

```bash
# Create a global skills directory
mkdir -p ~/.cursor/skills

# Symlink the skills folder
ln -sf ~/Documents/development/agentic_engineering/skills ~/.cursor/skills/agentic
```

Now skills are available at `~/.cursor/skills/agentic/agent-review.md`, etc.

## Step 4: Install global coding standards

```bash
# Symlink coding standards to a known location
ln -sf ~/Documents/development/agentic_engineering/CODING_STANDARDS.md ~/.cursor/CODING_STANDARDS.md
```

## Step 5: Per-repo AGENTS.md (one-time, per project)

Each repo needs a small `AGENTS.md` at its root that points to the global playbook.
Create this file in each project:

```markdown
# Coding Standards

Read `~/.cursor/CODING_STANDARDS.md` before doing any coding work.

## Skills

The following skills are available at `~/.cursor/skills/agentic/`:

| Skill | File | Use when |
|-------|------|----------|
| agent-review | agent-review.md | Reviewing a PR or branch |
| diff-summary | diff-summary.md | Understanding what a diff does |
| git-recap | git-recap.md | Summarizing recent work |
| init-second-brain | init-second-brain.md | Bootstrapping .claude/ for this project |
| load-second-brain | load-second-brain.md | Loading project context at session start |
| update-second-brain | update-second-brain.md | Recording session work into .claude/ |

To use a skill: "Run the agent-review skill from ~/.cursor/skills/agentic/agent-review.md"

## Knowledge Base

If this project has a `.claude/` directory, run `load-second-brain` at the start of
non-trivial sessions.

Update DECISIONS.md when making decisions, CODE_POINTERS.md when adding files/functions.
```

### Quick setup script

To create the AGENTS.md in a project:

```bash
# From inside any project repo
cp ~/Documents/development/agentic_engineering/docs/templates/AGENTS-project.md ./AGENTS.md
```

## Step 6: Verify

Open any project in Cursor and test:

1. Type `/` — you should see check, commit, implement, pr, security-check
2. Ask Cursor to "run the agent-review skill" — it should find and read the file
3. Ask Cursor to read CODING_STANDARDS.md — it should find the global copy

## Updating

When the playbook is updated:

```bash
cd ~/Documents/development/agentic_engineering
git pull
```

That's it. Symlinks mean every repo picks up changes immediately.

## Alternative: Per-repo symlinks (no global install)

If you prefer per-repo setup instead of global symlinks:

```bash
# From inside a project repo
ln -sf ../agentic_engineering/CODING_STANDARDS.md ./CODING_STANDARDS.md
ln -sf ../agentic_engineering/skills ./skills-shared

# Create .cursor/commands/ with symlinks
mkdir -p .cursor/commands
for cmd in check commit implement pr security-check; do
  ln -sf ../../agentic_engineering/.claude/commands/$cmd.md .cursor/commands/$cmd.md
done
```

This works if all repos are siblings in the same development folder. Add the symlinks
to `.gitignore` so they don't get committed.
