#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
. "$ROOT_DIR/tests/helpers/assert.sh"
trap cleanup_temp_dirs EXIT

make_repo_copy() {
  repo_dir="$(make_temp_dir)"
  cp -R "$ROOT_DIR/." "$repo_dir/"
  rm -rf "$repo_dir/.git"
  (cd "$repo_dir" && pwd -P)
}

make_git_repo_copy() {
  repo_dir="$(make_repo_copy)"
  git init -q "$repo_dir"
  printf '%s\n' "$repo_dir"
}

make_agent_home() {
  home_dir="$(make_temp_dir)"
  mkdir -p "$home_dir/.cursor" "$home_dir/.codex" "$home_dir/.claude"
  printf '%s\n' "$home_dir"
}

test_uninstall_removes_owned_installation_and_saved_opt_in() {
  repo_dir="$(make_git_repo_copy)"
  home_dir="$(make_agent_home)"
  workspace_dir="$(make_temp_dir)"
  other_dir="$(make_temp_dir)"

  HOME="$home_dir" AGENTIC_ENGINEERING_CURSOR_AGENTS_ROOT="$workspace_dir" "$repo_dir/scripts/install" --with-agents

  mkdir -p "$other_dir/custom" "$home_dir/.codex/skills/custom" "$home_dir/.codex/skills/.system/system-skill"
  printf 'custom\n' > "$home_dir/.codex/skills/custom/SKILL.md"
  printf 'system\n' > "$home_dir/.codex/skills/.system/system-skill/SKILL.md"
  ln -s "$other_dir/custom" "$home_dir/.cursor/skills/custom"
  ln -s "$other_dir/custom" "$home_dir/.claude/skills/custom"
  unmanaged_hook="$repo_dir/.git/hooks/pre-commit"
  printf '#!/usr/bin/env bash\nexit 0\n' > "$unmanaged_hook"
  chmod +x "$unmanaged_hook"

  HOME="$home_dir" AGENTIC_ENGINEERING_CURSOR_AGENTS_ROOT="$workspace_dir" "$repo_dir/scripts/uninstall"

  assert_not_exists "$workspace_dir/AGENTS.md" "uninstall should remove Cursor guidance owned by this clone"
  assert_not_exists "$home_dir/.codex/AGENTS.md" "uninstall should remove Codex guidance owned by this clone"
  assert_not_exists "$home_dir/.claude/CLAUDE.md" "uninstall should remove Claude Code guidance owned by this clone"
  assert_not_exists "$home_dir/.cursor/skills/implement" "uninstall should remove owned Cursor skill links"
  assert_not_exists "$home_dir/.codex/skills/implement" "uninstall should remove owned Codex skill mirrors"
  assert_not_exists "$home_dir/.claude/skills/implement" "uninstall should remove owned Claude Code skill links"
  assert_symlink_target "$home_dir/.cursor/skills/custom" "$other_dir/custom" "uninstall should preserve custom Cursor skills"
  assert_exists "$home_dir/.codex/skills/custom/SKILL.md" "uninstall should preserve custom Codex skills"
  assert_exists "$home_dir/.codex/skills/.system/system-skill/SKILL.md" "uninstall should preserve Codex system skills"
  assert_symlink_target "$home_dir/.claude/skills/custom" "$other_dir/custom" "uninstall should preserve custom Claude Code skills"
  assert_exists "$unmanaged_hook" "uninstall should preserve unrelated hooks"

  for hook_name in post-checkout post-commit post-merge; do
    assert_not_exists "$repo_dir/.git/hooks/$hook_name" "uninstall should remove managed $hook_name"
  done

  set +e
  git -C "$repo_dir" config --local --get agenticEngineering.agentsSync >/dev/null 2>&1
  status=$?
  set -e
  assert_eq "1" "$status" "uninstall should clear the saved guidance opt-in"
}

