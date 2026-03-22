---
name: rag-context
description: RAG-based context retrieval via Qdrant vector search and code-index-mcp. Semantic search for code, architecture knowledge, and project context. Auto-selects strategy (repomix vs RAG) based on project size.
allowed-tools: Bash, Read, Write, mcp__qdrant-mcp__qdrant-find, mcp__qdrant-mcp__qdrant-store, mcp__code-index-mcp__search_code_advanced, mcp__code-index-mcp__get_file_summary, mcp__code-index-mcp__set_project_path, mcp__code-index-mcp__build_deep_index
---

# RAG Context Retrieval

Skill for semantic search and context retrieval via Qdrant vector database and code-index-mcp. Enables agents to find relevant code, architecture knowledge, and project context without loading entire codebase into prompt.

## When to Use

- Project is large (repomix snapshot >700k tokens)
- Need to search for specific code patterns or architecture decisions
- Need to store/retrieve architectural knowledge
- Building context packs for agent spawning
- Any agent needing deep codebase understanding beyond pre-loaded context

## Strategy Selection

| Strategy | Condition | Tools |
|----------|-----------|-------|
| **repomix** | Snapshot <=700k tokens OR Qdrant unavailable | Read, Glob, Grep only |
| **rag** | Snapshot >700k tokens AND Qdrant healthy | Qdrant + code-index-mcp |
| **auto** | Default — detect at runtime | Check snapshot size, decide |

### Auto-Detection

```bash
# Check repomix snapshot size
if [ -f docs/context/codebase-snapshot.txt ]; then
  SIZE=$(wc -c < docs/context/codebase-snapshot.txt)
  ESTIMATED_TOKENS=$((SIZE / 4))
  if [ "$ESTIMATED_TOKENS" -gt 700000 ]; then
    echo "RAG strategy (>700k tokens)"
  else
    echo "Repomix strategy (<=700k tokens)"
  fi
fi

# Verify Qdrant health
curl -s http://localhost:6333/healthz
```

## Qdrant Search (mcp__qdrant-mcp)

### Find Knowledge

Search for stored architectural knowledge, design decisions, domain models:

```
mcp__qdrant-mcp__qdrant-find(
  query: "how does user authentication work"
)
```

**Query patterns:**
- Architecture: `"authentication architecture and flow"`
- Domain: `"user entity relationships and invariants"`
- Decisions: `"why we chose PostgreSQL over MongoDB"`
- Integration: `"payment provider integration points"`

### Store Knowledge

Store architectural summaries, design decisions, domain knowledge:

```
mcp__qdrant-mcp__qdrant-store(
  information: "Architecture: User auth uses JWT with RS256. Tokens stored in Redis with 24h TTL. Refresh tokens in PostgreSQL with 30d expiry.",
  metadata: {
    "type": "architecture",
    "domain": "auth",
    "file": "docs/architecture/auth.md",
    "updated": "2026-03-21"
  }
)
```

**What to store:**
- Architecture summaries after design phases
- Domain model descriptions
- ADR (Architecture Decision Record) summaries
- Integration point documentation
- Quality gate results and lessons learned

## Code Index Search (mcp__code-index-mcp)

### Search Code Patterns

Find code by semantic meaning, not just text matching:

```
mcp__code-index-mcp__search_code_advanced(
  pattern: "UserService authentication"
)
```

**Search patterns:**
- Classes: `"UserService class definition"`
- Functions: `"password hashing function"`
- Patterns: `"error handling middleware"`
- Integrations: `"database connection setup"`

### Get File Summary

Understand a specific file without reading all of it:

```
mcp__code-index-mcp__get_file_summary(
  file_path: "src/services/auth.service.ts"
)
```

### Build Index (First-Time / Refresh)

```
# 1. Set project path
mcp__code-index-mcp__set_project_path(path: "/path/to/project")

# 2. Build deep index (takes time on large projects)
mcp__code-index-mcp__build_deep_index()
```

## Agent Integration Patterns

### For spec-developer: Find Related Code

```
# Before implementing, find existing patterns
mcp__code-index-mcp__search_code_advanced(pattern: "similar service implementation")

# Understand the file you'll modify
mcp__code-index-mcp__get_file_summary(file_path: "src/services/user.service.ts")

# Find architecture context
mcp__qdrant-mcp__qdrant-find(query: "user service architecture and patterns")
```

### For spec-reviewer: Check Architecture Compliance

```
# Find architectural guidelines
mcp__qdrant-mcp__qdrant-find(query: "coding standards and architecture rules")

# Search for similar patterns to compare
mcp__code-index-mcp__search_code_advanced(pattern: "error handling pattern")
```

### For spec-tester: Find Test Patterns

```
# Find existing test patterns
mcp__code-index-mcp__search_code_advanced(pattern: "integration test setup")

# Find what needs testing
mcp__code-index-mcp__get_file_summary(file_path: "src/services/auth.service.ts")
```

