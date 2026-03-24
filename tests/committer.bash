#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
. "$ROOT_DIR/tests/helpers/assert.sh"
trap cleanup_temp_dirs EXIT

make_repo() {
  repo_dir="$(make_temp_dir)"
  git init "$repo_dir" >/dev/null
  git -C "$repo_dir" config user.name "Test User"
  git -C "$repo_dir" config user.email "test@example.com"
  printf 'base\n' > "$repo_dir/tracked.txt"
  git -C "$repo_dir" add tracked.txt
  git -C "$repo_dir" commit -m "chore: initial" >/dev/null
  printf '%s\n' "$repo_dir"
}

test_rejects_invalid_noninteractive_message() {
  repo_dir="$(make_repo)"
  printf 'change\n' > "$repo_dir/tracked.txt"

  set +e
  output="$(cd "$repo_dir" && "$ROOT_DIR/scripts/committer" "bad message" tracked.txt </dev/null 2>&1)"
  status=$?
  set -e

  assert_eq "1" "$status" "committer should fail for invalid non-interactive messages"
  assert_contains "$output" "Conventional Commits format" "committer should explain the format failure"
}


test_rejects_missing_emoji_in_noninteractive_message() {
  repo_dir="$(make_repo)"
  printf 'change\n' > "$repo_dir/tracked.txt"

  set +e
  output="$(cd "$repo_dir" && "$ROOT_DIR/scripts/committer" "feat(test): update tracked file" tracked.txt </dev/null 2>&1)"
  status=$?
  set -e

  assert_eq "1" "$status" "committer should fail when the emoji is missing"
  assert_contains "$output" "Expected: type(scope)?: emoji description" "committer should explain the emoji requirement"
}

test_commits_only_listed_files() {
  repo_dir="$(make_repo)"
  printf 'first change\n' > "$repo_dir/tracked.txt"
  printf 'new file\n' > "$repo_dir/extra.txt"

  (
    cd "$repo_dir"
    "$ROOT_DIR/scripts/committer" "feat(test): ✨ update tracked file" tracked.txt
  ) >/dev/null

  committed_files="$(git -C "$repo_dir" show --pretty='' --name-only HEAD)"
  assert_eq "tracked.txt" "$committed_files" "committer should only include listed files in the commit"

  status_output="$(git -C "$repo_dir" status --short)"
  assert_contains "$status_output" "?? extra.txt" "committer should leave unlisted files untouched"
}

test_rejects_when_nothing_is_staged() {
  repo_dir="$(make_repo)"

  set +e
  output="$(cd "$repo_dir" && "$ROOT_DIR/scripts/committer" "feat(test): ✨ no-op" tracked.txt 2>&1)"
  status=$?
  set -e

  assert_eq "1" "$status" "committer should fail when git add stages nothing"
  assert_contains "$output" "nothing staged" "committer should explain empty staging"
}

test_rejects_invalid_noninteractive_message
test_rejects_missing_emoji_in_noninteractive_message
test_commits_only_listed_files
test_rejects_when_nothing_is_staged
