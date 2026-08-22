#!/usr/bin/env bash
set -euo pipefail

readonly CURRENT_START_MARKER='<!-- second-brain-template: portable-v5 -->'
readonly END_MARKER='<!-- /second-brain-template -->'
readonly -a CORE_KNOWLEDGE_FILES=(
  ARCHITECTURE.md
  CODE_POINTERS.md
  CONVENTIONS.md
  DECISIONS.md
  DEFERRED.md
)

target_path=''
template_path=''

usage() {
  printf '%s\n' 'Usage: validate_portable_template.sh --target PATH --template PATH' >&2
}

marker_count() {
  marker="$1"
  file_path="$2"
  grep -Fxc "$marker" "$file_path" || true
}

marker_line() {
  marker="$1"
  file_path="$2"
  grep -Fnx "$marker" "$file_path" | cut -d: -f1
}

extract_baseline() {
  file_path="$1"
  output_path="$2"
  start_line="$(marker_line "$CURRENT_START_MARKER" "$file_path")"
  end_line="$(marker_line "$END_MARKER" "$file_path")"

  if [ "$start_line" -ge "$end_line" ]; then
    printf '%s\n' "Invalid portable-template marker order in $file_path" >&2
    return 1
  fi

  sed -n "${start_line},${end_line}p" "$file_path" > "$output_path"
}

expected_heading() {
  knowledge_file="$1"

  case "$knowledge_file" in
    ARCHITECTURE.md)
      printf '%s\n' '# Architecture'
      ;;
    CODE_POINTERS.md)
      printf '%s\n' '# Code Pointers'
      ;;
    CONVENTIONS.md)
      printf '%s\n' '# Conventions'
      ;;
    DECISIONS.md)
      printf '%s\n' '# Decisions'
      ;;
    DEFERRED.md)
      printf '%s\n' '# Deferred Work'
      ;;
  esac
}

valid_calendar_date() {
  audit_date="$1"

  awk -v audit_date="$audit_date" '
    BEGIN {
      split(audit_date, parts, "-")
      year = parts[1] + 0
      month = parts[2] + 0
      day = parts[3] + 0

      if (year < 1 || month < 1 || month > 12) {
        exit 1
      }

      days_in_month[1] = 31
      days_in_month[2] = 28
      days_in_month[3] = 31
      days_in_month[4] = 30
      days_in_month[5] = 31
      days_in_month[6] = 30
      days_in_month[7] = 31
      days_in_month[8] = 31
      days_in_month[9] = 30
      days_in_month[10] = 31
      days_in_month[11] = 30
      days_in_month[12] = 31

      if (month == 2 && year % 4 == 0 && (year % 100 != 0 || year % 400 == 0)) {
        days_in_month[2] = 29
      }

      exit !(day >= 1 && day <= days_in_month[month])
    }
  '
}

