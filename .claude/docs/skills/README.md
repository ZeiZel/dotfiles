# Skills Catalog

Complete catalog of all Claude Code skills with usage examples.

## Overview

Skills are reusable instruction sets that can be invoked with slash commands. They provide structured workflows for common tasks.

## Available Skills

| Skill | Command | Description |
|-------|---------|-------------|
| [Team Lead](#teamlead) | `/teamlead` | Multi-agent orchestration workflow |
| [Project Setup](#project-setup) | `/project-setup` | Initialize project for AI development |
| [Agent Creator](#agent-creator) | `/agent-creator` | Create new specialized agents |
| [Research](#research) | `/research [topic]` | Deep topic investigation |
| [Docs](#docs) | `/docs [library]` | Fetch library documentation |
| [Changelog](#changelog) | `/changelog` | Generate changelog from git history |
| [README](#readme) | `/readme` | Create or update README |
| [Audit](#audit) | `/audit` | Dependency and security audit |
| [Migrate](#migrate) | `/migrate [from] [to]` | Migration assistance |
| [Learn](#learn) | `/learn [topic]` | Learning roadmap generation |
| [Decide](#decide) | `/decide [question]` | Decision-making framework |

---

## Teamlead

Multi-agent orchestration for complex development workflows.

### Usage
```bash
/teamlead                           # Start for current task
/teamlead implement user auth       # Implement a feature
/teamlead --plan-only              # Planning phase only
```

### What it does
- Runs pre-flight checks (tools, project setup)
- Spawns specialized agents in parallel
- Tracks progress via Beads
- Drives quality to 95%+ through iteration
- Updates architecture documentation

### Integrated Tools
- **Beads**: Task management (`bd ready`, `bd list`, `bd close`)
- **Gastown**: Multi-agent distribution (`gt sling`, `gt convoy`)
- **Repomix**: Context refresh (`repomix --output`)

---

## Project Setup

Interactive wizard to prepare a project for AI-assisted development.

### Usage
```bash
/project-setup                      # Full interactive setup
/project-setup --minimal            # Quick setup
```

### What it creates
- `docs/project.yaml` - Project configuration
- `docs/architecture/` - Architecture documentation
- `docs/domains/` - Domain specifications
- `.mcp.json` - MCP server configuration
- Integration with Beads, Gastown, Repomix

---

## Agent Creator

Interactive wizard to create new specialized agents.

### Usage
```bash
/agent-creator                      # Full interactive mode
/agent-creator react-specialist     # Quick mode with name
/agent-creator --category=devops    # Pre-fill category
```

### Workflow Phases
1. **Discovery** - Collect specifications interactively
2. **Research** - Investigate domain best practices
3. **Generation** - Create agent file with synthesized knowledge
4. **Validation** - Verify quality and integration

---

## Research

Deep investigation of a topic with source synthesis.

### Usage
```bash
/research GraphQL best practices
/research "React Server Components vs Client Components"
/research Kubernetes networking patterns
```

### What it does
- Searches multiple authoritative sources
- Synthesizes findings into a coherent summary
- Provides source citations
- Generates actionable recommendations

### Output
- Summary document with key findings
- Source list with relevance notes
- Recommendations for next steps

---

## Docs

Fetch and organize documentation for a library or framework.

### Usage
```bash
/docs react-query
/docs "Next.js App Router"
/docs prisma
```

### What it does
- Fetches official documentation
- Extracts key patterns and examples
- Organizes by common use cases
- Saves to local reference file

---

## Changelog

Generate changelog from git history.

### Usage
```bash
/changelog                          # Full changelog
/changelog --since=v1.0.0           # Since tag
/changelog --since="2024-01-01"     # Since date
```

### What it does
- Analyzes git commits since last release/tag
- Categorizes changes (features, fixes, breaking)
- Generates formatted CHANGELOG.md
- Follows Keep a Changelog format

### Output Format
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
/readme                             # Create/update README
/readme --template=library          # Use library template
/readme --template=cli              # Use CLI tool template
```

### What it does
- Analyzes project structure
- Extracts key information from code
- Generates comprehensive README
- Includes installation, usage, API reference

### Templates
- **default**: General project
- **library**: npm/pip package
- **cli**: Command-line tool
- **api**: REST/GraphQL API

---

## Audit

Audit dependencies for updates and security vulnerabilities.

### Usage
```bash
/audit                              # Full audit
/audit --security-only              # Only security issues
/audit --outdated-only              # Only outdated packages
```

### What it does
- Checks for outdated dependencies
- Identifies security vulnerabilities (CVEs)
- Analyzes dependency tree for conflicts
- Provides upgrade recommendations

### Output
```markdown
## Security Issues (2 critical)
- lodash@4.17.15: CVE-2021-23337 (upgrade to 4.17.21)

## Outdated Dependencies
- react: 17.0.2 → 18.2.0 (major)
- typescript: 4.9.5 → 5.3.3 (major)

## Recommendations
1. Immediate: Upgrade lodash to fix critical CVE
2. Plan: React 18 migration (breaking changes)
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

### What it does
- Researches migration path
- Identifies breaking changes
- Creates step-by-step migration plan
- Generates code transformations where possible

### Output
- Migration guide document
- Breaking changes checklist
- Code modification suggestions
- Testing recommendations

---

## Learn

Generate a learning roadmap for a technology or topic.

### Usage
```bash
/learn kubernetes
/learn "system design"
/learn rust --level=beginner
/learn "machine learning" --weeks=12
```

### What it does
- Assesses current knowledge (optional)
- Creates structured learning path
- Recommends resources (docs, courses, projects)
- Defines milestones and checkpoints

### Output
```markdown
## Learning Roadmap: Kubernetes

### Week 1-2: Foundations
- [ ] Understand containers and Docker
- [ ] Core concepts: Pods, Services, Deployments
- Resources: [Official docs], [Kubernetes Up & Running]

### Week 3-4: Practical Application
- [ ] Deploy a multi-container app
- [ ] Configure networking and storage
- Project: Deploy a microservices app

### Week 5-6: Advanced Topics
- [ ] Helm charts
- [ ] GitOps with ArgoCD
- [ ] Monitoring with Prometheus
```

---

## Decide

Framework for making decisions with structured analysis.

### Usage
```bash
/decide "Should we use GraphQL or REST?"
/decide "Monolith vs microservices for MVP"
/decide "Which database: PostgreSQL, MongoDB, or DynamoDB?"
```

### What it does
- Clarifies decision criteria
- Generates pros/cons analysis
- Creates weighted decision matrix
- Provides recommendation with reasoning

### Output
```markdown
## Decision: GraphQL vs REST for Mobile API

### Criteria (weighted)
1. Development speed (30%)
2. Mobile performance (25%)
3. Team expertise (20%)
4. Long-term flexibility (15%)
5. Tooling ecosystem (10%)

### Analysis

| Criterion | GraphQL | REST |
|-----------|---------|------|
| Dev speed | 8 | 6 |
| Performance | 9 | 7 |
| Team expertise | 5 | 9 |
| Flexibility | 9 | 6 |
| Tooling | 8 | 9 |
| **Weighted** | **7.6** | **7.1** |

### Recommendation
GraphQL edges out REST primarily due to better mobile performance
and flexibility for evolving requirements. However, consider REST
if team expertise is a critical constraint.

### Next Steps
1. Prototype both approaches (2 days each)
2. Benchmark mobile performance
3. Final decision based on prototype results
```

---

## Usage Examples

### Research + Decision Making
```bash
# Research options
/research "state management React 2024"

# Make informed decision
/decide "Redux Toolkit vs Zustand vs Jotai"
```

### Project Bootstrap
```bash
# Set up project
/project-setup

# Generate README
/readme

# Audit dependencies
/audit
```

### Release Workflow
```bash
# Generate changelog
/changelog --since=v1.2.0

# Update README if needed
/readme

# Commit
/commit
```

### Learning Path
```bash
# Plan learning
/learn kubernetes --weeks=8

# Research specific topics as you go
/research "Kubernetes networking CNI plugins"
/docs cilium
```
