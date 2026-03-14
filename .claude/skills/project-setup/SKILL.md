---
name: project-setup
description: Interactive project onboarding wizard that prepares a project for AI-assisted development with spec-agents. Creates architecture documentation, domain specs, agent context files, and integrates tooling (Beads, Gastown, spec-kit, Repomix).
allowed-tools: Read, Write, Edit, Glob, Grep, Bash, WebSearch, AskUserQuestion, Task
---

# Project Setup Skill

Complete project onboarding for multi-agent AI development. This skill analyzes your project, asks clarifying questions, creates documentation, and configures all necessary tools for spec-agents workflow.

## Overview

```bash
/project-setup    # Full setup with spec-agents pipeline
```

Creates comprehensive project specification with all tooling integrated.

## Tooling Integration

### Core Tools

| Tool | Purpose | Install |
|------|---------|---------|
| **Beads** | Task management with DAG dependencies | `brew install beads` or `npm install -g beads-cli` |
| **Gastown** | Multi-agent orchestration for large projects | `brew install gastown` or `npm install -g gastown` |
| **spec-kit** | Spec-driven development framework | `npm install -g @github/specify` |
| **Repomix** | Codebase snapshot for agent context | `npm install -g repomix` |
| **Aider** | AI pair programming | `brew install aider` or `pip install aider-chat` |

### MCP Servers

| Server | Purpose |
|--------|---------|
| **context7** | Library documentation lookup |
| **sequential-thinking** | Complex reasoning support |
| **github** | Repository integration |
| **playwright** | E2E testing |

## Execution Phases

### Phase 0: Pre-flight Check

1. **Detect package manager**
   ```bash
   # Priority: bun > npm > yarn
   if command -v bun &>/dev/null; then
     PM="bun"
   elif command -v npm &>/dev/null; then
     PM="npm"
   else
     PM="yarn"
   fi
   ```

2. **Check installed tools**
   ```bash
   # Check each tool
   command -v bd &>/dev/null && echo "Beads: installed"
   command -v gt &>/dev/null && echo "Gastown: installed"
   command -v specify &>/dev/null && echo "spec-kit: installed"
   command -v repomix &>/dev/null && echo "Repomix: installed"
   command -v aider &>/dev/null && echo "Aider: installed"
   ```

3. **Offer installation of missing tools**
   - Present list of missing tools with installation commands
   - Ask user which tools to install
   - Run installation commands

### Phase 1: Discovery & Analysis

1. **Analyze project structure**
   - Use Glob to map file structure
   - Detect monorepo vs single repo
   - Count source files for project size assessment

2. **Detect tech stack**
   - Read `package.json`, `requirements.txt`, `Cargo.toml`, `go.mod`
   - Identify language, framework, runtime
   - Detect database, cache, messaging systems

3. **Find existing documentation**
   - Check for README.md, docs/, ARCHITECTURE.md
   - Look for OpenAPI/Swagger specs
   - Find existing ADRs

4. **Interactive questions via AskUserQuestion**

   **Project Type**
   ```yaml
   question: "What type of project is this?"
   options:
     - label: "Web Application"
       description: "Full-stack web app with frontend and backend"
     - label: "API/Backend"
       description: "REST/GraphQL API service"
     - label: "Mobile App"
       description: "React Native, Flutter, or native mobile"
     - label: "Library/SDK"
       description: "Reusable package for other projects"
   ```

   **Architecture Style**
   ```yaml
   question: "What is the architecture style?"
   options:
     - label: "Monolith (Recommended for new projects)"
       description: "Single deployable unit"
     - label: "Microservices"
       description: "Distributed services"
     - label: "Serverless"
       description: "Function-based (Lambda, Cloud Functions)"
     - label: "Monorepo"
       description: "Multiple packages in one repository"
   ```

   **Architecture Patterns**
   ```yaml
   question: "Which patterns does the project use?"
   multiSelect: true
   options:
     - label: "Feature-Sliced Design (FSD)"
       description: "Layers: app, pages, widgets, features, entities, shared"
     - label: "Clean Architecture"
       description: "Domain-centric with dependency inversion"
     - label: "Repository Pattern"
       description: "Data access abstraction"
     - label: "CQRS"
       description: "Command Query Responsibility Segregation"
   ```

   **Key Domains**
   ```yaml
   question: "What are the core business domains?"
   multiSelect: true
   options:
     - label: "User/Identity"
       description: "Authentication, profiles, permissions"
     - label: "Content/Media"
       description: "Articles, posts, files, images"
     - label: "Commerce"
       description: "Products, orders, payments"
     - label: "Communication"
       description: "Messaging, notifications, emails"
   ```

   **Code Style Preferences**
   ```yaml
   question: "How should AI agents write code?"
   options:
     - label: "Concise (Recommended)"
       description: "Self-documenting, minimal comments"
     - label: "Documented"
       description: "JSDoc/docstrings on public APIs"
     - label: "Verbose"
       description: "Detailed comments throughout"
   ```

