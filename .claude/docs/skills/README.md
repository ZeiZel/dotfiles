# Skills Catalog

Complete catalog of all Claude Code skills with usage examples.

## Overview

Skills are reusable instruction sets invoked via slash commands. They provide structured workflows for common tasks, from single-command utilities to full multi-agent pipelines.

## Skills by Category

### Development Workflow

| Skill | Command | Description |
|-------|---------|-------------|
| [Team Lead](#teamlead) | `/teamlead [task]` | Full multi-agent orchestration |
| [Implement](#implement) | `/implement [feature]` | Plan + code + tests |
| [Debug](#debug) | `/debug [issue]` | Reproduce + isolate + fix |
| [Refactor](#refactor) | `/refactor [target]` | Preserve behavior, improve code |
| [Test](#test) | `/test [file]` | Generate comprehensive tests |
| [Commit](#commit) | `/commit` | AI-assisted git commit |

### Quality & Review

| Skill | Command | Description |
|-------|---------|-------------|
| [PR Review](#pr-review) | `/pr-review` | Review changes for bugs and quality |
| [Security Audit](#security-audit) | `/security-audit` | OWASP Top 10, CVEs, secrets |
| [Audit](#audit) | `/audit` | Dependency vulnerabilities |
| [Simplify](#simplify) | `/simplify` | Review for reuse and efficiency |

### Research & Planning

| Skill | Command | Description |
|-------|---------|-------------|
| [Research](#research) | `/research [topic]` | Multi-source investigation |
| [Design](#design) | `/design [system]` | System design document |
| [Decide](#decide) | `/decide [question]` | Decision-making framework |
| [Docs](#docs) | `/docs [library]` | Library documentation |
| [Learn](#learn) | `/learn [topic]` | Learning roadmap |

### Project Lifecycle

| Skill | Command | Description |
|-------|---------|-------------|
| [Project Setup](#project-setup) | `/project-setup` | Initialize project for AI dev |
| [Onboard](#onboard) | `/onboard` | Explore codebase architecture |
| [Changelog](#changelog) | `/changelog` | Generate from git history |
| [README](#readme) | `/readme` | Create/update README |
| [Migrate](#migrate) | `/migrate [from] [to]` | Migration assistance |
| [Context Prime](#context-prime) | `/context-prime` | Load project context |

### Domain-Specific

| Skill | Command | Description |
|-------|---------|-------------|
| [Backend Dev](#backend-dev) | `/backend-dev` | API, databases, auth, microservices |
| [DevOps](#devops-skill) | `/devops` | Docker, K8s, CI/CD, Terraform |
| [AI Product Dev](#ai-product-dev) | `/ai-product-dev` | LLM, RAG, embeddings, agents |
| [Analytics](#analytics) | `/analytics` | SQL, A/B tests, metrics |
| [System Design](#system-design) | `/system-design` | Distributed systems, scalability |

### Agent System Management

| Skill | Command | Description |
|-------|---------|-------------|
| [Agent Creator](#agent-creator) | `/agent-creator` | Create new specialized agents |
| [Agent Workflow](#agent-workflow) | `/agent-workflow` | Automated multi-agent pipeline |
| [Directives](#directives) | `/directives` | Project config, quality gates |
| [Update AI](#update-ai) | `/update-ai` | Audit and optimize AI system |
| [Find Skills](#find-skills) | `/find-skills` | Discover installable skills |

### Internal (used by agents)

| Skill | Description |
|-------|-------------|
| [beads-tasks](#beads-tasks) | `bd` CLI task management |
| [gastown-orchestrate](#gastown-orchestrate) | `gt` CLI multi-agent orchestration |
| [rag-context](#rag-context) | Qdrant + code-index-mcp semantic search |
| [repomix-snapshot](#repomix-snapshot) | Codebase snapshots and extraction |
| [team-comms](#team-comms) | SendMessage protocol |
| [code-search](#code-search) | Multi-layer code search |

---

## Teamlead

Multi-agent orchestration for complex development workflows.

### Usage
```bash
/teamlead                           # Start for current task
/teamlead implement user auth       # Implement a feature
/teamlead fix login bug             # Fix a bug
/teamlead refactor auth module      # Refactor code
/teamlead --plan-only              # Planning phase only
/teamlead --parallel               # Maximize parallelism
```

### Pipeline
1. **Pre-flight** - Check tools (bd, gt, repomix), load context
2. **Planning** - spec-analyst -> spec-architect -> spec-planner
3. **Execution** - spec-developer + domain agents (parallel)
4. **Quality** - spec-reviewer + spec-tester (parallel) -> spec-validator
5. **Iteration** - Fix issues, re-validate (max 3 loops, 95%+ target)
6. **Documentation** - architecture-keeper updates living docs

### Integrated Tools
- **Beads**: Task tracking (`bd ready`, `bd list`, `bd close`)
- **Gastown**: Agent distribution (`gt sling`, `gt convoy`)
- **Repomix**: Context refresh
- **RAG**: qdrant-find + code-index-mcp

---

## Implement

Implement a feature with planning, tests, and clean code.

### Usage
```bash
/implement user authentication
/implement "add search functionality to products page"
/implement dark mode toggle
```

### What it does
- Analyzes requirements
- Plans implementation approach
- Writes code following project conventions
- Creates tests
- Self-reviews before completion

---

## Debug

Systematically debug an issue.

### Usage
```bash
/debug "login fails with 403 after token refresh"
/debug "memory leak in worker process"
/debug "flaky test in user.spec.ts"
```

### What it does
1. Reproduce the issue
2. Isolate the root cause
3. Fix the underlying problem
4. Verify the fix
5. Add regression test if applicable

---

## Refactor

Refactor code while preserving behavior.

### Usage
```bash
/refactor src/auth/service.ts
/refactor "extract common validation logic"
/refactor "simplify error handling in API layer"
```

### What it does
- Analyze current structure
- Identify improvements (extract, simplify, optimize)
- Refactor incrementally
- Verify behavior is preserved via tests

---

## Test

Generate comprehensive tests for a file or module.

### Usage
```bash
/test src/auth/service.ts
/test "user registration flow"
/test --e2e src/api/routes/
```

### What it does
- Analyze code for testable paths
- Generate unit tests
- Generate integration tests if applicable
- Cover edge cases and error paths
- Ensure proper mocking strategy

---

## PR Review

Review current PR or staged changes.

### Usage
```bash
/pr-review                    # Review staged changes
/pr-review --thorough         # Deep review
```

### What it does
- Check for bugs and logic errors
- Identify security vulnerabilities
- Review code style and conventions
- Suggest performance improvements
- Verify test coverage

---

## Security Audit

Audit codebase for security vulnerabilities.

### Usage
```bash
/security-audit
/security-audit src/api/
```

### What it does
- OWASP Top 10 vulnerability scan
- Dependency CVE check
- Secrets detection (.env, credentials)
- Configuration misalignment
- Produces actionable remediation plan

---

## Commit

AI-assisted git commit.

### Usage
```bash
/commit                       # Commit staged changes
```

### What it does
- Analyze staged/unstaged changes
- Draft concise commit message (why > what)
- Follow repository's commit style
- Stage relevant files
- Create commit

---

## Project Setup

Interactive wizard to prepare a project for AI development.

### Usage
```bash
/project-setup                # Full interactive setup
/project-setup --minimal      # Quick setup
```

### Creates
- `docs/project.yaml` - Project configuration
- `docs/architecture/` - Architecture documentation
- `docs/domains/` - Domain specifications
- `.mcp.json` - MCP server configuration

---

## Research

Deep investigation of a topic with source synthesis.

### Usage
```bash
/research GraphQL best practices
/research "React Server Components vs Client Components"
/research Kubernetes networking patterns
```

### Output
- Summary with key findings
- Source citations
- Actionable recommendations

---

## Decide

Structured decision-making framework.

### Usage
```bash
/decide "Should we use GraphQL or REST?"
/decide "Monolith vs microservices for MVP"
/decide "PostgreSQL vs MongoDB vs DynamoDB"
```

### Output
- Weighted criteria analysis
- Decision matrix with scores
- Recommendation with reasoning
- Suggested next steps

---

## Design

Create system design document.

### Usage
```bash
/design "real-time notification system"
/design "payment processing pipeline"
```

### Output
- Architecture diagrams
- Data models
- API specifications
- Trade-off analysis
- Scalability considerations

---

## Docs

Fetch and organize documentation for a library.

### Usage
```bash
/docs react-query
/docs "Next.js App Router"
/docs prisma
```

### What it does
- Fetch official documentation
- Extract key patterns and examples
- Organize by common use cases
- Save to local reference file

---

## Changelog

Generate changelog from git history.

### Usage
```bash
/changelog                    # Full changelog
/changelog --since=v1.0.0     # Since tag
/changelog --since="2024-01-01"
```

### Output (Keep a Changelog format)
```markdown
## [Unreleased]
### Added
- New feature X (#123)
### Changed
- Updated Y behavior (#124)
### Fixed
- Bug in Z component (#125)
```

---

## README

Create or update project README.

### Usage
```bash
/readme                       # Create/update
/readme --template=library    # npm/pip package
/readme --template=cli        # CLI tool
/readme --template=api        # REST/GraphQL API
```

---

## Audit

Audit dependencies for vulnerabilities and outdated packages.

### Usage
```bash
/audit                        # Full audit
/audit --security-only        # Only security issues
/audit --outdated-only        # Only outdated packages
```

---

## Migrate

Assistance with version or framework migrations.

### Usage
```bash
/migrate react@17 react@18
/migrate "Next.js Pages Router" "Next.js App Router"
/migrate express fastify
```

### Output
- Migration guide with steps
- Breaking changes checklist
- Code transformations
- Testing recommendations

---

## Learn

Generate a learning roadmap.

### Usage
```bash
/learn kubernetes
/learn "system design"
/learn rust --level=beginner
/learn "machine learning" --weeks=12
```

---

## Onboard

Deep exploration of codebase to understand architecture.

### Usage
```bash
/onboard                      # Full exploration
```

### What it does
- Explore project structure
- Identify patterns and conventions
- Map key architectural decisions
- Document findings

---

## Simplify

Review changed code for reuse, quality, and efficiency.

### Usage
```bash
/simplify                     # Review recent changes
```

---

## Backend Dev

Backend development assistance.

### Usage
```bash
/backend-dev                  # General backend help
```

Covers: API design, databases, auth, microservices, Node.js/Python/Go, REST/GraphQL.

---

## DevOps Skill

DevOps and infrastructure assistance.

### Usage
```bash
/devops                       # General devops help
```

Covers: Docker, Kubernetes, CI/CD, Terraform, monitoring, cloud architecture.

---

## AI Product Dev

AI/ML product development.

### Usage
```bash
/ai-product-dev               # AI development help
```

Covers: LLM integration, RAG, embeddings, prompt engineering, agent architecture.

---

## Analytics

Data analytics assistance.

### Usage
```bash
/analytics                    # Data analysis help
```

Covers: SQL, data pipelines, A/B testing, metrics design, dashboards.

---

## System Design

System design and architecture.

### Usage
```bash
/system-design                # System design help
```

Covers: Scalability, distributed systems, database selection, caching, messaging.

---

## Agent Creator

Create new specialized agents interactively.

### Usage
```bash
/agent-creator                # Interactive wizard
/agent-creator react-specialist
/agent-creator --category=devops
```

### Phases
1. Discovery - Collect specifications
2. Research - Domain best practices
3. Generation - Create agent file
4. Validation - Verify quality

---

## Agent Workflow

Automated multi-agent development from idea to production code.

### Usage
```bash
/agent-workflow               # Full pipeline
```

---

## Directives

Manage agent directives and project configuration.

### Usage
```bash
/directives                   # View/update config
```

Manages: `project.yaml`, MCP server configs, quality thresholds, team policies.

---

## Update AI

Audit and optimize the AI agent system.

### Usage
```bash
/update-ai                    # Full audit
```

### What it does
- Audit agent specs for improvements
- Research new approaches
- Benchmark agent performance
- Evolve multi-agent architecture

---

## Find Skills

Discover and install new agent skills.

### Usage
```bash
/find-skills "how do I do X"
/find-skills "code review"
```

---

## Context Prime

Load project context for the current session.

### Usage
```bash
/context-prime                # Read README + list files
```

---

## Internal Skills Reference

### beads-tasks
Task management via `bd` CLI. Used by team-lead and execution agents.
```bash
bd ready          # Available tasks
bd list           # All tasks
bd create         # New task
bd update --claim # Claim task
bd close          # Complete task
```

### gastown-orchestrate
Multi-agent orchestration via `gt` CLI. Used for projects with 50+ files.
```bash
gt sling          # Distribute tasks
gt convoy create  # Group related tasks
gt feed           # Monitor progress
```

### rag-context
Semantic search via Qdrant + code-index-mcp. Auto-selects strategy based on project size.

### repomix-snapshot
Codebase snapshots via Repomix. Create, check freshness, extract sections.

### team-comms
Bidirectional communication protocol:
- **PROGRESS** - Status updates during long tasks
- **QUESTION** - Ambiguity before starting
- **BLOCKER** - Cannot proceed
- **DONE** - Task complete (with role-specific fields)
- **SUGGESTION** - Proactive insight

### code-search
Multi-layer search: Glob (fast) -> Grep (content) -> code-index-mcp (semantic).

---

## Common Workflows

### Feature Development (full)
```bash
/project-setup                # First time only
/teamlead implement [feature] # Full pipeline with quality gates
/commit                       # When done
```

### Quick Fix
```bash
/debug [issue]                # Find and fix
/test [affected file]         # Verify
/commit
```

### Research -> Decision -> Implementation
```bash
/research "state management React 2024"
/decide "Redux Toolkit vs Zustand vs Jotai"
/implement "add Zustand state management"
```

### Code Quality
```bash
/pr-review                    # Review changes
/security-audit               # Security check
/simplify                     # Efficiency review
/test [changed files]         # Test coverage
```

### Release
```bash
/changelog --since=v1.2.0     # Generate changelog
/readme                       # Update README
/commit                       # Commit
```

### Learning Path
```bash
/learn kubernetes --weeks=8
/research "Kubernetes networking CNI"
/docs cilium
```
