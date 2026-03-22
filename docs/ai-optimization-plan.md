# AI System Optimization Plan

Date: 2026-03-21
Status: Active

## Executive Summary

Audit of the multi-agent AI system revealed 6 major optimization categories with 25+ actionable improvements. Key areas: context efficiency (-60% token waste), agent communication (persistent artifacts), performance (model selection + parallelism), knowledge persistence (cross-session learning), workflow adaptivity (task-type templates), and missing infrastructure (CLAUDE.md, project.yaml).

---

## 1. Context Efficiency Optimizations

### 1.1 Smart Context Injection (HIGH PRIORITY)

**Problem**: Team-lead reads full repomix snapshot and extracts sections via grep — this is imprecise, wasteful, and often sends irrelevant code to agents.

**Solution**: Task-type-aware context pipeline:

```
Task Classification -> File Pattern Selection -> Semantic Query -> Minimal Context Pack
```

**Implementation**:
- Classify task into type: backend, frontend, infra, docs, bugfix, refactor
- Use predefined file patterns per type:
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
  ```
- Query code-index-mcp with task-specific terms
- Target: <50k tokens per agent context pack (vs current unbounded)

**Impact**: -60% token waste, +30% context relevance

### 1.2 Hierarchical Context Layers

**Problem**: All agents get flat context at the same depth.

**Solution**: Three-layer context model:
- **Layer 1 (always)**: Project overview, architecture summary, coding standards (~5k tokens)
- **Layer 2 (task-specific)**: Relevant module code, related tests, API specs (~20-40k tokens)
- **Layer 3 (on-demand)**: Full file reads via RAG self-service (unlimited but lazy)

### 1.3 Context Caching in Qdrant

**Problem**: Context packs are rebuilt from scratch every time.

**Solution**: Store processed context packs with metadata:
```
mcp__qdrant-mcp__qdrant-store(
  information: "Context pack for auth module: {compressed summary}",
  metadata: {
    "type": "context-pack",
    "module": "auth",
    "files": ["src/auth/service.ts", "src/auth/controller.ts"],
    "created": "2026-03-21",
    "git_hash": "abc123"
  }
)
```
Invalidate when git hash changes for included files.

**Impact**: -50% context preparation time for repeat modules

### 1.4 Incremental Snapshot Updates

**Problem**: Repomix regenerates full snapshot even for small changes.

**Solution**:
- Track git diff since last snapshot
- Only re-index changed files in code-index-mcp
- Use `mcp__code-index-mcp__configure_file_watcher` for auto-refresh
- Store per-module snapshots instead of one monolithic file

---

## 2. Agent Communication Improvements

### 2.1 Artifact-Based Communication (HIGH PRIORITY)

**Problem**: Agent outputs are ephemeral — they die with the session. The next agent in pipeline gets a summary, not full output.

**Solution**: Shared artifact directory per workflow:

```
docs/artifacts/{workflow-id}/
  00-requirements.md        # spec-analyst output
  01-architecture.md        # spec-architect output
  02-task-plan.md           # spec-planner output
  03-implementation-log.md  # spec-developer notes
  04-review-report.md       # spec-reviewer output
  05-test-report.md         # spec-tester output
  06-validation-report.md   # spec-validator output
