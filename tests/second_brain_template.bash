#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
. "$ROOT_DIR/tests/helpers/assert.sh"
trap cleanup_temp_dirs EXIT

TEMPLATE_PATH="$ROOT_DIR/SECOND_BRAIN.md"
AUDIT_SKILL="$ROOT_DIR/skills/audit-second-brain/SKILL.md"
VALIDATOR="$ROOT_DIR/skills/audit-second-brain/scripts/validate_portable_template.sh"
START_MARKER='<!-- second-brain-template: portable-v5 -->'
END_MARKER='<!-- /second-brain-template -->'

current_marked_baseline() {
  sed -n '/^<!-- second-brain-template: portable-v5 -->$/,/^<!-- \/second-brain-template -->$/p' "$TEMPLATE_PATH"
}

write_canonical_core_files() {
  temp_dir="$1"

  mkdir -p "$temp_dir/.second_brain"
  printf '%s\n' '# Architecture' > "$temp_dir/.second_brain/ARCHITECTURE.md"
  printf '%s\n' '# Code Pointers' > "$temp_dir/.second_brain/CODE_POINTERS.md"
  printf '%s\n' '---' 'last_full_audit: 2026-08-06' '---' '' '# Conventions' \
    > "$temp_dir/.second_brain/CONVENTIONS.md"
  printf '%s\n' '# Decisions' > "$temp_dir/.second_brain/DECISIONS.md"
  printf '%s\n' '# Deferred Work' > "$temp_dir/.second_brain/DEFERRED.md"
}

test_template_has_one_current_portable_boundary() {
  start_count="$(grep -Fxc "$START_MARKER" "$TEMPLATE_PATH" || true)"
  end_count="$(grep -Fxc "$END_MARKER" "$TEMPLATE_PATH" || true)"

  assert_eq '1' "$start_count" 'portable template should have one current start marker'
  assert_eq '1' "$end_count" 'portable template should have one closing marker'
}

test_audit_migrates_any_existing_template_without_history_matrix() {
  assert_file_contains \
    "$AUDIT_SKILL" \
    'carries an older marker' \
    'audit should migrate unversioned, older, and customized second brains'
  assert_file_contains \
    "$AUDIT_SKILL" \
    'version-specific migration branches.' \
    'audit should avoid a version-by-version compatibility matrix'
  assert_file_contains \
    "$AUDIT_SKILL" \
    'migration-review subsection' \
    'audit should preserve ambiguous target-owned content for review'
  assert_file_contains \
    "$AUDIT_SKILL" \
    'without losing its entries or durable content' \
    'audit should preserve legacy deferred-work content while renaming the file'
  assert_file_contains \
    "$AUDIT_SKILL" \
    'Require `status=valid`.' \
    'audit should validate the completed migration'
  assert_file_contains \
    "$AUDIT_SKILL" \
    'Core knowledge-file presentation' \
    'audit should define canonical core knowledge-file presentation'
}

test_validator_accepts_exact_baseline_with_extension() {
  temp_dir="$(make_temp_dir)"
  target_path="$temp_dir/SECOND_BRAIN.md"
  current_marked_baseline > "$target_path"
  printf '\n## Repository-Specific Extensions\n\nKeep this target-owned rule.\n' >> "$target_path"

  output="$($VALIDATOR --target "$target_path" --template "$TEMPLATE_PATH")"
  assert_eq 'status=valid' "$output" 'validator should accept the current baseline and an extension'
}

test_validator_accepts_canonical_core_files() {
  temp_dir="$(make_temp_dir)"
  target_path="$temp_dir/SECOND_BRAIN.md"
  current_marked_baseline > "$target_path"
  write_canonical_core_files "$temp_dir"

  output="$($VALIDATOR --target "$target_path" --template "$TEMPLATE_PATH")"
  assert_eq 'status=valid' "$output" 'validator should accept canonical core knowledge files'
}

