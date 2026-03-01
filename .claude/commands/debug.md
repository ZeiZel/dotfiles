---
name: debug
description: Systematically debug an issue by reproducing, isolating, and fixing it
allowed-tools: Bash, Read, Write, Edit, Glob, Grep
---

Debug the following issue: $ARGUMENTS

Follow this systematic debugging process:

1. **Reproduce**: Understand and reproduce the issue
   - Read error messages and stack traces carefully
   - Find the relevant code paths
   - Try to reproduce with a minimal case

2. **Isolate**: Narrow down the root cause
   - Use binary search on recent commits if it's a regression: `git bisect`
   - Add strategic logging/console output
   - Check inputs, outputs, and state at each step
   - Look for common culprits: null/undefined, race conditions, stale cache, wrong env

3. **Fix**: Apply the minimal correct fix
   - Fix the root cause, not the symptom
   - Add a test that would have caught this bug
   - Check for similar patterns elsewhere in the codebase

4. **Verify**: Confirm the fix
   - Original issue no longer reproduces
   - New test passes
   - Existing tests still pass
   - No regression in related functionality
