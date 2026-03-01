---
name: security-audit
description: Audit codebase for security vulnerabilities - OWASP Top 10, dependency CVEs, secrets, misconfigurations
allowed-tools: Bash, Read, Glob, Grep
---

Perform a security audit of this codebase. Check:

1. **Secrets scan**: Grep for API keys, tokens, passwords, private keys in code
   - Check: `.env` files committed, hardcoded credentials, JWT secrets in code

2. **Dependency vulnerabilities**:
   - Run `npm audit` or `pip audit` or `cargo audit`
   - Check for known CVEs in dependencies

3. **OWASP Top 10**:
   - Injection (SQL, NoSQL, command, LDAP)
   - Broken authentication (weak passwords, missing MFA references)
   - Sensitive data exposure (PII logging, unencrypted storage)
   - XSS (unsanitized output, dangerouslySetInnerHTML)
   - Broken access control (missing auth checks, IDOR)
   - Security misconfiguration (debug mode, default credentials, CORS *)
   - CSRF protection
   - Insecure deserialization

4. **Infrastructure** (if applicable):
   - Dockerfiles running as root
   - Exposed ports
   - Missing network policies
   - Secrets in plain Kubernetes manifests

5. **Output**: Produce a security report sorted by severity (Critical → Low)
   with specific file:line references and remediation steps.

Focus area: $ARGUMENTS
