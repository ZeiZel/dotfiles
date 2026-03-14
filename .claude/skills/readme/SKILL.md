---
name: readme
description: Create or update README by analyzing project structure and code
allowed-tools: Read, Write, Glob, Grep, Bash
---

# README Skill

Generates or updates README.md by analyzing project structure, extracting information from code, and following best practices for the project type.

## Usage

```bash
/readme                              # Create/update README
/readme --template=library           # Use library template
/readme --template=cli               # Use CLI tool template
/readme --template=api               # Use API/service template
/readme --update                     # Update existing README
```

## Examples

```bash
/readme
/readme --template=library
/readme --update
```

## What It Does

1. **Project Analysis**
   - Detects project type (library, CLI, API, app)
   - Reads package.json/setup.py/Cargo.toml
   - Identifies key files and structure
   - Extracts scripts and commands

2. **Content Generation**
   - Project description
   - Installation instructions
   - Quick start guide
   - API/Usage documentation
   - Configuration options
   - Contributing guidelines

3. **Output**
   - Writes/updates README.md
   - Includes badges if applicable
   - Adds code examples from actual code

## Templates

### Library Template
- Package name and description
- Installation (npm/yarn/pnpm)
- Quick start with import
- API reference
- Configuration
- Contributing

### CLI Template
- Tool name and description
- Installation (global/npx)
- Commands and options
- Configuration file
- Examples

### API Template
- Service description
- Prerequisites
- Installation and setup
- API endpoints
- Authentication
- Environment variables

## Output Format

```markdown
# Project Name

[![npm version](badge)](link)

Brief description of what this project does.

## Features

- Feature 1
- Feature 2

## Installation

```bash
npm install project
```

## Quick Start

```typescript
import { something } from 'project';
// Example usage
```

## API

### function(params)
Description and example.

## Configuration

| Option | Type | Default | Description |

## Contributing

See [CONTRIBUTING.md](./CONTRIBUTING.md).

## License

MIT
```

## Flags

| Flag | Description |
|------|-------------|
| `--template=[type]` | Use specific template (library/cli/api) |
| `--update` | Update existing README, preserve custom sections |
| `--badges` | Include common badges |
| `--minimal` | Minimal README |

## Execute

Spawn the readme-generator agent:

```
subagent_type: readme-generator
prompt: [Create/Update] README.md for this project. Analyze the project structure, extract information from code and config files, and generate a comprehensive README [using the [template] template]. Include installation, quick start, API reference, and configuration.
```
