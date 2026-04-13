# Security Checklist

Shared reference for `code-review-and-quality`, `shipping-and-launch`, and `security-auditor` agent.

## Pre-Merge Security Check

Run this for every PR touching input handling, authentication, authorization, or external data.

### Input Validation

- [ ] All user-supplied inputs validated before use (not just "sanitized at the frontend")
- [ ] String inputs: max length enforced, encoding checked
- [ ] Numeric inputs: bounds checked, integer overflow considered
- [ ] File uploads: MIME type verified, size limited, stored outside web root
- [ ] No user input concatenated into SQL, shell commands, HTML, or URLs without encoding

### Authentication

- [ ] Session tokens are random (≥32 bytes entropy), not predictable
- [ ] Tokens have expiry and are revoked on logout
- [ ] Password storage uses bcrypt/argon2/scrypt — never MD5/SHA1/plaintext
- [ ] Login endpoints are rate-limited
- [ ] Authentication checked before anything else in request handlers

### Authorization

- [ ] Every resource access checks that the requesting user has permission
- [ ] IDOR prevented: ownership checked, not just authentication
- [ ] Admin/elevated actions require explicit role, not just "logged in"
- [ ] Authorization checked AFTER authentication — never in reverse

### Data Exposure

- [ ] No PII in URLs (query params, path segments)
- [ ] No secrets in logs (tokens, passwords, API keys)
- [ ] Error messages don't reveal stack traces, DB names, or user existence
- [ ] API responses don't include fields the caller doesn't need

### Security Headers (web apps)

- [ ] `Content-Security-Policy` configured
- [ ] `X-Frame-Options: DENY` or CSP `frame-ancestors`
- [ ] `X-Content-Type-Options: nosniff`
- [ ] `Strict-Transport-Security` (HTTPS only)
- [ ] CORS configured to allowlist, not wildcard (unless public API)

### Dependencies

- [ ] `npm audit` / `pip audit` / equivalent run and clean
- [ ] No direct dependencies with known Critical CVEs
- [ ] Lockfile committed (no floating versions)

## OWASP Top 10 Quick Reference

| Risk | How to check |
|------|-------------|
| Injection (SQL, XSS, command) | Trace every input to every output or interpreter |
| Broken authentication | Check token entropy, expiry, revocation, rate limiting |
| Sensitive data exposure | Check logs, error messages, API responses, URLs |
| Broken access control | Every resource: ownership check + role check |
| Security misconfiguration | Check CORS, headers, error verbosity, defaults |
| Vulnerable components | Run dependency audit |
| Identification failures | Check session management, logout invalidation |
| Software integrity failures | Check supply chain, verify package integrity |
| Logging failures | Check that security events are logged (not secrets) |
| SSRF | Validate URLs before fetching, allowlist internal hosts |

## Severity Levels

| Level | Definition | Action |
|-------|-----------|--------|
| Critical | Exploitable with high impact (data breach, takeover) | Block merge — fix immediately |
| High | Exploitable with significant impact | Fix before ship |
| Medium | Exploitable with limited impact or requires conditions | Fix in current sprint |
| Low | Defense in depth improvement | Fix in next sprint |
| Info | Best practice not followed | Document and track |
