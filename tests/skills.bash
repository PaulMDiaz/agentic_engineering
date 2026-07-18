#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
. "$ROOT_DIR/tests/helpers/assert.sh"

test_public_skill_inventory_is_complete() {
  for skill_dir in "$ROOT_DIR"/skills/*; do
    [ -d "$skill_dir" ] || continue
    skill_file="$skill_dir/SKILL.md"
    [ -f "$skill_file" ] || continue
    skill_name="$(basename "$skill_dir")"

    assert_file_contains \
      "$skill_file" \
      "name: $skill_name" \
      "skill front matter should match its directory"
    assert_file_contains \
      "$ROOT_DIR/README.md" \
      "| $skill_name |" \
      "README should list every public skill"
    assert_file_contains \
      "$ROOT_DIR/AGENTS.md" \
      "| $skill_name |" \
      "agent guidance should list every public skill"
  done
}

test_second_brain_audit_contract_is_integrated() {
  audit_skill="$ROOT_DIR/skills/audit-second-brain/SKILL.md"

  assert_file_contains \
    "$audit_skill" \
    'last_full_audit: YYYY-MM-DD' \
    "audit skill should define the audit marker"
  assert_file_contains \
    "$audit_skill" \
    'more than 90 days old' \
    "audit skill should define the recovery cadence"
  assert_file_contains \
    "$audit_skill" \
    'normative repository policy' \
    "audit skill should support normative conventions"
  assert_file_contains \
    "$audit_skill" \
    'must leave `last_full_audit` unchanged' \
    "partial audits should not claim full freshness"
  assert_file_contains \
    "$ROOT_DIR/skills/load-second-brain/SKILL.md" \
    'run or follow `audit-second-brain`' \
    "loading should route legacy or overdue guidance to the audit"
  assert_file_contains \
    "$ROOT_DIR/skills/init-second-brain/SKILL.md" \
    'run or follow `audit-second-brain`' \
    "initialization should perform the first audit"
  assert_file_contains \
    "$ROOT_DIR/skills/update-second-brain/SKILL.md" \
    'declared `Sources:` paths or globs changed' \
    "scoped maintenance should follow declared sources"
}

test_repo_conventions_follow_source_contract() {
  conventions_file="$ROOT_DIR/.claude/CONVENTIONS.md"
  audit_date="$(sed -n 's/^last_full_audit: //p' "$conventions_file")"
  missing_sources="$(
    awk '
      /^## / {
        section = $0
        if ((getline source_line) <= 0 || source_line !~ /^Sources: /) {
          print section
        }
      }
    ' "$conventions_file"
  )"

  if [[ ! "$audit_date" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]]; then
    fail "repository conventions should record a YYYY-MM-DD audit date"
  fi
  assert_eq \
    "" \
    "$missing_sources" \
    "every repository convention section should declare sources"
}

test_public_skill_inventory_is_complete
test_second_brain_audit_contract_is_integrated
test_repo_conventions_follow_source_contract