test_validator_rejects_changed_portable_baseline() {
  temp_dir="$(make_temp_dir)"
  target_path="$temp_dir/SECOND_BRAIN.md"
  current_marked_baseline | sed 's/context across coding sessions\./altered context across coding sessions./' > "$target_path"

  if output="$($VALIDATOR --target "$target_path" --template "$TEMPLATE_PATH" 2>&1)"; then
    fail 'validator should reject a changed portable baseline'
  fi
  assert_contains "$output" 'does not match the canonical template' 'validator should explain baseline mismatch'
}

test_validator_rejects_remaining_legacy_backlog() {
  temp_dir="$(make_temp_dir)"
  target_path="$temp_dir/SECOND_BRAIN.md"
  current_marked_baseline > "$target_path"
  mkdir "$temp_dir/.second_brain"
  : > "$temp_dir/.second_brain/BACKLOG.md"

  if output="$($VALIDATOR --target "$target_path" --template "$TEMPLATE_PATH" 2>&1)"; then
    fail 'validator should reject a remaining legacy backlog file'
  fi
  assert_contains "$output" 'Legacy deferred-work file remains' 'validator should explain legacy-file failure'
}

test_validator_rejects_legacy_deferred_heading() {
  temp_dir="$(make_temp_dir)"
  target_path="$temp_dir/SECOND_BRAIN.md"
  current_marked_baseline > "$target_path"
  write_canonical_core_files "$temp_dir"
  printf '%s\n' '# Backlog' > "$temp_dir/.second_brain/DEFERRED.md"

  if output="$($VALIDATOR --target "$target_path" --template "$TEMPLATE_PATH" 2>&1)"; then
    fail 'validator should reject the legacy deferred-work heading'
  fi
  assert_contains "$output" 'noncanonical top-level heading' 'validator should explain legacy-heading failure'
}

test_validator_rejects_legacy_knowledge_file_metadata() {
  temp_dir="$(make_temp_dir)"
  target_path="$temp_dir/SECOND_BRAIN.md"
  current_marked_baseline > "$target_path"
  write_canonical_core_files "$temp_dir"
  printf '%s\n' '---' 'summary: "Legacy summary"' '---' '' '# Architecture' \
    > "$temp_dir/.second_brain/ARCHITECTURE.md"

  if output="$($VALIDATOR --target "$target_path" --template "$TEMPLATE_PATH" 2>&1)"; then
    fail 'validator should reject legacy metadata in non-conventions knowledge files'
  fi
  assert_contains "$output" 'forbidden front matter' 'validator should explain legacy metadata failure'
}

test_validator_rejects_legacy_format_comments() {
  temp_dir="$(make_temp_dir)"
  target_path="$temp_dir/SECOND_BRAIN.md"
  current_marked_baseline > "$target_path"
  write_canonical_core_files "$temp_dir"
  printf '%s\n' '# Code Pointers' '<!-- Format: table -->' \
    > "$temp_dir/.second_brain/CODE_POINTERS.md"

  if output="$($VALIDATOR --target "$target_path" --template "$TEMPLATE_PATH" 2>&1)"; then
    fail 'validator should reject legacy knowledge-file format comments'
  fi
  assert_contains "$output" 'legacy format comment' 'validator should explain legacy format-comment failure'
}

test_validator_rejects_extra_conventions_metadata() {
  temp_dir="$(make_temp_dir)"
  target_path="$temp_dir/SECOND_BRAIN.md"
  current_marked_baseline > "$target_path"
  write_canonical_core_files "$temp_dir"
  printf '%s\n' '---' 'last_full_audit: 2026-08-06' 'summary: "Legacy summary"' '---' '' \
    '# Conventions' > "$temp_dir/.second_brain/CONVENTIONS.md"

  if output="$($VALIDATOR --target "$target_path" --template "$TEMPLATE_PATH" 2>&1)"; then
    fail 'validator should reject extra conventions metadata'
  fi
  assert_contains "$output" 'must contain only last_full_audit' 'validator should explain conventions metadata failure'
}

