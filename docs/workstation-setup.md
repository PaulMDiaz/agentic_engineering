---
summary: "How to install the agentic engineering playbook on a workstation so all repos get coding standards, skills, and slash commands"
read_when: "Setting up a new machine or onboarding the playbook to a work laptop"
---

# Workstation Setup

Install the agentic engineering playbook once. All projects in your development
folder get coding standards, skills, and slash commands — no per-repo setup needed.

## Prerequisites

- Git installed
- Cursor IDE
- Codex CLI (optional, if you use Codex agents)
- A development folder where your repos live (e.g., `~/Documents/Development/`)

## Step 1: Clone the repo

Clone into your development folder:

```bash
cd ~/Documents/Development
git clone https://github.com/PaulMDiaz/agentic_engineering.git
```

Your folder structure:

```
~/Documents/Development/
├── agentic_engineering/      # ← the playbook
├── project-a/                # ← your repos
├── project-b/
└── ...
```

## Step 2: Install slash commands

Symlink commands to `~/.cursor/commands/`:

```bash
mkdir -p ~/.cursor/commands

for cmd in check commit implement pr security-check; do
  ln -sf ~/Documents/Development/agentic_engineering/.claude/commands/$cmd.md ~/.cursor/commands/$cmd.md
done
```

Commands available: `/check`, `/commit`, `/implement`, `/pr`, `/security-check`

## Step 3: Install skills

Symlink skill folders to `~/.cursor/skills/`:

```bash
mkdir -p ~/.cursor/skills

for skill in agent-review diff-summary git-recap implement init-second-brain load-second-brain security-check update-second-brain; do
  ln -sf ~/Documents/Development/agentic_engineering/skills/$skill ~/.cursor/skills/$skill
done
```

Skills appear in Cursor Settings → Rules → Agent Decides.

## Step 4: Install development-wide rules

Symlink `AGENTS.md` to your development folder root. Cursor picks it up and applies
it to all projects underneath:

```bash
ln -sf ~/Documents/Development/agentic_engineering/AGENTS.md ~/Documents/Development/AGENTS.md
```

Shows in Cursor Settings → Rules → Development.

## Step 5: Install Codex development-wide rules (optional)

If you use Codex agents, symlink the same `AGENTS.md` into `~/.codex/`:

```bash
mkdir -p ~/.codex
ln -sf ~/Documents/Development/agentic_engineering/AGENTS.md ~/.codex/AGENTS.md
```

This makes Codex pick up the same coding standards and workflow guidance.

## Step 6: Install Codex system-level skills (optional)

If you want skills at Codex system scope, symlink **skill directories** (not individual markdown files) into `~/.codex/.system/`. Each target should look like `~/.codex/.system/<skill-name>/SKILL.md`.

```bash
mkdir -p ~/.codex/.system

for skill in agent-review diff-summary git-recap implement init-second-brain load-second-brain security-check update-second-brain; do
  # Source is a directory that contains SKILL.md
  ln -sfn ~/Documents/Development/agentic_engineering/skills/$skill ~/.codex/.system/$skill
done
```

This mirrors the Cursor skill setup so Codex can discover the same skill set.

## Verify

1. Open Cursor Settings (Cmd+Shift+J)
2. Go to **Rules**:
   - **Development tab**: AGENTS.md should appear
   - **Agent Decides section**: 8 skills listed
3. Type `/` in chat — commands should appear
4. (Codex) run `ls -l ~/.codex/AGENTS.md` and confirm it points to `agentic_engineering/AGENTS.md`
5. (Codex skills) run `find ~/.codex/.system -maxdepth 2 -name SKILL.md` and confirm paths look like `~/.codex/.system/<skill>/SKILL.md`

## Updating

```bash
cd ~/Documents/Development/agentic_engineering
git pull
```

Symlinks mean changes apply immediately.

## Uninstall

```bash
# Commands
rm -f ~/.cursor/commands/{check,commit,implement,pr,security-check}.md

# Skills
rm -f ~/.cursor/skills/{agent-review,diff-summary,git-recap,implement,init-second-brain,load-second-brain,security-check,update-second-brain}

# Rules
rm -f ~/Documents/Development/AGENTS.md

# Codex
rm -f ~/.codex/AGENTS.md
rm -f ~/.codex/.system/{agent-review,diff-summary,git-recap,implement,init-second-brain,load-second-brain,security-check,update-second-brain}

# Clean up empty directories
rmdir ~/.cursor/commands ~/.cursor/skills ~/.codex/.system ~/.codex 2>/dev/null
```

## Different folder path?

If your development folder isn't `~/Documents/Development/`, adjust all paths above.
For example, if you use `~/code/`:

```bash
ln -sf ~/code/agentic_engineering/AGENTS.md ~/code/AGENTS.md
ln -sf ~/code/agentic_engineering/AGENTS.md ~/.codex/AGENTS.md
mkdir -p ~/.codex/.system
ln -sfn ~/code/agentic_engineering/skills/agent-review ~/.codex/.system/agent-review
# repeat for other skills as needed
```
