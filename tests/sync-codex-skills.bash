#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
. "$ROOT_DIR/tests/helpers/assert.sh"
trap cleanup_temp_dirs EXIT

make_home() {
  home_dir="$(make_temp_dir)"
  mkdir -p "$home_dir/.codex"
  printf '%s\n' "$home_dir"
}

seed_repo_managed_skill() {
  dst_root="$1"
  skill_name="$2"

  mkdir -p "$dst_root/$skill_name"
  printf '%s\n' "$ROOT_DIR" > "$dst_root/$skill_name/.agentic-engineering-skill-source"
  printf 'managed\n' > "$dst_root/$skill_name/SKILL.md"
}

test_noops_without_codex_home() {
  home_dir="$(make_temp_dir)"

  HOME="$home_dir" "$ROOT_DIR/scripts/sync-codex-skills"

  assert_not_exists "$home_dir/.codex/skills" "sync-codex-skills should no-op when Codex home is missing"
}

test_mirrors_skill_folders_and_marker() {
  home_dir="$(make_home)"

  HOME="$home_dir" "$ROOT_DIR/scripts/sync-codex-skills"

  skill_dir="$home_dir/.codex/skills/implement"
  assert_exists "$skill_dir/SKILL.md" "sync-codex-skills should mirror skill contents"
  assert_file_contains \
    "$skill_dir/.agentic-engineering-skill-source" \
    "$ROOT_DIR" \
    "sync-codex-skills should mark repo-managed mirrors"
}

test_removes_stale_repo_managed_skill_and_preserves_unmanaged_entries() {
  home_dir="$(make_home)"
  dst_root="$home_dir/.codex/skills"
  mkdir -p "$dst_root/removed-skill" "$dst_root/custom" "$dst_root/.system/system-skill"
  printf '%s\n' "$ROOT_DIR" > "$dst_root/removed-skill/.agentic-engineering-skill-source"
  printf 'keep\n' > "$dst_root/removed-skill/SKILL.md"
  printf 'custom\n' > "$dst_root/custom/SKILL.md"
  printf '/some/other/repo\n' > "$dst_root/custom/.agentic-engineering-skill-source"
  printf 'system\n' > "$dst_root/.system/system-skill/SKILL.md"

  HOME="$home_dir" "$ROOT_DIR/scripts/sync-codex-skills"

  assert_not_exists \
    "$dst_root/removed-skill" \
    "sync-codex-skills should remove stale repo-managed mirrors"
  assert_exists \
    "$dst_root/custom/SKILL.md" \
    "sync-codex-skills should preserve unrelated user-managed skills"
  assert_exists \
    "$dst_root/.system/system-skill/SKILL.md" \
    "sync-codex-skills should preserve .system content"
}

test_uninstall_removes_only_repo_managed_skills() {
  home_dir="$(make_home)"
  dst_root="$home_dir/.codex/skills"
  mkdir -p "$dst_root/custom" "$dst_root/.system/system-skill"
  seed_repo_managed_skill "$dst_root" "managed-skill"
  printf '/some/other/repo\n' > "$dst_root/custom/.agentic-engineering-skill-source"
  printf 'custom\n' > "$dst_root/custom/SKILL.md"
  printf 'system\n' > "$dst_root/.system/system-skill/SKILL.md"

  HOME="$home_dir" "$ROOT_DIR/scripts/sync-codex-skills" uninstall

  assert_not_exists \
    "$dst_root/managed-skill" \
    "sync-codex-skills uninstall should remove repo-managed mirrors"
  assert_exists \
    "$dst_root/custom/SKILL.md" \
    "sync-codex-skills uninstall should preserve unrelated user-managed skills"
  assert_exists \
    "$dst_root/.system/system-skill/SKILL.md" \
    "sync-codex-skills uninstall should preserve .system content"
}

test_updates_existing_mirror_contents() {
  home_dir="$(make_home)"
  dst_root="$home_dir/.codex/skills"
  mkdir -p "$dst_root/implement"
  printf 'stale\n' > "$dst_root/implement/EXTRA.txt"
  printf 'old\n' > "$dst_root/implement/SKILL.md"

  HOME="$home_dir" "$ROOT_DIR/scripts/sync-codex-skills"

  assert_not_exists \
    "$dst_root/implement/EXTRA.txt" \
    "sync-codex-skills should delete stale files inside managed mirrors"
  skill_contents="$(<"$dst_root/implement/SKILL.md")"
  assert_contains "$skill_contents" "name: implement" "sync-codex-skills should refresh mirrored contents"
}

test_noops_without_codex_home
test_mirrors_skill_folders_and_marker
test_removes_stale_repo_managed_skill_and_preserves_unmanaged_entries
test_uninstall_removes_only_repo_managed_skills
test_updates_existing_mirror_contents
