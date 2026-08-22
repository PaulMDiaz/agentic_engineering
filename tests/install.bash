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

test_skips_missing_agent_homes() {
  repo_dir="$(make_repo_copy)"
  home_dir="$(make_temp_dir)"

  output="$(HOME="$home_dir" "$repo_dir/scripts/install")"

  assert_contains "$output" "Cursor not detected" "install should skip missing Cursor home"
  assert_contains "$output" "Codex not detected" "install should skip missing Codex home"
  assert_contains "$output" "Claude Code not detected" "install should skip missing Claude Code home"
  assert_not_exists "$home_dir/.cursor" "install should not create Cursor home"
  assert_not_exists "$home_dir/.codex" "install should not create Codex home"
  assert_not_exists "$home_dir/.claude" "install should not create Claude Code home"
}

test_default_install_syncs_skills_without_guidance() {
  repo_dir="$(make_repo_copy)"
  home_dir="$(make_agent_home)"
  workspace_dir="$(make_temp_dir)"

  HOME="$home_dir" AGENTIC_ENGINEERING_CURSOR_AGENTS_ROOT="$workspace_dir" "$repo_dir/scripts/install"

  assert_symlink_target \
    "$home_dir/.cursor/skills/implement" \
    "$repo_dir/skills/implement" \
    "install should link Cursor skills"
  assert_exists \
    "$home_dir/.codex/skills/implement/SKILL.md" \
    "install should mirror Codex skills"
  assert_file_contains \
    "$home_dir/.codex/skills/implement/.agentic-engineering-skill-source" \
    "$repo_dir" \
    "install should mark Codex skill mirrors"
  assert_symlink_target \
    "$home_dir/.claude/skills/implement" \
    "$repo_dir/skills/implement" \
    "install should link Claude Code skills"
  assert_not_exists "$workspace_dir/AGENTS.md" "default install should not link Cursor guidance"
  assert_not_exists "$home_dir/.codex/AGENTS.md" "default install should not link Codex guidance"
  assert_not_exists "$home_dir/.claude/CLAUDE.md" "default install should not link Claude Code guidance"
}

test_with_agents_requires_populated_source_before_installing() {
  repo_dir="$(make_repo_copy)"
  home_dir="$(make_agent_home)"
  workspace_dir="$(make_temp_dir)"
  : > "$repo_dir/AGENTS.local.md"

  set +e
  output="$(HOME="$home_dir" AGENTIC_ENGINEERING_CURSOR_AGENTS_ROOT="$workspace_dir" "$repo_dir/scripts/install" --with-agents 2>&1)"
  status=$?
  set -e

  assert_eq "1" "$status" "with-agents install should fail with an empty source"
  assert_contains "$output" "A populated AGENTS.local.md is required" "with-agents should explain its source requirement"
  assert_not_exists "$home_dir/.cursor/skills/implement" "source validation should run before Cursor install"
  assert_not_exists "$home_dir/.codex/skills/implement" "source validation should run before Codex install"
  assert_not_exists "$home_dir/.claude/skills/implement" "source validation should run before Claude Code install"
}

test_with_agents_links_every_guidance_surface_and_persists_opt_in() {
  repo_dir="$(make_git_repo_copy)"
  home_dir="$(make_agent_home)"
  workspace_dir="$(make_temp_dir)"

  HOME="$home_dir" AGENTIC_ENGINEERING_CURSOR_AGENTS_ROOT="$workspace_dir" "$repo_dir/scripts/install" --with-agents

  assert_symlink_target \
    "$workspace_dir/AGENTS.md" \
    "$repo_dir/AGENTS.local.md" \
    "with-agents should link Cursor workspace guidance"
  assert_symlink_target \
    "$home_dir/.codex/AGENTS.md" \
    "$repo_dir/AGENTS.local.md" \
    "with-agents should link Codex guidance"
  assert_symlink_target \
    "$home_dir/.claude/CLAUDE.md" \
    "$repo_dir/AGENTS.local.md" \
    "with-agents should link Claude Code guidance under the filename it reads"
  configured_source="$(git -C "$repo_dir" config --local --get agenticEngineering.agentsSync)"
  assert_eq "$repo_dir" "$configured_source" "with-agents should remember the source clone"
}

