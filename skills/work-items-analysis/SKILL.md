---
name: work-items-analysis
description: "Investigate work items for a person over a date range by combining Jira/Atlassian MCP data, GitHub CLI PR/issue data, and local git activity. Use when asked for work-item analysis, monthly summaries, executive summaries, Jira/GitHub activity reports, or itemized breakdowns of assigned/worked-on items."
argument-hint: "[since date or date range, optional person/account]"
---

# work-items-analysis

Produce an evidence-backed Markdown report of work items assigned to, reported by, or worked on by a user over a date range. Combine Jira data from the Atlassian MCP with GitHub CLI data and local git history.

## Inputs

Parse the user request for:

- **Date range**: Accept a previous date (`since 2026-05-09`), natural language (`past month`), or an explicit range. Resolve the request to an inclusive `START_DATE` and `END_DATE`. If only a previous date is supplied, use that date through today. If no range is specified, ask a focused question before searching; do not assume a default. For a 1:1 request, ask for the date of the last meeting or the intended lookback period.
- **Person**: If no person is supplied, resolve and use the signed-in Atlassian account for Jira and the signed-in GitHub account for GitHub independently. If the user names a person, resolve that person's Jira and GitHub accounts separately with the available account lookup tools; never assume that the two systems use the same account or login.
- **Output target**: Default to a Markdown report and companion Word executive summary in `~/Documents/work-item-analyses/`. Use concise filenames such as `work-items-analysis-YYYY-MM-DD-to-YYYY-MM-DD.md` and `work-items-executive-summary-YYYY-MM-DD-to-YYYY-MM-DD.docx`.

Always use exact calendar dates in the report header. Use the user's timezone when supplied; otherwise choose the workspace or account timezone and state one `REPORT_TIMEZONE` in the Search Basis. Derive a start-inclusive `START_INSTANT` and end-exclusive `END_EXCLUSIVE_INSTANT` in that timezone. For date-only discovery filters, translate those instants to the source timezone and round outward to enclosing whole-day bounds, named `SOURCE_START_DATE` and `SOURCE_END_EXCLUSIVE_DATE` in the examples. Do not substitute unchanged report-calendar dates when source timezones differ. Filter the resulting events against the exact report instants. Preserve the source's date or timestamp precision and do not silently assign separate report windows per system.

## Process

### Step 1: Establish The Date Range

Run `date` if the current date is needed. Do not guess relative dates.

If the request has no date range, ask the user to choose a range. Offer sensible options based on the current date, but let the user provide the date of their last 1:1 or another custom range.

Examples:

- `past month` on 2026-07-01 means `2026-06-01` through `2026-07-01` unless the user gave a different previous date.
- `since 2026-05-09` means `2026-05-09` through the current date.

### Step 2: Validate Atlassian MCP Access

Use Atlassian MCP tools, not browser scraping, when available.

1. Call `getAccessibleAtlassianResources`.
2. Select a resource that includes Jira scopes such as `read:jira-work`.
3. Store both the resource `id` and `url`. Use the `id` as `cloudId` for Jira tool calls and the `url` as the Jira base URL for report links.
4. If more than one Jira-capable resource is available and the correct site is ambiguous, ask the user which site to use.
5. Call `atlassianUserInfo` to identify the current Jira account. Use it as the Jira target only when the user did not name another person; otherwise resolve the named Jira account separately and record the mapping or the fact that it could not be resolved.

If MCP access fails:

- Record the exact error.
- Continue with GitHub/local git evidence if useful.
- Add a clear caveat that Jira coverage is blocked.
- Do not change MCP configuration, install a connector, restart Codex, or complete an OAuth flow as part of this reporting task unless that work is explicitly authorized in the current task or session. When authorized, keep troubleshooting or configuration work clearly scoped and report it separately from data coverage.

### Step 3: Query Jira

Use multiple JQL queries because "worked on" is broader than assignment. The examples use the resolved Jira account for the requested person. When no person was supplied, substitute the signed-in Jira account returned by `atlassianUserInfo`.

The `updated` field is the issue's last-update timestamp, so these queries are candidate discovery only. Do not use a current `updated` value as proof that work happened during the report window. Filter worklog, changelog, comment, and other event timestamps separately to the inclusive `START_INSTANT` through exclusive `END_EXCLUSIVE_INSTANT` window. If a later issue update would otherwise hide an in-window event, keep the candidate and use the event history to decide whether it belongs in the report.

Required queries:

```jql
assignee = "<JIRA_ACCOUNT>" AND updated >= "<SOURCE_START_DATE>" ORDER BY updated DESC
```

```jql
reporter = "<JIRA_ACCOUNT>" AND updated >= "<SOURCE_START_DATE>" ORDER BY updated DESC
```

