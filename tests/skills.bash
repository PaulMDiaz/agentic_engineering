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
      "repository guidance should list every public skill"
    assert_file_contains \
      "$ROOT_DIR/AGENTS.local.md" \
      "| $skill_name |" \
      "installed shared guidance should list every public skill"
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
  assert_file_contains \
    "$audit_skill" \
    'Repository ownership and portability' \
    "audit should enforce the repository ownership boundary"
  assert_file_contains \
    "$audit_skill" \
    'global/shared/user-local instruction files' \
    "audit should reject external shared guidance as convention evidence"
  assert_file_contains \
    "$ROOT_DIR/skills/update-second-brain/SKILL.md" \
    'global, shared, or user-local' \
    "scoped maintenance should not persist external guidance"
}

test_second_brain_loading_reuses_current_context() {
  assert_file_contains \
    "$ROOT_DIR/SECOND_BRAIN.md" \
    'Reuse Loaded Context' \
    "portable framework should define the context reuse guard"
  assert_file_contains \
    "$ROOT_DIR/skills/load-second-brain/SKILL.md" \
    '## Session Guard' \
    "loader should avoid duplicate reads in the same task"
  assert_file_contains \
    "$ROOT_DIR/skills/implement/SKILL.md" \
    'only to load missing relevant context' \
    "implementation should not reload context unconditionally"
  assert_file_contains \
    "$ROOT_DIR/skills/grill-with-docs/SKILL.md" \
    'only missing relevant' \
    "planning should not reload context unconditionally"
}

test_second_brain_pointer_and_presentation_contract_is_integrated() {
  assert_file_contains \
    "$ROOT_DIR/skills/init-second-brain/SKILL.md" \
    'path/to/file.py::Class.method' \
    'initialization should define symbol-based code pointers'
  assert_file_contains \
    "$ROOT_DIR/skills/load-second-brain/SKILL.md" \
    '**Pointer syntax**' \
    'loading should recognize symbol pointers'
  assert_file_contains \
    "$ROOT_DIR/skills/update-second-brain/SKILL.md" \
    'Prefer `path/to/file.py::Symbol`' \
    'maintenance should prefer symbol pointers'
  assert_file_contains \
    "$ROOT_DIR/skills/audit-second-brain/SKILL.md" \
    'Core knowledge-file presentation' \
    'audits should define canonical knowledge-file presentation'
  assert_file_contains \
    "$ROOT_DIR/skills/audit-second-brain/SKILL.md" \
    '# Deferred Work' \
    'audits should define the canonical deferred-work heading'
  assert_file_contains \
    "$ROOT_DIR/SECOND_BRAIN.md" \
    '## Code Pointer Syntax' \
    'portable second-brain policy should define pointer syntax'
  assert_file_contains \
    "$ROOT_DIR/skills/audit-second-brain/SKILL.md" \
    '### Automatic code-pointer migration' \
    'audits should expose automatic code-pointer migration'
  assert_file_contains \
    "$ROOT_DIR/skills/audit-second-brain/SKILL.md" \
    'During every change-producing audit, inventory and migrate eligible legacy code pointers.' \
    'pointer migration should run during change-producing audits'
  assert_file_contains \
    "$ROOT_DIR/skills/audit-second-brain/SKILL.md" \
    'Do not invent a symbol' \
    'pointer migration should retain ambiguous fallback pointers'
  assert_file_contains \
    "$ROOT_DIR/skills/audit-second-brain/SKILL.md" \
    'without changing their fallback syntax' \
    'pointer migration should preserve legacy fallback notation'
  assert_file_contains \
    "$ROOT_DIR/skills/audit-second-brain/SKILL.md" \
    'exactly one repository-relative source file' \
    'pointer migration should normalize only uniquely verified aliases'
}

