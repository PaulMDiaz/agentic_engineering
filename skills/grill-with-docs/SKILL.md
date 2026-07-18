---
name: grill-with-docs
description: Stress-test a plan against project language, code, existing decisions, and docs; resolve terminology one question at a time and update the right docs as decisions settle.
---

# Grill With Docs

Use this skill when the user wants to pressure-test a plan, design, architecture note,
domain model, or decision record before implementation. The session should sharpen the
project language, expose hidden trade-offs, and keep documentation current as the shared
understanding changes.

Ask one question at a time. Wait for the user's answer before continuing. For each
question, include your recommended answer and why you recommend it.

If a question can be answered by reading code or existing docs, inspect those sources
instead of asking the user.

## Startup

1. Load repo guidance:
   - Read the repo's agent instructions and coding standards if they are available.
   - If the repo has a `.claude/` second brain, run or follow `load-second-brain`
     before grilling the plan.
   - Check `CONVENTIONS.md`, `CODE_POINTERS.md`, `DECISIONS.md`, and `ARCHITECTURE.md`
     when they exist and are relevant.
2. Discover local documentation structure before creating anything:
   - Terminology docs: use an existing glossary, context document, architecture doc, or
     decision record when one already captures the relevant language. Do not create a
     `CONTEXT.md` merely because the repo has no existing terminology document.
   - Decision docs: prefer the repo's existing decision-record location. Common paths
     include `docs/architecture/decision_records/`, `docs/adr/`, `docs/adrs/`, and
     `.claude/DECISIONS.md`.
   - If docs under `docs/` require frontmatter, proprietary headers, templates, or
     specific naming, preserve that convention.
3. Identify the plan under review:
   - If the user points to a file, read it.
   - If the plan is only in chat, summarize the plan briefly and confirm the scope.
   - If the plan spans multiple contexts, identify the contexts and their boundaries.

## Grilling Loop

Work down the design tree one decision at a time.

For each unresolved branch:

1. State the dependency or ambiguity.
2. Ask one precise question.
3. Provide your recommended answer.
4. Cite the code or docs that support or contradict the recommendation when available.
5. Wait for feedback before moving to the next question.

Challenge fuzzy or overloaded language immediately:

- If the user says "account", ask whether they mean Customer, User, Tenant, or another
  existing project term.
- If the user uses a term differently from an existing glossary or decision record,
  surface the conflict and ask which definition should win.
- If a statement about behavior contradicts the code, show the contradiction and ask
  whether the plan or the implementation is authoritative.

Use concrete scenarios to test boundaries. Prefer scenarios that force clarity around
ownership, data shape, failure modes, reversibility, and migration cost.

## Documentation Updates

Update docs as decisions settle. Do not wait until the end if a term or decision is
resolved and the repo convention supports immediate edits.

For glossary or domain language:

- Update an existing glossary or context document only when the repository already uses
  one for that purpose.
- Otherwise, capture terminology in the repository's established documentation or a
  decision record only when it is durable and necessary to understand the decision.
- Do not create a standalone glossary or `CONTEXT.md` unless the user explicitly asks
  for one.

For architectural or product decisions:

- Offer a decision record only when all three are true:
  1. The decision is hard to reverse.
  2. The choice would be surprising without context.
  3. The decision involved a real trade-off.
- Use the repo's existing decision-record location and format before falling back to
  `ADR-FORMAT.md`.
- If the repo uses `.claude/DECISIONS.md`, update it for durable agent context when the
  decision changes how future agents should reason about the project.

For second-brain repos:

- Before handoff, run or follow `update-second-brain` if the session changed decisions,
  code pointers, architecture, conventions, backlog, or a declared convention source.
- Verify every second-brain claim you add against the actual files.

## Guardrails

- Preserve existing docs and local templates. Do not replace a repo's decision-record
  system with `docs/adr/` just because the fallback format exists.
- Do not introduce a glossary or context-document convention where the repository does
  not already use one.
- Keep edits narrow. Capture decisions and vocabulary, not full implementation plans
  unless the target document is already a planning artifact.
- Do not create an ADR for an obvious, reversible, or purely mechanical choice.
- Do not invent domain terms when existing project language already works.

## Handoff

When the grilling session pauses or ends, report:

- Resolved terminology and where it was documented.
- Decisions recorded and where they live.
- Remaining open questions, in dependency order.
- Code/docs contradictions that still need owner judgment.
