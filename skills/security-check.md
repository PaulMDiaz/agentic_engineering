---
name: security-check
description: Security review checklist — what to look for, how to report. Use before shipping changes or when asked to review for security issues.
---

# Security Check Skill

Review for security issues. Flag; don't silently fix.

## What to Check For

### Secrets & Credentials
- Secrets/keys hardcoded or logged
- `.env` or credential files committed
- Tokens in URLs or query params

### Input Handling
- Unsanitized user input (XSS, injection)
- Unsafe deserialization
- Path traversal vulnerabilities

### Dependencies
- Insecure dependencies (`npm audit` / `pip-audit` / `cargo audit`)
- Outdated packages with known CVEs

### Access Control
- Overly broad permissions
- Missing auth/authz checks
- Exposed internal endpoints
- Sensitive data in logs or error messages

## Process

1. `git diff main` — review all changes
2. Run dep audit for stack
3. Flag each issue with severity:
   - **CRITICAL** — immediate exploit risk
   - **HIGH** — serious vulnerability
   - **MEDIUM** — should fix before shipping
   - **LOW** — minor issue, fix when convenient
4. Report findings to user before fixing
5. User decides remediation priority

## Hard Rules

- Never log secrets, tokens, or PII
- Never commit `.env` or credential files
- Never expand permissions without explicit consent
- Never silently fix security issues — always report first
