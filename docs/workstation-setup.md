---
summary: "How to install the Agentic Engineering playbook for Cursor, Codex, and Claude Code"
read_when: "Setting up a workstation, updating the playbook, or removing its managed files"
---

# Workstation setup

Install Agentic Engineering once. Its two public scripts manage skills, shared guidance,
and the repository Git hooks that keep both current.

Use Agentic Engineering as an independent distribution. Do not install it concurrently
with another playbook that manages the same shared-guidance paths or skill names.

## Prerequisites

- Git
- At least one supported agent with its home directory already present:
  `~/.cursor`, `~/.codex`, or `~/.claude`
- A development folder containing this clone and the repositories that should inherit its
  Cursor guidance

## Clone the repository

```bash
cd ~/Documents/Development
git clone https://github.com/PaulMDiaz/agentic_engineering.git
cd agentic_engineering
```

The installer derives the Cursor workspace from the clone's parent directory. A clone at
`~/Documents/Development/agentic_engineering` therefore manages
`~/Documents/Development/AGENTS.md`. It will not create `~/AGENTS.md` when the clone sits
directly under the account home.

## Review shared guidance

Root `AGENTS.md` applies only to this repository. `AGENTS.local.md` is the source installed
for other repositories and agent sessions. Review it before enabling guidance, especially
the path to `CODING_STANDARDS.md` if this clone does not use the documented location.

## Install

For the normal personal setup, install skills and enroll this clone as the shared-guidance
source:

```bash
./scripts/install --with-agents
```

`--with-agents` is a one-time opt-in. The installer records the choice in this clone's local
Git configuration. Later plain installs, including managed hook runs, continue syncing the
guidance links.

To install skills without shared guidance:

```bash
./scripts/install
```

You can opt in later by running `./scripts/install --with-agents` once.

The installer skips an agent when its home directory does not exist. For detected agents it
uses these destinations:

| Surface | Skills | Shared guidance |
| --- | --- | --- |
| Cursor | Symlinks in `~/.cursor/skills/` | `<clone parent>/AGENTS.md` |
| Codex | Real mirrors in `~/.codex/skills/` | `~/.codex/AGENTS.md` |
| Claude Code | Symlinks in `~/.claude/skills/` | `~/.claude/CLAUDE.md` |

The same command installs managed `post-checkout`, `post-merge`, and `post-commit` hooks in
this repository. Each hook reruns `scripts/install`, so new skills, Codex mirror updates,
and enrolled guidance links repair themselves after repository changes.

## Ownership and collisions

- Cursor and Claude Code keep existing skill paths with the same name.
- Codex treats Agentic Engineering's same-name skill directories as authoritative and
  replaces their contents. Unrelated names and `.system` remain untouched.
- Guidance sync claims a missing path or an empty placeholder. It repoints links to this
  repository's old or current guidance source.
- Guidance files with content and links to another source remain untouched. The installer
  reports every skipped collision.
- The installer refuses to use a symlink as an agent's `skills` root and refuses to replace
  an unmanaged repository Git hook.

## Verify

1. Confirm Cursor and Claude Code skill links point into this repository's `skills/`
   directory.
2. Confirm Codex has real folders at `~/.codex/skills/<skill>/SKILL.md`.
3. If guidance is enabled, confirm the three guidance destinations above point to
   `agentic_engineering/AGENTS.local.md`.
4. Confirm `.git/hooks/post-checkout`, `post-merge`, and `post-commit` exist in this clone.
5. Start a new agent session so it reloads skills and guidance.

## Update

```bash
git pull
```

The managed hook normally runs the installer after the pull. If a hook reports a warning,
run the installer directly so the error is visible:

```bash
./scripts/install
```

## Uninstall

```bash
./scripts/uninstall
```

The uninstaller removes guidance links, skill links, Codex mirrors, hooks, and the saved
guidance opt-in only when this clone owns them. It preserves user files, other playbooks'
links, unrelated skills, agent home directories, and skill-root directories.

## Different clone path

Run the same two scripts from the alternate clone. No destination arguments are needed.
Update the `CODING_STANDARDS.md` path inside `AGENTS.local.md` so the installed guidance
points to the real clone location.
