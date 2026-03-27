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

### PROGRESS — Intermediate Status Update

Send periodically during long tasks to provide visibility.

```
SendMessage(
  to: "team-lead",
  message: "PROGRESS: 60% complete on bd-123. Completed: UserService, AuthController. Remaining: tests, error handling."
)
```

**Rules:**
- Send every ~25% completion or when a significant milestone is reached
- Include what's done and what remains
- Do NOT send for tasks that take <5 minutes
- Reference the Beads task ID

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

### Enhanced BLOCKER Format (v2)

When sending a BLOCKER, include a structured `resolution_hint` to enable automatic resolution by team-lead:

```
SendMessage(
  to: "team-lead",
  message: "BLOCKER: {reason}. Tried: {attempts}. Need: {ask}.
    resolution_hint: {HINT_CODE}
    blocked_task: {bd-XXX}
    blocking_dependency: {bd-YYY | agent-name | external}
    context: {details needed by resolver agent}"
)
```

**Resolution Hint Codes:**

| Hint Code | Meaning | Auto-Resolution Agent |
|-----------|---------|----------------------|
| NEEDS_REANALYSIS | Requirements incomplete/ambiguous | spec-analyst |
| NEEDS_REARCH | Architecture decision missing/flawed | spec-architect or domain architect |
| NEEDS_PREREQ | Prerequisite task not complete | Owner of prerequisite task |
| NEEDS_SCHEMA | Database schema not ready | database-architect |
| NEEDS_API_CONTRACT | API contract not defined | api-designer |
| NEEDS_DESIGN | Design specs/mockups missing | open-pencil-designer |
| NEEDS_SECURITY_REVIEW | Security decision required | security-architect |
| NEEDS_INFRA | Infrastructure not provisioned | senior-devops-architect |
| NEEDS_CLARIFICATION | Only user can resolve | Escalate to user (NEVER auto-resolve) |
| NEEDS_BUGFIX | Existing code has blocking bug | spec-developer |
| NEEDS_CONFIG | Configuration/environment issue | devops-troubleshooter |

**Rules for resolution_hint:**
- ALWAYS include `resolution_hint` when sending BLOCKER — it enables faster automatic resolution
- If unsure which hint applies, use the closest match; team-lead will route appropriately
- NEEDS_CLARIFICATION always escalates to user immediately — never auto-resolved
- Include enough `context` for the resolver agent to fix the issue without asking questions back

### DONE — Task Complete

Send when all deliverables are finished. Use structured format for efficient parsing by team-lead.

```
SendMessage(
  to: "team-lead",
  message: "DONE: Implemented JWT auth endpoints (bd-101).
    Files: src/auth/auth.controller.ts, src/auth/auth.service.ts, src/auth/auth.module.ts, tests/auth.test.ts
    Decisions: RS256 for JWT signing, 15m access token TTL, refresh tokens in httpOnly cookies
    Tests: 15 passing, 95% coverage
    Confidence: 0.9
    Follow-up: rate limiting on /login endpoint (not in scope)"
)
```

**Rules:**
- Include **Files** changed (team-lead needs this for context propagation)
- Include **Decisions** made (stored in knowledge base for future reference)
- Include **Confidence** score 0-1 (helps team-lead decide if review needs extra scrutiny)
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

1. Parse `resolution_hint` from the BLOCKER message
2. If hint is `NEEDS_CLARIFICATION` → escalate to user immediately
3. If hint has a mapped resolver agent → spawn resolver automatically:
   - Provide the BLOCKER context to resolver
   - Resolver sends DONE when fixed
   - SendMessage to blocked agent: "RESOLVED: {hint} addressed. You may proceed."
4. If no hint provided → assess manually:
   - Can resolve without user? Yes → spawn helper agent
   - No → escalate to user
5. Track resolution: `bd update bd-XXX --status blocked --message "{reason}"`
6. Anti-loop: max 2 auto-resolution attempts per blocker. If resolver also blocks with same hint → escalate to user.

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