test_validator_rejects_missing_conventions_metadata() {
  temp_dir="$(make_temp_dir)"
  target_path="$temp_dir/SECOND_BRAIN.md"
  current_marked_baseline > "$target_path"
  write_canonical_core_files "$temp_dir"
  printf '%s\n' '# Conventions' > "$temp_dir/.second_brain/CONVENTIONS.md"

  if output="$($VALIDATOR --target "$target_path" --template "$TEMPLATE_PATH" 2>&1)"; then
    fail 'validator should reject missing conventions audit metadata'
  fi
  assert_contains "$output" 'lacks required audit front matter' 'validator should explain missing conventions metadata'
}

test_validator_rejects_malformed_conventions_metadata() {
  temp_dir="$(make_temp_dir)"
  target_path="$temp_dir/SECOND_BRAIN.md"
  current_marked_baseline > "$target_path"
  write_canonical_core_files "$temp_dir"
  printf '%s\n' '---' 'last_full_audit: yesterday' '---' '' '# Conventions' \
    > "$temp_dir/.second_brain/CONVENTIONS.md"

  if output="$($VALIDATOR --target "$target_path" --template "$TEMPLATE_PATH" 2>&1)"; then
    fail 'validator should reject malformed conventions audit metadata'
  fi
  assert_contains "$output" 'must contain only last_full_audit' 'validator should explain malformed conventions metadata'
}

test_validator_rejects_impossible_conventions_audit_date() {
  temp_dir="$(make_temp_dir)"
  target_path="$temp_dir/SECOND_BRAIN.md"
  current_marked_baseline > "$target_path"
  write_canonical_core_files "$temp_dir"
  printf '%s\n' '---' 'last_full_audit: 2026-02-30' '---' '' '# Conventions' \
    > "$temp_dir/.second_brain/CONVENTIONS.md"

  if output="$($VALIDATOR --target "$target_path" --template "$TEMPLATE_PATH" 2>&1)"; then
    fail 'validator should reject an impossible conventions audit date'
  fi
  assert_contains "$output" 'invalid calendar date' 'validator should explain impossible-date failure'
}

test_validator_accepts_leap_day_conventions_audit_date() {
  temp_dir="$(make_temp_dir)"
  target_path="$temp_dir/SECOND_BRAIN.md"
  current_marked_baseline > "$target_path"
  write_canonical_core_files "$temp_dir"
  printf '%s\n' '---' 'last_full_audit: 2024-02-29' '---' '' '# Conventions' \
    > "$temp_dir/.second_brain/CONVENTIONS.md"

  output="$($VALIDATOR --target "$target_path" --template "$TEMPLATE_PATH")"
  assert_eq 'status=valid' "$output" 'validator should accept a valid leap-day audit date'
}

test_validator_rejects_duplicate_conventions_metadata() {
  temp_dir="$(make_temp_dir)"
  target_path="$temp_dir/SECOND_BRAIN.md"
  current_marked_baseline > "$target_path"
  write_canonical_core_files "$temp_dir"
  printf '%s\n' '---' 'last_full_audit: 2026-08-06' 'last_full_audit: 2026-08-06' '---' '' \
    '# Conventions' > "$temp_dir/.second_brain/CONVENTIONS.md"

  if output="$($VALIDATOR --target "$target_path" --template "$TEMPLATE_PATH" 2>&1)"; then
    fail 'validator should reject duplicate conventions audit metadata'
  fi
  assert_contains "$output" 'must contain exactly one last_full_audit' 'validator should explain duplicate conventions metadata'
}

test_template_has_one_current_portable_boundary
test_audit_migrates_any_existing_template_without_history_matrix
test_validator_accepts_exact_baseline_with_extension
test_validator_accepts_canonical_core_files
test_validator_rejects_changed_portable_baseline
test_validator_rejects_remaining_legacy_backlog
test_validator_rejects_legacy_deferred_heading
test_validator_rejects_legacy_knowledge_file_metadata
test_validator_rejects_legacy_format_comments
test_validator_rejects_extra_conventions_metadata
test_validator_rejects_missing_conventions_metadata
test_validator_rejects_malformed_conventions_metadata
test_validator_rejects_impossible_conventions_audit_date
test_validator_accepts_leap_day_conventions_audit_date
test_validator_rejects_duplicate_conventions_metadata
