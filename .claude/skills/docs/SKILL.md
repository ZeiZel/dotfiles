---
name: docs
description: Fetch and organize documentation for libraries, APIs, and frameworks into quick reference guides
allowed-tools: WebFetch, WebSearch, Read, Write, Glob
---

# Docs Skill

Collects and organizes documentation for libraries, APIs, and frameworks into quick reference guides that developers can use immediately.

## Usage

```bash
/docs [library]                      # Fetch docs for library
/docs [library] --api                # Focus on API reference
/docs [library] --examples           # Focus on examples
/docs [library] --save               # Save to docs/references/
```

## Examples

```bash
/docs react-query
/docs "Next.js App Router"
/docs prisma --api
/docs zod --examples
/docs tanstack-router --save
```

## What It Does

1. **Identifies Sources**
   - Official documentation
   - GitHub README
   - API reference
   - Community resources

2. **Extracts Key Information**
   - Installation instructions
   - Quick start guide
   - Core API methods
   - Configuration options
   - Common patterns

3. **Organizes Output**
   - Version information
   - Quick reference format
   - Runnable examples
   - Links to full docs

## Output Format

```markdown
# [Library] Quick Reference

**Version**: [X.Y.Z]
**Docs**: [URL]

## Installation

```bash
npm install [library]
```

## Quick Start

```typescript
// Basic usage example
```

## Core API

### functionName(params)
[Description with example]

## Common Patterns

### Pattern 1
```typescript
// Code example
```

## Configuration

| Option | Type | Default | Description |
|--------|------|---------|-------------|

## Troubleshooting

### Common Issue 1
[Solution]
```

## Flags

| Flag | Description |
|------|-------------|
| `--api` | Focus on API reference only |
| `--examples` | Focus on code examples |
| `--save` | Save to docs/references/[library].md |
| `--version [X]` | Specific version docs |

## Execute

Spawn the docs-collector agent:

```
subagent_type: docs-collector
prompt: Collect and organize documentation for [library]. Focus on [api/examples/all]. Create a quick reference guide with installation, quick start, core API, and common patterns.
```