### Phase 2: Beads Initialization

```bash
# Initialize Beads workspace
bd init

# Create setup epic
bd create --title "[Epic] Project Setup" \
  --description "Initial project configuration for AI-assisted development" \
  --priority 0
```

Creates `.beads/` workspace with task templates.

### Phase 3: Spec-Agents Pipeline

Sequential execution of spec-agents via Task tool:

#### 1. spec-analyst
```markdown
Use **spec-analyst** to create project requirements:

## Input
- Project context from discovery phase
- User answers from questions
- Existing documentation

## Output
- docs/requirements.md
- docs/user-stories.md
- docs/project-brief.md
```

#### 2. spec-architect
```markdown
Use **spec-architect** to design architecture:

## Input
- Requirements from spec-analyst
- Detected tech stack
- Architecture style preference

## Output
- docs/architecture/overview.md
- docs/api-spec.md (if API project)
- docs/tech-stack.md
```

#### 3. spec-planner
```markdown
Use **spec-planner** to create implementation plan:

## Input
- Architecture from spec-architect
- Requirements from spec-analyst

## Output
- docs/tasks.md
- docs/test-plan.md
- docs/implementation-plan.md
```

#### 4. Create Beads tasks from plan
```bash
# Parse tasks.md and create Beads tasks
bd create --bulk-from docs/tasks.md
```

### Phase 4: Spec-Kit Integration

```bash
# Initialize spec-kit
specify init $PROJECT_NAME --template $PROJECT_TYPE
```

Creates:
- `docs/Constitution.md` - Project principles
- Validation rules for specifications

### Phase 5: Gastown Setup (Large Projects)

Triggered when: monorepo detected OR >50 source files

```bash
# Initialize Gastown
gt install .
gt rig add main .
```

Creates `docs/gastown/config.yaml` for multi-agent orchestration.

### Phase 6: MCP & Tooling Configuration

#### Update .gitignore for Claude Code

Add Claude Code runtime directories to `.gitignore`:

```bash
# Check if .gitignore exists
if [ ! -f .gitignore ]; then
  touch .gitignore
fi

# Add Claude Code exclusions if not present
if ! grep -q ".claude/backups/" .gitignore 2>/dev/null; then
  cat >> .gitignore << 'EOF'

# Claude Code - runtime/cache/temp (not for sync)
.claude/backups/
.claude/cache/
.claude/chrome/
.claude/debug/
.claude/downloads/
.claude/file-history/
.claude/ide/
.claude/paste-cache/
.claude/plans/
.claude/projects/
.claude/session-env/
.claude/shell-snapshots/
.claude/statsig/
.claude/tasks/
.claude/telemetry/
.claude/todos/

# Claude Code - cache files
.claude/history.jsonl
.claude/stats-cache.json
.claude/mcp-needs-auth-cache.json
.claude/*-cache.json
.claude/settings.local.json
EOF
  echo "✓ Updated .gitignore with Claude Code exclusions"
fi
```

These directories contain:
- `backups/` - File backups before edits (safety mechanism)
- `file-history/` - Edit history for undo
- `debug/` - Debug logs and session info
- `cache/` - Various caches
- `projects/` - Project-specific session data
- Other runtime/temp directories

