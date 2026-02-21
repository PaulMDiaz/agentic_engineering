---
summary: "Review code for security issues before shipping"
read_when: "Before merging anything touching auth, secrets, inputs, or external data"
---

# /security-check

Review for security issues. Flag; don't silently fix.

## Check For
- Secrets/keys hardcoded or logged
- Unsanitized user input (XSS, injection)
- Insecure dependencies (`npm audit` / `pip-audit` / `cargo audit`)
- Overly broad permissions
- Exposed internal endpoints
- Sensitive data in logs or error messages
- Missing auth/authz checks
- Unsafe deserialization

## Process
1. `git diff main` — review all changes
2. Run dep audit for stack
3. Flag each issue with severity: CRITICAL / HIGH / MEDIUM / LOW
4. Report to Paul before fixing
5. Paul decides remediation priority

## Never
- Log secrets, tokens, or PII
- Commit `.env` or credential files
- Expand permissions without Paul's consent