test_uninstall_preserves_guidance_owned_elsewhere() {
  repo_dir="$(make_repo_copy)"
  home_dir="$(make_agent_home)"
  workspace_dir="$(make_temp_dir)"
  other_dir="$(make_temp_dir)"
  printf 'other guidance\n' > "$other_dir/AGENTS.md"
  ln -s "$other_dir/AGENTS.md" "$workspace_dir/AGENTS.md"
  ln -s "$other_dir/AGENTS.md" "$home_dir/.codex/AGENTS.md"
  ln -s "$other_dir/AGENTS.md" "$home_dir/.claude/CLAUDE.md"

  HOME="$home_dir" AGENTIC_ENGINEERING_CURSOR_AGENTS_ROOT="$workspace_dir" "$repo_dir/scripts/uninstall"

  assert_symlink_target "$workspace_dir/AGENTS.md" "$other_dir/AGENTS.md" "uninstall should preserve foreign Cursor guidance"
  assert_symlink_target "$home_dir/.codex/AGENTS.md" "$other_dir/AGENTS.md" "uninstall should preserve foreign Codex guidance"
  assert_symlink_target "$home_dir/.claude/CLAUDE.md" "$other_dir/AGENTS.md" "uninstall should preserve foreign Claude Code guidance"
}

test_uninstall_removes_legacy_repo_guidance_links() {
  repo_dir="$(make_repo_copy)"
  home_dir="$(make_agent_home)"
  workspace_dir="$(make_temp_dir)"
  ln -s "$repo_dir/AGENTS.md" "$workspace_dir/AGENTS.md"
  ln -s "$repo_dir/AGENTS.md" "$home_dir/.codex/AGENTS.md"
  ln -s "$repo_dir/AGENTS.md" "$home_dir/.claude/CLAUDE.md"

  HOME="$home_dir" AGENTIC_ENGINEERING_CURSOR_AGENTS_ROOT="$workspace_dir" "$repo_dir/scripts/uninstall"

  assert_not_exists "$workspace_dir/AGENTS.md" "uninstall should remove legacy Cursor guidance links"
  assert_not_exists "$home_dir/.codex/AGENTS.md" "uninstall should remove legacy Codex guidance links"
  assert_not_exists "$home_dir/.claude/CLAUDE.md" "uninstall should remove legacy Claude Code guidance links"
}

test_uninstall_preserves_symlinked_skill_roots() {
  repo_dir="$(make_repo_copy)"
  home_dir="$(make_agent_home)"
  other_dir="$(make_temp_dir)"
  mkdir -p "$other_dir/cursor-skills" "$other_dir/codex-skills" "$other_dir/claude-skills"
  ln -s "$other_dir/cursor-skills" "$home_dir/.cursor/skills"
  ln -s "$other_dir/codex-skills" "$home_dir/.codex/skills"
  ln -s "$other_dir/claude-skills" "$home_dir/.claude/skills"

  HOME="$home_dir" "$repo_dir/scripts/uninstall"

  assert_symlink_target "$home_dir/.cursor/skills" "$other_dir/cursor-skills" "uninstall should preserve a symlinked Cursor skills root"
  assert_symlink_target "$home_dir/.codex/skills" "$other_dir/codex-skills" "uninstall should preserve a symlinked Codex skills root"
  assert_symlink_target "$home_dir/.claude/skills" "$other_dir/claude-skills" "uninstall should preserve a symlinked Claude Code skills root"
}

test_uninstall_rejects_unknown_options() {
  repo_dir="$(make_repo_copy)"
  home_dir="$(make_temp_dir)"

  set +e
  output="$(HOME="$home_dir" "$repo_dir/scripts/uninstall" --all 2>&1)"
  status=$?
  set -e

  assert_eq "2" "$status" "uninstall should reject unknown options"
  assert_contains "$output" "Unknown option" "uninstall should explain an unknown option"
}

test_uninstall_removes_owned_installation_and_saved_opt_in
test_uninstall_preserves_guidance_owned_elsewhere
test_uninstall_removes_legacy_repo_guidance_links
test_uninstall_preserves_symlinked_skill_roots
test_uninstall_rejects_unknown_options
