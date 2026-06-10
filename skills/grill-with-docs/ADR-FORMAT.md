# Decision Record Format

Prefer the repository's existing decision-record format and directory. This file is a
fallback for repos that do not already define one.

## Location

Use the first existing convention that applies:

1. `docs/architecture/decision_records/`
2. `docs/adr/`
3. `docs/adrs/`
4. `.claude/DECISIONS.md`

If none exists, create `docs/adr/` lazily when the first decision record is needed.

For files under `docs/`, preserve local requirements such as YAML frontmatter,
proprietary headers, numbering schemes, ticket prefixes, and status metadata.

## Minimal Template

```md
# {Short title of the decision}

{1-3 sentences: what was decided, what context forced the choice, and why this option won.}
```

## Optional Sections

Only add sections when they carry real information:

- **Status**: `proposed`, `accepted`, `deprecated`, or `superseded`
- **Context**: constraints or facts not visible in code
- **Considered Options**: alternatives worth remembering
- **Consequences**: downstream effects a future maintainer could miss
- **Follow-ups**: implementation or validation work that is not part of the decision

## When to Record

Record a decision only when all three are true:

1. **Hard to reverse**: changing it later has meaningful cost.
2. **Surprising without context**: a future reader would wonder why this path was chosen.
3. **Real trade-off**: reasonable alternatives existed and were rejected for specific reasons.

## What Qualifies

- Architectural shape or ownership boundaries.
- Integration patterns between systems or contexts.
- Technology choices with meaningful lock-in.
- Scope decisions, especially explicit non-goals.
- Deliberate deviations from the obvious path.
- Constraints not visible in code.
- Rejected alternatives that would otherwise be re-proposed.

If a repo uses `.claude/DECISIONS.md`, record durable agent-facing decisions there too
when future agents need the rationale to avoid re-litigating the same choice.
