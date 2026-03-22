---
name: directives
description: Manage agent directives, project configuration, quality gates, and context strategies. Read/update project.yaml, MCP server configs, quality thresholds, and team policies.
allowed-tools: Read, Write, Edit, Bash, Glob
---

# Directives & Configuration Management

Skill for managing agent directives, project configuration, quality gates, and operational policies. Provides a unified interface to project settings that control how the multi-agent team operates.

## When to Use

- Setting up a new project for AI-assisted development
- Adjusting quality gate thresholds
- Changing context strategy (repomix/rag/auto)
- Configuring MCP server settings
- Defining team policies and coding standards
- Updating agent capabilities or tool access

## Project Configuration (docs/project.yaml)

### Structure

```yaml
project:
  name: "my-project"
  description: "Project description"
  tech_stack:
    language: typescript
    framework: nestjs
    database: postgresql
    orm: prisma
  architecture:
    style: clean-architecture
    patterns: [repository, service, controller]

context:
  strategy: auto          # auto | repomix | rag
  threshold: 700000       # tokens threshold for auto strategy
  snapshot_ttl: 3600      # seconds before snapshot is stale
  rag:
    collection: "codebase"
    embedding_model: "sentence-transformers/paraphrase-multilingual-MiniLM-L12-v2"  # multilingual default
    embedding_dim: 384

quality:
  min_score: 95           # minimum quality score to pass
  max_iterations: 3       # max iteration loops before escalation
  coverage_threshold: 80  # minimum test coverage %
  review_required: true   # code review mandatory
  security_scan: true     # security scan mandatory

team:
  parallel_agents: 3      # max concurrent agents
  communication: named    # named (SendMessage) | anonymous
  task_manager: beads     # beads | todowrite
  orchestrator: gastown   # gastown | direct | auto

coding_standards:
  style_guide: "project"  # project | airbnb | google | standard
  linting: eslint
  formatting: prettier
  commit_convention: conventional  # conventional | angular | custom
```

### Reading Configuration

```bash
# Read full config
cat docs/project.yaml

# Read specific values
yq '.context.strategy' docs/project.yaml
yq '.quality.min_score' docs/project.yaml
yq '.team.parallel_agents' docs/project.yaml
```

### Updating Configuration

```bash
# Update context strategy
yq -i '.context.strategy = "rag"' docs/project.yaml

# Update quality threshold
yq -i '.quality.min_score = 90' docs/project.yaml

# Update team settings
yq -i '.team.parallel_agents = 5' docs/project.yaml
```

## Quality Gates

### Gate Definitions

```yaml
quality_gates:
  planning:
    requirements_completeness: 95
    architecture_feasibility: true
    task_breakdown_granularity: true
    risk_mitigation_coverage: true

  execution:
    code_quality: 85
    test_coverage: 80
    performance_benchmarks: true
    security_checks: true

  review:
    overall_score: 95
    critical_issues: 0
    security_vulnerabilities: 0
    performance_regressions: 0

  validation:
    requirements_met: 100
    acceptance_criteria: 100
    integration_tests: true
    documentation_updated: true
```

### Gate Decision Matrix

| Score | Decision | Action |
|-------|----------|--------|
| >= 95% | PASS | Proceed to next phase |
| 80-94% | CONDITIONAL | Fix critical issues, re-validate |
| < 80% | FAIL | Full iteration required |

### Adjusting Gates

```bash
# Lower threshold for prototyping
yq -i '.quality.min_score = 80' docs/project.yaml

# Disable security scan for internal tools
yq -i '.quality.security_scan = false' docs/project.yaml

# Increase coverage for critical services
yq -i '.quality.coverage_threshold = 90' docs/project.yaml
```

## MCP Server Configuration (.mcp.json)

### Check MCP Setup

```bash
# Verify .mcp.json exists
if [ -f .mcp.json ]; then
  echo "MCP configured"
  cat .mcp.json | jq '.mcpServers | keys'
else
  echo "MCP not configured"
fi
```

### Expected MCP Servers

```json
{
  "mcpServers": {
    "qdrant-mcp": {
      "command": "npx",
      "args": ["-y", "@qdrant/mcp-server"],
      "env": { "QDRANT_URL": "http://localhost:6333" }
    },
    "code-index-mcp": {
      "command": "npx",
      "args": ["-y", "code-index-mcp"]
    },
    "sequential-thinking": {
      "command": "npx",
      "args": ["-y", "@anthropic/sequential-thinking-mcp"]
    }
  }
}
```

## Team Policies

### Agent Tool Access Matrix

| Agent | Beads | Gastown | RAG | Repomix | SendMessage |
|-------|-------|---------|-----|---------|-------------|
| team-lead | Full | Full | Full | Full | Full |
| spec-orchestrator | Full | Read | Read | Read | Full |
| spec-analyst | Read | - | - | Read | Full |
| spec-architect | Read | - | Read | Read | Full |
| spec-planner | Full | - | - | Read | Full |
| spec-developer | Claim/Close | - | Search | - | Full |
| spec-reviewer | Read | - | Search | - | Full |
| spec-tester | Read | - | Search | - | Full |
| spec-validator | Read | - | Read | Read | Full |

### Escalation Policy

```yaml
escalation:
  blocker_timeout: 300        # seconds before auto-escalate to user
  question_timeout: 600       # seconds before reminder
  max_silent_time: 1800       # seconds before team-lead checks in
  user_notification:
    - blockers                 # always notify on blockers
    - quality_gate_failure     # notify on gate failures
    - iteration_max_reached    # notify when max iterations hit
    - completion               # notify on workflow completion
```

## Directive Templates

### New Project Setup

```bash
# Create docs structure
mkdir -p docs/{architecture,domains,context,requirements}

# Create project.yaml with defaults
cat > docs/project.yaml << 'EOF'
project:
  name: "new-project"
  description: "TBD"
context:
  strategy: auto
  threshold: 700000
quality:
  min_score: 95
  max_iterations: 3
  coverage_threshold: 80
team:
  parallel_agents: 3
  task_manager: beads
EOF
```

### Switch to RAG Mode

```bash
# Enable RAG strategy
yq -i '.context.strategy = "rag"' docs/project.yaml

# Verify Qdrant
curl -s http://localhost:6333/healthz

# Build index
# mcp__code-index-mcp__set_project_path(path: ".")
# mcp__code-index-mcp__build_deep_index()
```

### Prototype Mode (Relaxed Quality)

```bash
yq -i '.quality.min_score = 75' docs/project.yaml
yq -i '.quality.coverage_threshold = 50' docs/project.yaml
yq -i '.quality.security_scan = false' docs/project.yaml
yq -i '.quality.review_required = false' docs/project.yaml
```

### Production Mode (Strict Quality)

```bash
yq -i '.quality.min_score = 95' docs/project.yaml
yq -i '.quality.coverage_threshold = 90' docs/project.yaml
yq -i '.quality.security_scan = true' docs/project.yaml
yq -i '.quality.review_required = true' docs/project.yaml
```
