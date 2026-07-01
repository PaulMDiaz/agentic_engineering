---
name: work-items-analysis
description: "Investigate work items for a person over a date range by combining Jira/Atlassian MCP data, GitHub CLI PR/issue data, and local git activity. Use when asked for work-item analysis, monthly summaries, executive summaries, Jira/GitHub activity reports, or itemized breakdowns of assigned/worked-on items."
argument-hint: "[since date or date range, optional person/account]"
---

# work-items-analysis

Produce an evidence-backed Markdown report of work items assigned to, reported by, or worked on by a user over a date range. Combine Jira data from the Atlassian MCP with GitHub CLI data and local git history.

## Inputs

Parse the user request for:

- **Date range**: Accept a previous date (`since 2026-05-09`), natural language (`past month`), or an explicit range. If only a previous date is supplied, use that date through today.
- **Person**: Default to the current Atlassian user and GitHub user. If the user names a person, use that person where Jira/GitHub queries support it.
- **Output target**: Default to a Markdown report in `/Users/pauldiaz/Documents/work-item-analyses/`. Use a concise filename such as `work-items-analysis-YYYY-MM-DD-to-YYYY-MM-DD.md`.

Always use exact calendar dates in the report header.

## Process

### Step 1: Establish The Date Range

Run `date` if the current date is needed. Do not guess relative dates.

Examples:

- `past month` on 2026-07-01 means `2026-06-01` through `2026-07-01` unless the user gave a different previous date.
- `since 2026-05-09` means `2026-05-09` through the current date.

### Step 2: Validate Atlassian MCP Access

Use Atlassian MCP tools, not browser scraping, when available.

1. Call `getAccessibleAtlassianResources`.
2. Select the resource whose URL matches the expected Atlassian site, usually `https://slingshotaero.atlassian.net`.
3. Confirm the resource includes Jira scopes such as `read:jira-work`.
4. Call `atlassianUserInfo` to identify the current Jira account.

If MCP access fails:

- Record the exact error.
- Continue with GitHub/local git evidence if useful.
- Add a clear caveat that Jira coverage is blocked.

Known fix for `Unauthorized` with Atlassian remote MCP:

```toml
[mcp_servers.atlassian_mcp]
enabled = true
command = "/opt/homebrew/bin/node"
args = ["/opt/homebrew/lib/node_modules/npm/bin/npx-cli.js", "-y", "mcp-remote@latest", "https://mcp.atlassian.com/v1/mcp/authv2"]
startup_timeout_sec = 120
```

After config changes, Codex must be restarted and the OAuth flow completed.

### Step 3: Query Jira

Use multiple JQL queries because "worked on" is broader than assignment.

Required queries:

```jql
assignee = currentUser() AND updated >= "<START_DATE>" ORDER BY updated DESC
```

```jql
reporter = currentUser() AND updated >= "<START_DATE>" ORDER BY updated DESC
```

```jql
worklogAuthor = currentUser() AND worklogDate >= "<START_DATE>" ORDER BY updated DESC
```

```jql
text ~ "<DISPLAY_NAME>" AND updated >= "<START_DATE>" ORDER BY updated DESC
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

Search authored and involved PRs:

```bash
gh search prs --author <LOGIN> --updated ">=<START_DATE>" --json title,url,repository,number,state,createdAt,updatedAt,closedAt,author,labels --limit 100
```

```bash
gh search prs --involves <LOGIN> --updated ">=<START_DATE>" --json title,url,repository,number,state,createdAt,updatedAt,closedAt,author,labels --limit 100
```

Search authored and involved issues:

```bash
gh search issues --author <LOGIN> --updated ">=<START_DATE>" --json title,url,repository,number,state,createdAt,updatedAt,closedAt,author,labels --limit 100
```

```bash
gh search issues --involves <LOGIN> --updated ">=<START_DATE>" --json title,url,repository,number,state,createdAt,updatedAt,closedAt,author,labels --limit 100
```

For important PRs, fetch detail:

```bash
gh pr view <NUMBER> --repo <OWNER/REPO> --json title,url,state,author,createdAt,updatedAt,closedAt,mergedAt,body,commits,files,reviews,comments
```

Extract Jira keys from PR titles, bodies, branches, commit messages, and comments. For each Jira key found in GitHub evidence that was not returned by broad Jira queries, call `getJiraIssue` directly.

### Step 5: Query Local Git Repositories

Search local repositories under the workspace root to catch work that may not be surfaced by GitHub search.

Find repos:

```bash
find <WORKSPACE_ROOT> -maxdepth 2 -name .git -type d
```

For each repo, inspect commits authored by the user since the start date:

```bash
git -C <REPO> log --all --since=<START_DATE> --author="<AUTHOR_PATTERN>" --date=short --pretty=format:"%ad%x09%h%x09%an%x09%s%x09%d"
```

Use local git as corroborating evidence, not as the only source when Jira/GitHub API data is available.

### Step 6: Normalize And Deduplicate

Build a single item list keyed by Jira key when present; otherwise by GitHub URL.

For each item capture:

- Key or URL
- Title/summary
- Source systems: Jira, GitHub, local git
- Status
- Assignee/reporter when available
- Updated date
- Parent/epic when available
- Role evidence: assigned, reporter, partner/contributor/reviewer mention, authored PR, involved PR, local commits
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

Create a Markdown file in `/Users/pauldiaz/Documents/work-item-analyses/` unless the user asks for a different location or only asks for chat output.

Use this structure:

```markdown
# Work Items Analysis: <START_DATE> to <END_DATE>

## Executive Summary

<3-6 bullets on major themes, completed work, active/blocked work, and strongest evidence.>

## Search Basis

- Jira account:
- GitHub account:
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

## Roll-Up By Theme

### <Theme>

Completed:

- ...

In progress / blocked:

- ...

## Notes And Caveats

- ...
```

## Quality Bar

- Do not claim Jira state from GitHub alone when the Jira issue was not fetched.
- Do not infer completion from a merged PR if Jira says the item is still open or blocked; state both facts.
- Prefer concise executive language but keep item-level evidence concrete.
- Include direct links for every Jira issue and GitHub PR/issue used in the final report.
- Mask secrets and do not read `.env` files.
- If network or auth blocks part of the analysis, explain exactly what failed and what evidence was still used.
