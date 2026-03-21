---
name: teamlead
description: Invoke the Team Lead orchestration agent for complex multi-agent development workflows with Beads task management and integrated tooling (Beads, Gastown, Repomix, Aider)
allowed-tools: Read, Write, Glob, Grep, Bash, Task, TodoWrite, SendMessage, WebSearch
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
- Spawns **named** agents with bidirectional communication via SendMessage
- **Never edits code directly** — pure orchestration only

## Usage

```bash
/teamlead                           # Start team lead for current task
/teamlead implement user auth       # Implement a feature
/teamlead --plan-only              # Planning phase only
/teamlead --parallel               # Maximize parallel execution
```

## Context Pipeline

Team Lead manages the context pipeline — deciding how agents receive project context.

### Context Strategies

| Strategy | When | How |
|----------|------|-----|
| **repomix** | Snapshot ≤700k tokens | Read snapshot, extract relevant sections, inject into agent prompt |
| **rag** | Snapshot >700k tokens | Query qdrant-find + code-index-mcp, compose targeted Context Pack |
| **auto** | Default | Check snapshot size at runtime, select repomix or rag |

### Pipeline Flow

```
Pre-flight
  └─ Read docs/project.yaml → context.strategy
  └─ If auto: estimate tokens, decide
  └─ If rag: verify Qdrant health

Per-Agent Spawning
  └─ Formulate task-specific queries
  └─ If repomix: extract from snapshot
  └─ If rag: qdrant-find + code-index-mcp
  └─ Compose Context Pack (pre-loaded context)
  └─ Add Context Source block (self-service instructions)
  └─ Inject into agent spawn prompt
```

### RAG Tools (for rag strategy)

```bash
# Semantic search for architectural knowledge
mcp__qdrant-mcp__qdrant-find(query: "how authentication works")

# Search for code patterns
mcp__code-index-mcp__search_code_advanced(pattern: "UserService")

# Understand a specific file
mcp__code-index-mcp__get_file_summary(file_path: "src/auth/service.ts")

# Store new knowledge (after documentation phase)
mcp__qdrant-mcp__qdrant-store(information: "Architecture update: ...", metadata: {...})
```

### Agent Context Levels

- **Planning agents** (analyst, architect, planner): Get docs context only, no RAG tools
- **Execution agents** (developer, reviewer, tester): Get pre-loaded context + RAG tools for self-service
- **Documentation agents** (architecture-keeper): Get phase results + RAG for codebase understanding

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

## Bidirectional Communication

Team Lead spawns agents with names so they can respond:

| Message Type | Trigger | Team Lead Response |
|---|---|---|
| `QUESTION: ...` | Ambiguity before starting | Clarify immediately via SendMessage |
| `BLOCKER: ...` | Cannot proceed | Resolve or escalate to user |
| `DONE: ...` | Task complete | Close bd task, unblock dependents |
| `SUGGESTION: ...` | Proactive insight | Evaluate, track in bd if significant |

All spawned agents receive a **Team Context Block** with their name and communication instructions.

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

### With RAG (Qdrant + code-index-mcp)
```bash
# Search for code context
mcp__qdrant-mcp__qdrant-find(query: "...")
mcp__code-index-mcp__search_code_advanced(pattern: "...")
mcp__code-index-mcp__get_file_summary(file_path: "...")

# Index project (first time / refresh)
mcp__code-index-mcp__set_project_path(path: ".")
mcp__code-index-mcp__build_deep_index()

# Store knowledge
mcp__qdrant-mcp__qdrant-store(information: "...", metadata: {...})
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
- **qdrant-mcp**: RAG vector search for project context
- **code-index-mcp**: Deep code indexing and semantic search

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
