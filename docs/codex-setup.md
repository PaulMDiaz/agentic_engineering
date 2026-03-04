# Codex Skill Sync On Launch (macOS)

This setup keeps your skills authored in:

`/Users/pauldiaz/Documents/Development/agentic_engineering/skills`

and mirrors them into real folders under:

`/Users/pauldiaz/.codex/skills`

so Codex can index them each time it starts.

## 1. Create sync scripts and LaunchAgent

```bash
mkdir -p /Users/pauldiaz/.codex/scripts
mkdir -p /Users/pauldiaz/Library/LaunchAgents

cat > /Users/pauldiaz/.codex/scripts/sync-codex-skills.sh <<'EOF'
#!/usr/bin/env bash
set -euo pipefail

SRC="/Users/pauldiaz/Documents/Development/agentic_engineering/skills"
DST="/Users/pauldiaz/.codex/skills"

for skill in agent-review diff-summary git-recap implement init-second-brain load-second-brain security-check update-second-brain; do
  mkdir -p "$DST/$skill"
  rsync -a --delete "$SRC/$skill/" "$DST/$skill/"
done
EOF

cat > /Users/pauldiaz/.codex/scripts/sync-when-codex-running.sh <<'EOF'
#!/usr/bin/env bash
set -euo pipefail

last_pid=""
while true; do
  pid="$(pgrep -x Codex || true)"
  if [[ -n "$pid" && "$pid" != "$last_pid" ]]; then
    /Users/pauldiaz/.codex/scripts/sync-codex-skills.sh
    last_pid="$pid"
  elif [[ -z "$pid" ]]; then
    last_pid=""
  fi
  sleep 2
done
EOF

cat > /Users/pauldiaz/Library/LaunchAgents/com.pauldiaz.codex-skill-sync.plist <<'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
  <dict>
    <key>Label</key><string>com.pauldiaz.codex-skill-sync</string>
    <key>ProgramArguments</key>
    <array>
      <string>/bin/bash</string>
      <string>/Users/pauldiaz/.codex/scripts/sync-when-codex-running.sh</string>
    </array>
    <key>RunAtLoad</key><true/>
    <key>KeepAlive</key><true/>
    <key>StandardOutPath</key><string>/tmp/codex-skill-sync.out</string>
    <key>StandardErrorPath</key><string>/tmp/codex-skill-sync.err</string>
  </dict>
</plist>
EOF

chmod +x /Users/pauldiaz/.codex/scripts/sync-codex-skills.sh
chmod +x /Users/pauldiaz/.codex/scripts/sync-when-codex-running.sh
```
## Load the LaunchAgent
```
launchctl unload /Users/pauldiaz/Library/LaunchAgents/com.pauldiaz.codex-skill-sync.plist 2>/dev/null || true
launchctl load /Users/pauldiaz/Library/LaunchAgents/com.pauldiaz.codex-skill-sync.plist
```
## Run one initial sync now
```
/Users/pauldiaz/.codex/scripts/sync-codex-skills.sh
```
## verify 
```
launchctl list | rg 'com\.pauldiaz\.codex-skill-sync'
for skill in agent-review diff-summary git-recap implement init-second-brain load-second-brain security-check update-second-brain; do
  test -f "/Users/pauldiaz/.codex/skills/$skill/SKILL.md" && echo "OK $skill"
done
```
## important note
```~/.codex/skills/.system/*``` can remain symlinks.
Your mirrored real folders are ```~/.codex/skills/<skill-name>/.```
Restart Codex to refresh the session skill index.