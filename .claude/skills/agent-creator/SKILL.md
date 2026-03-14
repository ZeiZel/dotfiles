---
name: agent-creator
description: Interactive agent creation wizard - collects specifications, researches domain best practices, and generates properly structured agent files that integrate with spec-agents workflow
allowed-tools: Read, Write, Edit, Glob, Grep, WebSearch, WebFetch, Task, TodoWrite, AskUserQuestion
---

# Agent Creator Skill

Interactive wizard for creating well-structured Claude Code agents with domain expertise.

## Overview

This skill guides you through a 4-phase process to create production-ready agents:
1. **Discovery** - Gather agent specifications interactively
2. **Research** - Investigate domain best practices via web search
3. **Generation** - Create the agent file with synthesized knowledge
4. **Validation** - Verify quality and integration readiness

## Workflow

### Phase 1: Discovery

Use `AskUserQuestion` to collect the following specifications:

#### Required Information

```yaml
Agent Identity:
  name: # kebab-case, e.g., "react-frontend" or "kubernetes-ops"
  category: # devops | frontend | backend | spec-agents | analysis | ui-ux | utility
  experience_persona: # e.g., "10+ years at Google, led 3 products with 10M+ users"

Domain Expertise:
  primary_technologies: # Main tech stack (React, Go, Kubernetes, etc.)
  frameworks: # Specific frameworks (Next.js, Gin, Helm, etc.)
  specialization: # Narrow focus area

Capabilities:
  core_capabilities: # 3-5 main things this agent excels at
  complexity: # low | moderate | complex

Activation:
  keywords: # 5+ words that trigger this agent
  conditions: # Scenarios when this agent is ideal

Tools:
  required_tools: # Always include: Read, Write, Edit, Glob, Grep
  additional_tools: # Domain-specific: Bash, WebSearch, Task, etc.
```

#### Discovery Questions Template

Ask these in sequence using `AskUserQuestion`:

**Question 1: Agent Identity**
- "What is the agent name? (kebab-case, e.g., `react-frontend`)"
- Options: [Custom input]

**Question 2: Category**
- "Which category best fits this agent?"
- Options: devops, frontend, backend, spec-agents, analysis, ui-ux, utility, [Other]

**Question 3: Domain Expertise**
- "What technologies and frameworks should this agent specialize in?"
- "Provide a persona (e.g., '10+ years at Meta building React apps')"

**Question 4: Capabilities**
- "List 3-5 core capabilities for this agent"
- "What is the complexity level? (low/moderate/complex)"

**Question 5: Activation Triggers**
- "What keywords should auto-activate this agent?"
- "In what scenarios should this agent be recommended?"

---

### Phase 2: Research

Search for domain best practices using `WebSearch`:

#### Search Queries Template

```
"{primary_technology} best practices 2025"
"{primary_technology} {framework} architecture patterns"
"{primary_technology} code style guide conventions"
"{primary_technology} performance optimization techniques"
"{primary_technology} security checklist OWASP"
"{primary_technology} testing strategies unit integration e2e"
```

#### Extract and Synthesize

From search results, extract:

1. **Core Principles** (5-7 statements)
   - Architectural philosophy
   - Design patterns to follow
   - Quality standards

2. **Code Patterns** (2-3 examples)
   - Common implementation patterns
   - Idiomatic code samples
   - Anti-patterns to avoid

3. **Tooling Recommendations**
   - Linters, formatters
   - Testing frameworks
   - Build tools

4. **Checklists**
   - Security checklist
   - Performance checklist
   - Accessibility checklist (if frontend)

---

### Phase 3: Generation

Generate the agent file using this template:

#### File Location
```
.claude/agents/{category}/{agent-name}.md
```

#### Agent File Template

```markdown
---
name: {agent-name}
category: {category}
description: {80-120 char description synthesizing role and expertise}
capabilities:
  - {capability-1}
  - {capability-2}
  - {capability-3}
  - {capability-4}
  - {capability-5}
tools: {comma-separated tools}
complexity: {low|moderate|complex}
auto_activate:
  keywords: ["{keyword-1}", "{keyword-2}", "{keyword-3}", "{keyword-4}", "{keyword-5}"]
  conditions: ["{condition-1}", "{condition-2}", "{condition-3}"]
specialization: {one-word specialization}
---

# {Agent Title}

{Role statement with experience persona. 2-3 sentences describing who this agent is and their expertise.}

## Core Engineering Philosophy

{3-4 principles derived from research. Format as bullet points with bold headers.}

- **{Principle 1}**: {explanation}
- **{Principle 2}**: {explanation}
- **{Principle 3}**: {explanation}

## {Domain} Expertise

### Technology Stack
```yaml
Primary:
  - {tech-1}: {version/details}
  - {tech-2}: {version/details}
Frameworks:
  - {framework-1}
  - {framework-2}
Tools:
  - {tool-1}: {purpose}
  - {tool-2}: {purpose}
```

### Architecture Patterns
{YAML or bullet list of preferred patterns}

### Code Conventions
{Key conventions for this domain}

## Implementation Patterns

### Pattern 1: {Pattern Name}
```{language}
// Example code demonstrating the pattern
```

### Pattern 2: {Pattern Name}
```{language}
// Example code demonstrating the pattern
```

## Quality Standards

### {Domain} Checklist
```yaml
Pre-Implementation:
  - [ ] {check-1}
  - [ ] {check-2}

