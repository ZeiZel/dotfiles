# Claude Code AI Development System

## Overview

Comprehensive AI-powered development system with 50+ specialized agents, 25+ reusable skills, and integrated tooling for full-cycle software development.

## Quick Start

```bash
# 1. Set up project for AI development
/project-setup

# 2. Start full development workflow
/teamlead implement [feature]

# 3. Or use individual skills
/implement [feature]         # Quick implementation
/test [file]                 # Generate tests
/debug [issue]               # Systematic debugging
/commit                      # AI-assisted commit
```

## Full Development Pipeline

### Phase 1: Project Preparation

```bash
/project-setup               # Interactive onboarding wizard
```

Creates: `docs/project.yaml`, `docs/architecture/`, `docs/domains/`, `.mcp.json`

### Phase 2: Planning & Design

```bash
/research [topic]             # Deep topic investigation
/decide [question]            # Structured decision-making
/design [system]              # System design document
/docs [library]               # Fetch library documentation
```

### Phase 3: Development

```bash
# Full orchestrated workflow (recommended for complex features)
/teamlead implement [feature]

# Lightweight workflows
/implement [feature]          # Plan + code + tests
/debug [issue]                # Reproduce + isolate + fix
/refactor [target]            # Preserve behavior, improve structure
```

### Phase 4: Quality Assurance

```bash
/test [file or module]        # Generate comprehensive tests
/pr-review                    # Review staged changes
/security-audit               # OWASP Top 10, CVEs, secrets
/audit                        # Dependency vulnerabilities
/simplify                     # Review for reuse and efficiency
```

### Phase 5: Release

```bash
/commit                       # AI-assisted commit message
/changelog                    # Generate from git history
/readme                       # Create/update README
```

### Phase 6: Maintenance

```bash
/migrate [from] [to]          # Version/framework migration
/update-ai                    # Audit and optimize AI system
/onboard                      # Explore codebase architecture
```

## Workflow Templates

| Template | Command | Phases | Quality Gate |
|----------|---------|--------|--------------|
| Feature | `/teamlead implement X` | full pipeline | 95% |
| Bugfix | `/teamlead fix X` | dev -> review -> test | 90% |
| Hotfix | `/teamlead hotfix X` | dev -> test | 85% |
| Refactor | `/teamlead refactor X` | arch -> dev -> review -> test | 95% |
| Docs | `/teamlead document X` | writer -> arch-keeper | review |
| Prototype | `/teamlead prototype X` | arch -> dev | 75% |

## Agent System

### Architecture

```
/teamlead (orchestrator)
    |
    +-- Planning Phase
    |   +-- spec-analyst       # Requirements & user stories
    |   +-- spec-architect     # System design & tech stack
    |   +-- spec-planner       # Task breakdown & ordering
    |
    +-- Execution Phase (parallel)
    |   +-- spec-developer     # Implementation
    |   +-- [domain agents]    # Specialized work
    |
    +-- Quality Phase (parallel)
    |   +-- spec-reviewer      # Code review
    |   +-- spec-tester        # Test creation & execution
    |   +-- spec-validator     # Final quality check
    |
    +-- Documentation Phase
        +-- architecture-keeper # Update living docs
```

### Agent Categories

