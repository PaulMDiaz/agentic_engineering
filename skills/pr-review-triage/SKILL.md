---
name: pr-review-triage
description: "Triage GitHub PR comments into a /tmp working checklist and stop before implementation. Use when asked to inspect, categorize, or prepare a tracker for PR review feedback."
argument-hint: "[PR number or URL, optional docs/category standard]"
---

# pr-review-triage

Use this skill to turn PR review feedback into a tracked checklist.

This is a triage-only skill. Always stop after creating the initial checklist and delivering the triage summary. Do not implement fixes, update code, mark checklist items complete, open follow-up issues, or post GitHub replies as part of this skill.

## Core Rules

- Create or update a Markdown checklist in `/tmp` or `/private/tmp`.
- Do not make code changes while using this skill.
- Do not mark rows addressed unless the current branch already addresses them before triage begins.
- Keep reviewer-response drafts in the checklist, but do not post them.
- Do not draft responses for bots unless the user explicitly asks.
- Mark informational or no-action rows as `No response required`.
- For future work, recommend durable tracking in an issue, backlog, or documented rationale, but do not create that tracking during this skill.

## Inputs

Parse the user request for:

- PR number or URL.
- Repository, if not implied by the current working directory.
- Any architecture docs, product context, or category definitions the user wants used as the standard for judging comments.

If the user asks for end-to-end handling, fixes, or posting reviewer responses, still complete only the triage/checklist phase under this skill and then stop. Follow-on implementation or response application should be a separate user-confirmed task.

## Step 1: Collect PR Feedback

Use GitHub tooling to collect all available feedback:

- Review comments.
- Issue-level PR comments.
- Review summaries.
- Review-thread comments and unresolved thread state when available.
- Bot comments only for tracking, not for response drafting unless requested.

Preserve enough metadata to act on each item:

- Author.
- File and line or PR-level location.
- Comment ID/thread ID when available.
- Original comment URL when available.
- Short paraphrase.
- Whether the author is a bot or a human.
- Whether the thread already appears resolved or answered.

Useful GitHub CLI patterns:

```bash
gh pr view <PR> --json number,title,state,isDraft,mergeable,mergeStateStatus,reviewDecision,comments,reviews,files
gh api repos/<OWNER>/<REPO>/pulls/<PR>/comments --paginate
gh api repos/<OWNER>/<REPO>/issues/<PR>/comments --paginate
gh api graphql -f owner=<OWNER> -f name=<REPO> -F number=<PR> -f query='<reviewThreads query>'
```

## Step 2: Categorize Comments

Categorize each comment using these defaults unless the user provides a different taxonomy:

- Deal breaker / fundamental architectural design flaw or incompatibility.
- Potentially missing non-functional requirement.
- Minor bug / refactor / acceptable reduction in complexity.
- Stylistic / readability concern.
- Clarification needed.
- Out of scope / future work.
- Duplicate / already addressed.
- Incorrect / likely misunderstanding.
- Informational / no action.

For each comment, assign:

- Severity: `blocking`, `important`, `minor`, `style`, or `unclear`.
- Recommended action.
- Whether code changes are likely needed.
- Initial reviewer response draft, or `No response required`.

Judge comments against the repo's stated contracts and docs. When a comment conflicts with docs or code, classify it as `Incorrect / likely misunderstanding` only with concrete evidence.

## Step 3: Create The Checklist

Create a Markdown checklist in `/tmp` or `/private/tmp` with a descriptive name, for example:

```text
/private/tmp/<repo>-pr<PR>-review-comment-checklist.md
```

Use this table shape:

```markdown
| Status | Author | Location | Comment / concern | Severity | Recommended action | Code changes likely? | Reviewer response |
| --- | --- | --- | --- | --- | --- | --- | --- |
| [ ] | reviewer | `path/file.py:123` | Short paraphrase. | important | Concrete next action. | Yes | Draft response or No response required. |
```

Status meanings:

- `[ ]` Open.
- `[~]` In progress.
- `[x]` Addressed.
- `[d]` Deferred / future work.
- `[n]` No code change / response only.

Include an executive tracking section with counts by category and whether any blocking/deal-breaker items exist.

After creating the initial checklist:

- Stop.
- Present the summary and checklist path.
- Do not implement fixes or post responses.

## Checklist Completion Criteria

This skill is complete when:

- All available PR feedback has been inventoried.
- Every comment has a checklist row or is explicitly grouped as a duplicate.
- Every row has a category, severity, recommended action, code-change likelihood, and reviewer-response field.
- The executive summary includes total comments reviewed, counts by category, and whether any blocking/deal-breaker items exist.
- The final response gives the checklist path and calls out the most important open decisions or blockers.

Do not continue into remediation. The initial checklist is the deliverable.

## Reference: Later Checklist Work

Use this guidance only in a later follow-on task after the user explicitly asks to work items from the checklist.

Recommended processing order:

1. Blocking/deal-breaker items.
2. Missing non-functional requirements.
3. Minor bugs/refactors.
4. Style/readability items.
5. Clarifications, duplicates, out-of-scope, and informational rows.

When working items later:

- Mark the row `[~]` before editing.
- Patch the smallest relevant surface.
- Add or update focused tests when behavior changes.
- Run focused verification for the touched area.
- Update the checklist row with the actual result, not the original plan.
- Mark the row `[x]`, `[d]`, or `[n]` only after the action is complete.

## Reference: Later Reviewer Responses

Use this guidance only in a later follow-on task after the checklist items have been worked and the user explicitly asks to apply responses.

Before applying reviewer responses later:

- Confirm the checklist has no `[ ]` or `[~]` rows.
- Confirm all bot rows have blank response cells unless the user requested bot replies.
- Confirm all `No response required` rows will be skipped.
- Run the relevant lint, type, test, docs, or CI-equivalent checks.
- Check the worktree and avoid committing unrelated changes.

When applying responses later:

- Reply to human review threads/comments only.
- Use the checklist's reviewer-response text as the source of truth.
- Keep replies concise and tied to actual changes.
- Include issue/backlog links for deferred work.
- Skip bots, informational rows, positive notes, duplicate no-response rows, and comments already answered.
- Prefer replying in-thread over posting a new PR-level omnibus comment.

For many thread replies, batch GraphQL mutations conservatively to avoid GitHub resource limits. Verify after posting:

- Count replies authored by the current GitHub user.
- Compare intended reply targets with actual `in_reply_to_id` values or thread replies.
- Delete accidental duplicate replies if they occur.

## Handoff

Final response should include:

- Checklist path.
- Total comments reviewed.
- Counts by category.
- Whether any blocking/deal-breaker items exist.
- The highest-priority items to decide or work next.
- Any notable future-work, duplicate, or likely-misunderstanding clusters.

Keep the handoff short. The checklist is the detailed audit trail.