#### Generate `.mcp.json`:
```json
{
  "context7": {
    "type": "stdio",
    "command": "npx",
    "args": ["@context7/mcp-server"]
  },
  "sequential-thinking": {
    "type": "stdio",
    "command": "npx",
    "args": ["@anthropic/mcp-sequential-thinking"]
  },
  "github": {
    "type": "stdio",
    "command": "npx",
    "args": ["@modelcontextprotocol/server-github"]
  }
}
```

Generate `docs/quality-gates.yaml`:
```yaml
gates:
  planning:
    threshold: 95
    validators: [requirements_coverage, architecture_completeness]
  development:
    threshold: 85
    validators: [code_coverage, linting, security_scan]
  release:
    threshold: 95
    validators: [all_tests_pass, documentation_complete]
```

### Phase 7: Repomix Snapshot

```bash
# Create codebase snapshot for context
repomix --output docs/context/codebase-snapshot.txt
```

Creates compressed codebase representation for quick context loading.

## Generated File Structure

```
project/
├── .beads/                          # Beads workspace
├── .gastown/                        # Gastown (if enabled)
├── .mcp.json                        # MCP servers configuration
├── docs/
│   ├── architecture/
│   │   ├── overview.md              # System architecture
│   │   ├── components/              # Component documentation
│   │   ├── data-flow/               # Data flow diagrams
│   │   └── decisions/               # ADRs
│   ├── domains/
│   │   ├── index.md                 # Domain overview
│   │   └── [domain]/                # Per-domain docs
│   │       ├── model.md
│   │       ├── events.md
│   │       └── services.md
│   ├── context/
│   │   ├── frontend.md              # Frontend agent context
│   │   ├── backend.md               # Backend agent context
│   │   ├── recent-changes.md        # Change log
│   │   └── codebase-snapshot.txt    # Repomix output
│   ├── beads/
│   │   └── templates/               # Task templates
│   │       ├── epic-feature.yaml
│   │       ├── epic-bugfix.yaml
│   │       └── epic-refactor.yaml
│   ├── gastown/
│   │   └── config.yaml              # Gastown config (if enabled)
│   ├── project.yaml                 # Project configuration
│   ├── Constitution.md              # Project principles
│   ├── requirements.md              # From spec-analyst
│   ├── user-stories.md              # From spec-analyst
│   ├── project-brief.md             # From spec-analyst
│   ├── api-spec.md                  # From spec-architect
│   ├── tech-stack.md                # From spec-architect
│   ├── tasks.md                     # From spec-planner
│   ├── test-plan.md                 # From spec-planner
│   ├── implementation-plan.md       # From spec-planner
│   └── quality-gates.yaml           # Quality thresholds
└── .claude/
    └── settings.local.json          # Local Claude settings
```

## Generated Artifacts

### docs/project.yaml
```yaml
version: "2.0"
project:
  name: "{project_name}"
  description: "{description}"
  type: "{web-app|api|mobile|library|monorepo}"

tech_stack:
  language: "{TypeScript|Python|Go|Rust}"
  framework: "{Next.js|FastAPI|Gin|etc}"
  runtime: "{bun|node|deno}"
  database: "{PostgreSQL|MongoDB|etc}"

architecture:
  style: "{monolith|microservices|serverless}"
  patterns: ["{FSD|Clean|Repository|CQRS}"]

domains:
  - name: "{domain_name}"
    entities: ["{Entity1}", "{Entity2}"]
    bounded_context: "{context_name}"

tooling:
  package_manager: "{bun|npm|yarn}"
  beads:
    enabled: true
    workspace: ".beads"
  gastown:
    enabled: "{true|false}"
    rig: "main"
  spec_kit:
    enabled: true
  repomix:
    enabled: true

quality_gates:
  planning:
    threshold: 95
  development:
    threshold: 85
  validation:
    threshold: 95

agent_preferences:
  code_style: "{concise|documented|verbose}"
  review_strictness: "{strict|moderate|lenient}"
  auto_fix: true
```

