---
name: figma-to-pencil
description: Transfer Figma designs to local OpenPencil and configure the project for AI-driven design workflow. Imports .fig files, sets up OpenPencil MCP in .mcp.json, and updates project.yaml with design tool configuration.
allowed-tools: Read, Write, Edit, Glob, Grep, Bash, AskUserQuestion, mcp__figma__get_file, mcp__figma__get_file_components, mcp__figma__get_file_styles, mcp__figma__get_node, mcp__figma__get_image, mcp__open-pencil__*
---

# Figma to OpenPencil Transfer

Transfers a Figma design to a local OpenPencil workspace and configures the current project to work with it via MCP.

## Usage

```bash
/figma-to-pencil <figma-url-or-file-key>
/figma-to-pencil                          # Will ask for URL interactively
```

## What This Skill Does

1. Validates OpenPencil CLI is installed
2. Extracts Figma file key from URL
3. Imports the design into a local .fig file (OpenPencil reads native .fig)
4. Configures the project's `.mcp.json` with OpenPencil MCP server
5. Updates `docs/project.yaml` with design tool section
6. Verifies the imported design is accessible via MCP

## Execute

### Step 1: Validate Prerequisites

```bash
# Check OpenPencil CLI
command -v open-pencil && open-pencil --version

# Check if Figma MCP is available (for metadata extraction)
# Figma MCP tools should be accessible if configured
```

If `open-pencil` CLI is not installed:
```bash
bun add -g @open-pencil/cli
```

### Step 2: Parse Figma Input

Extract file key from various Figma URL formats:
- `https://www.figma.com/file/ABC123/...` -> `ABC123`
- `https://www.figma.com/design/ABC123/...` -> `ABC123`
- Raw file key: `ABC123`

If no argument provided, use AskUserQuestion:
```yaml
question: "What is the Figma file URL or key?"
options:
  - label: "I'll paste the URL"
    description: "Figma file URL (figma.com/file/... or figma.com/design/...)"
  - label: "No Figma design"
    description: "Skip import, just set up OpenPencil for new designs"
```

### Step 3: Import Design

#### Option A: CLI Import (preferred)

```bash
# Create design directory if not exists
mkdir -p designs/

# Import from Figma using OpenPencil CLI
open-pencil import --from-figma <file_key> --output designs/<project-name>.fig
```

#### Option B: Manual Reconstruction (if CLI import unavailable)

1. Extract design structure via Figma MCP:
   ```
   mcp__figma__get_file(file_key) -> file structure
   mcp__figma__get_file_components(file_key) -> components list
   mcp__figma__get_file_styles(file_key) -> design tokens
   ```

2. For key frames, extract detailed specs:
   ```
   mcp__figma__get_node(file_key, node_id) -> frame details
   mcp__figma__get_image(file_key, node_id, format: "svg") -> assets
   ```

3. Save extracted data to `designs/figma-export/`:
   - `structure.json` - file tree
   - `components.json` - component specs
   - `tokens.json` - design tokens
   - `assets/` - exported images/SVGs

#### Option C: New Design (no Figma)

If user chose "No Figma design":
```bash
# Create empty design workspace
mkdir -p designs/
# OpenPencil will create .fig files when opened
```

### Step 4: Configure Project MCP

Read existing `.mcp.json` (if any) and add OpenPencil MCP server.

```bash
# Check if .mcp.json exists
test -f .mcp.json && echo "EXISTS" || echo "MISSING"
```

If `.mcp.json` exists, read it and merge. If not, create new.

Add to `.mcp.json`:
```json
{
  "mcpServers": {
    "open-pencil": {
      "type": "stdio",
      "command": "npx",
      "args": ["@open-pencil/mcp"]
    }
  }
}
```

Preserve all existing MCP servers when merging.

### Step 5: Update project.yaml

Read `docs/project.yaml` (if exists) and add/update design section:

```yaml
design:
  tool: "open-pencil"
  source: "figma"  # or "local" if no Figma import
  figma_file_key: "<file_key>"  # omit if no Figma
  local_file: "designs/<project-name>.fig"
  mcp_configured: true
```

### Step 6: Verify Setup

```bash
# 1. Check design file exists
ls -la designs/*.fig 2>/dev/null || echo "No .fig files yet (will be created on first use)"

# 2. Check .mcp.json has open-pencil
grep -q "open-pencil" .mcp.json && echo "MCP configured" || echo "MCP missing"

# 3. Check project.yaml has design section
grep -q "design:" docs/project.yaml 2>/dev/null && echo "project.yaml updated" || echo "project.yaml needs design section"
```

### Step 7: Report

Output summary:
```
## Figma to OpenPencil Transfer Complete

**Source**: {Figma URL or "New workspace"}
**Design file**: designs/{name}.fig
**MCP server**: open-pencil (configured in .mcp.json)
**project.yaml**: Updated with design section

### Next Steps
- Open design: `open-pencil designs/{name}.fig`
- Or use in browser: `open-pencil serve` -> http://localhost:3100
- AI agents can now access the design via OpenPencil MCP tools
- Use `/teamlead` to request design modifications
```

## Notes

- OpenPencil reads/writes native Figma `.fig` format — no conversion needed
- The MCP server provides 90+ tools for AI agents to manipulate designs
- Design files should be committed to Git (they are the source of truth)
- Add `designs/` to `.gitignore` only if designs contain sensitive data
