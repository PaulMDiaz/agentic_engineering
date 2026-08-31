# Architecture

## Repository shape

Agentic Engineering is a documentation-first playbook with small shell-based installation
and verification surfaces.

| Area | Responsibility |
| --- | --- |
| `AGENTS.md` | Repository-local guidance for Agentic Engineering |
| `AGENTS.local.md` | Portable template rendered into machine-local shared guidance |
| `CLAUDE.md` | Compatibility shim that directs Claude-style entry points to `AGENTS.md` |
| `CODING_STANDARDS.md` | Portable engineering rules distributed to other repositories |
| `SECOND_BRAIN.md` | Directly copyable portable second-brain baseline used by this repository and adopters |
| `AGENTS.second-brain.snippet.md` | Delimited integration for an adopter's existing `AGENTS.md` |
| `skills/<name>/` | Canonical reusable workflows and their supporting assets |
| `scripts/install` | Skill and optional guidance reconciliation plus managed Git hooks |
| `scripts/uninstall` | Ownership-checked removal of installed files, hooks, and guidance enrollment |
| `tests/` | Zero-dependency shell regression suite |
| `.second_brain/` | Durable repository decisions, conventions, architecture, pointers, and deferred work |
| `.github/workflows/` | Shell tests, Markdown lint, link checking, and duplicate detection |

## Workstation synchronization

Cursor and Claude Code receive live symlinks to `skills/<name>/`. Codex receives real
directory mirrors tagged with `.agentic-engineering-skill-source`. An explicit first
`scripts/install --with-agents` run renders `AGENTS.local.md` with the resolved checkout
root at the Cursor workspace, Codex, and Claude Code destinations and saves the enrollment
in local Git configuration. Repository Git hooks rerun the plain installer after checkout,
merge, and commit, so skills always reconcile and guidance reconciles only for an enrolled
clone. Root `AGENTS.md` remains repository-local.

Agentic Engineering is an independent distribution. Its installer is not designed to run
concurrently with another playbook that manages the same destination skill names or shared
guidance paths.

## Second-brain distribution

The root `SECOND_BRAIN.md` begins at the `portable-v5` marker, so the same file is both the
repository's operating policy and the source template installed skills copy into adopters.
Cursor skills infer this repository root through their symlink target. Codex mirrors read
the adjacent `.agentic-engineering-skill-source` marker. Adopted repositories remain
self-contained and have no runtime dependency on Agentic Engineering.
