#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
. "$ROOT_DIR/tests/helpers/assert.sh"
trap cleanup_temp_dirs EXIT

make_home() {
  home_dir="$(make_temp_dir)"
  mkdir -p "$home_dir/.claude"
  printf '%s\n' "$home_dir"
}

make_script_fixture() {
  fixture_root="$(make_temp_dir)"
  mkdir -p "$fixture_root/scripts" "$fixture_root/skills"
  cp "$ROOT_DIR/scripts/sync-claude-skills" "$fixture_root/scripts/sync-claude-skills"
  cp -R "$ROOT_DIR/skills/implement" "$fixture_root/skills/implement"
  printf '%s\n' "$fixture_root"
}

test_noops_without_claude_home() {
  home_dir="$(make_temp_dir)"

  HOME="$home_dir" "$ROOT_DIR/scripts/sync-claude-skills"

  assert_not_exists "$home_dir/.claude/skills" "sync-claude-skills should no-op when Claude home is missing"
}

test_creates_symlinks_for_valid_skills_only() {
  home_dir="$(make_home)"
  fixture_root="$(make_script_fixture)"
  mkdir -p "$fixture_root/skills/not-a-skill"

  HOME="$home_dir" "$fixture_root/scripts/sync-claude-skills"

  assert_symlink_target \
    "$home_dir/.claude/skills/implement" \
    "$fixture_root/skills/implement" \
    "sync-claude-skills should link valid skills"
  assert_not_exists \
    "$home_dir/.claude/skills/not-a-skill" \
    "sync-claude-skills should skip directories without SKILL.md"
}

test_preserves_existing_entries() {
  home_dir="$(make_home)"
  mkdir -p "$home_dir/.claude/skills"
  mkdir -p "$home_dir/custom-skill"
  ln -s "$home_dir/custom-skill" "$home_dir/.claude/skills/implement"

  HOME="$home_dir" "$ROOT_DIR/scripts/sync-claude-skills"

  assert_symlink_target \
    "$home_dir/.claude/skills/implement" \
    "$home_dir/custom-skill" \
    "sync-claude-skills should leave existing entries alone"
}

test_uninstall_removes_only_repo_managed_symlinks() {
  home_dir="$(make_home)"
  fixture_root="$(make_script_fixture)"
  mkdir -p "$home_dir/.claude/skills" "$home_dir/custom-skill"
  ln -s "$fixture_root/skills/implement" "$home_dir/.claude/skills/implement"
  ln -s "$fixture_root/skills/removed-skill" "$home_dir/.claude/skills/removed-skill"
  ln -s "$home_dir/custom-skill" "$home_dir/.claude/skills/custom"

  HOME="$home_dir" "$fixture_root/scripts/sync-claude-skills" uninstall

  assert_not_exists \
    "$home_dir/.claude/skills/implement" \
    "uninstall should remove managed current skill symlinks"
  assert_not_exists \
    "$home_dir/.claude/skills/removed-skill" \
    "uninstall should remove managed dangling skill symlinks"
  assert_symlink_target \
    "$home_dir/.claude/skills/custom" \
    "$home_dir/custom-skill" \
    "uninstall should preserve custom skill symlinks"
}

test_noops_without_claude_home
test_creates_symlinks_for_valid_skills_only
test_preserves_existing_entries
test_uninstall_removes_only_repo_managed_symlinks