```

Team-lead passes artifact path to each agent. Each agent:
1. Reads previous artifacts for context
2. Writes own output to numbered file
3. Sends DONE with artifact path reference

**Impact**: Full context preservation, agents can reference exact sections

### 2.2 PROGRESS Message Type

**Problem**: Only DONE/BLOCKER signals — no intermediate visibility.

**Solution**: Add PROGRESS to the communication protocol:
```
SendMessage(to: "team-lead", message: "PROGRESS: 60% complete on bd-123.
  Completed: UserService, AuthController.
  Remaining: tests, error handling.
  ETA: ~5 minutes.")
```

Team-lead can track progress and detect stalls early.

### 2.3 Cross-Agent Context File

**Problem**: Agents working in parallel don't know about each other's changes.

**Solution**: Shared state file that team-lead maintains:
```yaml
# docs/artifacts/{workflow-id}/shared-state.yaml
agents:
  spec-developer-bd-101:
    status: in_progress
    files_changed: [src/auth/service.ts, src/auth/controller.ts]
    key_decisions: ["Using argon2id for password hashing", "JWT with RS256"]
  spec-developer-bd-102:
    status: done
    files_changed: [src/user/service.ts]
    key_decisions: ["Email validation with zod"]
```

Parallel agents read this before writing to avoid conflicts.

---

## 3. Agent Performance Optimizations

### 3.1 Model Selection Strategy (HIGH PRIORITY)

**Problem**: All agents use the same model (usually opus), even for simple tasks.

**Solution**: Route by task complexity:

```yaml
model_routing:
  opus:  # Complex reasoning, nuanced analysis
    - team-lead (orchestration decisions)
    - spec-architect (system design)
    - spec-reviewer (code quality analysis)
    - security-architect (threat analysis)
  sonnet:  # Implementation, structured tasks
    - spec-developer (code writing)
    - spec-tester (test generation)
    - spec-planner (task breakdown)
    - spec-analyst (requirements)
    - spec-validator (checklist validation)
    - architecture-keeper (doc updates)
  haiku:  # Mechanical, template-based tasks
    - changelog-keeper
    - boilerplate-generator
    - regex-helper
    - meeting-summarizer
```

**Implementation**: Add `model` frontmatter to each agent spec, team-lead passes `model:` param when spawning.

**Impact**: -40% cost, +20% speed for simple tasks

### 3.2 Parallel Quality Gates

**Problem**: Review -> Test -> Validate runs sequentially, adding ~3x time.

**Solution**: Run review and test in parallel, then validate:
```
Phase 1 (parallel):
  spec-reviewer -> review-report
  spec-tester -> test-report

Phase 2 (after both complete):
  spec-validator -> reads both reports -> final verdict
```

**Impact**: -40% quality gate time

### 3.3 Self-Review Checklist

**Problem**: Agents send DONE but output has issues that reviewer catches — wasting an iteration cycle.

**Solution**: Add mandatory self-check before DONE:

```markdown
## Pre-DONE Checklist (mandatory before sending DONE)
- [ ] Code compiles/passes linting
- [ ] All acceptance criteria from task addressed
- [ ] Tests cover happy path + 2 error cases minimum
- [ ] No hardcoded values, secrets, or debug code
- [ ] Imports are clean (no unused)
- [ ] Error handling is present
- [ ] Code follows project patterns (check via RAG)
```

**Impact**: +20% first-pass quality, -30% review iterations

### 3.4 Early Architecture Validation

**Problem**: Spec-architect produces design, developer builds it, reviewer finds architectural issues — expensive rework.

**Solution**: Add lightweight architecture check after architect, before developer:
- Spec-architect writes architecture doc
- Team-lead does quick validation: "Does this conflict with existing patterns?" (via RAG query)
- If conflict found: iterate architect before spawning developer

---

## 4. Knowledge Persistence (HIGH PRIORITY)

### 4.1 Session-Surviving Knowledge Base

**Problem**: Every session starts from scratch. Agent learnings, discovered patterns, resolved questions — all lost.

**Solution**: Structured Qdrant knowledge storage after each workflow:

```
Post-workflow knowledge capture:
1. spec-reviewer stores: quality patterns, common issues found
2. spec-developer stores: implementation patterns, library gotchas
3. team-lead stores: orchestration decisions, what worked/didn't
4. architecture-keeper stores: architecture updates, new decisions

Metadata schema:
{
  "type": "pattern|decision|gotcha|quality-rule",
  "domain": "auth|user|payment|...",
  "agent": "spec-developer",
  "project": "my-project",
  "confidence": 0.9,
  "created": "2026-03-21"
}
```

### 4.2 Pattern Library

**Problem**: Each project re-discovers the same patterns (error handling, auth, validation, etc.).

**Solution**: Pre-seed Qdrant with proven patterns:
- Error handling patterns per framework
- Auth implementation patterns
- Testing patterns (unit, integration, e2e)
- API design patterns
- Database access patterns

Agents query pattern library before implementing: "What's the established pattern for X?"

### 4.3 Post-Mortem Insights

**Problem**: When quality gates fail, the same mistakes repeat.

**Solution**: After each failed quality gate, store the insight:
```
mcp__qdrant-mcp__qdrant-store(
  information: "Quality gate failure: Missing input validation on PUT endpoints.
    Root cause: spec-developer focused on happy path.
    Fix: Add 'validate all inputs' to developer checklist.",
  metadata: {
    "type": "post-mortem",
    "severity": "medium",
    "recurring": true
  }
)
```

Team-lead queries post-mortems when creating similar tasks and includes warnings in agent prompts.

---

## 5. Workflow Adaptivity

### 5.1 Task-Type Workflow Templates (HIGH PRIORITY)

**Problem**: Every task runs the full pipeline: analyst -> architect -> planner -> dev -> review -> test -> validate. A simple bug fix doesn't need architecture design.

**Solution**: Define workflow templates by task type:

```yaml
workflows:
  feature:
    phases: [analyst, architect, planner, developer, reviewer, tester, validator]
    quality: strict (95%)

  bugfix:
    phases: [developer, reviewer, tester]
    quality: standard (90%)
    context: "Focus on root cause analysis. Read the bug report and related code."

  hotfix:
    phases: [developer, tester]
    quality: minimal (85%)
    context: "Critical fix. Minimal change, maximum safety."

  refactor:
    phases: [architect, developer, reviewer, tester]
    quality: strict (95%)
    context: "Preserve behavior. Focus on code quality metrics before/after."

  docs:
    phases: [technical-writer, architecture-keeper]
    quality: review-only

  prototype:
    phases: [architect, developer]
    quality: relaxed (75%)
    context: "Exploration mode. Prioritize speed over polish."

  security-fix:
    phases: [security-architect, developer, reviewer, tester, validator]
    quality: critical (98%)
```

Team-lead selects template based on task classification.

**Impact**: -60% overhead for simple tasks, appropriate rigor for complex ones

### 5.2 Adaptive Agent Count

**Problem**: `team.parallel_agents: 3` is static, but some tasks need 1 agent, others need 5.

**Solution**: Team-lead adjusts parallelism based on task graph:
- Count independent tasks from planner output
- Cap at system limit but don't artificially constrain
- Single-agent mode for tightly coupled tasks

---

## 6. Missing Infrastructure

### 6.1 Create CLAUDE.md (CRITICAL)

**Problem**: No CLAUDE.md exists at project root. This is the primary instruction file that Claude Code reads on every session.

**Solution**: Create CLAUDE.md with essential project-level instructions:
- Link to Constitution
- Default context strategy
- Common commands
- Project-specific rules
- Link to docs/ for detailed specs

### 6.2 Create project.yaml Template

**Problem**: `docs/project.yaml` is referenced everywhere but doesn't exist. The directives skill defines the schema but no instance is created.

**Solution**: Create a default project.yaml that other projects can copy/customize.

### 6.3 Environment Context File

**Problem**: Team-lead references `~/.claude/context/environment.md` but it may not exist or be stale.

**Solution**: Generate environment.md via Ansible role (roles/ai) and keep it updated.

### 6.4 Embedding Model Upgrade Path

**Problem**: Original model `all-MiniLM-L6-v2` (384 dims) is EN-only. Does not work for Russian content.

**DONE (2026-03-22)**: Switched default to `paraphrase-multilingual-MiniLM-L12-v2` (384 dims, 50+ languages).
- RU search: 0 -> 0.65-0.77 score
- Same 384 dims — no collection recreation needed
- Supported by both sentence-transformers and fastembed

**Future upgrade path** (if quality insufficient):
- Next: all-mpnet-base-v2 (768 dims) — balanced, EN-only
- Best: nomic-embed-text-v1.5 (768 dims) — SOTA for code
- Requires: recreate Qdrant collection with new dimension

---

## 7. Quick Wins (Implement First)

1. **Create CLAUDE.md** — immediate impact, 10 minutes
2. **Add model frontmatter to agents** — cost/speed savings, 30 minutes
3. **Add self-review checklist to spec-developer** — quality improvement, 15 minutes
4. **Create artifact directory pattern** — better agent communication, 20 minutes
5. **Add PROGRESS message to team-comms** — visibility, 10 minutes
6. **Create workflow templates in team-lead** — adaptive workflows, 45 minutes
7. **Create project.yaml template** — configuration foundation, 15 minutes

## 8. Medium-Term Improvements

1. Smart context injection pipeline
2. Context caching in Qdrant
3. Parallel quality gates
4. Knowledge persistence after workflows
5. Pattern library pre-seeding
6. Incremental snapshot updates

## 9. Long-Term Evolution

1. Embedding model upgrade (requires collection recreation)
2. Auto-prompt optimization (A/B test agent prompts)
3. Agent performance metrics and benchmarking
4. Custom MCP server for project-specific tools
5. CI/CD integration (AI review in PR pipeline)

---

## 10. Research Findings (2025-2026)

Full reports: `docs/reports/ai-dev-trends-2025-2026.md`, `docs/research/multi-agent-optimization-2025-2026.md`

### Key Insight

**Context is the bottleneck, not model capability.** At 70% context fill, precision drops. At 85%, hallucinations increase. At 90%+, responses become erratic. Context engineering > prompt engineering.

### High-Priority New Tools

| Tool | What | Impact | Install |
|------|------|--------|---------|
| **Context7 MCP** | Live library docs in context | Eliminates hallucinated APIs | `claude mcp add --transport http context7 https://mcp.context7.com/mcp` |
| **CodeGrok MCP** | AST-aware code search (Tree-sitter + CodeRankEmbed) | 10x token reduction vs naive file reading | GitHub: dondetir/CodeGrok_mcp |
| **Mem0** | Structured agent memory (episodic/semantic/procedural) | 26% accuracy boost over flat vector search | GitHub: mem0ai/mem0 |
| **Claude Code Plugins** | 9000+ plugins ecosystem | Reusable skills/hooks | Already enabled |

### Techniques to Adopt

1. **Hybrid Search in Qdrant**: Add BM25 sparse vectors alongside dense. 60/40 weighting. 20-40% better retrieval. Qdrant supports since v1.7.

2. **Structured DONE messages**: Change from free-text to JSON:
   ```json
   {"summary": "...", "files_changed": [], "decisions_made": [], "confidence": 0.9}
   ```

3. **Compaction instructions in CLAUDE.md**: Add "When compacting, preserve: modified files list, architectural decisions, test commands, open blockers."

4. **Prospective reflection for spec-planner**: Self-critique plans BEFORE sending to developer. 10-15% quality improvement for 15-20% extra tokens.

5. **Token budget per agent role**:
   - Orchestrator: 30-40% coordination, rest for summaries
   - Planning: 50% docs, 30% summaries, 20% buffer
   - Execution: 20% instructions, 60% code, 20% buffer
   - Review: 30% standards, 50% code, 20% buffer

6. **Agent Teams (experimental)**: Native parallel multi-agent with inter-agent messaging. Enable: `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1`. 3-4x token cost but faster for complex tasks.

### Architecture Validation

Our existing architecture already implements many best practices that Anthropic formalized:
- Constitution.md as "hot memory" rules
- Spec-agents for context isolation (one agent per phase)
- Qdrant for "cold storage" knowledge
- 700k token Repomix/RAG threshold
- Hierarchical orchestration (team-lead -> workers -> validators)

**Main gaps identified:**
- AST-aware code indexing (vs plain text chunking) -> CodeGrok MCP
- Structured agent memory (vs flat markdown) -> Mem0
- Automated prompt optimization (vs manual maintenance) -> AutoPDL
- Hybrid search (keyword + semantic) -> Qdrant BM25