test_bare_install_repairs_guidance_after_opt_in() {
  repo_dir="$(make_git_repo_copy)"
  home_dir="$(make_agent_home)"
  workspace_dir="$(make_temp_dir)"

  HOME="$home_dir" AGENTIC_ENGINEERING_CURSOR_AGENTS_ROOT="$workspace_dir" "$repo_dir/scripts/install" --with-agents
  rm -f "$workspace_dir/AGENTS.md" "$home_dir/.codex/AGENTS.md" "$home_dir/.claude/CLAUDE.md"

  HOME="$home_dir" AGENTIC_ENGINEERING_CURSOR_AGENTS_ROOT="$workspace_dir" "$repo_dir/scripts/install"

  assert_symlink_target "$workspace_dir/AGENTS.md" "$repo_dir/AGENTS.local.md" "bare install should restore Cursor guidance after opt-in"
  assert_symlink_target "$home_dir/.codex/AGENTS.md" "$repo_dir/AGENTS.local.md" "bare install should restore Codex guidance after opt-in"
  assert_symlink_target "$home_dir/.claude/CLAUDE.md" "$repo_dir/AGENTS.local.md" "bare install should restore Claude Code guidance after opt-in"
}

test_hooks_run_the_installer_without_recursion() {
  repo_dir="$(make_git_repo_copy)"
  home_dir="$(make_agent_home)"
  workspace_dir="$(make_temp_dir)"

  HOME="$home_dir" AGENTIC_ENGINEERING_CURSOR_AGENTS_ROOT="$workspace_dir" "$repo_dir/scripts/install" --with-agents

  for hook_name in post-checkout post-commit post-merge; do
    hook_path="$repo_dir/.git/hooks/$hook_name"
    assert_exists "$hook_path" "install should create $hook_name"
    assert_file_contains "$hook_path" "agentic-engineering-skill-sync" "$hook_name should carry the ownership marker"
    assert_file_contains "$hook_path" "AGENTIC_ENGINEERING_SKIP_HOOKS=1" "$hook_name should avoid recursion"
    assert_file_contains "$hook_path" "scripts/install" "$hook_name should call the installer"
  done

  rm -f "$workspace_dir/AGENTS.md" "$home_dir/.codex/AGENTS.md" "$home_dir/.claude/CLAUDE.md"
  git -C "$repo_dir" config user.name "Agentic Engineering Test"
  git -C "$repo_dir" config user.email "agentic-engineering@example.invalid"
  HOME="$home_dir" AGENTIC_ENGINEERING_CURSOR_AGENTS_ROOT="$workspace_dir" \
    git -C "$repo_dir" commit --allow-empty -m "trigger sync" >/dev/null

  assert_symlink_target "$workspace_dir/AGENTS.md" "$repo_dir/AGENTS.local.md" "hook should restore Cursor guidance"
  assert_symlink_target "$home_dir/.codex/AGENTS.md" "$repo_dir/AGENTS.local.md" "hook should restore Codex guidance"
  assert_symlink_target "$home_dir/.claude/CLAUDE.md" "$repo_dir/AGENTS.local.md" "hook should restore Claude Code guidance"
}

test_different_clone_opt_in_does_not_enable_guidance() {
  repo_dir="$(make_git_repo_copy)"
  home_dir="$(make_agent_home)"
  workspace_dir="$(make_temp_dir)"
  git -C "$repo_dir" config --local agenticEngineering.agentsSync "$home_dir/other-playbook"

  HOME="$home_dir" AGENTIC_ENGINEERING_CURSOR_AGENTS_ROOT="$workspace_dir" "$repo_dir/scripts/install"

  assert_not_exists "$workspace_dir/AGENTS.md" "another clone's opt-in should not enable Cursor guidance"
  assert_not_exists "$home_dir/.codex/AGENTS.md" "another clone's opt-in should not enable Codex guidance"
  assert_not_exists "$home_dir/.claude/CLAUDE.md" "another clone's opt-in should not enable Claude Code guidance"
}

test_guidance_claims_empty_placeholders_and_preserves_user_content() {
  repo_dir="$(make_repo_copy)"
  home_dir="$(make_agent_home)"
  workspace_dir="$(make_temp_dir)"
  other_dir="$(make_temp_dir)"
  : > "$workspace_dir/AGENTS.md"
  printf 'my Codex guidance\n' > "$home_dir/.codex/AGENTS.md"
  printf 'other Claude guidance\n' > "$other_dir/CLAUDE.md"
  ln -s "$other_dir/CLAUDE.md" "$home_dir/.claude/CLAUDE.md"

  output="$(HOME="$home_dir" AGENTIC_ENGINEERING_CURSOR_AGENTS_ROOT="$workspace_dir" "$repo_dir/scripts/install" --with-agents 2>&1)"

  assert_symlink_target "$workspace_dir/AGENTS.md" "$repo_dir/AGENTS.local.md" "install should claim an empty guidance placeholder"
  assert_file_contains "$home_dir/.codex/AGENTS.md" "my Codex guidance" "install should preserve non-empty guidance"
  assert_symlink_target "$home_dir/.claude/CLAUDE.md" "$other_dir/CLAUDE.md" "install should preserve guidance linked elsewhere"
  assert_contains "$output" "existing non-empty file" "install should report preserved guidance files"
  assert_contains "$output" "links outside this repo" "install should report preserved foreign links"
}