### docs/Constitution.md
```markdown
# Project Constitution

## Core Principles
- All code must pass linting
- Test coverage minimum: {coverage_threshold}%
- TypeScript strict mode (if applicable)
- No hardcoded secrets

## Architecture Rules
- Follow {architecture_style} architecture
- Document API with OpenAPI
- Use dependency injection

## Code Standards
- Formatting: {formatter}
- Linting: {linter}
- Testing: {test_framework}

## Agent Guidelines

### For spec-developer
- Follow patterns in docs/architecture/
- Write tests alongside implementation
- Keep changes focused and minimal

### For spec-reviewer
- Focus on security and performance
- Check for N+1 queries
- Verify error handling

### For spec-tester
- Minimum {coverage_threshold}% coverage
- Include edge cases
- Test error scenarios
```

### docs/beads/templates/epic-feature.yaml
```yaml
template: epic-feature
title: "[Feature] {feature_name}"
priority: medium
description: |
  ## Overview
  {feature_description}

  ## Acceptance Criteria
  - [ ] {criterion_1}
  - [ ] {criterion_2}

  ## Technical Approach
  - {approach_1}
  - {approach_2}

  ## Dependencies
  - {dependency_if_any}

subtasks:
  - title: "Design {feature_name} architecture"
    agent: spec-architect
  - title: "Implement {feature_name}"
    agent: spec-developer
  - title: "Test {feature_name}"
    agent: spec-tester
  - title: "Review {feature_name}"
    agent: spec-reviewer
```

### docs/gastown/config.yaml
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

## Execution Flow

```
/project-setup
       │
       ▼
[Phase 0] Pre-flight Check
   • Detect package manager (bun > npm > yarn)
   • Check installed tools
   • Offer installation of missing tools
       │
       ▼
[Phase 1] Discovery & Analysis
   • Analyze project structure
   • Detect tech stack
   • Ask interactive questions
       │
       ▼
[Phase 2] Beads Initialization
   • bd init
   • Create setup epic
       │
       ▼
[Phase 3] Spec-Agents Pipeline
   • spec-analyst → requirements.md, user-stories.md
   • spec-architect → architecture/overview.md
   • spec-planner → tasks.md, implementation-plan.md
       │
       ▼
[Phase 4] Spec-Kit Integration
   • specify init
   • Generate Constitution.md
       │
       ▼
[Phase 5] Gastown Setup (if large project)
   • gt install .
   • gt rig add main .
       │
       ▼
[Phase 6] MCP & Tooling
   • Update .gitignore (Claude Code exclusions)
   • Generate .mcp.json
   • Generate quality-gates.yaml
       │
       ▼
[Phase 7] Repomix Snapshot
   • repomix --output docs/context/codebase-snapshot.txt
       │
       ▼
✓ Project ready for AI development
```

## Post-Setup Workflow

```bash
# View tasks
bd list

# Start development
/teamlead implement [feature]

# Monitor (if Gastown enabled)
gt feed

# Refresh context snapshot
repomix --output docs/context/codebase-snapshot.txt
```

## Verification Checklist

After setup completion, verify:

1. **Structure**: `docs/` contains all generated files
2. **Spec-agents output**: requirements.md, architecture.md, tasks.md exist
3. **Beads**: `bd list` shows tasks from tasks.md
4. **MCP**: `.mcp.json` contains configured servers
5. **Context**: `docs/context/codebase-snapshot.txt` created (if repomix available)
6. **Team Lead**: `/teamlead` can read all artifacts

## Execute

Running project setup wizard...

### Step 1: Pre-flight

Check for installed tools and package manager using Bash.

### Step 2: Discovery

Analyze project structure using Glob and Read tools:
- Package files (package.json, requirements.txt, etc.)
- Source code structure
- Existing documentation

### Step 3: Questions

Use AskUserQuestion to gather:
- Project type and architecture
- Key domains
- Code style preferences

### Step 4: Generate

1. Create documentation structure
2. Run spec-agents pipeline (Task tool with spec-analyst, spec-architect, spec-planner)
3. Initialize Beads and create tasks
4. Configure MCP servers
5. Create Repomix snapshot

### Step 5: Report

Present summary of created files and next steps.
