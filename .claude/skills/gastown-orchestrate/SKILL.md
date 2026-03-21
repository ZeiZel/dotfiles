---
name: gastown-orchestrate
description: Multi-agent orchestration for large projects (>50 files) via gt CLI (Gastown). Distribute tasks to agent pools, group related work into convoys, monitor progress.
allowed-tools: Bash, Read, Write
---

# Gastown Multi-Agent Orchestration

Skill for orchestrating multiple agents on large projects via `gt` CLI (Gastown). Use when project has >50 source files or requires parallel workstreams.

## When to Use

- Project has >50 source files
- Monorepo structure detected
- Multiple independent workstreams needed
- Need to distribute Beads tasks across agent pools
- Large feature requiring parallel development

## Prerequisites

```bash
# Check if gt is installed
command -v gt

# Install if missing
npm install -g @gastown/gt

# Initialize in project
gt install .
gt rig add main .
```

## Core Commands

### Initialize

```bash
# Install Gastown in project
gt install .

# Add repository as a rig
gt rig add main .

# Check rig status
gt rig status main
```

### Distribute Tasks

```bash
# Distribute ready Beads tasks to agent pools (polecats)
gt sling

# Check distribution status
gt feed
```

### Group Related Tasks (Convoys)

```bash
# Create a convoy for related tasks
gt convoy create "user-auth" bd-123 bd-124 bd-125

# List convoys
gt convoy list

# Check convoy progress
gt convoy status "user-auth"
```

### Monitor

```bash
# Real-time progress feed
gt feed

# Rig status (repository overview)
gt rig status main

# Agent pool status
gt polecat status
```

## Configuration

### Gastown Config (`docs/gastown/config.yaml`)

```yaml
rig:
  name: "main"
  repository: "."

mayor:
  context_files:
    - docs/architecture/overview.md
    - docs/Constitution.md
    - docs/project.yaml

polecats:
  pool_size: 3
  specializations:
    backend:
      agents: [spec-developer, spec-tester]
      context: [docs/context/backend.md]
    frontend:
      agents: [spec-developer, spec-tester]
      context: [docs/context/frontend.md]
    review:
      agents: [spec-reviewer, spec-validator]
      context: [docs/quality-gates.yaml]
```

## Integration Patterns

### With Beads (bd)

Gastown distributes Beads tasks to agent pools:

```bash
# 1. Create tasks with Beads
bd create --title "[API] Implement endpoints" --priority high
bd create --title "[UI] Create components" --priority high
bd create --title "[Test] Write integration tests" --priority medium

# 2. Set dependencies
bd dep add bd-103 bd-101  # Tests depend on API
bd dep add bd-103 bd-102  # Tests depend on UI

# 3. Let Gastown distribute ready tasks
gt sling

# 4. Monitor progress
gt feed
```

### With team-lead

Team-lead decides WHEN to use Gastown based on project size:

```bash
# Check project size
file_count=$(fd -e ts -e tsx -e py -e go -e rs | wc -l)

if [ "$file_count" -gt 50 ]; then
  # Large project: use Gastown for distribution
  gt install . 2>/dev/null || true
  gt rig add main . 2>/dev/null || true
  gt sling
else
  # Small project: direct agent spawning via Task tool
  echo "Small project, using direct orchestration"
fi
```

### Convoy Patterns

Group related tasks by feature:

```bash
# Feature: User Authentication
gt convoy create "user-auth" bd-100 bd-101 bd-102 bd-103

# Feature: Payment Integration
gt convoy create "payments" bd-200 bd-201 bd-202

# Monitor by feature
gt convoy status "user-auth"
gt convoy status "payments"
```

## When NOT to Use

- Small projects (<50 files) — use direct Task tool spawning
- Single-agent tasks — no distribution needed
- Quick fixes — overhead not justified

## Fallback

If `gt` is not installed, team-lead falls back to direct agent spawning via Task tool with parallel execution.

```
Gastown not installed. Using direct Task tool orchestration.
Install for large projects: npm install -g @gastown/gt
```
