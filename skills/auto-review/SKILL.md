---
name: auto-review
description: Bounded implementation review for an orchestrator. Use for self-review or an independent check during implementation; check unnecessary scope, correctness, and acceptance without the human-facing PR review process.
---

# Auto review

The implementer or another eligible agent can use this skill. Follow `CODING_STANDARDS.md` and the caller
for whether independence is required; this skill does not request another agent. Re-read the
actual diff against the acceptance criteria, relevant contracts, and validation results. A recap
of implementation steps or passing tests is not a review.
Inspect the entire assigned diff and affected behavior using the supplied implementation context.
Do not delegate further or load the full-review workflow. PR feedback collection and formal
review ledgers are outside this skill's scope. The orchestrator owns acceptance.

First ask what can be removed while preserving the requested behavior and established contracts.
Check whether deletion, existing repository code, standard-library or platform functionality can
replace an addition. Verify suitability before proposing a replacement. Do not trade correctness,
readability, security, or required verification for fewer lines, or expand into unrelated cleanup.

Every addition needs a present requirement or established affected contract. Speculative reuse
and existing behavior alone do not justify abstractions or compatibility layers. Check supported
callers, support policy, and persisted-data contracts where relevant. Demonstrated unnecessary
scope blocks acceptance even when tests pass; unresolved necessity questions must be resolved.

Read applicable coding standards when not already available in current context. Check
correctness, acceptance coverage, and changed prose against those standards. Validate suspected issues against the source and affected callers. Reuse current
passing checks; run another only for a concrete uncertainty or an outstanding requirement.

Identify the review as self-review or independent review. Return actionable findings with
location, evidence, consequence, and a scoped remedy. For excess
scope, identify what to remove or reuse and why required behavior remains satisfied. Combine
related findings and discard unsupported speculation. Keep each finding as short as the evidence
allows. State any unresolved questions or coverage gaps. If none, say no issues were found and
briefly identify the reviewed scope and verification used. No separate checklist or acceptance
ceremony is required; incomplete coverage is not a pass.
