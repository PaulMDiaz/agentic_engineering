---
name: pr-review-triage
description: "Triage GitHub PR comments into a Markdown working checklist before any authorized follow-up. Use when asked to inspect, categorize, or prepare a tracker for PR review feedback."
argument-hint: "[PR number or URL, optional checklist directory, optional docs/category standard]"
---

# pr-review-triage

Use this skill to turn PR review feedback into a tracked checklist.

This skill owns the triage phase. Create the initial checklist and deliver its summary before
any follow-up implementation or replies. A triage-only request ends here. For a broader request,
return control to the orchestrator to continue the already-authorized work through the
appropriate workflow, such as `implement`; completing triage does not require another approval.

## Core Rules

- Create or update a Markdown checklist in the user-specified directory, defaulting to `tmp/`
  under the reviewed repository root. Carry forward a directory already specified for this checklist.
- Do not make code changes while using this skill.
- Do not mark rows addressed unless the current branch already addresses them before triage begins.
- Keep reviewer-response drafts in the checklist, but do not post them.
- Do not draft responses for bots unless the user explicitly asks.
- Mark informational or no-action rows as `No response required`.
- For deferred future work, recommend tracking in a GitHub issue, `DEFERRED.md`, or documented rationale as appropriate, but do not create that tracking during this skill.
- Recommend a GitHub issue only when the work is specific and actionable, intentionally outside the current pull request or feature branch, materially impactful, and needs team visibility beyond agent context.
- Before recommending an issue, inspect issue links already present in the pull request or branch context and run one focused repository issue search. Do not assume no issue exists or perform an exhaustive search.

## Inputs

Parse the user request for:

- PR number or URL.
- Repository, if not implied by the current working directory.
- Checklist directory, if specified. Resolve relative directories from the reviewed repository root.
- Any architecture docs, product context, or category definitions the user wants used as the standard for judging comments.

Carry forward authorization for follow-up work from the current request or earlier session
instructions. Ask only about unresolved decisions or actions that still require permission.
A request to fix comments does not by itself authorize posting replies; posting requires
explicit authorization, which need not be repeated if already given.

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

Create the chosen directory if needed and use a stable, descriptive checklist name, for example:

```text
<repository-root>/tmp/<repo>-pr<PR>-review-comment-checklist.md
```

Reuse an existing checklist for the same repository and PR, preserving recorded progress while
reconciling new feedback. Leave existing response drafts unchanged unless new feedback, verified
code changes, or an explicit user request requires a correction. Do not rewrite them just to
improve phrasing. Leave the checklist in place after triage and follow-up work so it can be
revisited across sessions. Keep the checklist uncommitted; do not change tracked
ignore rules just to store it. Report its resolved path in the handoff.

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

- Present the summary and checklist path.
- End the triage phase. Continue through the appropriate workflow only for already-authorized
  follow-up work; otherwise the checklist is the final deliverable.

## Checklist Completion Criteria

This skill is complete when:

- All available PR feedback has been inventoried.
- Every comment has a checklist row or is explicitly grouped as a duplicate.
- Every row has a category, severity, recommended action, code-change likelihood, and reviewer-response field.
- The executive summary includes total comments reviewed, counts by category, and whether any blocking/deal-breaker items exist.
- The final response gives the checklist path and calls out the most important open decisions or blockers.

The initial checklist completes this skill. It does not complete a broader request that also
authorizes remediation or replies.

## Reference: Later Checklist Work

Use this guidance during follow-up implementation when working the checklist is authorized
in the current request or a later one.

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

Use this guidance after the checklist items have been worked and posting responses has been
explicitly authorized in the current request or a later one.

Before applying reviewer responses later:

- Confirm the checklist has no `[ ]` or `[~]` rows.
- Confirm all bot rows have blank response cells unless the user requested bot replies.
- Confirm all `No response required` rows will be skipped.
- Confirm relevant validation is current, following the verification reuse rule in
  `CODING_STANDARDS.md`; rerun checks only when justified or explicitly required.
- Check the worktree and avoid committing unrelated changes.

When applying responses later:

- Reply to human review threads/comments only.
- Use the checklist's reviewer-response text as the source of truth.
- Keep replies concise and tied to actual changes.
- Include the GitHub issue link for issue-worthy deferred work. If the repository uses
  `DEFERRED.md`, keep the entry in its established format and reference the same issue there.
- Use the PR description's **Tracked follow-ups** section for relevant issue links.
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