test_second_brain_primary_guidance_contract_is_integrated() {
  snippet="$ROOT_DIR/AGENTS.second-brain.snippet.md"
  audit_skill="$ROOT_DIR/skills/audit-second-brain/SKILL.md"

  assert_file_contains \
    "$snippet" \
    '## Second Brain — Primary Repository Guidance' \
    'injected guidance should identify its primary scope'
  assert_file_contains \
    "$snippet" \
    '<!-- second-brain-guidance: portable-v1 -->' \
    'injected guidance should have a stable migration boundary'
  assert_file_contains \
    "$snippet" \
    'Before completing change-producing work, assess whether' \
    'injected guidance should require durable-knowledge assessment'
  assert_file_contains \
    "$snippet" \
    'do not act on the stale claim' \
    'injected guidance should correct stale durable knowledge'
  assert_file_contains \
    "$ROOT_DIR/skills/init-second-brain/SKILL.md" \
    'Place it immediately after any YAML' \
    'initialization should place primary guidance first'
  assert_file_contains \
    "$audit_skill" \
    '### AGENTS.md primary-guidance integration' \
    'audits should migrate existing primary guidance'
  assert_file_contains \
    "$audit_skill" \
    'preserve the ambiguous wording' \
    'audits should preserve ambiguous legacy guidance'
  assert_file_contains \
    "$ROOT_DIR/AGENTS.md" \
    '<!-- second-brain-guidance: portable-v1 -->' \
    'repository guidance should embed the portable primary contract'
  assert_file_contains \
    "$ROOT_DIR/SECOND_BRAIN.md" \
    '## Guidance Authority' \
    'portable policy should define second-brain authority'
}

test_repository_and_installed_agents_guidance_are_separate() {
  repository_guidance="$ROOT_DIR/AGENTS.md"
  installed_guidance="$ROOT_DIR/AGENTS.local.md"
  workstation_doc="$ROOT_DIR/docs/workstation-setup.md"

  assert_file_contains \
    "$repository_guidance" \
    'development-wide or home-level guidance.' \
    'repository guidance should reject global installation'
  assert_file_contains \
    "$installed_guidance" \
    'Follow repository-local `AGENTS.md` files' \
    'installed guidance should defer to repository-local guidance'
  assert_file_contains \
    "$installed_guidance" \
    '~/Documents/Development/agentic_engineering/CODING_STANDARDS.md' \
    'installed guidance should resolve the default standards source explicitly'
  if grep -qF '<!-- second-brain-guidance: portable-v1 -->' "$installed_guidance"; then
    fail 'installed shared guidance should not embed repository-local second-brain policy'
  fi
  installer="$ROOT_DIR/scripts/install"
  script_count="$(find "$ROOT_DIR/scripts" -maxdepth 1 -type f | wc -l | tr -d ' ')"

  assert_file_contains \
    "$workstation_doc" \
    'scripts/install --with-agents' \
    'workstation setup should document explicit guidance enrollment'
  assert_file_contains \
    "$installer" \
    'AGENTS_SOURCE="$ROOT_DIR/AGENTS.local.md"' \
    'installer should use AGENTS.local.md as shared guidance'
  assert_file_contains \
    "$installer" \
    '$CURSOR_AGENTS_ROOT/AGENTS.md' \
    'installer should cover the Cursor development folder'
  assert_file_contains \
    "$installer" \
    '$codex_home/AGENTS.md' \
    'installer should cover Codex guidance'
  assert_file_contains \
    "$installer" \
    '$claude_home/CLAUDE.md' \
    'installer should cover Claude Code under the filename it reads'
  assert_eq "2" "$script_count" 'the workstation interface should contain only install and uninstall scripts'
  assert_exists "$ROOT_DIR/scripts/uninstall" 'the workstation interface should include an uninstaller'
}

test_skill_ownership_guidance_matches_sync_behavior() {
  assert_file_contains \
    "$ROOT_DIR/README.md" \
    'Codex treats a directory with the same' \
    'README should disclose authoritative same-name Codex synchronization'
  assert_file_contains \
    "$ROOT_DIR/.second_brain/CONVENTIONS.md" \
    'Codex synchronization treats same-name skill directories as replaceable' \
    'durable conventions should match Codex synchronization behavior'
  assert_file_contains \
    "$ROOT_DIR/.second_brain/CONVENTIONS.md" \
    'Codex uninstall and stale cleanup remove only mirrors marked as' \
    'durable conventions should scope marker ownership to cleanup behavior'
}

