---
name: project-setup
description: Interactive project onboarding wizard that prepares a project for AI-assisted development with spec-agents. Creates architecture documentation, domain specs, and agent context files.
allowed-tools: Read, Write, Edit, Glob, Grep, Bash, WebSearch, AskUserQuestion, Task
---

# Project Setup Skill

Interactive wizard for preparing a project to work with the spec-agents ecosystem. This skill analyzes your project, asks clarifying questions, and creates the documentation and configuration needed for optimal agent coordination.

## Overview

This skill guides you through a comprehensive onboarding process:

1. **Discovery** - Analyze existing codebase structure
2. **Questions** - Gather project-specific information
3. **Architecture** - Generate architecture documentation
4. **Domains** - Document business domains and models
5. **Context** - Create agent-specific context files
6. **Configuration** - Set up Beads and agent coordination

## Usage

```
/project-setup                    # Full interactive onboarding
/project-setup --quick            # Minimal setup, infer most settings
/project-setup --update           # Update existing documentation
/project-setup --domain user      # Focus on specific domain
```

## Onboarding Phases

### Phase 1: Project Analysis

Automatically analyze:
- Project structure and file organization
- Package.json/requirements.txt for tech stack
- Existing documentation
- Source code patterns
- Test structure
- CI/CD configuration

### Phase 2: Interactive Questions

Ask about:

#### Basic Information
- Project name and description
- Primary language and framework
- Target users/audience
- Development team size

#### Architecture
- Architecture style (monolith, microservices, serverless)
- Key components and their responsibilities
- External integrations
- Data storage solutions

#### Domains
- Core business domains
- Key entities and their relationships
- Business rules and invariants
- Domain events

#### Development Practices
- Coding conventions
- Testing strategy
- Branching strategy
- Deployment process

#### Agent Preferences
- Preferred code style
- Documentation format
- Review strictness level
- Auto-fix preferences

### Phase 3: Documentation Generation

Create documentation structure:

```
docs/
├── architecture/
│   ├── overview.md              # System architecture
│   ├── components/              # Component docs
│   ├── integrations/            # External services
│   ├── data-flow/               # Data flow diagrams
│   └── decisions/               # ADRs
├── domains/
│   ├── index.md                 # Domain overview
│   ├── [domain]/                # Per-domain docs
│   │   ├── model.md
│   │   ├── events.md
│   │   └── services.md
│   └── glossary.md              # Ubiquitous language
├── context/
│   ├── frontend.md              # Frontend agent context
│   ├── backend.md               # Backend agent context
│   ├── devops.md                # DevOps agent context
│   └── recent-changes.md        # Change log
└── project.yaml                 # Project configuration
```

### Phase 4: Configuration

Generate:

#### Project Configuration (docs/project.yaml)
```yaml
project:
  name: "my-project"
  description: "Brief description"
  version: "1.0.0"

tech_stack:
  language: TypeScript
  framework: Next.js
  database: PostgreSQL
  cache: Redis

architecture:
  style: monolith
  patterns:
    - Feature-Sliced Design
    - Repository pattern
    - CQRS (read/write separation)

domains:
  - name: user
    description: User management and authentication
    entities: [User, UserProfile, UserPreferences]
  - name: order
    description: Order processing
    entities: [Order, OrderItem, OrderStatus]

coding_standards:
  formatting: prettier
  linting: eslint
  testing: vitest
  coverage_threshold: 80

agent_preferences:
  code_style: concise
  documentation: minimal_inline
  review_strictness: moderate
  auto_fix: true
```

#### Beads Configuration
```bash
# Initialize Beads if not present
bd init

# Create initial project tasks
bd create --title "[Setup] Initialize documentation structure" \
  --description "Created by project-setup skill"
```

## Question Templates

