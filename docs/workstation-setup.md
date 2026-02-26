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

Cursor expects skills as folders containing `SKILL.md`. Symlink each skill folder:

```bash
# Create the global skills directory if it doesn't exist
mkdir -p ~/.cursor/skills

# Symlink each skill folder
ln -sf ~/Documents/development/agentic_engineering/skills/agent-review ~/.cursor/skills/agent-review
ln -sf ~/Documents/development/agentic_engineering/skills/diff-summary ~/.cursor/skills/diff-summary
ln -sf ~/Documents/development/agentic_engineering/skills/git-recap ~/.cursor/skills/git-recap
ln -sf ~/Documents/development/agentic_engineering/skills/implement ~/.cursor/skills/implement
ln -sf ~/Documents/development/agentic_engineering/skills/init-second-brain ~/.cursor/skills/init-second-brain
ln -sf ~/Documents/development/agentic_engineering/skills/load-second-brain ~/.cursor/skills/load-second-brain
ln -sf ~/Documents/development/agentic_engineering/skills/security-check ~/.cursor/skills/security-check
ln -sf ~/Documents/development/agentic_engineering/skills/update-second-brain ~/.cursor/skills/update-second-brain
```

Skills appear in Cursor Settings → Rules (Agent Decides section) and can be invoked with `/skill-name`.

## Step 4: Install global coding standards

```bash
# Symlink coding standards to a known location
ln -sf ~/Documents/development/agentic_engineering/CODING_STANDARDS.md ~/.cursor/CODING_STANDARDS.md
```

## Step 5: Install development-wide rules (Cursor)

Cursor reads `AGENTS.md` from parent directories. Symlink it at your development
folder root so it applies to all projects underneath:

```bash
# Symlink AGENTS.md to your development folder
ln -sf ~/Documents/Development/agentic_engineering/AGENTS.md ~/Documents/Development/AGENTS.md
```

This appears in Cursor Settings → Rules → Development and applies to all projects
under `~/Documents/Development/`.

**Note:** Adjust the path if your development folder is named differently (e.g., `~/code/`).

## Step 7: Verify

Open Cursor Settings and check:

1. **Rules** — "agentic-engineering" should appear and be enabled
2. **Skills** — all 8 skills should appear (agent-review, diff-summary, etc.)
3. **Commands** — type `/` in chat to see check, commit, implement, pr, security-check

Test in a project:
- `/check` should run the quality gate command
- `/agent-review` should invoke the skill
- Ask "read the coding standards" — it should find `~/.cursor/CODING_STANDARDS.md`

## Updating

When the playbook is updated:

```bash
cd ~/Documents/development/agentic_engineering
git pull
```

That's it. Symlinks mean every repo picks up changes immediately.

## Uninstall

To cleanly remove all global symlinks and go back to a clean slate:

```bash
# Remove global slash commands
rm -f ~/.cursor/commands/check.md
rm -f ~/.cursor/commands/commit.md
rm -f ~/.cursor/commands/implement.md
rm -f ~/.cursor/commands/pr.md
rm -f ~/.cursor/commands/security-check.md

# Remove global skills
rm -f ~/.cursor/skills/agent-review
rm -f ~/.cursor/skills/diff-summary
rm -f ~/.cursor/skills/git-recap
rm -f ~/.cursor/skills/implement
rm -f ~/.cursor/skills/init-second-brain
rm -f ~/.cursor/skills/load-second-brain
rm -f ~/.cursor/skills/security-check
rm -f ~/.cursor/skills/update-second-brain

# Remove development-wide rules and coding standards
rm -f ~/Documents/Development/AGENTS.md
rm -f ~/.cursor/CODING_STANDARDS.md

# Clean up empty directories (only removes if empty)
rmdir ~/.cursor/commands 2>/dev/null
rmdir ~/.cursor/skills 2>/dev/null
```

Per-repo AGENTS.md files can be deleted individually or left in place — they're
harmless without the global symlinks (Cursor will just not find the referenced paths).

The agentic_engineering repo itself is just a normal git clone — delete it whenever.

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
