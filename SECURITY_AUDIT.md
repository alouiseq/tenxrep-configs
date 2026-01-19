# Security Audit Guide for TenXRep

Use this guide to audit the codebase for security vulnerabilities. Run this audit before major releases or when adding sensitive features.

## How to Run a Security Audit

Ask Claude: **"Run a security audit on [tenxrep-api/tenxrep-web]"**

Claude will use the checklist below to systematically review the code.

---

## Security Audit Checklist

### 1. Authentication & Authorization

**Check for:**
- [ ] JWT tokens properly validated (signature, expiration, issuer)
- [ ] Passwords hashed with strong algorithm (bcrypt, argon2)
- [ ] No plaintext passwords in logs or error messages
- [ ] Protected routes require authentication
- [ ] Admin routes check for admin role
- [ ] Session/token expiration is reasonable
- [ ] No hardcoded credentials or API keys

**Files to review:**
- `tenxrep-api/app/core/auth.py`
- `tenxrep-api/app/api/v1/endpoints/auth.py`
- `tenxrep-web/src/services/api.ts`

### 2. Input Validation & Injection

**Check for:**
- [ ] SQL injection: Using parameterized queries (SQLAlchemy ORM)
- [ ] XSS: User input sanitized before rendering
- [ ] Command injection: No shell commands with user input
- [ ] Path traversal: File paths validated
- [ ] Pydantic schemas validate all input
- [ ] Request body size limits

**Files to review:**
- `tenxrep-api/app/schemas/*.py`
- `tenxrep-api/app/api/v1/endpoints/*.py`
- `tenxrep-web/src/components/*Form*.tsx`

### 3. Data Protection

**Check for:**
- [ ] Sensitive data encrypted at rest (if applicable)
- [ ] HTTPS enforced in production
- [ ] No sensitive data in URLs (use POST for credentials)
- [ ] PII not logged
- [ ] Database credentials not in code
- [ ] .env files in .gitignore

**Files to review:**
- `tenxrep-api/.gitignore`
- `tenxrep-api/app/core/config.py`
- `tenxrep-api/app/core/database.py`

### 4. API Security

**Check for:**
- [ ] CORS configured properly (not `*` in production)
- [ ] Rate limiting on sensitive endpoints (login, signup)
- [ ] No sensitive data in error messages
- [ ] HTTP methods restricted appropriately
- [ ] No debug mode in production

**Files to review:**
- `tenxrep-api/app/main.py`
- `tenxrep-api/app/core/config.py`

### 5. Dependency Security

**Check for:**
- [ ] No known vulnerabilities in dependencies
- [ ] Dependencies pinned to specific versions
- [ ] No unnecessary dependencies

**Commands to run:**
```bash
# Python (tenxrep-api)
pip audit  # or: safety check

# JavaScript (tenxrep-web, tenxrep-marketing)
npm audit
```

### 6. Secrets Management

**Check for:**
- [ ] No secrets in code or git history
- [ ] Environment variables for all secrets
- [ ] Different secrets for dev/prod
- [ ] Secrets rotated periodically

**Commands to run:**
```bash
# Search for potential secrets
grep -r "password\|secret\|api_key\|token" --include="*.py" --include="*.ts" --include="*.tsx" . | grep -v node_modules | grep -v venv | grep -v ".env"
```

### 7. Error Handling

**Check for:**
- [ ] No stack traces exposed to users
- [ ] Generic error messages for auth failures
- [ ] Errors logged server-side (Sentry)
- [ ] Failed login attempts logged/monitored

### 8. Data Loss Prevention

**Check for:**
- [ ] Database backups configured
- [ ] Soft deletes where appropriate
- [ ] Cascade deletes won't orphan data
- [ ] Transaction rollback on errors

---

## Quick Audit Commands

```bash
# Check for hardcoded secrets
grep -rn "password.*=" --include="*.py" tenxrep-api/app/
grep -rn "secret.*=" --include="*.py" tenxrep-api/app/

# Check for SQL injection vulnerabilities (raw SQL)
grep -rn "execute\|raw\|text(" --include="*.py" tenxrep-api/app/

# Check npm vulnerabilities
cd tenxrep-web && npm audit
cd tenxrep-marketing && npm audit

# Check if .env is gitignored
cat tenxrep-api/.gitignore | grep -E "^\.env$"
```

---

## Severity Levels

- **CRITICAL**: Data breach risk, auth bypass, injection vulnerabilities
- **HIGH**: Sensitive data exposure, weak crypto, missing auth
- **MEDIUM**: Information disclosure, CORS issues, missing rate limits
- **LOW**: Best practice violations, minor info leaks

---

## After Audit

1. Create issues for each finding
2. Prioritize CRITICAL and HIGH first
3. Fix before public launch
4. Re-audit after fixes
