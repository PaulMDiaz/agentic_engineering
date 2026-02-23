---
summary: "How the second brain integrates with Claude Code and Cursor session lifecycle"
read_when: "Setting up second brain for a new project or tool"
---

# Second Brain Hooks

## Session start

Claude Code and Cursor auto-load `CLAUDE.md` at the start of every session. The
`init-second-brain` skill creates this file with a note to run `load-second-brain`
explicitly when context is needed.

**No hook configuration required.** Context is loaded on demand — not automatically.

Research ([Gloaguen et al., 2026](https://arxiv.org/abs/2602.11988)) shows that
automatically loading repository context files reduces task success rates and
increases inference cost. Load context explicitly when the session calls for it.

## Session end

No automated stop hook. At the end of any substantial session, say:

> "update second brain"

This triggers `update-second-brain` manually. Human-in-the-loop is intentional.

## Platform summary

| Feature | Claude Code | Cursor |
|---|---|---|
| Auto-load CLAUDE.md on start | ✅ | ✅ |
| Context loading | On demand (`load-second-brain`) | On demand (`load-second-brain`) |
| Session end update | Manual ("update second brain") | Manual ("update second brain") |
