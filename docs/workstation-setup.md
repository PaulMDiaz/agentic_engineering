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

for skill in agent-review check-ci diff-summary git-recap implement init-second-brain load-second-brain security-check update-second-brain; do
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

## Step 6: Install Codex skills (optional, macOS)

Codex skill indexing may ignore pure symlinked skill folders. The reliable setup is:

- keep source-of-truth skills in `~/Documents/Development/agentic_engineering/skills`
- mirror them into **real folders** under `~/.codex/skills/<skill>/SKILL.md`
- run sync automatically when Codex launches

Create sync scripts and LaunchAgent:

```bash
mkdir -p ~/.codex/scripts
mkdir -p ~/Library/LaunchAgents

cat > ~/.codex/scripts/sync-codex-skills.sh <<'EOF'
#!/usr/bin/env bash
set -euo pipefail

SRC="$HOME/Documents/Development/agentic_engineering/skills"
DST="$HOME/.codex/skills"

for skill in agent-review check-ci diff-summary git-recap implement init-second-brain load-second-brain security-check update-second-brain; do
  mkdir -p "$DST/$skill"
  rsync -a --delete "$SRC/$skill/" "$DST/$skill/"
done
EOF

cat > ~/.codex/scripts/sync-when-codex-running.sh <<'EOF'
#!/usr/bin/env bash
set -euo pipefail

last_pid=""
while true; do
  pid="$(pgrep -x Codex || true)"
  if [[ -n "$pid" && "$pid" != "$last_pid" ]]; then
    "$HOME/.codex/scripts/sync-codex-skills.sh"
    last_pid="$pid"
  elif [[ -z "$pid" ]]; then
    last_pid=""
  fi
  sleep 2
done
EOF

cat > ~/Library/LaunchAgents/com.codex-skill-sync.plist <<'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
  <dict>
    <key>Label</key><string>com.codex-skill-sync</string>
    <key>ProgramArguments</key>
    <array>
      <string>/bin/bash</string>
      <string>-lc</string>
      <string>$HOME/.codex/scripts/sync-when-codex-running.sh</string>
    </array>
    <key>RunAtLoad</key><true/>
    <key>KeepAlive</key><true/>
    <key>StandardOutPath</key><string>/tmp/codex-skill-sync.out</string>
    <key>StandardErrorPath</key><string>/tmp/codex-skill-sync.err</string>
  </dict>
</plist>
EOF

chmod +x ~/.codex/scripts/sync-codex-skills.sh
chmod +x ~/.codex/scripts/sync-when-codex-running.sh
```

Load the LaunchAgent and run one initial sync:

```bash
launchctl unload ~/Library/LaunchAgents/com.codex-skill-sync.plist 2>/dev/null || true
launchctl load ~/Library/LaunchAgents/com.codex-skill-sync.plist
~/.codex/scripts/sync-codex-skills.sh
```

Notes:
- `~/.codex/skills/.system/*` can remain symlinks.
- Codex should read mirrored **real folders** at `~/.codex/skills/<skill>/SKILL.md`.
- Restart Codex to refresh the session skill index.

## Verify

1. Open Cursor Settings (Cmd+Shift+J)
2. Go to **Rules**:
   - **Development tab**: AGENTS.md should appear
   - **Agent Decides section**: 9 skills listed
3. Type `/` in chat — commands should appear
4. (Codex) run `ls -l ~/.codex/AGENTS.md` and confirm it points to `agentic_engineering/AGENTS.md`
5. (Codex skills) run `find ~/.codex/skills -maxdepth 2 -name SKILL.md` and confirm paths look like `~/.codex/skills/<skill>/SKILL.md`

## Updating

```bash
cd ~/Documents/Development/agentic_engineering
git pull
```

Cursor symlinks apply immediately. For Codex, changes propagate on the next sync (or run `~/.codex/scripts/sync-codex-skills.sh` manually).

## Uninstall

```bash
# Commands
rm -f ~/.cursor/commands/{check,commit,implement,pr,security-check}.md

# Skills
rm -f ~/.cursor/skills/{agent-review,check-ci,diff-summary,git-recap,implement,init-second-brain,load-second-brain,security-check,update-second-brain}

# Rules
rm -f ~/Documents/Development/AGENTS.md

# Codex
rm -f ~/.codex/AGENTS.md
rm -f ~/.codex/skills/{agent-review,check-ci,diff-summary,git-recap,implement,init-second-brain,load-second-brain,security-check,update-second-brain}
rm -f ~/.codex/scripts/sync-codex-skills.sh ~/.codex/scripts/sync-when-codex-running.sh
launchctl unload ~/Library/LaunchAgents/com.codex-skill-sync.plist 2>/dev/null || true
rm -f ~/Library/LaunchAgents/com.codex-skill-sync.plist

# Clean up empty directories
rmdir ~/.cursor/commands ~/.cursor/skills ~/.codex/scripts ~/.codex/skills ~/.codex 2>/dev/null
```

## Different folder path?

If your development folder isn't `~/Documents/Development/`, adjust all paths above.
For example, if you use `~/code/`:

```bash
ln -sf ~/code/agentic_engineering/AGENTS.md ~/code/AGENTS.md
ln -sf ~/code/agentic_engineering/AGENTS.md ~/.codex/AGENTS.md
mkdir -p ~/.codex/skills
mkdir -p ~/.codex/scripts
# set SRC in ~/.codex/scripts/sync-codex-skills.sh to ~/code/agentic_engineering/skills
~/.codex/scripts/sync-codex-skills.sh
```
