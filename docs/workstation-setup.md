---
summary: "How to install the agentic engineering playbook on a workstation so all repos get coding standards and skills"
read_when: "Setting up a new machine or onboarding the playbook to a work laptop"
---

# Workstation Setup

Install the agentic engineering playbook once. All projects in your development
folder get coding standards and skills — no per-repo setup needed.

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

## Step 2: Install skills

Create the initial Cursor skill symlinks:

```bash
mkdir -p ~/.cursor/skills
~/Documents/Development/agentic_engineering/scripts/sync-cursor-skills
```

Notes:
- Cursor reads skill folders through symlinks in `~/.cursor/skills`.
- Existing linked skills update immediately because the targets are live.
- New skill folders need another sync pass to create the new symlink.

Skills appear in Cursor Customize → Skills.

## Step 3: Install skill sync hooks in the playbook repo

Install repo-local git hooks so sync runs automatically whenever this source-of-truth repo
changes branch, merges, or records a new commit:

```bash
cd ~/Documents/Development/agentic_engineering
./scripts/install-skill-hooks
./scripts/sync-workstation-skills
```

Notes:
- Hooks are installed only in `agentic_engineering/.git/hooks`, which is sufficient because this repo is the source of truth for the `skills/` directory.
- `post-checkout`, `post-merge`, and `post-commit` all call `scripts/sync-workstation-skills`.
- Hook-triggered sync warns on failure but does not block the git operation. Running the sync scripts yourself still fails loudly.
- Cursor uses symlinks. Codex uses mirrored real folders.

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
- run sync from this repo's git hooks or manually when needed

Create the initial mirrored folders:

```bash
mkdir -p ~/.codex/scripts
~/Documents/Development/agentic_engineering/scripts/sync-codex-skills
```

Notes:
- `~/.codex/skills/.system/*` can remain symlinks.
- Codex should read mirrored **real folders** at `~/.codex/skills/<skill>/SKILL.md`.
- The playbook repo hooks keep the mirror fresh whenever `agentic_engineering` changes locally.
- Codex cleanup only removes mirrored skills previously created by this repo. It preserves `~/.codex/skills/.system` and unrelated custom skills.
- If a custom Codex skill uses the same folder name as one of this repo's skills, sync treats the repo skill as authoritative and refreshes that folder.
- Restart Codex to refresh the session skill index.

## Verify

1. Open Cursor Customize (Cmd+Shift+J)
2. Go to **Skills** and confirm 14 skills are listed
3. Go to **Rules** and confirm AGENTS.md appears in the Development tab
4. Type `/` in Agent chat and confirm skills such as `implement` and `security-check` are available
5. Run `find .git/hooks -maxdepth 1 \\( -name post-checkout -o -name post-commit -o -name post-merge \\) -type f` from `agentic_engineering/` and confirm the three hook files exist
6. (Codex) run `ls -l ~/.codex/AGENTS.md` and confirm it points to `agentic_engineering/AGENTS.md`
7. (Codex skills) run `find ~/.codex/skills -maxdepth 2 -name SKILL.md` and confirm paths look like `~/.codex/skills/<skill>/SKILL.md`

## Updating

```bash
cd ~/Documents/Development/agentic_engineering
git pull
```

The repo hooks should run automatically after `git pull`, branch switches, and new local commits in `agentic_engineering`. Manual fallback:

```bash
cd ~/Documents/Development/agentic_engineering
./scripts/sync-workstation-skills
```

## Uninstall

```bash
# Skills
rm -f ~/.cursor/skills/{agent-review,audit-second-brain,check-ci,diff-summary,git-recap,grill-with-docs,implement,init-second-brain,load-second-brain,pr-review-triage,security-check,sync-second-brain,update-second-brain,work-items-analysis}

# Rules
rm -f ~/Documents/Development/AGENTS.md

# Codex
rm -f ~/.codex/AGENTS.md
~/Documents/Development/agentic_engineering/scripts/sync-codex-skills uninstall

# Hook automation
cd ~/Documents/Development/agentic_engineering
./scripts/install-skill-hooks uninstall

# Clean up empty directories
rmdir ~/.cursor/skills ~/.codex/skills ~/.codex 2>/dev/null
```

## Different folder path?

If your development folder isn't `~/Documents/Development/`, adjust all paths above.
For example, if you use `~/code/`:

```bash
ln -sf ~/code/agentic_engineering/AGENTS.md ~/code/AGENTS.md
ln -sf ~/code/agentic_engineering/AGENTS.md ~/.codex/AGENTS.md
~/code/agentic_engineering/scripts/install-skill-hooks
~/code/agentic_engineering/scripts/sync-workstation-skills
```