```jql
worklogAuthor = "<JIRA_ACCOUNT>" AND worklogDate >= "<SOURCE_START_DATE>" AND worklogDate < "<SOURCE_END_EXCLUSIVE_DATE>" ORDER BY updated DESC
```

```jql
text ~ "<JIRA_DISPLAY_NAME>" AND updated >= "<SOURCE_START_DATE>" ORDER BY updated DESC
```

For each query, request fields:

```text
summary,status,assignee,reporter,created,updated,description,issuetype,priority,labels,resolution,parent
```

If a JQL query fails, report the failure and continue. Some Jira instances reject `updatedBy()` syntax; do not depend on it.

### Step 4: Query GitHub

Use the GitHub CLI for PRs and issues.

Get the current GitHub identity:

```bash
gh api user
```

If no person was supplied, use the returned login for GitHub queries. If the user named a person, resolve that person's GitHub login separately and do not infer it from the Jira account or display name.

Search authored and involved PRs:

```bash
gh search prs --author <LOGIN> --updated ">=<SOURCE_START_DATE>" --json title,url,repository,number,state,createdAt,updatedAt,closedAt,author,labels --limit 100
```

```bash
gh search prs --involves <LOGIN> --updated ">=<SOURCE_START_DATE>" --json title,url,repository,number,state,createdAt,updatedAt,closedAt,author,labels --limit 100
```

Search authored and involved issues:

```bash
gh search issues --author <LOGIN> --updated ">=<SOURCE_START_DATE>" --json title,url,repository,number,state,createdAt,updatedAt,closedAt,author,labels --limit 100
```

```bash
gh search issues --involves <LOGIN> --updated ">=<SOURCE_START_DATE>" --json title,url,repository,number,state,createdAt,updatedAt,closedAt,author,labels --limit 100
```

These GitHub searches are also candidate discovery. Filter commits, reviews, comments, and other event timestamps from PR or issue details to the same `START_INSTANT` inclusive and `END_EXCLUSIVE_INSTANT` exclusive window. A later `updatedAt` value is current-state metadata, not historical proof, and later activity must not appear in the bounded report.

For important PRs, fetch detail:

```bash
gh pr view <NUMBER> --repo <OWNER/REPO> --json title,url,state,author,createdAt,updatedAt,closedAt,mergedAt,body,commits,files,reviews,comments
```

Review/comment coverage:

1. Use the `--involves` PR results to identify candidate collaboration work, especially PRs authored by someone else.
2. Fetch PR detail for material candidates and verify that the user authored a review or comment. Do not treat an `--involves` result alone as review evidence.
3. Record the review outcome: approval, changes requested, or substantive comment; include the PR's current state.
4. Include a dedicated review/collaboration section in the report. In the executive summary, separate individual delivery from review/collaboration support and append the full verified `Review And Collaboration Evidence` list. Promote material cross-team support—for example, an IRK, finite-burn, or other dependency-track review—there when it helps the stakeholder understand the user's impact.

Extract Jira keys from PR titles, bodies, branches, commit messages, and comments. For each Jira key found in GitHub evidence that was not returned by broad Jira queries, call `getJiraIssue` directly.

### Step 5: Query Local Git Repositories

Search local repositories under the workspace root to catch work that may not be surfaced by GitHub search.

Find repos:

```bash
find <WORKSPACE_ROOT> -maxdepth 2 -name .git -type d
```

For each repo, inspect commits authored by the requested person with a verified local author pattern from `START_INSTANT` through `END_EXCLUSIVE_INSTANT`. This local corroboration remains in scope if GitHub account resolution fails; do not substitute an unverified GitHub login for the local author pattern.

```bash
git -C <REPO> log --all --since="<START_INSTANT>" --until="<END_EXCLUSIVE_INSTANT>" --author="<AUTHOR_PATTERN>" --date=iso-strict --pretty=format:"%cI%x09%aI%x09%h%x09%an%x09%s%x09%d"
```

To enforce the exclusive end boundary regardless of how the Git date filter handles an exact endpoint, use the committer timestamp (`%cI`) as the chosen local-window membership field and postfilter the full timestamp output to `START_INSTANT <= %cI < END_EXCLUSIVE_INSTANT`. Keep the author timestamp (`%aI`) as corroborating context. The verified author pattern establishes the target person's role independently of the GitHub account.

Use local git as corroborating evidence, not as the only source when Jira/GitHub API data is available.

### Step 6: Normalize And Deduplicate

Build a single item list keyed by Jira key when present; otherwise by GitHub URL.

Before including a contribution, verify the target person's role and an event timestamp inside the report window. Candidate issue or PR membership alone does not establish either.

