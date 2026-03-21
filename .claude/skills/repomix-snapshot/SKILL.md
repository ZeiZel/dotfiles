---
name: repomix-snapshot
description: Codebase context snapshots via Repomix. Create, refresh, and extract relevant sections from compressed codebase representations for agent context injection.
allowed-tools: Bash, Read, Write, Glob, Grep
---

# Repomix Context Snapshots

Skill for managing codebase context via Repomix. Creates compressed codebase snapshots that can be selectively injected into agent prompts.

## When to Use

- Before spawning agents that need codebase context
- When snapshot is stale (>1 hour old)
- When switching between repomix and RAG strategies
- For small-to-medium projects (<=700k tokens after compression)

## Prerequisites

```bash
# Check if repomix is installed
command -v repomix

# Install if missing
npm install -g repomix
```

## Core Commands

### Create/Refresh Snapshot

```bash
# Default: full project snapshot
repomix --output docs/context/codebase-snapshot.txt

# With specific includes
repomix --include "src/**/*.ts,src/**/*.tsx" --output docs/context/codebase-snapshot.txt

# With excludes
repomix --exclude "node_modules,dist,coverage" --output docs/context/codebase-snapshot.txt

# Specific directory
repomix --input src/services --output docs/context/services-snapshot.txt
```

### Check Snapshot Freshness

```bash
# Check age of snapshot
if [ -f docs/context/codebase-snapshot.txt ]; then
  age=$(stat -f %m docs/context/codebase-snapshot.txt 2>/dev/null || stat -c %Y docs/context/codebase-snapshot.txt 2>/dev/null || echo 0)
  now=$(date +%s)
  age_minutes=$(( (now - age) / 60 ))
  echo "Snapshot age: ${age_minutes} minutes"

  if [ $((now - age)) -gt 3600 ]; then
    echo "Stale - needs refresh"
  else
    echo "Fresh"
  fi
fi
```

### Estimate Token Count

```bash
if [ -f docs/context/codebase-snapshot.txt ]; then
  SIZE=$(wc -c < docs/context/codebase-snapshot.txt)
  ESTIMATED_TOKENS=$((SIZE / 4))
  echo "Estimated tokens: ~${ESTIMATED_TOKENS}"

  if [ "$ESTIMATED_TOKENS" -gt 700000 ]; then
    echo "Strategy: RAG (>700k tokens)"
  else
    echo "Strategy: repomix (<=700k tokens)"
  fi
fi
```

## Section Extraction

When injecting context into agent prompts, extract only relevant sections:

### By File Path Pattern

```bash
# Extract sections related to auth
grep -A 50 "src/auth\|src/services/auth\|auth.service\|auth.controller" \
  docs/context/codebase-snapshot.txt

# Extract sections related to a specific module
grep -A 30 "src/modules/users" docs/context/codebase-snapshot.txt
```

### By Content Pattern

```bash
# Find architecture-relevant sections
grep -B 2 -A 20 "class.*Service\|interface.*Repository\|@Controller\|@Module" \
  docs/context/codebase-snapshot.txt

# Find configuration sections
grep -B 2 -A 10 "config\|environment\|\.env" \
  docs/context/codebase-snapshot.txt
```

## Integration Patterns

### For team-lead: Prepare Context Before Spawning

```bash
# 1. Check if snapshot exists and is fresh
if [ ! -f docs/context/codebase-snapshot.txt ] || \
   [ $(($(date +%s) - $(stat -f %m docs/context/codebase-snapshot.txt 2>/dev/null || echo 0))) -gt 3600 ]; then
  # Refresh snapshot
  mkdir -p docs/context
  repomix --output docs/context/codebase-snapshot.txt
fi

# 2. Read snapshot
# Use Read tool to load docs/context/codebase-snapshot.txt

# 3. Extract relevant sections for the agent's task
# 4. Include in spawn prompt as "## Pre-loaded Context"
```

### For spec-analyst: Read Project Overview

```bash
# Read full snapshot for requirements analysis
# Use Read tool on docs/context/codebase-snapshot.txt
# Focus on: directory structure, config files, entry points
```

### For spec-architect: Understand Existing Architecture

```bash
# Read snapshot focusing on:
# - Module structure
# - Service classes
# - Database models
# - API routes
# - Configuration
```

## Focused Snapshots

Create domain-specific snapshots for targeted context:

```bash
# Backend services only
repomix --include "src/services/**,src/models/**,src/controllers/**" \
  --output docs/context/backend-snapshot.txt

# Frontend components only
repomix --include "src/components/**,src/pages/**,src/hooks/**" \
  --output docs/context/frontend-snapshot.txt

# Tests only
repomix --include "**/*.test.*,**/*.spec.*,**/test/**" \
  --output docs/context/tests-snapshot.txt

# Infrastructure only
repomix --include "docker*,*.yml,*.yaml,terraform/**,k8s/**" \
  --output docs/context/infra-snapshot.txt
```

## Strategy Decision Flow

```
1. Check docs/project.yaml → context.strategy
2. If strategy == "auto":
   a. Check snapshot size
   b. If >700k tokens → use RAG (see rag-context skill)
   c. If <=700k tokens → use repomix (this skill)
3. If strategy == "repomix": always use snapshot
4. If strategy == "rag": always use RAG tools

Note: If Qdrant is unavailable, fall back to repomix regardless of strategy.
```

## Context Pack Template (for agent spawning)

```markdown
## Pre-loaded Context

### Project Structure
{Extracted from snapshot: directory tree, entry points}

### Relevant Code
{Extracted from snapshot: files related to agent's task}

### Architecture Patterns
{Extracted from snapshot: service classes, modules, configs}

## Context Source
**Strategy**: repomix
All relevant context is pre-loaded above. Use Read/Glob/Grep for additional file access.
```
