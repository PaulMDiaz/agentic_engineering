#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
. "$ROOT_DIR/tests/helpers/assert.sh"
trap cleanup_temp_dirs EXIT

make_home() {
  home_dir="$(make_temp_dir)"
  mkdir -p "$home_dir/.codex" "$home_dir/.claude"
  printf '%s\n' "$home_dir"
}

# The script derives the development folder from its own clone location, so the fixture
# needs a repo directory nested inside a development directory.
make_clone_fixture() {
  dev_dir="$(make_temp_dir)"
  clone_dir="$dev_dir/agentic_engineering"
  mkdir -p "$clone_dir/scripts"
  cp "$ROOT_DIR/scripts/sync-agent-guidance" "$clone_dir/scripts/sync-agent-guidance"
  printf 'shared guidance\n' > "$clone_dir/AGENTS.local.md"
  printf '%s\n' "$clone_dir"
}

test_links_every_surface() {
  home_dir="$(make_home)"
  clone_dir="$(make_clone_fixture)"
  dev_dir="$(dirname "$clone_dir")"

  HOME="$home_dir" "$clone_dir/scripts/sync-agent-guidance"

  assert_symlink_target \
    "$dev_dir/AGENTS.md" \
    "$clone_dir/AGENTS.local.md" \
    "sync-agent-guidance should link development-folder guidance for Cursor"
  assert_symlink_target \
    "$home_dir/.codex/AGENTS.md" \
    "$clone_dir/AGENTS.local.md" \
    "sync-agent-guidance should link Codex guidance"
  assert_symlink_target \
    "$home_dir/.claude/CLAUDE.md" \
    "$clone_dir/AGENTS.local.md" \
    "sync-agent-guidance should link Claude Code guidance as CLAUDE.md"
  assert_not_exists \
    "$home_dir/.claude/AGENTS.md" \
    "sync-agent-guidance should not write AGENTS.md into the Claude Code home"
}

test_skips_surfaces_without_agent_home() {
  home_dir="$(make_temp_dir)"
  clone_dir="$(make_clone_fixture)"

  HOME="$home_dir" "$clone_dir/scripts/sync-agent-guidance"

  assert_not_exists \
    "$home_dir/.codex/AGENTS.md" \
    "sync-agent-guidance should skip Codex when its home is missing"
  assert_not_exists \
    "$home_dir/.claude/CLAUDE.md" \
    "sync-agent-guidance should skip Claude Code when its home is missing"
}

test_replaces_empty_placeholder_file() {
  home_dir="$(make_home)"
  clone_dir="$(make_clone_fixture)"
  : > "$home_dir/.codex/AGENTS.md"

  HOME="$home_dir" "$clone_dir/scripts/sync-agent-guidance"

  assert_symlink_target \
    "$home_dir/.codex/AGENTS.md" \
    "$clone_dir/AGENTS.local.md" \
    "sync-agent-guidance should claim an empty placeholder file"
}

test_preserves_user_authored_file() {
  home_dir="$(make_home)"
  clone_dir="$(make_clone_fixture)"
  printf 'my own guidance\n' > "$home_dir/.codex/AGENTS.md"

  output="$(HOME="$home_dir" "$clone_dir/scripts/sync-agent-guidance" 2>&1)"

  assert_file_contains \
    "$home_dir/.codex/AGENTS.md" \
    "my own guidance" \
    "sync-agent-guidance should preserve a non-empty user file"
  assert_contains "$output" "existing non-empty file" \
    "sync-agent-guidance should warn when it skips a user file"
}

test_preserves_links_outside_the_repo() {
  home_dir="$(make_home)"
  clone_dir="$(make_clone_fixture)"
  other_dir="$(make_temp_dir)"
  printf 'other playbook\n' > "$other_dir/AGENTS.md"
  ln -s "$other_dir/AGENTS.md" "$home_dir/.codex/AGENTS.md"

  output="$(HOME="$home_dir" "$clone_dir/scripts/sync-agent-guidance" 2>&1)"

  assert_symlink_target \
    "$home_dir/.codex/AGENTS.md" \
    "$other_dir/AGENTS.md" \
    "sync-agent-guidance should leave another source's link alone"
  assert_contains "$output" "links outside this repo" \
    "sync-agent-guidance should warn when it skips a foreign link"
}

test_repoints_stale_repo_owned_link() {
  home_dir="$(make_home)"
  clone_dir="$(make_clone_fixture)"
  ln -s "$clone_dir/AGENTS.md" "$home_dir/.codex/AGENTS.md"

  HOME="$home_dir" "$clone_dir/scripts/sync-agent-guidance"

  assert_symlink_target \
    "$home_dir/.codex/AGENTS.md" \
    "$clone_dir/AGENTS.local.md" \
    "sync-agent-guidance should repoint a stale link it owns"
}

test_skips_development_folder_when_clone_sits_in_home() {
  home_dir="$(make_home)"
  mkdir -p "$home_dir/agentic_engineering/scripts"
  cp "$ROOT_DIR/scripts/sync-agent-guidance" "$home_dir/agentic_engineering/scripts/sync-agent-guidance"
  printf 'shared guidance\n' > "$home_dir/agentic_engineering/AGENTS.local.md"

  HOME="$home_dir" "$home_dir/agentic_engineering/scripts/sync-agent-guidance"

  assert_not_exists \
    "$home_dir/AGENTS.md" \
    "sync-agent-guidance should not create guidance directly in the account home"
  assert_symlink_target \
    "$home_dir/.codex/AGENTS.md" \
    "$home_dir/agentic_engineering/AGENTS.local.md" \
    "sync-agent-guidance should still link agent homes"
}

test_uninstall_removes_only_repo_owned_links() {
  home_dir="$(make_home)"
  clone_dir="$(make_clone_fixture)"
  dev_dir="$(dirname "$clone_dir")"
  other_dir="$(make_temp_dir)"
  printf 'other playbook\n' > "$other_dir/AGENTS.md"
  HOME="$home_dir" "$clone_dir/scripts/sync-agent-guidance"
  rm -f "$home_dir/.claude/CLAUDE.md"
  ln -s "$other_dir/AGENTS.md" "$home_dir/.claude/CLAUDE.md"

  HOME="$home_dir" "$clone_dir/scripts/sync-agent-guidance" uninstall

  assert_not_exists \
    "$dev_dir/AGENTS.md" \
    "uninstall should remove development-folder guidance it owns"
  assert_not_exists \
    "$home_dir/.codex/AGENTS.md" \
    "uninstall should remove Codex guidance it owns"
  assert_symlink_target \
    "$home_dir/.claude/CLAUDE.md" \
    "$other_dir/AGENTS.md" \
    "uninstall should preserve guidance owned by another source"
}

test_fails_when_guidance_source_is_missing() {
  home_dir="$(make_home)"
  clone_dir="$(make_clone_fixture)"
  rm -f "$clone_dir/AGENTS.local.md"

  set +e
  output="$(HOME="$home_dir" "$clone_dir/scripts/sync-agent-guidance" 2>&1)"
  status=$?
  set -e

  assert_eq "1" "$status" "sync-agent-guidance should fail without a guidance source"
  assert_contains "$output" "Missing guidance source" \
    "sync-agent-guidance should name the missing source"
}

test_links_every_surface
test_skips_surfaces_without_agent_home
test_replaces_empty_placeholder_file
test_preserves_user_authored_file
test_preserves_links_outside_the_repo
test_repoints_stale_repo_owned_link
test_skips_development_folder_when_clone_sits_in_home
test_uninstall_removes_only_repo_owned_links
test_fails_when_guidance_source_is_missing
