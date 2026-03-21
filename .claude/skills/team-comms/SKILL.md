---
name: team-comms
description: Bidirectional communication protocol for multi-agent teams. QUESTION/BLOCKER/DONE/SUGGESTION messaging via SendMessage, Team Context Block injection, escalation rules.
allowed-tools: SendMessage, Read
---

# Team Communication Protocol

Skill defining the bidirectional communication protocol for multi-agent teams. All agents spawned by team-lead MUST follow this protocol.

## When to Use

- Every agent spawned as part of a team workflow
- When an agent needs to communicate with team-lead or other agents
- When encountering blockers, completing work, or having suggestions
- For team-lead: when spawning agents and handling incoming messages

## Message Types

### QUESTION — Need Clarification

Send BEFORE starting work if requirements have genuine ambiguity.

```
SendMessage(
  to: "team-lead",
  message: "QUESTION: The auth spec mentions 'social login' but no providers are listed. Which OAuth providers should I implement? (Google, GitHub, Apple?)"
)
```

**Rules:**
- Ask BEFORE working, not after guessing
- Be specific about what's unclear
- Suggest options if possible
- Do NOT ask about things you can resolve via code search

### BLOCKER — Cannot Proceed

Send IMMEDIATELY when you cannot continue work.

```
SendMessage(
  to: "team-lead",
  message: "BLOCKER: Database migration bd-100 is not complete but my task bd-101 depends on the users table schema. Cannot proceed with API implementation."
)
```

**Rules:**
- Send immediately, don't try workarounds silently
- Include the Beads task ID if applicable
- Explain what you tried and why it failed
- Suggest potential resolutions

### DONE — Task Complete

Send when all deliverables are finished.

```
SendMessage(
  to: "team-lead",
  message: "DONE: Implemented JWT auth endpoints (bd-101). Deliverables:\n- POST /api/auth/login\n- POST /api/auth/refresh\n- POST /api/auth/logout\n- 15 unit tests, all passing\n- 95% code coverage"
)
```

**Rules:**
- List all deliverables
- Include test results if applicable
- Reference the Beads task ID
- Note any follow-up items or tech debt

### SUGGESTION — Proactive Insight

Send when you notice something important during work.

```
SendMessage(
  to: "team-lead",
  message: "SUGGESTION: The current password hashing uses bcrypt with cost=10. For production, recommend upgrading to argon2id or increasing bcrypt cost to 12. This affects auth service performance but significantly improves security."
)
```

**Rules:**
- Categorize severity: critical / important / minor
- Explain the impact
- Suggest a concrete action
- Continue your current work (don't block on suggestions)

## Team Context Block

**MANDATORY**: Team-lead injects this block into EVERY agent spawn prompt:

```markdown
## Team Context

**Your assigned name**: {agent-type}-{descriptive-context}
**Team Lead**: team-lead (use SendMessage to reach it)

**Communication Protocol** (you have SendMessage in your tools):
- `QUESTION: ...` — before starting, if requirements have genuine ambiguity
- `BLOCKER: ...` — immediately if you cannot proceed
- `DONE: {summary}` — when your deliverables are complete
- `SUGGESTION: ...` — proactively flag tech issues, arch concerns, refactoring ideas

**Context Strategy**: {repomix|rag}
{If rag: "You have RAG tools available. Use them if pre-loaded context is insufficient."}
{If repomix: "All context is pre-loaded. Use Read/Glob/Grep for additional files."}

**Escalation rule**: Do NOT work silently on ambiguity. Ask first.
**Team culture**: Your domain expertise is valued. Speak up on tech stack,
architecture, security, refactoring. You are autonomous, not isolated.
```

## Team-Lead Response Protocol

### On Receiving QUESTION

1. Answer via SendMessage immediately
2. If question reveals a requirements gap -> spawn spec-analyst
3. Log the clarification in session context

```
SendMessage(
  to: "spec-developer-bd-101",
  message: "ANSWER: Implement Google and GitHub OAuth. Apple is deferred to Phase 2. Use passport.js for the integration."
)
```

### On Receiving BLOCKER

1. Assess: can you resolve without user input?
   - Yes: resolve (spawn helper agent, provide missing info)
   - No: escalate to user immediately
2. `bd update bd-XXX --status blocked --message "{reason}"`
3. SendMessage back with resolution or ETA

### On Receiving DONE

1. `bd close bd-XXX --message "{summary}"`
2. Check if downstream tasks are now unblocked (`bd ready`)
3. Spawn next phase agents if applicable

### On Receiving SUGGESTION

1. Evaluate significance (critical/important/minor)
2. If critical: pause current phase, address immediately
3. If important: `bd create --title "Review: {title}"` + notify user
4. SendMessage back: "Noted: {decision}"
5. NEVER ignore suggestions silently

## Named Agent Pattern

Every spawned agent MUST have a name for addressability:

```
Pattern: {agent-type}-{context}

Examples:
  spec-analyst-requirements
  spec-developer-bd-123
  spec-reviewer-auth-module
  spec-tester-integration
  architecture-keeper-phase2
```

## Inter-Agent Communication

Agents can also communicate with each other (not just team-lead):

```
# Developer asks reviewer a question
SendMessage(
  to: "spec-reviewer-auth-module",
  message: "QUESTION: Should I use class-validator or zod for input validation? The project has both installed."
)

# Tester informs developer of a finding
SendMessage(
  to: "spec-developer-bd-101",
  message: "SUGGESTION: Your createUser method doesn't handle duplicate email gracefully. Consider adding a unique constraint check before insert."
)
```

## Anti-Patterns

- Working silently on ambiguous requirements (ASK FIRST)
- Sending DONE without listing deliverables
- Ignoring SUGGESTION messages from other agents
- Spawning agents WITHOUT a name parameter
- Not including Team Context Block in spawn prompts
- Blocking on suggestions instead of continuing work
