---
name: migrate
description: Guided migration assistance for version upgrades and framework changes
allowed-tools: Read, Write, Edit, WebSearch, Bash
---

# Migrate Skill

Provides guided assistance for migrating between versions, frameworks, or technologies with step-by-step plans and code transformations.

## Usage

```bash
/migrate [from] [to]                 # Migration guidance
/migrate react@17 react@18           # Version migration
/migrate express fastify             # Framework migration
/migrate --plan                      # Plan only, no changes
/migrate --apply                     # Apply transformations
```

## Examples

```bash
/migrate react@17 react@18
/migrate "Next.js Pages" "Next.js App Router"
/migrate express fastify
/migrate webpack vite
/migrate jest vitest
```

## What It Does

1. **Research Migration Path**
   - Fetches official migration guides
   - Identifies breaking changes
   - Finds community solutions

2. **Analyzes Codebase**
   - Identifies affected files
   - Estimates migration scope
   - Detects patterns to update

3. **Creates Migration Plan**
   - Step-by-step instructions
   - Code transformations
   - Verification checkpoints
   - Rollback strategy

4. **Optional: Applies Changes**
   - Automated code updates
   - Configuration changes
   - Dependency updates

## Output Format

```markdown
# Migration Plan: [From] → [To]

## Overview
- **Effort**: [X hours/days]
- **Risk**: [Low/Medium/High]
- **Breaking Changes**: [count]

## Breaking Changes

### Change 1: [Description]
**Impact**: [files/components affected]
**Before**:
```typescript
// Old code
```
**After**:
```typescript
// New code
```

## Migration Steps

### Phase 1: Preparation
- [ ] Ensure test coverage
- [ ] Create backup branch
- [ ] Update dependencies

### Phase 2: Core Migration
- [ ] Step 1: [Description]
- [ ] Step 2: [Description]
- [ ] Verify: [Test command]

### Phase 3: Cleanup
- [ ] Remove deprecated code
- [ ] Update documentation

## Rollback Plan
[Steps to revert if issues]

## Verification
```bash
npm test
npm run lint
```
```

## Common Migrations

| From | To | Complexity |
|------|-----|------------|
| React 17 | React 18 | Medium |
| Next.js Pages | App Router | High |
| Express | Fastify | Medium |
| Webpack | Vite | Medium |
| Jest | Vitest | Low |
| Moment.js | date-fns | Low |
| Class components | Hooks | Medium |

## Flags

| Flag | Description |
|------|-------------|
| `--plan` | Generate plan only, no code changes |
| `--apply` | Apply code transformations |
| `--dry-run` | Show what would change without applying |
| `--interactive` | Step-by-step interactive mode |

## Execute

Spawn the migration-assistant agent:

```
subagent_type: migration-assistant
prompt: Create a migration plan from [source] to [target]. Research official migration guides, identify breaking changes in this codebase, and generate step-by-step migration instructions with code transformations. [Plan only / Apply changes].
```