validate_knowledge_file() {
  knowledge_file="$1"
  knowledge_path="$2"
  expected_top_level_heading="$(expected_heading "$knowledge_file")"
  front_matter_end_line=0
  body_start_line=1
  first_line="$(sed -n '1p' "$knowledge_path")"

  if grep -Eq '<!--[[:space:]]*Format:' "$knowledge_path"; then
    printf '%s\n' "Second-brain file contains a legacy format comment: $knowledge_path" >&2
    return 1
  fi

  if [ "$first_line" = '---' ]; then
    front_matter_end_line="$(
      awk 'NR > 1 && $0 == "---" { print NR; exit }' "$knowledge_path"
    )"

    if [ -z "$front_matter_end_line" ]; then
      printf '%s\n' "Second-brain file has unclosed front matter: $knowledge_path" >&2
      return 1
    fi

    if [ "$knowledge_file" != 'CONVENTIONS.md' ]; then
      printf '%s\n' "Second-brain file has forbidden front matter: $knowledge_path" >&2
      return 1
    fi

    metadata_count=0
    while IFS= read -r metadata_line; do
      [ -z "$metadata_line" ] && continue
      metadata_count=$((metadata_count + 1))
      if [[ ! "$metadata_line" =~ ^last_full_audit:[[:space:]][0-9]{4}-[0-9]{2}-[0-9]{2}$ ]]; then
        printf '%s\n' "Conventions front matter must contain only last_full_audit: $knowledge_path" >&2
        return 1
      fi
      audit_date="${metadata_line#last_full_audit: }"
      if ! valid_calendar_date "$audit_date"; then
        printf '%s\n' "Conventions front matter has an invalid calendar date: $knowledge_path" >&2
        return 1
      fi
    done < <(sed -n "2,$((front_matter_end_line - 1))p" "$knowledge_path")

    if [ "$metadata_count" -ne 1 ]; then
      printf '%s\n' "Conventions front matter must contain exactly one last_full_audit: $knowledge_path" >&2
      return 1
    fi

    body_start_line=$((front_matter_end_line + 1))
  elif [ "$knowledge_file" = 'CONVENTIONS.md' ]; then
    printf '%s\n' "Conventions file lacks required audit front matter: $knowledge_path" >&2
    return 1
  fi

  first_body_line="$(
    awk -v start_line="$body_start_line" 'NR >= start_line && NF { print; exit }' "$knowledge_path"
  )"
  if [ "$first_body_line" != "$expected_top_level_heading" ]; then
    printf '%s\n' "Second-brain file has a noncanonical top-level heading: $knowledge_path" >&2
    return 1
  fi
}

while [ "$#" -gt 0 ]; do
  case "$1" in
    --target)
      target_path="$2"
      shift 2
      ;;
    --template)
      template_path="$2"
      shift 2
      ;;
    *)
      usage
      exit 1
      ;;
  esac
done

if [ -z "$target_path" ] || [ -z "$template_path" ]; then
  usage
  exit 1
fi

if [ ! -f "$target_path" ] || [ ! -f "$template_path" ]; then
  printf '%s\n' 'Target and canonical template must be regular files' >&2
  exit 1
fi

template_start_count="$(marker_count "$CURRENT_START_MARKER" "$template_path")"
template_end_count="$(marker_count "$END_MARKER" "$template_path")"
target_start_count="$(marker_count "$CURRENT_START_MARKER" "$target_path")"
target_end_count="$(marker_count "$END_MARKER" "$target_path")"

if [ "$template_start_count" -ne 1 ] || [ "$template_end_count" -ne 1 ]; then
  printf '%s\n' 'Canonical template has an invalid portable-template boundary' >&2
  exit 1
fi

if [ "$target_start_count" -ne 1 ] || [ "$target_end_count" -ne 1 ]; then
  printf '%s\n' 'Target has an invalid portable-template boundary' >&2
  exit 1
fi

target_start_line="$(marker_line "$CURRENT_START_MARKER" "$target_path")"
if [ "$target_start_line" -ne 1 ]; then
  printf '%s\n' 'Target contains content before the portable-template boundary' >&2
  exit 1
fi

legacy_backlog_path="$(dirname "$target_path")/.second_brain/BACKLOG.md"
if [ -e "$legacy_backlog_path" ]; then
  printf '%s\n' "Legacy deferred-work file remains: $legacy_backlog_path" >&2
  exit 1
fi

second_brain_dir="$(dirname "$target_path")/.second_brain"
for knowledge_file in "${CORE_KNOWLEDGE_FILES[@]}"; do
  knowledge_path="$second_brain_dir/$knowledge_file"
  if [ -f "$knowledge_path" ]; then
    validate_knowledge_file "$knowledge_file" "$knowledge_path"
  fi
done

temp_dir="$(mktemp -d "${TMPDIR:-/tmp}/portable-template-validation.XXXXXX")"
trap 'rm -rf "$temp_dir"' EXIT

template_baseline="$temp_dir/template-baseline.md"
target_baseline="$temp_dir/target-baseline.md"
extract_baseline "$template_path" "$template_baseline"
extract_baseline "$target_path" "$target_baseline"

if ! cmp -s "$template_baseline" "$target_baseline"; then
  printf '%s\n' 'Target portable baseline does not match the canonical template' >&2
  exit 1
fi

printf '%s\n' 'status=valid'
