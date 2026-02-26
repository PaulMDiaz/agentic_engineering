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

## Verify

1. Open Cursor Settings (Cmd+Shift+J)
2. Go to **Rules**:
   - **Development tab**: AGENTS.md should appear
   - **Agent Decides section**: 8 skills listed
3. Type `/` in chat — commands should appear

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

# Clean up empty directories
rmdir ~/.cursor/commands ~/.cursor/skills 2>/dev/null
```

## Different folder path?

If your development folder isn't `~/Documents/Development/`, adjust all paths above.
For example, if you use `~/code/`:

```bash
ln -sf ~/code/agentic_engineering/AGENTS.md ~/code/AGENTS.md
```
