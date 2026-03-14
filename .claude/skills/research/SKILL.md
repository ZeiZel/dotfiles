---
name: research
description: Deep topic investigation with multi-source synthesis and comprehensive research reports
allowed-tools: WebSearch, WebFetch, Read, Write, Task
---

# Research Skill

Conducts deep research on any topic, synthesizing information from multiple authoritative sources into comprehensive, actionable reports.

## Usage

```bash
/research [topic]                    # Standard research
/research [topic] --quick            # Quick overview (15-20 min)
/research [topic] --deep             # Deep dive (4-8 hours equivalent)
/research [topic] --compare [vs]     # Comparison research
```

## Examples

```bash
/research GraphQL best practices
/research "React Server Components" --quick
/research Kubernetes networking --deep
/research "Redux vs Zustand" --compare
```

## What It Does

1. **Defines Research Scope**
   - Clarifies research question
   - Identifies key aspects to investigate
   - Sets appropriate depth level

2. **Multi-Source Search**
   - Searches authoritative sources
   - Evaluates source quality
   - Gathers diverse perspectives

3. **Information Synthesis**
   - Identifies common themes
   - Notes conflicting information
   - Extracts actionable insights

4. **Report Generation**
   - Executive summary
   - Key findings with evidence
   - Recommendations
   - Source citations

## Output Format

```markdown
# Research Report: [Topic]

## Executive Summary
[Key findings and recommendations]

## Key Findings

### Finding 1: [Title]
[Evidence and sources]

### Finding 2: [Title]
[Evidence and sources]

## Recommendations
1. [Actionable recommendation]
2. [Actionable recommendation]

## Sources
[Cited sources with links]
```

## Research Depth Levels

| Level | Time | Sources | Output |
|-------|------|---------|--------|
| Quick | 15-20 min | 3-5 | 1-2 pages |
| Standard | 1-2 hours | 8-12 | 3-5 pages |
| Deep | 4-8 hours | 15-25+ | 10+ pages |

## Execute

Spawn the web-researcher agent:

```
subagent_type: web-researcher
prompt: Research [user's topic] with [depth level] depth. Produce a comprehensive report with executive summary, key findings, recommendations, and source citations.
```
