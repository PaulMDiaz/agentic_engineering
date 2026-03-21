#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
. "$ROOT_DIR/tests/helpers/assert.sh"
trap cleanup_temp_dirs EXIT

make_repo_copy() {
  repo_dir="$(make_temp_dir)"
  cp -R "$ROOT_DIR/." "$repo_dir/"
  rm -rf "$repo_dir/.git"
  git init "$repo_dir" >/dev/null
  printf '%s\n' "$repo_dir"
}

test_installs_managed_hooks() {
  repo_dir="$(make_repo_copy)"

  (cd "$repo_dir" && ./scripts/install-skill-hooks)

  for hook in post-checkout post-commit post-merge; do
    hook_path="$repo_dir/.git/hooks/$hook"
    assert_exists "$hook_path" "install-skill-hooks should create $hook"
    assert_file_contains "$hook_path" "agentic-engineering-skill-sync" "$hook should be marked as managed"
    assert_file_contains "$hook_path" "scripts/sync-workstation-skills" "$hook should call the sync entry point"
  done
}

test_refuses_to_overwrite_unmanaged_hook() {
  repo_dir="$(make_repo_copy)"
  hook_path="$repo_dir/.git/hooks/post-commit"
  printf '#!/usr/bin/env bash\nexit 0\n' > "$hook_path"
  chmod +x "$hook_path"

  set +e
  output="$(cd "$repo_dir" && ./scripts/install-skill-hooks 2>&1)"
  status=$?
  set -e

  assert_eq "1" "$status" "install-skill-hooks should refuse unmanaged hooks"
  assert_contains "$output" "Refusing to overwrite existing unmanaged hook" "install-skill-hooks should explain refusal"
}

test_uninstall_removes_only_managed_hooks() {
  repo_dir="$(make_repo_copy)"
  (cd "$repo_dir" && ./scripts/install-skill-hooks)

  extra_hook="$repo_dir/.git/hooks/pre-commit"
  printf '#!/usr/bin/env bash\nexit 0\n' > "$extra_hook"
  chmod +x "$extra_hook"

  (cd "$repo_dir" && ./scripts/install-skill-hooks uninstall)

  for hook in post-checkout post-commit post-merge; do
    assert_not_exists "$repo_dir/.git/hooks/$hook" "uninstall should remove managed $hook"
  done
  assert_exists "$extra_hook" "uninstall should keep unrelated hooks"
}

test_installs_managed_hooks
test_refuses_to_overwrite_unmanaged_hook
test_uninstall_removes_only_managed_hooks
