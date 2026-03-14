---
name: teamlead
description: Invoke the Team Lead orchestration agent for complex multi-agent development workflows with Beads task management
allowed-tools: Task, Read, Write, Edit, Glob, Grep, Bash, TodoWrite
---

# Team Lead Orchestration Skill

Invoke the Team Lead agent to orchestrate complex development workflows with intelligent sub-agent coordination.

## Overview

The Team Lead is an active orchestration agent that:
- Spawns specialized agents for each phase of development
- Manages tasks persistently via Beads CLI
- Executes parallel tasks when dependencies allow
- Drives quality-driven iteration loops (95%+ target)
- Maintains architecture documentation through dedicated agents

## Usage

```
/teamlead                           # Interactive mode - discusses approach first
/teamlead implement user auth       # Direct execution with feature description
/teamlead --parallel                # Maximize parallel agent execution
/teamlead --plan-only               # Planning phase only, no implementation
```

## Workflow Phases

### Phase 1: Planning
```
User Request → spec-analyst → spec-architect → spec-planner → Beads Tasks
```

### Phase 2: Execution
```
Beads Tasks → [parallel agents] → Implementation
```

### Phase 3: Quality Gates
```
Implementation → spec-reviewer → spec-tester → spec-validator → Quality Score
```

### Phase 4: Iteration (if needed)
```
Quality < 95% → Targeted Fixes → Re-validation (max 3 iterations)
```

### Phase 5: Architecture Update
```
Completion → architecture-keeper → Updated specs and domain documentation
```

## Context Management

The Team Lead manages context for each sub-agent by providing:

1. **Task-Specific Context**
   - Beads task ID and details
   - Acceptance criteria
   - Technical constraints
   - Integration points

2. **Project Context**
   - Architecture overview from `docs/architecture/`
   - Domain models from `docs/domains/`
   - Previous decisions and rationale

3. **Phase Context**
   - Current workflow phase
   - Dependencies and blockers
   - Expected deliverables

## Agent Selection

| Phase | Agent | Purpose |
|-------|-------|---------|
| Requirements | spec-analyst | Gather and document requirements |
| Design | spec-architect | System architecture and API design |
| Planning | spec-planner | Task breakdown with dependencies |
| Backend | senior-backend-architect | API implementation |
| Frontend | front-lead | Coordinate framework engineers |
| Database | database-architect | Schema and optimization |
| Testing | spec-tester | Comprehensive test suites |
| Review | spec-reviewer | Code quality and security |
| Validation | spec-validator | Final quality assessment |
| Documentation | architecture-keeper | Maintain architecture specs |

## Beads Integration

All tasks are managed through Beads for persistence:

```bash
# View ready tasks
bd ready

# Create task with context
bd create --title "[Feature] Description" --description "Full context..."

# Track progress
bd list

# Close with results
bd close bd-123 --message "Completed with 96% quality score"
```

## Quality Standards

- **Pass Threshold**: 95% quality score
- **Max Iterations**: 3 attempts before escalation
- **Required Checks**:
  - Code quality and patterns
  - Test coverage (>80%)
  - Security scan
  - Documentation completeness

## Output

The Team Lead provides:

1. **Session Reports** - Current status and progress
2. **Phase Transitions** - Summaries when moving between phases
3. **Quality Reports** - Validation scores and issues
4. **Completion Summary** - Final deliverables and metrics
5. **Architecture Updates** - Updated domain and system documentation

## Examples

### Full Feature Implementation
```
/teamlead implement user notification system with push, email, and in-app channels
```

### Planning Only
```
/teamlead --plan-only design a payment processing integration with Stripe
```

### Parallel Execution
```
/teamlead --parallel implement dashboard with charts, tables, and export functionality
```

## Execute

**Feature**: $ARGUMENTS

Starting Team Lead orchestration workflow...

Use the **team-lead** sub agent to orchestrate the complete development workflow for the requested feature. The team lead will:

1. Analyze the request and determine scope
2. Spawn planning agents (spec-analyst, spec-architect, spec-planner)
3. Create Beads tasks with dependencies
4. Execute implementation with appropriate agents in parallel where possible
5. Run quality gates and iterate as needed
6. Update architecture documentation via architecture-keeper
7. Deliver completion report with quality metrics
