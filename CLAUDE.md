# Dotfiles Project

Ansible-based macOS developer environment provisioning with multi-agent AI development system.

## Quick Reference

- **Constitution**: `docs/Constitution.md` — mandatory rules for ALL agents
- **Optimization Plan**: `docs/ai-optimization-plan.md` — current improvement roadmap
- **Agents**: `.claude/agents/` — agent specifications
- **Skills**: `.claude/skills/` — reusable skill definitions
- **AI Infrastructure**: `roles/ai/` — Ansible role for Qdrant, MCP servers

## Key Commands

```bash
# Task management
bd ready          # Available tasks
bd list           # All tasks
bd create         # New task
bd update --claim # Claim task

# Context
repomix --output docs/context/codebase-snapshot.txt  # Refresh snapshot

# RAG health
curl -s http://localhost:6333/healthz               # Qdrant status
docker start qdrant                                  # Start if stopped
```

## Context Strategy

- **auto** (default): Check snapshot size, use repomix if <=700k tokens, RAG if larger
- **repomix**: Read snapshot, extract relevant sections per agent
- **rag**: Query Qdrant + code-index-mcp for targeted context

## Workflow Templates

| Template | Phases | Quality | Use When |
|----------|--------|---------|----------|
| feature | full pipeline | 95% | New features |
| bugfix | dev -> review -> test | 90% | Bug fixes |
| hotfix | dev -> test | 85% | Critical fixes |
| refactor | arch -> dev -> review -> test | 95% | Refactoring |
| docs | writer -> arch-keeper | review | Documentation |
| prototype | arch -> dev | 75% | Exploration |

## Agent Model Routing

- **opus**: team-lead, spec-architect, spec-reviewer, security-architect
- **sonnet**: spec-developer, spec-tester, spec-planner, spec-analyst, spec-validator
- **haiku**: changelog-keeper, boilerplate-generator, regex-helper

## Compaction Rules

When context is compacted, ALWAYS preserve:
- List of modified files and their purpose
- Architectural decisions made during the session
- Test commands and their results
- Open blockers and unresolved questions
- Current task IDs (bd-XXX) and their status
- Workflow template being used (feature/bugfix/hotfix/etc)

## User Preferences

- Language: Russian for communication
- Approach: thorough analysis before implementation
- Shell: zsh with eza, bat, fd, rg, lazygit
