#!/usr/bin/env bash
set -euo pipefail

TEST_TEMP_DIRS=""

fail() {
  printf 'FAIL: %s\n' "$1" >&2
  exit 1
}

track_temp_dir() {
  dir_path="$1"
  TEST_TEMP_DIRS="${TEST_TEMP_DIRS}${TEST_TEMP_DIRS:+
}$dir_path"
}

cleanup_temp_dirs() {
  if [ -z "${TEST_TEMP_DIRS:-}" ]; then
    return 0
  fi

  while IFS= read -r dir_path; do
    [ -n "$dir_path" ] || continue
    rm -rf "$dir_path"
  done <<< "$TEST_TEMP_DIRS"
}

make_temp_dir() {
  dir_path="$(mktemp -d)"
  track_temp_dir "$dir_path"
  printf '%s\n' "$dir_path"
}

assert_eq() {
  expected="$1"
  actual="$2"
  message="$3"
  if [ "$expected" != "$actual" ]; then
    fail "$message (expected: $expected, actual: $actual)"
  fi
}

assert_contains() {
  haystack="$1"
  needle="$2"
  message="$3"
  if [[ "$haystack" != *"$needle"* ]]; then
    fail "$message (missing: $needle)"
  fi
}

assert_exists() {
  path="$1"
  message="$2"
  if [ ! -e "$path" ]; then
    fail "$message ($path)"
  fi
}

assert_not_exists() {
  path="$1"
  message="$2"
  if [ -e "$path" ]; then
    fail "$message ($path)"
  fi
}

assert_symlink_target() {
  path="$1"
  expected="$2"
  message="$3"

  if [ ! -L "$path" ]; then
    fail "$message (not a symlink: $path)"
  fi

  actual="$(readlink "$path")"
  assert_eq "$expected" "$actual" "$message"
}

assert_file_contains() {
  path="$1"
  needle="$2"
  message="$3"

  assert_exists "$path" "$message"
  contents="$(<"$path")"
  assert_contains "$contents" "$needle" "$message"
}
