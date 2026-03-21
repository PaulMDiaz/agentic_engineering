#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
. "$ROOT_DIR/tests/helpers/assert.sh"
trap cleanup_temp_dirs EXIT

make_home() {
  home_dir="$(make_temp_dir)"
  mkdir -p "$home_dir/.cursor"
  printf '%s\n' "$home_dir"
}

make_script_fixture() {
  fixture_root="$(make_temp_dir)"
  mkdir -p "$fixture_root/scripts" "$fixture_root/skills"
  cp "$ROOT_DIR/scripts/sync-cursor-skills" "$fixture_root/scripts/sync-cursor-skills"
  cp -R "$ROOT_DIR/skills/implement" "$fixture_root/skills/implement"
  printf '%s\n' "$fixture_root"
}

test_noops_without_cursor_home() {
  home_dir="$(make_temp_dir)"

  HOME="$home_dir" "$ROOT_DIR/scripts/sync-cursor-skills"

  assert_not_exists "$home_dir/.cursor/skills" "sync-cursor-skills should no-op when Cursor home is missing"
}

test_creates_symlinks_for_valid_skills_only() {
  home_dir="$(make_home)"
  fixture_root="$(make_script_fixture)"
  mkdir -p "$fixture_root/skills/not-a-skill"

  HOME="$home_dir" "$fixture_root/scripts/sync-cursor-skills"

  assert_symlink_target \
    "$home_dir/.cursor/skills/implement" \
    "$fixture_root/skills/implement" \
    "sync-cursor-skills should link valid skills"
  assert_not_exists \
    "$home_dir/.cursor/skills/not-a-skill" \
    "sync-cursor-skills should skip directories without SKILL.md"
}

test_preserves_existing_entries() {
  home_dir="$(make_home)"
  mkdir -p "$home_dir/.cursor/skills"
  mkdir -p "$home_dir/custom-skill"
  ln -s "$home_dir/custom-skill" "$home_dir/.cursor/skills/implement"

  HOME="$home_dir" "$ROOT_DIR/scripts/sync-cursor-skills"

  assert_symlink_target \
    "$home_dir/.cursor/skills/implement" \
    "$home_dir/custom-skill" \
    "sync-cursor-skills should leave existing entries alone"
}

test_noops_without_cursor_home
test_creates_symlinks_for_valid_skills_only
test_preserves_existing_entries
