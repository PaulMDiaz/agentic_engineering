#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
. "$ROOT_DIR/tests/helpers/assert.sh"
trap cleanup_temp_dirs EXIT

make_home() {
  home_dir="$(make_temp_dir)"
  mkdir -p "$home_dir/.cursor" "$home_dir/.codex" "$home_dir/.claude"
  printf '%s\n' "$home_dir"
}

# Guidance sync targets the directory above the clone, so the entry point runs from a
# fixture clone to keep every write inside temp directories.
make_clone_fixture() {
  dev_dir="$(make_temp_dir)"
  clone_dir="$dev_dir/agentic_engineering"
  mkdir -p "$clone_dir/scripts" "$clone_dir/skills"
  cp "$ROOT_DIR"/scripts/sync-* "$clone_dir/scripts/"
  cp -R "$ROOT_DIR/skills/implement" "$clone_dir/skills/implement"
  cp "$ROOT_DIR/AGENTS.local.md" "$clone_dir/AGENTS.local.md"
  printf '%s\n' "$clone_dir"
}

test_syncs_every_sync_surface() {
  home_dir="$(make_home)"
  clone_dir="$(make_clone_fixture)"
  dev_dir="$(dirname "$clone_dir")"

  HOME="$home_dir" "$clone_dir/scripts/sync-workstation-skills"

  assert_symlink_target \
    "$home_dir/.cursor/skills/implement" \
    "$clone_dir/skills/implement" \
    "sync-workstation-skills should create Cursor skill symlinks"
  assert_exists \
    "$home_dir/.codex/skills/implement/SKILL.md" \
    "sync-workstation-skills should mirror Codex skills"
  assert_symlink_target \
    "$home_dir/.claude/skills/implement" \
    "$clone_dir/skills/implement" \
    "sync-workstation-skills should create Claude Code skill symlinks"
  assert_symlink_target \
    "$dev_dir/AGENTS.md" \
    "$clone_dir/AGENTS.local.md" \
    "sync-workstation-skills should link development-folder guidance"
  assert_symlink_target \
    "$home_dir/.codex/AGENTS.md" \
    "$clone_dir/AGENTS.local.md" \
    "sync-workstation-skills should link Codex guidance"
  assert_symlink_target \
    "$home_dir/.claude/CLAUDE.md" \
    "$clone_dir/AGENTS.local.md" \
    "sync-workstation-skills should link Claude Code guidance"
}

test_fails_when_one_sync_surface_errors() {
  home_dir="$(make_home)"
  clone_dir="$(make_clone_fixture)"
  printf 'occupied\n' > "$home_dir/.codex/skills"

  set +e
  output="$(HOME="$home_dir" "$clone_dir/scripts/sync-workstation-skills" 2>&1)"
  status=$?
  set -e

  assert_eq "1" "$status" "sync-workstation-skills should fail when a child sync fails"
  assert_contains "$output" "File exists" "sync-workstation-skills should surface the child script failure"
}

test_syncs_every_sync_surface
test_fails_when_one_sync_surface_errors