test_agent_review_requires_validated_synthesis() {
  agent_review="$ROOT_DIR/skills/agent-review/SKILL.md"

  assert_file_contains \
    "$agent_review" \
    'Candidate-Finding Validation Gate' \
    'agent review should validate candidates before reporting them'
  assert_file_contains \
    "$agent_review" \
    'Subagent findings are untrusted candidate evidence.' \
    'agent review should reserve final synthesis for the parent'
  assert_file_contains \
    "$agent_review" \
    'Final-Delivery Gate' \
    'agent review should require final-delivery validation'
  assert_file_contains \
    "$agent_review" \
    'Comment anchor' \
    'agent review should distinguish changed comment anchors'
  assert_file_contains \
    "$agent_review" \
    'provide its **Implementation location**' \
    'inline review should require an implementation location without a PR anchor'
  assert_file_contains \
    "$agent_review" \
    'refresh the existing human feedback' \
    'agent review should deduplicate concurrent human feedback'
  assert_file_contains \
    "$agent_review" \
    'feedback could not be collected' \
    'agent review should disclose unavailable PR feedback'
  assert_file_contains \
    "$agent_review" \
    'dependency contract unverified' \
    'agent review should disclose unverifiable dependency contracts'
  assert_file_contains \
    "$agent_review" \
    'String contracts' \
    'agent review should classify behavior-bearing string literals'
  assert_file_contains \
    "$agent_review" \
    'duplicate use across the changed files and direct callers' \
    'agent review should check string literals for local duplication'
}

test_init_second_brain_adopts_existing_knowledge() {
  init_skill="$ROOT_DIR/skills/init-second-brain/SKILL.md"

  assert_file_contains \
    "$init_skill" \
    'Initialize or adopt a committed' \
    "initializer should support existing committed knowledge"
  assert_file_contains \
    "$init_skill" \
    'SECOND_BRAIN.md' \
    "initializer should add the portable entry point"
  assert_file_contains \
    "$init_skill" \
    'Preserve every unrelated instruction' \
    "initializer should preserve unrelated AGENTS guidance"
  assert_file_contains \
    "$init_skill" \
    'source template begins with the portable marker' \
    "initializer should support a directly copyable source template"
  assert_file_contains \
    "$init_skill" \
    '.agentic-engineering-skill-source' \
    "initializer should locate its canonical template source"
  assert_file_contains \
    "$init_skill" \
    'from memory.' \
    "initializer should stop rather than invent canonical templates"
  assert_eq \
    '<!-- second-brain-template: portable-v5 -->' \
    "$(head -n 1 "$ROOT_DIR/SECOND_BRAIN.md")" \
    "portable template should be directly copyable"
  assert_file_contains \
    "$ROOT_DIR/SECOND_BRAIN.md" \
    "This repository's committed, self-contained knowledge base preserves durable" \
    "adopted template should introduce its durable repository context"
  assert_file_contains \
    "$ROOT_DIR/SECOND_BRAIN.md" \
    'Keep Knowledge Repository-Owned' \
    "portable template should prevent imported local guidance"
  assert_file_contains \
    "$init_skill" \
    'Treat the repository root as the evidence boundary' \
    "initializer should not seed external guidance"
}

test_agentic_conventions_follow_source_contract() {
  conventions_file="$ROOT_DIR/.second_brain/CONVENTIONS.md"
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
    fail "Agentic conventions should record a YYYY-MM-DD audit date"
  fi
  assert_eq \
    "" \
    "$missing_sources" \
    "every Agentic convention section should declare sources"
}

test_conventional_commit_guidance_allows_custom_types() {
  assert_file_contains \
    "$ROOT_DIR/CODING_STANDARDS.md" \
    'Other types are allowed.' \
    'commit guidance should follow Conventional Commits custom-type allowance'
  assert_file_contains \
    "$ROOT_DIR/skills/git-recap/SKILL.md" \
    'including custom types.' \
    'git recap should recognize valid custom conventional-commit types'
}

test_unslop_is_default_shared_guidance() {
  assert_file_contains \
    "$ROOT_DIR/AGENTS.local.md" \
    'Apply `unslop` to every agent-authored response and document.' \
    'shared guidance should make unslop the default'
  assert_file_contains \
    "$ROOT_DIR/AGENTS.md" \
    'Apply `unslop` to every agent-authored response and document.' \
    'repository guidance should make unslop the default'
  assert_file_contains \
    "$ROOT_DIR/skills/unslop/SKILL.md" \
    'Do not rewrite quotations,' \
    'unslop should preserve exact source material'
}

test_public_skill_inventory_is_complete
test_second_brain_audit_contract_is_integrated
test_second_brain_loading_reuses_current_context
test_second_brain_pointer_and_presentation_contract_is_integrated
test_second_brain_primary_guidance_contract_is_integrated
test_repository_and_installed_agents_guidance_are_separate
test_skill_ownership_guidance_matches_sync_behavior
test_agent_review_requires_validated_synthesis
test_init_second_brain_adopts_existing_knowledge
test_agentic_conventions_follow_source_contract
test_conventional_commit_guidance_allows_custom_types
test_unslop_is_default_shared_guidance
