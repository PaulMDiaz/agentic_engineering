---
name: security-check
description: Evidence-based security review for a diff or repository. Use before shipping changes or when asked to review for security issues.
---

# Security Check Skill

Review for security issues. Flag findings clearly, separate confirmed issues from uncertain concerns, and do not silently fix security problems unless the user asks.

## When to Use

Use this skill when the user asks for:
- a security review of a branch, PR, or diff
- a pre-merge or pre-ship security check
- a broader repository security posture review

## Scope Modes

### Diff-focused security review (default)
Use this when the request is tied to a branch, PR, or set of changes.

### Repo posture review
Use this when the user explicitly asks for a broader audit of the repository’s security posture.

## Process

### 1. Determine scope
Interpret the request first:
- “review this PR for security” → diff-focused review
- “audit this repo for security” → repo posture review

Be explicit in the final report about which scope you used.

### 2. Gather evidence in order
Use repo evidence before generic assumptions. Prefer sources in this order:

1. diff / changed files
2. auth, config, and environment-handling files
3. dependency manifests and lockfiles
4. CI, deployment, or workflow configuration
5. docs only when needed for context or to confirm expected behavior

### 3. Review by category
Check the relevant scope for:

#### Secrets & Credentials
- secrets, tokens, or credentials hardcoded or logged
- `.env` or credential files committed
- tokens or secrets exposed in URLs, query params, output, or examples

#### Input Handling & Injection
- unsanitized user input flowing into shell, SQL, templates, eval, or file paths
- unsafe deserialization
- path traversal or arbitrary file access risks
- prompt injection exposure where model inputs are not delimited or validated

#### Auth, Authz & Permissions
- missing auth/authz checks
- overly broad permissions
- exposed internal/admin functionality
- dangerous defaults that grant more access than intended

#### Dependencies & Supply Chain
- insecure or obviously outdated dependencies
- risky new packages added without scrutiny
- lockfile / manifest inconsistencies

If an audit tool is available and appropriate for the stack, run it. If no suitable audit tool is configured or runnable, say so explicitly — do not imply that dependency review passed automatically.

#### Logging, Errors & Data Exposure
- secrets, tokens, or PII in logs
- overly detailed error output that leaks internal state
- sensitive data exposed in traces, debug output, fixtures, or sample commands

### 4. Be explicit about certainty
Separate your conclusions into:
- confirmed issues
- suspicious patterns / needs verification
- no findings

Do not overstate uncertain risks as confirmed vulnerabilities.

### 5. Report in a structured format
Use this structure:

## Security Review

**Scope:** `diff review` or `repo posture review`
**Status:** one of:
- `✅ No issues found`
- `❌ Issues found`
- `⚠️ Partial / uncertain review`

### Evidence Used
List the files and sources inspected.

### Findings
Use this section only if you found confirmed issues.

For each finding:

#### 1. [SEVERITY] Short title
**What:** clear description of the issue  
**Why:** why it matters  
**Fix:** most direct remediation  
**File(s):** `path/to/file:L<start>-L<end>`

Severity guide:
- `[CRITICAL]` — immediate exploit risk or major secret exposure
- `[HIGH]` — serious vulnerability or dangerous privilege/exposure issue
- `[MEDIUM]` — meaningful weakness that should be fixed before shipping
- `[LOW]` — minor weakness, cleanup, or defense-in-depth improvement

### Suspicious / Needs Verification
Use this section for concerns that are plausible but not confirmed from available evidence.

### Summary
End with a concise bottom line about whether the reviewed scope appears safe to merge/ship and what, if anything, remains uncertain.

## Hard Rules

- Never log secrets, tokens, or PII
- Never commit `.env` or credential files
- Never expand permissions without explicit consent
- Never silently fix security issues before reporting them unless the user explicitly asks for remediation
