---
name: coding-standards
description: Universal coding standards and conventions. Apply to all coding work — new code, reviews, refactoring, debugging.
---

# Coding Standards

Read and follow these rules for all coding work.

## Design

- Pure functions: return new objects, never mutate inputs
- No default parameter values — require explicit arguments
- Functional over OOP for new code; classes only for external connectors
- Keep files under ~500 LOC; split when larger

## Typing

- Strong typing: avoid `Any`
- Use `dict[str, X]` not `Dict[str, Any]`
- Prefer structured models over loose dicts

## Error Handling

- No silent fallbacks — propagate errors, let outer loop handle
- No bare `except Exception` in business logic
- Security-clamping (LLM output validation) is NOT a fallback

## Git & Commits

- Conventional commits: `type(scope): description`
- Atomic commits — one logical change per commit
- No `--force` push without explicit approval

## Security

- `.env` first in `.gitignore`
- Secrets in `.env` only — never hardcode
- Load secrets via `os.environ`, not reading `.env` directly
- `trash` > `rm`
- Never install external tools/plugins without explicit approval
- Mask secrets in output

## LLM Classifiers

- Use safety-tuned models for internet content (not agentic/MoE)
- Always validate/clamp LLM output before acting on it

## Project Conventions

Check `.claude/CONVENTIONS.md` if it exists for project-specific rules.
