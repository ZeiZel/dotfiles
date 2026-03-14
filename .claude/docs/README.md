# Claude Code Configuration

## Overview

This configuration contains a comprehensive suite of AI-powered development tools:

- **50+ Agents** - Specialized AI assistants for different domains
- **16+ Skills** - Reusable instruction sets for common workflows
- **Integrated Tooling** - Beads, Gastown, Repomix, and more

## Quick Start

```bash
# Set up a new project for AI development
/project-setup

# Start team-led development workflow
/teamlead implement [feature]

# Generate tests for your code
/test [file or module]

# Create a commit with AI assistance
/commit

# Research a topic
/research [topic]

# Get help with decision making
/decide [question]
```

## Agent Categories

| Category | Count | Description |
|----------|-------|-------------|
| [Backend](agents/README.md#backend) | 1 | Server-side architecture and APIs |
| [Frontend](agents/README.md#frontend) | 5 | React, Vue, Angular, and frontend architecture |
| [DevOps](agents/README.md#devops) | 3 | CI/CD, infrastructure, and deployments |
| [Data](agents/README.md#data) | 2 | Databases and data engineering |
| [Security](agents/README.md#security) | 2 | Security architecture and compliance |
| [Documentation](agents/README.md#documentation) | 5 | Technical writing and docs generation |
| [Research](agents/README.md#research) | 4 | Web research and information gathering |
| [Dev Tools](agents/README.md#dev-tools) | 6 | Development utilities and helpers |
| [Everyday](agents/README.md#everyday) | 5 | Daily productivity tasks |
| [Spec Agents](agents/README.md#spec-agents) | 8 | Specification-driven development |
| [Content](agents/README.md#content) | 3 | Blog posts, presentations, social media |
| [Other](agents/README.md#other) | 10+ | Mobile, AI/ML, Product, UI/UX, etc. |

## Skills Overview

| Skill | Command | Description |
|-------|---------|-------------|
| Team Lead | `/teamlead` | Multi-agent orchestration workflow |
| Project Setup | `/project-setup` | Initialize project for AI development |
| Agent Creator | `/agent-creator` | Create new specialized agents |
| Research | `/research [topic]` | Deep topic investigation |
| Docs | `/docs [library]` | Fetch library documentation |
| Changelog | `/changelog` | Generate changelog from git history |
| README | `/readme` | Create or update README |
| Audit | `/audit` | Dependency and security audit |
| Migrate | `/migrate [from] [to]` | Migration assistance |
| Learn | `/learn [topic]` | Learning roadmap generation |
| Decide | `/decide [question]` | Decision-making framework |

See [Skills Documentation](skills/README.md) for detailed usage.

## Architecture

```
.claude/
├── agents/              # Specialized AI agents
│   ├── backend/         # Backend development
│   ├── frontend/        # Frontend development
│   ├── devops/          # DevOps and infrastructure
│   ├── documentation/   # Technical writing
│   ├── research/        # Research and analysis
│   ├── dev-tools/       # Development utilities
│   ├── everyday/        # Productivity helpers
│   ├── spec-agents/     # Specification workflow
│   └── ...
├── skills/              # Reusable skill instructions
│   ├── teamlead/
│   ├── project-setup/
│   ├── research/
│   └── ...
├── docs/                # This documentation
│   ├── agents/
│   └── skills/
└── settings.json        # Claude Code settings
```

## Integrated Tools

### Beads - Task Management
```bash
bd init           # Initialize workspace
bd ready          # View available tasks
bd list           # View all tasks
bd create         # Create new task
bd close          # Complete task
```

### Gastown - Multi-Agent Orchestration
```bash
gt install .      # Initialize
gt sling          # Distribute tasks
gt convoy create  # Group related tasks
gt feed           # Monitor progress
```

### Repomix - Context Snapshots
```bash
repomix --output docs/context/snapshot.txt
```

## Getting Started

1. **Install prerequisites:**
   ```bash
   brew install beads gastown
   npm install -g repomix
   ```

2. **Set up your project:**
   ```bash
   /project-setup
   ```

3. **Start developing:**
   ```bash
   /teamlead implement [your feature]
   ```

## Documentation

- [All Agents](agents/README.md) - Complete agent catalog
- [All Skills](skills/README.md) - Skill documentation and examples
- [Agent Creator Guide](../skills/agent-creator/SKILL.md) - Create custom agents