| Category | Agents | Use Case |
|----------|--------|----------|
| [Spec Agents](agents/README.md#spec-agents) | 8 | Specification-driven development |
| [Frontend](agents/README.md#frontend) | 5 | React, Vue, Angular, architecture |
| [Backend](agents/README.md#backend) | 1 | Server-side, APIs, distributed systems |
| [DevOps](agents/README.md#devops) | 3 | CI/CD, infrastructure, incidents |
| [Data](agents/README.md#data) | 2 | Databases, data engineering |
| [Security](agents/README.md#security) | 2 | Security architecture, compliance |
| [Documentation](agents/README.md#documentation) | 5 | Technical writing, docs generation |
| [Research](agents/README.md#research) | 4 | Web research, trend analysis |
| [Dev Tools](agents/README.md#dev-tools) | 6 | Migrations, regex, SQL, git |
| [Everyday](agents/README.md#everyday) | 5 | Email, meetings, decisions |
| [Orchestration](agents/README.md#orchestration) | 2 | Team lead, agile master |
| [Domain](agents/README.md#domain-specialists) | 3+ | Payments, search, realtime |

See [Agent Catalog](agents/README.md) for full details.

### Model Routing

| Model | Agents | Use Case |
|-------|--------|----------|
| **opus** | team-lead, spec-architect, spec-reviewer, security-architect | Complex reasoning |
| **sonnet** | spec-developer, spec-tester, spec-planner, spec-analyst | Implementation |
| **haiku** | changelog-keeper, boilerplate-generator, regex-helper | Mechanical tasks |

## Skills Reference

### Development Skills

| Skill | Command | Description |
|-------|---------|-------------|
| Team Lead | `/teamlead [task]` | Full orchestrated multi-agent workflow |
| Implement | `/implement [feature]` | Plan + code + tests |
| Debug | `/debug [issue]` | Systematic debugging |
| Refactor | `/refactor [target]` | Preserve behavior, improve code |
| Test | `/test [file]` | Generate comprehensive tests |

### Quality Skills

| Skill | Command | Description |
|-------|---------|-------------|
| PR Review | `/pr-review` | Review changes for bugs and quality |
| Security Audit | `/security-audit` | OWASP, CVEs, secrets scan |
| Audit | `/audit` | Dependency vulnerabilities |
| Simplify | `/simplify` | Review for reuse and efficiency |

### Research & Planning

| Skill | Command | Description |
|-------|---------|-------------|
| Research | `/research [topic]` | Multi-source investigation |
| Design | `/design [system]` | System design document |
| Decide | `/decide [question]` | Decision-making framework |
| Docs | `/docs [library]` | Library documentation |
| Learn | `/learn [topic]` | Learning roadmap |

### Project Management

| Skill | Command | Description |
|-------|---------|-------------|
| Project Setup | `/project-setup` | Initialize project for AI dev |
| Commit | `/commit` | AI-assisted git commit |
| Changelog | `/changelog` | Generate from git history |
| README | `/readme` | Create/update README |
| Onboard | `/onboard` | Explore codebase architecture |

### Domain Skills

| Skill | Command | Description |
|-------|---------|-------------|
| Backend Dev | `/backend-dev` | API, databases, auth, microservices |
| DevOps | `/devops` | Docker, K8s, CI/CD, Terraform |
| AI Product | `/ai-product-dev` | LLM, RAG, embeddings, agents |
| Analytics | `/analytics` | SQL, A/B tests, metrics, dashboards |
| System Design | `/system-design` | Scalability, distributed systems |

### Agent & System Skills

| Skill | Command | Description |
|-------|---------|-------------|
| Agent Creator | `/agent-creator` | Create new specialized agents |
| Directives | `/directives` | Manage project config and policies |
| Update AI | `/update-ai` | Audit and optimize AI system |
| Find Skills | `/find-skills` | Discover installable skills |
| Agent Workflow | `/agent-workflow` | Automated multi-agent pipeline |

### Tooling Skills (used by agents internally)

| Skill | Description |
|-------|-------------|
| beads-tasks | `bd` CLI task management |
| gastown-orchestrate | `gt` CLI multi-agent orchestration |
| rag-context | Qdrant + code-index-mcp semantic search |
| repomix-snapshot | Codebase snapshots and extraction |
| team-comms | SendMessage protocol (QUESTION/BLOCKER/DONE) |
| code-search | Glob + Grep + code-index-mcp search ladder |

See [Skills Documentation](skills/README.md) for detailed usage.

## Integrated Tools

### Beads (`bd`) - Task Management
```bash
bd init                       # Initialize workspace
bd ready                      # Available tasks
bd list                       # All tasks
bd create                     # New task
bd update --claim             # Claim task
bd close                      # Complete task
```

### Gastown (`gt`) - Multi-Agent Orchestration
```bash
gt install .                  # Initialize
gt rig add main .             # Add rig
gt sling                      # Distribute tasks to agents
gt convoy create              # Group related tasks
gt feed                       # Monitor progress
```

### Repomix - Context Snapshots
```bash
repomix --output docs/context/codebase-snapshot.txt
```

### RAG (Qdrant + code-index-mcp)
```bash
# Semantic search
mcp__qdrant-mcp__qdrant-find(query: "how auth works")
mcp__code-index-mcp__search_code_advanced(pattern: "UserService")

# Code understanding
mcp__code-index-mcp__get_file_summary(file_path: "src/auth.ts")

# Knowledge storage
mcp__qdrant-mcp__qdrant-store(information: "...", metadata: {...})

# Index project
mcp__code-index-mcp__set_project_path(path: ".")
mcp__code-index-mcp__build_deep_index()
```

### Health Checks
```bash
curl -s http://localhost:6333/healthz   # Qdrant status
docker start qdrant                      # Start if stopped
```

## Context Strategy

| Strategy | Condition | How |
|----------|-----------|-----|
| **auto** | Default | Check snapshot size, auto-select |
| **repomix** | <=700k tokens | Read snapshot, extract relevant sections |
| **rag** | >700k tokens | Query Qdrant + code-index-mcp |

Configured in `docs/project.yaml` -> `context.strategy`.

## Architecture

```
.claude/
+-- agents/                   # 50+ specialized agents
|   +-- spec-agents/          # Specification workflow
|   +-- frontend/             # React, Vue, Angular
|   +-- backend/              # Server-side
|   +-- devops/               # CI/CD, infrastructure
|   +-- documentation/        # Technical writing
|   +-- research/             # Web research
|   +-- dev-tools/            # Development utilities
|   +-- everyday/             # Productivity helpers
|   +-- orchestration/        # Team coordination
|   +-- security/             # Security & compliance
|   +-- data/                 # Databases & pipelines
|   +-- domain/               # Payments, search, realtime
|   +-- quality/              # Performance engineering
|   +-- architecture/         # API design
|   +-- ai/                   # ML engineering
|   +-- mobile/               # React Native
|   +-- ui-ux/                # Design
|   +-- product/              # Product & growth
|   +-- utility/              # Code review, refactoring
|   +-- analysis/             # Data analysis
|   +-- team-lead.md          # Main orchestrator
+-- skills/                   # 25+ reusable skills
+-- docs/                     # This documentation
|   +-- agents/README.md      # Agent catalog
|   +-- skills/README.md      # Skills documentation
+-- settings.json             # Claude Code settings
```

## Key Documents

| Document | Location | Purpose |
|----------|----------|---------|
| Constitution | `docs/Constitution.md` | Mandatory rules for all agents |
| Optimization Plan | `docs/ai-optimization-plan.md` | Improvement roadmap |
| Project Config | `docs/project.yaml` | Project-level settings |
| CLAUDE.md | `CLAUDE.md` | Project instructions |

## Getting Started

1. **Install prerequisites:**
   ```bash
   brew install beads gastown
   npm install -g repomix
   ```

2. **Set up your project:**
   ```bash
   /project-setup
   ```

3. **Start developing:**
   ```bash
   /teamlead implement [your feature]
   ```

## Documentation

- [Agent Catalog](agents/README.md) - All agents with descriptions and tools
- [Skills Documentation](skills/README.md) - Skill usage and examples
- [Constitution](../../docs/Constitution.md) - Agent rules and boundaries
- [Agent Creator Guide](../skills/agent-creator/SKILL.md) - Create custom agents