### Architecture Questions
```yaml
questions:
  - header: "Architecture"
    question: "What is the primary architecture style?"
    options:
      - label: "Monolith"
        description: "Single deployable unit"
      - label: "Microservices"
        description: "Distributed services"
      - label: "Serverless"
        description: "Function-based (Lambda, Cloud Functions)"
      - label: "Hybrid"
        description: "Mix of styles"

  - header: "Components"
    question: "What are the main components of your system?"
    multiSelect: true
    options:
      - label: "Web Frontend"
        description: "Browser-based UI"
      - label: "Mobile App"
        description: "Native or hybrid mobile"
      - label: "REST API"
        description: "HTTP-based API"
      - label: "GraphQL API"
        description: "GraphQL endpoint"
```

### Domain Questions
```yaml
questions:
  - header: "Domains"
    question: "What are the core business domains?"
    multiSelect: true
    options:
      - label: "User Management"
        description: "Authentication, profiles, permissions"
      - label: "Content"
        description: "Articles, posts, media"
      - label: "E-commerce"
        description: "Products, orders, payments"
      - label: "Communication"
        description: "Messaging, notifications"
```

### Preferences Questions
```yaml
questions:
  - header: "Code Style"
    question: "How should agents write code?"
    options:
      - label: "Concise (Recommended)"
        description: "Minimal comments, self-documenting"
      - label: "Documented"
        description: "JSDoc/docstrings on functions"
      - label: "Verbose"
        description: "Detailed comments throughout"

  - header: "Review"
    question: "How strict should code reviews be?"
    options:
      - label: "Strict"
        description: "Enforce all best practices"
      - label: "Moderate (Recommended)"
        description: "Focus on bugs and security"
      - label: "Lenient"
        description: "Accept working code"
```

## Generated Artifacts

### Architecture Overview Template
```markdown
# [Project Name] Architecture

## System Overview
[Generated description based on analysis]

## Tech Stack
| Layer | Technology | Purpose |
|-------|------------|---------|
| Frontend | [detected] | UI/UX |
| Backend | [detected] | API/Logic |
| Database | [detected] | Persistence |

## Component Diagram
[Generated ASCII diagram]

## Key Patterns
- [Detected patterns from code analysis]

## External Integrations
[List from dependency analysis]
```

### Domain Model Template
```markdown
# Domain: [Name]

## Overview
[Description from questions]

## Entities
[Generated from code analysis]

## Events
[Identified from code patterns]

## Services
[Detected from file structure]
```

### Agent Context Template
```markdown
# Context: [Agent Type]

## Project Overview
[Brief from project.yaml]

## Relevant Architecture
[Filtered for agent type]

## Patterns in Use
[Relevant patterns]

## Files to Know
[Key files for this agent type]

## Conventions
[Code style preferences]
```

## Execution Flow

```
/project-setup

1. Read existing files:
   - package.json / requirements.txt / Cargo.toml
   - README.md
   - Existing docs/
   - src/ structure

2. Analyze codebase:
   - Detect tech stack
   - Identify patterns
   - Map file structure
   - Find domains/entities

3. Ask questions:
   - Confirm detected information
   - Gather missing context
   - Understand preferences
   - Define domains

4. Generate documentation:
   - Create docs/ structure
   - Write architecture docs
   - Document domains
   - Create agent contexts
   - Generate project.yaml

5. Configure tooling:
   - Initialize Beads if needed
   - Update .claude/ settings
   - Create initial tasks

6. Report:
   - Summary of created files
   - Next steps
   - Suggested /teamlead invocation
```

## Post-Setup

After running project-setup:

1. **Review generated docs** in `docs/`
2. **Verify project.yaml** settings
3. **Customize context files** as needed
4. **Run /teamlead** for first feature

## Integration

### With architecture-keeper
After setup, architecture-keeper will maintain documentation.

### With team-lead
Team-lead uses project.yaml and context files for agent orchestration.

### With spec-agents
All spec-agents read from docs/ for context.

## Execute

Running project setup wizard for current directory...

First, analyze the project structure using Glob and Read tools to understand:
- File structure and organization
- Package dependencies and tech stack
- Existing documentation
- Source code patterns

Then, use AskUserQuestion to gather:
- Project description and purpose
- Architecture decisions
- Domain models
- Agent preferences

Finally, create:
- Documentation structure in docs/
- Project configuration in docs/project.yaml
- Agent context files in docs/context/
- Initial Beads tasks for documentation review
