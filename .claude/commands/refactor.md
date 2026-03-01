---
name: refactor
description: Refactor code while preserving behavior - extract, simplify, optimize
allowed-tools: Bash, Read, Write, Edit, Glob, Grep
---

Refactor the following: $ARGUMENTS

Follow this safe refactoring process:

1. **Understand** the current code:
   - Read all relevant files
   - Map dependencies and callers
   - Run existing tests to establish baseline

2. **Plan** the refactoring:
   - Identify what changes and what stays
   - Ensure behavior is preserved (no functional changes)
   - Break into small, atomic steps

3. **Execute** step by step:
   - Make one change at a time
   - Run tests after each step
   - If tests fail, revert and try differently

4. **Verify**:
   - All existing tests pass
   - Type checker passes
   - No new warnings from linter
   - Show before/after diff summary
