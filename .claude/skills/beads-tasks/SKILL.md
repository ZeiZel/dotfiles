---
name: beads-tasks
description: Manage development tasks via bd CLI (Beads) - create, track, claim, close tasks with DAG dependencies. Persistent task management that survives across sessions.
allowed-tools: Bash, Read, Write
---

# Beads Task Management

Skill for managing development tasks via `bd` CLI (Beads task manager). Provides persistent task tracking with DAG dependencies that survives across agent sessions.

## When to Use

- Creating tasks from requirements or plans
- Claiming and tracking work in progress
- Managing task dependencies (DAG)
- Closing tasks with completion summaries
- Checking available/blocked/completed tasks
- Any agent that needs persistent task state

## Prerequisites

```bash
# Check if bd is installed
command -v bd

# Install if missing
brew install beads
# or: curl -fsSL https://raw.githubusercontent.com/steveyegge/beads/main/scripts/install.sh | bash

# Initialize in project (first time)
bd init
```

## Core Commands

### View Tasks

```bash
# Tasks ready for work (no unmet dependencies)
bd ready

# All active tasks
bd list

# Task details
bd show bd-123

# Tasks by status
bd list --status blocked
bd list --status completed
```

### Create Tasks

```bash
# Simple task
bd create --title "[Component] Action description" \
  --description "Context and acceptance criteria" \
  --priority high

# Task with full context
bd create --title "[Auth] Implement JWT authentication" \
  --description "## Context
Implement JWT-based auth for the API.

## Acceptance Criteria
- [ ] Login endpoint with email/password
- [ ] Token refresh mechanism
- [ ] Rate limiting on auth endpoints

## Technical Approach
- JWT with RS256 signing
- Redis for token blacklist

## Assigned Agent
senior-backend-architect" \
  --priority high
```

### Manage Dependencies

```bash
# bd-124 depends on bd-123 (bd-124 cannot start until bd-123 is done)
bd dep add bd-124 bd-123

# View dependency graph
bd dep list bd-124
```

### Work on Tasks

```bash
# Claim a task (atomic ownership)
bd update bd-123 --claim

# Update status
bd update bd-123 --status in-progress
bd update bd-123 --status blocked --message "Waiting for API spec"

# Close with result
bd close bd-123 --message "Completed: 95% coverage, all tests passing"

# Reopen if issues found
bd reopen bd-123 --message "Validation failed: missing edge case"
```

## Agent Integration Patterns

### For spec-planner: Create Task Breakdown

```bash
# After planning phase, create tasks with dependencies
bd create --title "[DB] Create user schema migration" --priority high
# Returns: bd-100

bd create --title "[API] Implement user endpoints" --priority high
# Returns: bd-101

bd create --title "[Test] Write user API tests" --priority medium
# Returns: bd-102

# Set dependencies
bd dep add bd-101 bd-100   # API depends on DB schema
bd dep add bd-102 bd-101   # Tests depend on API
```

### For spec-developer: Claim and Complete

```bash
# Check what's available
bd ready

# Claim task
bd update bd-101 --claim

# ... do implementation work ...

# Close with summary
bd close bd-101 --message "Implemented: GET/POST/PUT/DELETE /api/users with validation"
```

### For spec-reviewer: Track Review Tasks

```bash
# Create review task linked to implementation
bd create --title "[Review] Code review for bd-101" --priority high
bd dep add bd-103 bd-101   # Review depends on implementation

# After review
bd close bd-103 --message "Approved: minor style fixes applied"
# or
bd update bd-103 --status blocked --message "Needs rework: security issues found"
```

### For team-lead: Monitor Progress

```bash
# Overview
bd list

# Check blockers
bd list --status blocked

# Check what's ready for next phase
bd ready
```

## Task Naming Convention

Format: `[Component/Domain] Action description`

Examples:
- `[Auth] Implement JWT token validation`
- `[DB] Create users table migration`
- `[API] Add rate limiting middleware`
- `[Test] Integration tests for auth flow`
- `[Review] Security review for auth module`
- `[Docs] Update API documentation`

## Priority Levels

| Priority | When to Use |
|----------|------------|
| `critical` | Blocking other teams, production issues |
| `high` | Core feature implementation, security fixes |
| `medium` | Standard development tasks |
| `low` | Nice-to-have improvements, minor refactoring |

## Fallback

If `bd` is not installed, use `TodoWrite` (built-in) as fallback. Note: TodoWrite does NOT persist across sessions.

```
TodoWrite is a session-only fallback. For persistent tracking, install Beads:
brew install beads
```
