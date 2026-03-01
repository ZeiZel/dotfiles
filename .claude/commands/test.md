---
name: test
description: Generate comprehensive tests for a file or module
allowed-tools: Bash, Read, Write, Edit, Glob, Grep
---

Generate tests for: $ARGUMENTS

Process:

1. **Analyze** the target code:
   - Read the file(s) to test
   - Identify the testing framework used in the project
   - Check existing test patterns and conventions

2. **Plan test cases**:
   - Happy path: Normal expected usage
   - Edge cases: Empty inputs, boundaries, large values
   - Error cases: Invalid inputs, network failures, timeouts
   - Integration: Interactions between modules (if applicable)

3. **Write tests**:
   - Follow the project's existing test conventions
   - Use descriptive test names: `should [expected behavior] when [condition]`
   - Arrange → Act → Assert pattern
   - Mock external dependencies, not internal logic
   - One assertion per test when possible

4. **Verify**: Run the tests and ensure they all pass
