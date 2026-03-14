---
name: decide
description: Structured decision-making using frameworks like pros/cons, decision matrices, and risk analysis
allowed-tools: Read, Write, WebSearch
---

# Decide Skill

Facilitates structured decision-making using proven frameworks like pros/cons analysis, weighted decision matrices, and risk assessment.

## Usage

```bash
/decide [question]                   # Start decision analysis
/decide [question] --quick           # Quick pros/cons
/decide [question] --matrix          # Decision matrix
/decide [question] --risk            # Include risk analysis
```

## Examples

```bash
/decide "Should we use GraphQL or REST?"
/decide "Monolith vs microservices for MVP" --quick
/decide "Which database: PostgreSQL, MongoDB, or DynamoDB?" --matrix
/decide "Should we migrate to Kubernetes?" --risk
```

## What It Does

1. **Clarifies the Decision**
   - Defines the question clearly
   - Identifies options
   - Sets evaluation criteria

2. **Analyzes Options**
   - Pros and cons for each option
   - Weighted scoring (if matrix)
   - Risk assessment (if requested)

3. **Generates Recommendation**
   - Data-driven conclusion
   - Key reasoning
   - Next steps

## Output Format

```markdown
# Decision: [Question]

## Options
1. **Option A**: [Brief description]
2. **Option B**: [Brief description]

## Analysis

### Option A
**Pros:**
- [Pro 1]
- [Pro 2]

**Cons:**
- [Con 1]
- [Con 2]

### Option B
**Pros:**
- [Pro 1]

**Cons:**
- [Con 1]

## Decision Matrix (if --matrix)

| Criteria | Weight | Option A | Option B |
|----------|--------|----------|----------|
| Cost | 25% | 4 | 3 |
| Speed | 20% | 5 | 4 |
| Quality | 30% | 3 | 5 |
| **Total** | | **3.7** | **4.1** |

## Risk Analysis (if --risk)

| Risk | Likelihood | Impact | Mitigation |
|------|------------|--------|------------|
| [Risk 1] | High | High | [Action] |

## Recommendation

**Choose: Option B**

**Key Reasons:**
1. [Primary reason]
2. [Secondary reason]

**Tradeoffs:**
- [What you're giving up]

## Next Steps
1. [Immediate action]
2. [Follow-up action]
```

## Decision Frameworks

| Framework | Best For | Flag |
|-----------|----------|------|
| Pros/Cons | Quick binary decisions | `--quick` |
| Decision Matrix | Multiple criteria | `--matrix` |
| Risk Assessment | High-stakes decisions | `--risk` |
| 10/10/10 | Emotional decisions | (included if helpful) |

## Flags

| Flag | Description |
|------|-------------|
| `--quick` | Simple pros/cons analysis |
| `--matrix` | Weighted decision matrix |
| `--risk` | Include risk assessment |
| `--criteria="X,Y,Z"` | Specify evaluation criteria |

## Execute

Spawn the decision-helper agent:

```
subagent_type: decision-helper
prompt: Help decide: [question]. Identify options, [generate pros/cons / create weighted decision matrix / assess risks], and provide a recommendation with reasoning. [Use criteria: X, Y, Z if specified].
```
