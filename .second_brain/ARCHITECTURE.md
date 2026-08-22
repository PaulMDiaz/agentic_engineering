# Architecture

## Repository shape

Agentic Engineering is a documentation-first playbook with small shell-based installation
and verification surfaces.

| Area | Responsibility |
| --- | --- |
| `AGENTS.md` | Repository-local guidance for Agentic Engineering |
| `AGENTS.local.md` | Shared guidance installed at development-wide and Codex locations |
| `CLAUDE.md` | Compatibility shim that directs Claude-style entry points to `AGENTS.md` |
| `CODING_STANDARDS.md` | Portable engineering rules distributed to other repositories |
| `SECOND_BRAIN.md` | Directly copyable portable second-brain baseline used by this repository and adopters |
| `AGENTS.second-brain.snippet.md` | Delimited integration for an adopter's existing `AGENTS.md` |
| `skills/<name>/` | Canonical reusable workflows and their supporting assets |
| `scripts/` | Independent Cursor and Codex skill synchronization plus managed Git hooks |
| `tests/` | Zero-dependency shell regression suite |
| `.second_brain/` | Durable repository decisions, conventions, architecture, pointers, and deferred work |
| `.github/workflows/` | Shell tests, Markdown lint, link checking, and duplicate detection |

## Workstation synchronization

Cursor receives live symlinks to `skills/<name>/`. Codex receives real directory mirrors
tagged with `.agentic-engineering-skill-source`. Development-wide and Codex `AGENTS.md`
links point to `AGENTS.local.md`, leaving root `AGENTS.md` repository-local. Repository Git
hooks run the shared skill-sync wrapper after checkout, merge, and commit.

Agentic Engineering is an independent distribution. Its installer is not designed to run
concurrently with another playbook that manages the same destination skill names or shared
guidance paths.

## Second-brain distribution

The root `SECOND_BRAIN.md` begins at the `portable-v5` marker, so the same file is both the
repository's operating policy and the source template installed skills copy into adopters.
Cursor skills infer this repository root through their symlink target. Codex mirrors read
the adjacent `.agentic-engineering-skill-source` marker. Adopted repositories remain
self-contained and have no runtime dependency on Agentic Engineering.
