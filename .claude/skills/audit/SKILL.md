---
name: audit
description: Audit dependencies for security vulnerabilities, outdated packages, and license compliance
allowed-tools: Read, Bash, WebSearch
---

# Audit Skill

Audits project dependencies for security vulnerabilities, outdated packages, and license compliance issues.

## Usage

```bash
/audit                               # Full audit
/audit --security                    # Security vulnerabilities only
/audit --outdated                    # Outdated packages only
/audit --licenses                    # License compliance only
/audit --fix                         # Auto-fix safe updates
```

## Examples

```bash
/audit
/audit --security
/audit --outdated --fix
```

## What It Does

1. **Detects Ecosystem**
   - npm/yarn/pnpm (JavaScript)
   - pip/poetry (Python)
   - cargo (Rust)
   - go modules (Go)

2. **Security Scan**
   - CVE vulnerability detection
   - Severity classification
   - Remediation guidance

3. **Outdated Check**
   - Current vs latest versions
   - Major/minor/patch breakdown
   - Breaking change warnings

4. **License Check**
   - License type detection
   - Compatibility analysis
   - Attribution requirements

## Output Format

```markdown
# Dependency Audit Report

**Project**: [name]
**Date**: [date]
**Ecosystem**: [npm/pip/cargo/go]

## Summary

| Category | Count | Severity |
|----------|-------|----------|
| Critical CVEs | X | 🔴 |
| High CVEs | X | 🟠 |
| Outdated (Major) | X | 🟡 |
| License Issues | X | ⚪ |

## Critical Security Issues

### CVE-2024-XXXXX: [package]
**Severity**: Critical
**Current**: 1.0.0
**Fixed in**: 1.0.1

**Fix**:
```bash
npm install [package]@1.0.1
```

## Outdated Dependencies

### Major Updates
| Package | Current | Latest | Breaking |
|---------|---------|--------|----------|
| react | 17.0.2 | 18.2.0 | Yes |

### Safe Updates
| Package | Current | Latest |
|---------|---------|--------|
| lodash | 4.17.20 | 4.17.21 |

## Recommendations

1. **Immediate**: Fix critical CVEs
2. **Planned**: Schedule major updates
3. **Routine**: Apply safe updates
```

## Flags

| Flag | Description |
|------|-------------|
| `--security` | Only show security vulnerabilities |
| `--outdated` | Only show outdated packages |
| `--licenses` | Only show license issues |
| `--fix` | Auto-fix safe (patch/minor) updates |
| `--json` | Output as JSON |

## Execute

Spawn the dependency-auditor agent:

```
subagent_type: dependency-auditor
prompt: Perform a [full/security/outdated/license] audit of project dependencies. Identify vulnerabilities, outdated packages, and license issues. Provide severity-ranked findings with remediation steps. [Auto-fix safe updates if --fix].
```
