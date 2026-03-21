---
name: code-search
description: Advanced codebase search combining Glob, Grep, and code-index-mcp. Pattern matching, semantic search, architecture navigation, and cross-reference analysis.
allowed-tools: Glob, Grep, Read, Bash, mcp__code-index-mcp__search_code_advanced, mcp__code-index-mcp__get_file_summary, mcp__code-index-mcp__find_files
---

# Advanced Code Search

Skill for deep codebase exploration combining multiple search strategies. Escalates from fast pattern matching to semantic search when needed.

## When to Use

- Finding specific classes, functions, or interfaces
- Understanding module structure and dependencies
- Tracing data flow across files
- Finding usage patterns and examples
- Architecture-level navigation
- Any agent that needs to understand existing code before implementing

## Search Strategy Ladder

Use the simplest approach first, escalate as needed:

```
Level 1: Glob — find files by name/path pattern
Level 2: Grep — find content by text pattern
Level 3: Read — read specific files for full context
Level 4: code-index-mcp — semantic search when text search is insufficient
```

## Level 1: File Discovery (Glob)

### Find Files by Pattern

```
# Find all TypeScript service files
Glob("src/**/*service*.ts")

# Find test files
Glob("**/*.test.ts")
Glob("**/*.spec.ts")

# Find configuration files
Glob("**/*.config.*")
Glob("**/config/**")

# Find by module
Glob("src/modules/auth/**")
Glob("src/**/user*")
```

### Common Patterns

| Need | Pattern |
|------|---------|
| Services | `src/**/*service*.ts` |
| Controllers | `src/**/*controller*.ts` |
| Models/Entities | `src/**/*model*.ts`, `src/**/*entity*.ts` |
| Tests | `**/*.test.*`, `**/*.spec.*` |
| Configs | `**/*.config.*`, `**/config/**` |
| Migrations | `**/migrations/**` |
| Types/Interfaces | `src/**/*types*.ts`, `src/**/*interface*.ts` |
| Routes | `src/**/*route*.ts`, `src/**/*router*.ts` |
| Middleware | `src/**/*middleware*.ts` |
| Hooks | `src/**/*hook*.ts`, `src/**/use*.ts` |

## Level 2: Content Search (Grep)

### Find Code Patterns

```
# Find class definitions
Grep("class.*Service", "src/")
Grep("class.*Controller", "src/")

# Find function definitions
Grep("async.*function.*create", "src/")
Grep("export (const|function)", "src/")

# Find imports/usage
Grep("import.*UserService", "src/")
Grep("from.*@/services", "src/")

# Find decorators/annotations
Grep("@Injectable|@Controller|@Module", "src/")

# Find error handling
Grep("catch|throw new|Error\\(", "src/")

# Find TODO/FIXME
Grep("TODO|FIXME|HACK|XXX", "src/")
```

### Cross-Reference Analysis

```
# Who uses this service?
Grep("UserService", "src/")

# What does this module export?
Grep("export", "src/modules/auth/index.ts")

# Find all API endpoints
Grep("@(Get|Post|Put|Delete|Patch)\\(", "src/")

# Find database queries
Grep("findOne|findMany|create|update|delete", "src/repositories/")
```

## Level 3: Deep Read

```
# Read a specific file for full understanding
Read("src/services/auth.service.ts")

# Read related files together
Read("src/services/auth.service.ts")
Read("src/controllers/auth.controller.ts")
Read("src/models/user.entity.ts")
```

## Level 4: Semantic Search (code-index-mcp)

When text search returns too many or too few results:

```
# Search by meaning, not exact text
mcp__code-index-mcp__search_code_advanced(
  pattern: "user authentication and authorization logic"
)

# Find similar implementations
mcp__code-index-mcp__search_code_advanced(
  pattern: "error handling middleware pattern"
)

# Understand a complex file
mcp__code-index-mcp__get_file_summary(
  file_path: "src/services/auth.service.ts"
)

# Find files by semantic relevance
mcp__code-index-mcp__find_files(
  query: "payment processing"
)
```

## Agent Integration Patterns

### For spec-developer: Before Implementing

```
# 1. Find the module you'll work in
Glob("src/modules/auth/**")

# 2. Find existing patterns to follow
Grep("class.*Service", "src/services/")

# 3. Understand the specific file
Read("src/services/auth.service.ts")

# 4. Find related tests
Glob("**/*auth*.test.*")

# 5. If still need more context, use semantic search
mcp__code-index-mcp__search_code_advanced(pattern: "auth service dependencies")
```

### For spec-reviewer: During Review

```
# 1. Find all changed files
Bash("git diff --name-only HEAD~1")

# 2. Check for similar patterns in codebase
Grep("pattern-from-changed-code", "src/")

# 3. Verify imports are correct
Grep("import.*from", "path/to/changed/file.ts")

# 4. Check test coverage exists
Glob("**/*{module-name}*.test.*")
```

### For spec-tester: Finding What to Test

```
# 1. Find public API surface
Grep("export (class|function|const|interface)", "src/modules/auth/")

# 2. Find error scenarios
Grep("throw|reject|Error", "src/services/auth.service.ts")

# 3. Find existing test patterns
Glob("src/**/*.test.ts")
Read("src/services/__tests__/user.service.test.ts")

# 4. Find integration points
Grep("inject|constructor.*private", "src/services/auth.service.ts")
```

### For spec-architect: Architecture Discovery

```
# 1. Map module structure
Glob("src/modules/*/index.ts")

# 2. Find entry points
Glob("src/main.ts")
Glob("src/app.module.ts")

# 3. Map service dependencies
Grep("@Inject|constructor.*private.*Service", "src/")

# 4. Find database models
Glob("src/**/*entity*.ts")
Glob("src/**/*schema*.ts")

# 5. Map API surface
Grep("@Controller|@Get|@Post", "src/")
```

## Tips

- **Start broad, narrow down**: Use Glob to find files, then Grep to find content, then Read for full context
- **Use multiple patterns**: If one pattern misses results, try alternatives (e.g., `Service` vs `service` vs `Svc`)
- **Combine tools**: Glob to find files, then Grep within those files
- **Semantic search as last resort**: code-index-mcp is powerful but slower; use it when text patterns don't capture what you need
- **Read before modifying**: Always understand the full file context before editing