Implementation:
  - [ ] {check-3}
  - [ ] {check-4}

Post-Implementation:
  - [ ] {check-5}
  - [ ] {check-6}
```

### Performance Targets
{Specific metrics: latency, bundle size, etc.}

### Security Requirements
{Domain-specific security considerations}

## Working Methodology

### Phase 1: Analysis
- Understand requirements and constraints
- Review existing codebase patterns
- Identify integration points

### Phase 2: Design
- Propose architecture/approach
- Define data flow and interfaces
- Plan error handling strategy

### Phase 3: Implementation
- Write clean, tested code
- Follow established patterns
- Document decisions

### Phase 4: Validation
- Run quality checks
- Verify against requirements
- Prepare handoff documentation

## Communication Style

- {How agent communicates with user}
- {Level of detail in explanations}
- {When to ask for clarification}

## Output Standards

### Deliverables
- {deliverable-1}
- {deliverable-2}
- {deliverable-3}

### Quality Metrics
- Code quality score: >85%
- Test coverage: >80%
- Documentation completeness: 100%

## Integration Points

### Works With
- **spec-orchestrator**: Receives task assignments, reports completion
- **spec-reviewer**: Submits code for review
- **spec-validator**: Final validation before delivery
- **{related-agent}**: {collaboration description}

### Task Input Format
```markdown
## Task Assignment
**From**: spec-orchestrator
**Task ID**: {id}
**Type**: {implementation|review|testing}
**Priority**: {high|medium|low}

### Specifications
{task details}

### Acceptance Criteria
- [ ] {criterion-1}
- [ ] {criterion-2}
```

### Task Output Format
```markdown
## Task Completion Report
**Task ID**: {id}
**Agent**: {agent-name}
**Status**: completed|needs_review

### Artifacts Created
- `{file}`: {description}

### Quality Metrics
- Code quality: {score}%
- Test coverage: {coverage}%
- Issues found: {count}
```

## Key Success Metrics

- {KPI-1}
- {KPI-2}
- {KPI-3}

Remember: {One-liner summarizing the agent's core philosophy}
```

---

### Phase 4: Validation

Before saving the agent file, verify:

#### Required Frontmatter Checks
- [ ] `name` is kebab-case
- [ ] `category` matches existing categories or is new
- [ ] `description` is 80-120 characters
- [ ] `capabilities` has 3-5 items
- [ ] `tools` includes at minimum: Read, Write, Edit, Glob, Grep
- [ ] `complexity` is one of: low, moderate, complex
- [ ] `auto_activate.keywords` has 5+ items
- [ ] `auto_activate.conditions` has 2+ items

#### Content Quality Checks
- [ ] Experience persona is credible and specific
- [ ] Core principles are actionable (not generic)
- [ ] Code examples are syntactically correct
- [ ] Checklists have actionable items with checkboxes
- [ ] Integration Points reference real spec-agents
- [ ] Quality metrics are measurable
- [ ] Working methodology has all 4 phases

#### Integration Checks
- [ ] Task Input Format matches spec-orchestrator expectations
- [ ] Task Output Format includes required fields
- [ ] Quality gate thresholds are defined (95% compliance)

---

## Example: Creating a React Frontend Agent

**User request**: `/agent-creator react-frontend`

### Phase 1 Output (Discovery)
```yaml
name: react-frontend
category: frontend
experience_persona: "Senior frontend engineer with 10+ years at Meta, leading React applications serving 10M+ users"
primary_technologies: [React 19, TypeScript 5]
frameworks: [Next.js 15 App Router, TanStack Query, Zustand]
capabilities:
  - Server and Client Component architecture
  - Performance optimization (Core Web Vitals)
  - Accessible UI implementation (WCAG 2.1 AA)
  - State management patterns
  - Type-safe API integration
complexity: complex
keywords: [react, frontend, next.js, components, hooks, ui, accessibility, web vitals]
conditions: [React application development, Frontend feature implementation, UI/UX code implementation]
tools: Read, Write, Edit, Glob, Grep, Bash, WebSearch
```

### Phase 2 Output (Research Summary)
```yaml
Core Principles:
  - Component Composition over inheritance
  - Colocation (styles, tests, types near components)
  - Server-first rendering with selective hydration
  - Type safety at boundaries

Key Patterns:
  - CVA for variant-based styling
  - Custom hooks for reusable logic
  - Suspense boundaries for loading states
  - Error boundaries for resilience

Security:
  - XSS prevention via React escaping
  - CSRF tokens for forms
  - Content Security Policy headers

Performance:
  - Code splitting at route level
  - Image optimization with next/image
  - Font optimization with next/font
```

### Phase 3 Output (Generated File)
File: `.claude/agents/frontend/react-frontend.md`

(Full agent file following the template above)

---

## Usage

```
/agent-creator                    # Interactive mode - asks all questions
/agent-creator react-frontend     # Quick mode - pre-fills name, asks remaining
/agent-creator --category=devops  # Quick mode - pre-fills category
```

## Tips

1. **Be specific with technologies** - "React 19" is better than "React"
2. **Include version numbers** - Helps with best practice research
3. **Define narrow scope** - Specialized agents outperform generalists
4. **Add real code examples** - Demonstrate the patterns you want enforced
5. **Cross-reference existing agents** - Check `.claude/agents/` for inspiration
