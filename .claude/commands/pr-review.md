---
name: pr-review
description: Review current PR or staged changes for bugs, security issues, and code quality
allowed-tools: Bash, Read, Glob, Grep
---

Review the current changes for a pull request. Follow this process:

1. Get the diff:
   - If on a branch, run `git diff main...HEAD` (or `git diff master...HEAD`)
   - If no branch diff, use `git diff --staged`

2. For each changed file, analyze:
   - Security vulnerabilities (injection, XSS, auth issues, secrets)
   - Bug risks (null handling, race conditions, error cases)
   - Performance concerns (N+1 queries, unnecessary re-renders, missing indexes)
   - Test coverage (are new code paths tested?)
   - API contract changes (breaking changes?)

3. Use the code-reviewer agent's format:
   - Summary of the change
   - Critical issues (must fix before merge)
   - Important issues (should fix)
   - Improvements (nice to have)
   - What's good (positive feedback)

4. If $ARGUMENTS is provided, focus the review on: $ARGUMENTS
