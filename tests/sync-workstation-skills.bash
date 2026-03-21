#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
. "$ROOT_DIR/tests/helpers/assert.sh"
trap cleanup_temp_dirs EXIT

make_home() {
  home_dir="$(make_temp_dir)"
  mkdir -p "$home_dir/.cursor" "$home_dir/.codex"
  printf '%s\n' "$home_dir"
}

test_syncs_both_cursor_and_codex_surfaces() {
  home_dir="$(make_home)"

  HOME="$home_dir" "$ROOT_DIR/scripts/sync-workstation-skills"

  assert_symlink_target \
    "$home_dir/.cursor/skills/implement" \
    "$ROOT_DIR/skills/implement" \
    "sync-workstation-skills should create Cursor skill symlinks"
  assert_exists \
    "$home_dir/.codex/skills/implement/SKILL.md" \
    "sync-workstation-skills should mirror Codex skills"
}

test_fails_when_one_sync_surface_errors() {
  home_dir="$(make_home)"
  printf 'occupied\n' > "$home_dir/.codex/skills"

  set +e
  output="$(HOME="$home_dir" "$ROOT_DIR/scripts/sync-workstation-skills" 2>&1)"
  status=$?
  set -e

  assert_eq "1" "$status" "sync-workstation-skills should fail when a child sync fails"
  assert_contains "$output" "File exists" "sync-workstation-skills should surface the child script failure"
}

test_syncs_both_cursor_and_codex_surfaces
test_fails_when_one_sync_surface_errors
