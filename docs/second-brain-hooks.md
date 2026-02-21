---
summary: "How to wire session-start and session-end hooks for the second brain across Claude Code, Cursor, and OpenClaw"
read_when: "Setting up second brain automation for a new tool or environment"
---

# Second Brain Hooks

The second brain skills (`init-second-brain`, `load-second-brain`, `update-second-brain`) are
tool-agnostic — plain markdown, no platform APIs. This doc covers how to wire session-start
and session-end automation for each platform.

## How it works

| Event | Mechanism | All platforms |
|---|---|---|
| Session start | Instruction file auto-loaded | CLAUDE.md (Claude Code / Cursor) or AGENTS.md (OpenClaw) |
| Session end | Platform-specific (see below) | — |

Session start is already handled: `init-second-brain` creates a `CLAUDE.md` that tells the
agent to load `.claude/` files at the start of every non-trivial session. No hook needed.

Session end is where platforms diverge.

---

## Claude Code

### Session start (no config needed)

Claude Code auto-loads `CLAUDE.md` at the start of every session. The `init-second-brain`
skill creates this file with the load instruction built in. Nothing to configure.

### Session end — Stop hook

Claude Code fires a `Stop` event when the agent finishes responding. Wire it to write a
marker file; the next session picks it up and runs the update before doing anything else.

**Step 1: Create the hook script**

```bash
mkdir -p ~/.claude/hooks
cat > ~/.claude/hooks/second-brain-stop.sh << 'EOF'
#!/usr/bin/env bash
# Fires when Claude Code stops. Marks that second brain needs updating.
CLAUDE_DIR="$(pwd)/.claude"
if [ -d "$CLAUDE_DIR" ]; then
  date -u +"%Y-%m-%dT%H:%M:%SZ" > "$CLAUDE_DIR/.pending-update"
fi
exit 0
EOF
chmod +x ~/.claude/hooks/second-brain-stop.sh
```

**Step 2: Register in `~/.claude/settings.json`**

Add to your existing settings (merge with `PreToolUse` etc. if already present):

```json
{
  "hooks": {
    "Stop": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "~/.claude/hooks/second-brain-stop.sh",
            "timeout": 5
          }
        ]
      }
    ]
  }
}
```

**Step 3: Add pending-update check to `CLAUDE.md` template**

`init-second-brain` already creates a `CLAUDE.md`. Add this section to its template (or
manually add to existing projects):

```markdown
## Session Start Checklist

1. If `.claude/.pending-update` exists:
   - Run the `update-second-brain` skill to record the previous session
   - Delete `.claude/.pending-update`
2. If this is a non-trivial session, run `load-second-brain` to load full context
```

Now the flow is:
```
Session ends → Stop hook writes .pending-update
Next session starts → CLAUDE.md noticed .pending-update → runs update-second-brain → deletes marker
```

### Fallback — manual

If you prefer not to use the Stop hook, add this reminder to `CLAUDE.md`:

```markdown
> Before ending any session: say "update second brain" to record what we worked on.
```

---

## Cursor

Cursor auto-loads `.cursorrules` and `CLAUDE.md` from the project root. Session end has
no native hook.

### Session start (no config needed)

Same as Claude Code — `CLAUDE.md` auto-loads. `init-second-brain` handles this.

### Session end — slash command + cursorrules reminder

**Step 1: Add a reminder to `.cursorrules`**

```
# Second Brain
At the end of any substantial work session, always run /update-second-brain
before closing the conversation.
```

**Step 2: Add the slash command**

Create `.claude/commands/update-second-brain.md` in your project (the `init-second-brain`
skill creates the `commands/` directory for this purpose):

```markdown
Run the update-second-brain skill: review what we worked on this session and
update .claude/NOTES.md and any other knowledge files that changed.
```

Cursor picks up slash commands from `.claude/commands/` automatically. Type
`/update-second-brain` at end of session.

### Note on `.pending-update` marker

If you also use Claude Code on the same project, the Stop hook will write
`.pending-update`. Cursor will ignore it (no Stop hook) but Claude Code will
pick it up correctly next session. No conflict.

---

## OpenClaw

### Session start — `agent:bootstrap`

Enable the bundled `bootstrap-extra-files` hook to inject `.claude/` knowledge files
into the agent context automatically:

```bash
openclaw hooks enable bootstrap-extra-files
```

Then configure it in `openclaw.json` to include the project's `.claude/` files:

```json
{
  "hooks": {
    "bootstrapExtraFiles": {
      "patterns": [".claude/ARCHITECTURE.md", ".claude/NOTES.md", ".claude/BACKLOG.md"]
    }
  }
}
```

### Session end — `command:new`

Wire the `session-memory` hook (already bundled) to trigger update-second-brain when
`/new` is issued:

```bash
openclaw hooks enable session-memory
```

This fires on `command:new` — when you type `/new` to reset the session, it saves context
before clearing.

### Future: `session:start` / `session:end`

These events are listed as **planned** in the OpenClaw docs. When they ship, replace
the `agent:bootstrap` + `command:new` pair with direct event bindings.

---

## Platform comparison

| Feature | Claude Code | Cursor | OpenClaw |
|---|---|---|---|
| Auto-load on start | ✅ CLAUDE.md | ✅ CLAUDE.md / .cursorrules | ✅ AGENTS.md |
| Automatic end-of-session update | ✅ Stop hook + marker | ❌ Manual / slash command | ⚠️ `/new` only |
| Zero-config start | ✅ | ✅ | ✅ |
| True session:end event | Not needed (Stop works) | ❌ | 🗓 Planned |

---

## Adding to new projects

`init-second-brain` handles all project-side setup (CLAUDE.md, .claude/ structure,
commands/). The only global one-time setup is:

- **Claude Code**: add the Stop hook to `~/.claude/settings.json` once
- **Cursor**: add the `.cursorrules` reminder once per project
- **OpenClaw**: `openclaw hooks enable bootstrap-extra-files session-memory` once