For each item capture:

- Key or URL
- Title/summary
- Source systems: Jira, GitHub, local git
- Status
- Assignee/reporter when available
- Updated date
- Parent/epic when available
- Role evidence: assigned, reporter, partner/contributor/reviewer mention, authored PR, verified review/comment, involved PR, local commits
- In-window event dates and source precision; treat current `updated` or `updatedAt` only as discovery metadata
- Short outcome or current state
- Relevant links

Group related items by theme:

- TALOS Unified Architecture
- TVSIM bus/payload planning
- CoA / planner graph compatibility
- Data/Knowledge and mission-state contracts
- Engineering enablement
- Other project-specific themes that emerge from the data

### Step 7: Write The Report

Create a Markdown file in `~/Documents/work-item-analyses/` unless the user asks for a different location or only asks for chat output.

Use this structure:

```markdown
# Work Items Analysis: <START_DATE> to <END_DATE>

## Executive Summary

### Individual Development Contributions

<3-6 plain paragraphs on the user's authored delivery, active/blocked work, and strongest evidence.>

### Review And Collaboration Evidence

<One plain paragraph per verified review/comment contribution, its PR state, and the support it provided.>

## Search Basis

- Jira account:
- GitHub account:
- Report timezone:
- Jira queries:
- GitHub queries:
- Local git scope:
- Caveats:

## Primary Work Items

### <KEY>: <Summary>

- Jira:
- GitHub:
- Status:
- Assignee:
- Parent:
- Updated:
- Role evidence:

Summary:

Outcome / Current state:

## GitHub Corroboration

### <repo>

- <PR/issue links and what they prove>

## Review And Collaboration Evidence

- <PR link>: <review/comment outcome>, <PR state>, and the contribution it demonstrates.

## Roll-Up By Theme

### <Theme>

Completed:

- ...

In progress / blocked:

- ...

## Notes And Caveats

- ...
```

### Step 8: Create The Word Executive Summary

Unless the user asks for chat-only output, create a companion `.docx` in the same directory. It must contain the complete executive summary, including the full verified `Review And Collaboration Evidence` list.

- Build a temporary Markdown source containing only the report title and executive-summary sections; do not convert the full work-items report. Rewrite each summary item as a plain paragraph separated by blank lines; do not copy Markdown list markers into the temporary source.
- Use Pandoc to generate the `.docx` from Markdown so links become real Word hyperlinks. Do not provide raw RTF source or use an RTF conversion as a substitute.
- Use headings plus plain paragraph line breaks, not Word list formatting or indented bullets, so the user can paste the content into meeting notes without manual cleanup.
- Keep the same headings and linked evidence as the Markdown executive summary.
- Verify the output is a Word document and contains external hyperlink relationships:

```bash
set -euo pipefail
pandoc --from markdown --to docx --output <SUMMARY.docx> <SUMMARY.md>
file <SUMMARY.docx>
relationship_xml="$(unzip -p <SUMMARY.docx> "word/_rels/document.xml.rels")"
if rg -q '\]\(https?://' <SUMMARY.md> && ! rg -q 'TargetMode="External"' <<< "$relationship_xml"; then
  printf '%s\n' "Expected external hyperlinks in <SUMMARY.docx>, but none were generated." >&2
  exit 1
fi
```

- If Pandoc is unavailable, report that the Word companion could not be generated; do not install a dependency without user approval.

## Quality Bar

- Do not claim Jira state from GitHub alone when the Jira issue was not fetched.
- Do not infer completion from a merged PR if Jira says the item is still open or blocked; state both facts.
- Do not label a PR as reviewed or commented on solely because it appeared in `gh search prs --involves`; verify the user's authorship in the PR's reviews or comments first.
- Do not treat a current Jira `updated` or GitHub `updatedAt` value as proof of an in-window contribution. Use independently dated events and keep them within the inclusive `START_INSTANT` to exclusive `END_EXCLUSIVE_INSTANT` window.
- Keep Jira and GitHub account mappings separate and state when either target account could not be resolved.
- Prefer concise executive language but keep item-level evidence concrete.
- Append the full verified `Review And Collaboration Evidence` list to a distinct executive-summary subsection so individual delivery and support for others are clearly separated.
- Produce the companion Word executive summary with plain line breaks and real hyperlinks, and verify its hyperlink relationships before handoff.
- Include direct links for every Jira issue and GitHub PR/issue used in the final report. Build Jira links from the selected MCP resource URL, for example `<JIRA_BASE_URL>/browse/<KEY>`, unless the Jira tool returns a more specific URL.
- Mask secrets and do not read `.env` files.
- If network or auth blocks part of the analysis, explain exactly what failed and what evidence was still used.
