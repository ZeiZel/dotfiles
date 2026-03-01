---
name: implement
description: Implement a feature with planning, tests, and clean code
allowed-tools: Bash, Read, Write, Edit, Glob, Grep
---

Implement the following feature: $ARGUMENTS

Follow this process:

1. **Research phase** (spawn Explore subagent):
   - Find relevant existing code patterns
   - Identify files that need to change
   - Check for existing tests and utilities to reuse

2. **Plan phase**:
   - List all files to create/modify
   - Define the data flow
   - Identify edge cases
   - Present the plan and wait for approval

3. **Implementation phase**:
   - Write types/interfaces first
   - Implement core logic
   - Add error handling
   - Write tests alongside code

4. **Verification phase**:
   - Run existing tests to ensure nothing breaks
   - Run linter
   - Run type checker
   - Summarize what was done and any follow-up items