test_with_agents_skips_account_home_workspace_guidance() {
  home_dir="$(make_agent_home)"
  repo_dir="$home_dir/agentic_engineering"
  mkdir -p "$repo_dir"
  cp -R "$ROOT_DIR/." "$repo_dir/"
  rm -rf "$repo_dir/.git"
  repo_dir="$(cd "$repo_dir" && pwd -P)"

  HOME="$home_dir" "$repo_dir/scripts/install" --with-agents

  assert_not_exists "$home_dir/AGENTS.md" "install should not create workspace guidance in the account home"
  assert_symlink_target "$home_dir/.codex/AGENTS.md" "$repo_dir/AGENTS.local.md" "install should still link Codex guidance"
  assert_symlink_target "$home_dir/.claude/CLAUDE.md" "$repo_dir/AGENTS.local.md" "install should still link Claude Code guidance"
}

test_codex_same_name_skills_are_authoritative_and_stale_managed_skills_are_removed() {
  repo_dir="$(make_repo_copy)"
  home_dir="$(make_agent_home)"
  codex_skills="$home_dir/.codex/skills"
  mkdir -p "$codex_skills/implement" "$codex_skills/custom" "$codex_skills/removed-skill" "$codex_skills/.system/system-skill"
  printf 'stale\n' > "$codex_skills/implement/EXTRA.txt"
  printf 'custom\n' > "$codex_skills/custom/SKILL.md"
  printf '%s\n' "$repo_dir" > "$codex_skills/removed-skill/.agentic-engineering-skill-source"
  printf 'removed\n' > "$codex_skills/removed-skill/SKILL.md"
  printf 'system\n' > "$codex_skills/.system/system-skill/SKILL.md"

  HOME="$home_dir" "$repo_dir/scripts/install"

  assert_not_exists "$codex_skills/implement/EXTRA.txt" "install should replace a same-name Codex skill directory"
  assert_file_contains "$codex_skills/implement/SKILL.md" "name: implement" "install should refresh the authoritative Codex skill"
  assert_not_exists "$codex_skills/removed-skill" "install should remove stale mirrors owned by this clone"
  assert_exists "$codex_skills/custom/SKILL.md" "install should preserve unrelated Codex skills"
  assert_exists "$codex_skills/.system/system-skill/SKILL.md" "install should preserve Codex system skills"
}

test_cursor_and_claude_collisions_are_preserved() {
  repo_dir="$(make_repo_copy)"
  home_dir="$(make_agent_home)"
  other_dir="$(make_temp_dir)"
  mkdir -p "$home_dir/.cursor/skills" "$home_dir/.claude/skills" "$other_dir/implement"
  ln -s "$other_dir/implement" "$home_dir/.cursor/skills/implement"
  ln -s "$other_dir/implement" "$home_dir/.claude/skills/implement"

  HOME="$home_dir" "$repo_dir/scripts/install"

  assert_symlink_target "$home_dir/.cursor/skills/implement" "$other_dir/implement" "install should preserve a Cursor collision"
  assert_symlink_target "$home_dir/.claude/skills/implement" "$other_dir/implement" "install should preserve a Claude Code collision"
}

test_refuses_unmanaged_hook() {
  repo_dir="$(make_git_repo_copy)"
  home_dir="$(make_temp_dir)"
  hook_path="$repo_dir/.git/hooks/post-commit"
  printf '#!/usr/bin/env bash\nexit 0\n' > "$hook_path"
  chmod +x "$hook_path"

  set +e
  output="$(HOME="$home_dir" "$repo_dir/scripts/install" 2>&1)"
  status=$?
  set -e

  assert_eq "1" "$status" "install should fail on an unmanaged hook conflict"
  assert_contains "$output" "Refusing to overwrite existing unmanaged hook" "install should explain the hook conflict"
}

test_skips_missing_agent_homes
test_default_install_syncs_skills_without_guidance
test_with_agents_requires_populated_source_before_installing
test_with_agents_links_every_guidance_surface_and_persists_opt_in
test_bare_install_repairs_guidance_after_opt_in
test_hooks_run_the_installer_without_recursion
test_different_clone_opt_in_does_not_enable_guidance
test_guidance_claims_empty_placeholders_and_preserves_user_content
test_with_agents_skips_account_home_workspace_guidance
test_codex_same_name_skills_are_authoritative_and_stale_managed_skills_are_removed
test_cursor_and_claude_collisions_are_preserved
test_refuses_unmanaged_hook