### For team-lead: Build Context Packs

```
# 1. Query for task-relevant architecture
mcp__qdrant-mcp__qdrant-find(query: "authentication module architecture")

# 2. Find relevant code files
mcp__code-index-mcp__search_code_advanced(pattern: "auth service")

# 3. Get summaries of key files
mcp__code-index-mcp__get_file_summary(file_path: "src/auth/service.ts")

# 4. Compose Context Pack from results
# 5. Inject into agent spawn prompt as "## Pre-loaded Context"
```

### After Documentation Phase: Update RAG Index

```
# Store updated architecture knowledge
mcp__qdrant-mcp__qdrant-store(
  information: "Updated auth architecture: added OAuth2 provider support...",
  metadata: { "type": "architecture", "domain": "auth" }
)

# Rebuild code index
mcp__code-index-mcp__build_deep_index()
```

## Smart Context Injection

When building context packs, use task-type-aware patterns to minimize token waste:

### Task-Type File Patterns

```yaml
context_patterns:
  backend:
    include: ["src/services/**", "src/models/**", "src/controllers/**", "src/middleware/**"]
    queries: ["service architecture", "API patterns", "database models"]
  frontend:
    include: ["src/components/**", "src/pages/**", "src/hooks/**", "src/store/**"]
    queries: ["component patterns", "state management", "routing"]
  infra:
    include: ["docker*", "*.yml", "terraform/**", "k8s/**", "ci/**"]
    queries: ["deployment", "infrastructure", "CI/CD"]
  testing:
    include: ["**/*.test.*", "**/*.spec.*", "test/**", "cypress/**"]
    queries: ["test patterns", "test utilities", "fixtures"]
  auth:
    include: ["src/**/auth*", "src/**/session*", "src/**/token*"]
    queries: ["authentication flow", "JWT", "session management"]
```

### Context Budget Per Agent Role

| Agent Role | Target Budget | Allocation |
|------------|--------------|------------|
| Orchestrator (team-lead) | 30-40k tokens | 40% coordination, 60% agent summaries |
| Planning (analyst, architect) | 40-50k tokens | 50% docs, 30% summaries, 20% buffer |
| Execution (developer, tester) | 50-60k tokens | 20% instructions, 60% relevant code, 20% buffer |
| Review (reviewer, validator) | 40-50k tokens | 30% standards, 50% code, 20% buffer |

### Three-Layer Context Model

```
Layer 1 (always, ~5k tokens):
  - Project overview from CLAUDE.md
  - Architecture summary
  - Coding standards

Layer 2 (task-specific, ~20-40k tokens):
  - Relevant module code (via task-type patterns)
  - Related tests
  - API specs for the domain

Layer 3 (on-demand, unlimited but lazy):
  - Full file reads via RAG self-service
  - Only when Layer 1+2 insufficient
```

## Hybrid Search

Qdrant collection supports BM25 sparse vectors alongside dense embeddings.

### When to Use Hybrid Search

- Searching for specific function/class names (BM25 excels at exact matches)
- Combined semantic + keyword queries
- Finding code with domain-specific terminology

### Query Strategy

1. **Keyword-heavy queries** (function names, class names): weight BM25 higher (70/30)
2. **Conceptual queries** ("how does auth work?"): weight dense higher (30/70)
3. **Balanced queries**: use 40/60 BM25/dense split (default)

## RAG Infrastructure

- **Qdrant**: Docker container, port 6333 (REST) / 6334 (gRPC)
- **Collection**: "codebase" (384-dim dense + BM25 sparse vectors)
- **Embedding model**: sentence-transformers/paraphrase-multilingual-MiniLM-L12-v2 (default, 50+ languages)
- **Alternative**: sentence-transformers/all-MiniLM-L6-v2 (EN-only, faster)
- **CRITICAL**: Indexing model MUST match qdrant-mcp EMBEDDING_MODEL env var. Check `docs/project.yaml` -> `context.rag.embedding_model`
- **Hybrid search**: BM25 + dense vector fusion (20-40% better retrieval)
- **Provisioned by**: `roles/ai/` Ansible role via `setup-ai.sh`

### Health Check

```bash
# Qdrant health
curl -s http://localhost:6333/healthz

# Collection info
curl -s http://localhost:6333/collections/codebase
```

### Start Qdrant (if stopped)

```bash
docker start qdrant
```

## Self-Service Instructions for Agents

Include this block when spawning agents with RAG access:

```markdown
## Context Source

**Strategy**: rag

Pre-loaded context above covers the primary scope. If you need MORE context:
1. `mcp__code-index-mcp__search_code_advanced` — search for code patterns
2. `mcp__code-index-mcp__get_file_summary` — understand a specific file
3. `mcp__qdrant-mcp__qdrant-find` — semantic search for architectural knowledge
Only query RAG if pre-loaded context is insufficient for your task.
```
