---
name: teamlead
description: Invoke the Team Lead orchestration agent for complex multi-agent development workflows with Beads task management and integrated tooling (Beads, Gastown, Repomix, Aider)
allowed-tools: Read, Write, Edit, Glob, Grep, Bash, Task, TodoWrite, WebSearch
---

# Team Lead Skill

Invokes the Team Lead orchestration agent for managing complex multi-agent development workflows with full tooling integration.

## Overview

The Team Lead agent:
- Orchestrates multiple specialized agents
- Manages tasks via Beads CLI
- Drives quality-driven iteration loops (95%+ quality)
- Maintains living documentation via architecture-keeper
- Integrates with Gastown for large projects
- Refreshes context via Repomix

## Usage

```bash
/teamlead                           # Start team lead for current task
/teamlead implement user auth       # Implement a feature
/teamlead --plan-only              # Planning phase only
/teamlead --parallel               # Maximize parallel execution
```

## Integrated Tools

### Beads - Task Management
```bash
bd init           # Initialize workspace
bd ready          # View available tasks
bd list           # View all tasks
bd create         # Create new task
bd update --claim # Claim task
bd close          # Complete task
```

### Gastown - Multi-Agent Orchestration (Large Projects)
```bash
gt install .      # Initialize
gt rig add main . # Add rig
gt sling          # Distribute tasks
gt convoy create  # Group related tasks
gt feed           # Monitor progress
```

### Repomix - Context Refresh
```bash
repomix --output docs/context/codebase-snapshot.txt
```

### Aider - Pair Programming
```bash
aider [files]     # Interactive coding session
```

## Workflow Phases

1. **Pre-flight** - Check tools, load context, verify project setup
2. **Planning** - Requirements analysis, architecture design, task breakdown
3. **Execution** - Parallel agent spawning for independent tasks
4. **Quality Gates** - Code review, testing, validation (95%+ target)
5. **Iteration** - Fix issues, re-validate (max 3 iterations)
6. **Documentation** - Update architecture docs via architecture-keeper

## Pre-flight Protocol

Team Lead performs these checks at startup:

```bash
# 1. Check Beads
if ! command -v bd &>/dev/null; then
  notify "Beads not installed. Install: brew install beads"
fi
bd list 2>/dev/null || bd init

# 2. Check Gastown (for large projects)
file_count=$(find . -type f \( -name "*.ts" -o -name "*.tsx" -o -name "*.py" \) | wc -l)
if [ $file_count -gt 50 ] && ! command -v gt &>/dev/null; then
  notify "Large project detected. Consider: brew install gastown"
fi

# 3. Check Project Setup
if [ ! -f docs/project.yaml ]; then
  notify "Project not configured. Run: /project-setup"
fi

# 4. Check MCP Servers
if [ ! -f .mcp.json ]; then
  notify "MCP servers not configured. Run: /project-setup"
fi

# 5. Refresh Context (if repomix available)
if command -v repomix &>/dev/null && [ -f docs/context/codebase-snapshot.txt ]; then
  age=$(stat -f %m docs/context/codebase-snapshot.txt 2>/dev/null || echo 0)
  now=$(date +%s)
  if [ $((now - age)) -gt 3600 ]; then
    repomix --output docs/context/codebase-snapshot.txt
    notify "Context refreshed via repomix"
  fi
fi
```

## Workflow with Tools

```
/teamlead implement [feature]
       │
       ▼
[Pre-flight] Check tools availability
       │
       ▼
[Beads] bd ready - check available tasks
       │
       ▼
[Repomix] Refresh context snapshot (if stale)
       │
       ▼
[Spec-agents] Spawn with context
       │
       ▼
[Beads] bd update --claim - track work
       │
       ▼
[Gastown] gt sling - distribute (if large project)
       │
       ▼
[Quality] spec-reviewer, spec-validator
       │
       ▼
[Beads] bd close - mark complete
       │
       ▼
[Notify] Summary + suggestions
```

## Notification System

Team Lead notifies user in these cases:

### Missing Tools
```
⚠️ Tool 'beads' not installed.
Install: brew install beads
This would help with: persistent task tracking across sessions
```

### Tool Failure
```
❌ Tool 'repomix' failed: command not found
Suggestion: npm install -g repomix
Continuing without context snapshot...
```

### Optimization Suggestions
```
💡 Recommendation: Install Gastown for parallel agent orchestration
Install: brew install gastown
Benefit: 3x faster development for large features
```

### Missing Context
```
📝 Project not prepared for AI development.
Run: /project-setup
This will create specifications and task structure.
```

## Prerequisites

- Beads CLI installed (`brew install beads`)
- Project documentation in `docs/` (run `/project-setup` first if needed)
- Optional: Gastown for large projects
- Optional: Repomix for context snapshots
- Optional: Aider for pair programming

## Integration

### With Beads
```bash
bd ready          # View available tasks
bd list           # View all tasks
bd show bd-123    # View task details
```

### With Gastown (Large Projects)
```bash
gt sling          # Distribute tasks to agents
gt convoy create  # Group related tasks
gt feed           # Monitor progress
```

### With Repomix
```bash
repomix --output docs/context/snapshot.txt
```

### With Architecture
- Reads context from `docs/project.yaml`
- Reads architecture from `docs/architecture/`
- Reads domains from `docs/domains/`
- Updates via architecture-keeper agent

### With MCP Servers
- **context7**: Documentation lookup during development
- **sequential-thinking**: Complex reasoning for architecture decisions
- **github**: PR and issue management

## Execute

Invoke the team-lead agent with the Task tool:

```
subagent_type: team-lead
prompt: [User's request or feature description]
```

The agent will:
1. Run pre-flight checks
2. Load project context from docs/
3. Refresh context via repomix (if available and stale)
4. Create development plan
5. Spawn specialized agents
6. Track progress in Beads
7. Use Gastown for distribution (if large project)
8. Drive to 95%+ quality
9. Update documentation
10. Report completion with suggestions
