---
name: sync-second-brain
description: Manage a dedicated second-brain git worktree for syncing `.claude/` changes across repos on a separate `second-brain` branch. Use when you want second-brain commits isolated from product-code branches.
---

# Sync Second Brain

Use a dedicated `second-brain` branch plus a temporary extra worktree to copy `.claude/`
changes into a separate checkout, commit them there, push them, and then return to the
original repo/branch workflow cleanly.

## When to Use

Use this skill when:
- the current repo root has a `.claude/` directory and `.gitignore` ignores `.claude/`, which indicates the second-brain files should stay off the main development branches and live on a dedicated `second-brain` branch instead
- you are syncing second-brain updates across repos and want a predictable branch name and path
- you want to stage, review, and push `.claude/` changes without switching your main working tree away from its current branch

Do not use this skill when:
- the repo intentionally tracks `.claude/` on its normal development branches, for example `.claude/` is not ignored in `.gitignore` and those files already belong in `main`, `develop`, or feature branches
- the `.claude/` update belongs in the same branch as the code change and there is no reason to isolate it

## When to Create, Keep, or Remove the Worktree

- Create the extra worktree immediately before a `.claude/` sync when you need a clean checkout of the dedicated `second-brain` branch.
- Treat the extra worktree as disposable, not persistent.
- Remove it in the same sync session immediately after the `.claude/` commit is pushed and the worktree is clean.
- If you are tempted to leave it around, stop and remove it anyway unless the user explicitly asked for a persistent second-brain checkout.

## Full Lifecycle

### 1. Create the `second-brain` branch and worktree

Start in the original repo and remember where you were:

```bash
cd ~/Documents/Development/example-repo
original_repo_dir="$PWD"
original_branch="$(git rev-parse --abbrev-ref HEAD)"
```

This keeps the original repo path and branch name so you can return to the normal workflow at the end.

Check whether the `second-brain` branch already exists locally or on `origin`. Create it only if needed:

```bash
cd ~/Documents/Development/example-repo

if git show-ref --verify --quiet refs/heads/second-brain; then
  echo "Local branch second-brain already exists"
elif git ls-remote --exit-code --heads origin second-brain >/dev/null 2>&1; then
  git fetch origin second-brain:second-brain
else
  base_branch="$(git symbolic-ref --quiet --short refs/remotes/origin/HEAD | sed 's@^origin/@@')"
  git fetch origin "$base_branch"
  git branch second-brain "origin/$base_branch"
fi
```

What this does:
- `git show-ref --verify --quiet refs/heads/second-brain` checks for a local `second-brain` branch.
- `git ls-remote --exit-code --heads origin second-brain` checks whether `origin` already has that branch.
- `git fetch origin second-brain:second-brain` creates the local branch from the remote branch when only the remote exists.
- `git symbolic-ref --quiet --short refs/remotes/origin/HEAD | sed 's@^origin/@@'` resolves the repo's default remote branch name.
- `git branch second-brain "origin/$base_branch"` creates `second-brain` from that normal base branch instead of from an arbitrary feature branch.

If `base_branch` comes back empty, set it explicitly before continuing:

```bash
base_branch=main
git fetch origin "$base_branch"
git branch second-brain "origin/$base_branch"
```

Check whether an extra worktree already exists before creating another one:

```bash
git worktree list
```

If `~/Documents/Development/example-repo-second-brain` is already listed, remove it first so the sync starts from a fresh disposable checkout:

```bash
git -C ~/Documents/Development/example-repo-second-brain status --short
git worktree remove ~/Documents/Development/example-repo-second-brain
git worktree prune
```

Then create the dedicated worktree:

```bash
git worktree add ~/Documents/Development/example-repo-second-brain second-brain
```

This creates a separate checkout at `~/Documents/Development/example-repo-second-brain` on branch `second-brain` while leaving the original repo checkout on its current branch. The intent is to create it for this sync only, not to keep a long-lived second-brain checkout around.

### 2. Copy or sync `.claude/` changes into the second-brain worktree

Create the destination directory in the second-brain worktree if needed:

```bash
mkdir -p ~/Documents/Development/example-repo-second-brain/.claude
```

Copy new and changed `.claude/` files from the original repo into the dedicated worktree:

```bash
cp -R -i ~/Documents/Development/example-repo/.claude/. ~/Documents/Development/example-repo-second-brain/.claude/
```

What this does:
- `cp -R` copies recursively.
- `-i` prompts before overwriting an existing file, which makes the sync safer than a blind mirror.
- This updates files that changed and brings over new files, but it does not auto-delete anything.

Review the result in the second-brain worktree:

```bash
diff -ru ~/Documents/Development/example-repo/.claude ~/Documents/Development/example-repo-second-brain/.claude || true
git -C ~/Documents/Development/example-repo-second-brain status --short .claude
git -C ~/Documents/Development/example-repo-second-brain diff -- .claude
```

What this does:
- `diff -ru ... || true` compares the source `.claude/` tree to the second-brain worktree without stopping on differences.
- Files shown as existing only in `~/Documents/Development/example-repo-second-brain/.claude` are candidates for manual deletion.
- `git status` and `git diff` then show what the second-brain branch will actually commit.

If a file was intentionally removed from the source `.claude/`, delete it manually in the second-brain worktree after review:

```bash
trash ~/Documents/Development/example-repo-second-brain/.claude/old-file.md
```

If `trash` is unavailable, fall back to:

```bash
rm -i ~/Documents/Development/example-repo-second-brain/.claude/old-file.md
```

This is the safe-sync rule: copy additions and edits explicitly, then handle deletions one-by-one after review. Do not use `rsync --delete`.

### 3. Commit and push on `second-brain`

Move into the extra worktree, stage only `.claude/`, commit, and push:

```bash
cd ~/Documents/Development/example-repo-second-brain
git add .claude
git commit -m "docs(second-brain): 📝 sync .claude"
git push -u origin second-brain
```

What this does:
- `git add .claude` limits the commit to second-brain files.
- `git commit` records the sync on the dedicated branch.
- `git push -u origin second-brain` publishes the branch and sets upstream tracking if this is the first push.

### 4. Remove the extra worktree when done

Before removing it, confirm there is nothing uncommitted left in the extra checkout:

```bash
git -C ~/Documents/Development/example-repo-second-brain status --short
```

If it is clean, remove it from the original repo directory as part of the same workflow:

```bash
cd ~/Documents/Development/example-repo
git worktree remove ~/Documents/Development/example-repo-second-brain
```

Then clean up stale worktree metadata:

```bash
git worktree prune
```

### 5. Return to the original repo directory and branch workflow

Go back to the original checkout and confirm you are on the branch you started from:

```bash
cd "$original_repo_dir"
git switch "$original_branch"
git status --short
```

This returns you to the normal repo workflow after the dedicated second-brain sync is finished.

## Safety Notes

- Keep the branch name as `second-brain` unless the repo has an established alternative.
- Keep the extra worktree path separate from the main repo checkout, for example `~/Documents/Development/example-repo-second-brain`.
- Always review `git status` and `git diff` in the extra worktree before committing.
- Do not leave a long-lived second-brain worktree behind unless the user explicitly asks for that exception.
