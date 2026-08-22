# AGENTS.md Second-Brain Snippet

Place this complete, delimited section immediately after any front matter and repository
title in an existing project-specific `AGENTS.md`. Do not replace unrelated instructions.

<!-- second-brain-guidance: portable-v1 -->
## Second Brain — Primary Repository Guidance

For repository context, conventions, architecture, decisions, code pointers, and
durable-maintenance workflow, this section and `SECOND_BRAIN.md` are the primary repository
guidance. Other `AGENTS.md` content remains authoritative for unrelated repository rules.

Before non-trivial work, or read-only work needing repository context beyond the prompt and
a named file or symbol, read and follow `SECOND_BRAIN.md`. Load only the relevant
`.second_brain/` files it selects, and reuse context that remains current.

Before completing change-producing work, assess whether decisions, architecture,
conventions, code pointers, deferred work, or declared convention sources changed. Update
the relevant durable knowledge when it did; otherwise state that no durable update was
needed.

When source code, configuration, or an explicit user request disproves a second-brain
claim, do not act on the stale claim. Verify the source, correct durable knowledge when
permitted, then continue using the corrected guidance.
<!-- /second-brain-guidance -->
