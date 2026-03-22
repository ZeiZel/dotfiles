---
name: rag-setup
description: Initialize RAG infrastructure for a project - verify Qdrant, create collection, configure MCP servers in .mcp.json, index project files with embeddings, and update project.yaml. Used when project is too large for repomix context strategy.
allowed-tools: Read, Write, Edit, Bash, Glob, Grep, mcp__code-index-mcp__set_project_path, mcp__code-index-mcp__build_deep_index
---

# RAG Setup Skill

Initializes RAG (Retrieval Augmented Generation) infrastructure for a project that is too large for repomix-only context strategy. Handles Qdrant setup, collection creation, embedding generation, and MCP configuration.

## When to Use

- Project repomix snapshot exceeds 700k tokens
- Team-lead detects project is too large for repomix during preflight
- User explicitly requests RAG setup for a project
- `/project-setup` Phase 7.5 determines RAG is needed

## Prerequisites

RAG infrastructure is provisioned at **user scope** by the `roles/ai/` Ansible role:
- Qdrant container: `docker start qdrant` (port 6333/6334)
- MCP servers: `claude mcp add` at user scope (qdrant-mcp, code-index-mcp)
- FastEmbed model: pre-downloaded by Ansible

If not provisioned, this skill will guide the user through setup.

## Execution Steps

### Step 1: Verify Qdrant

```bash
# Check if Qdrant is running
curl -s http://localhost:6333/healthz

# If not running, try to start
docker start qdrant 2>/dev/null

# If container doesn't exist, guide user
echo "Run: ansible-playbook dotfiles.yml --tags ai"
```

### Step 2: Verify/Create Collection

```bash
# Check if collection exists for this project
# Default collection is "codebase" (shared across projects)
# For project-specific collection, use project name
curl -s http://localhost:6333/collections/{collection_name}
```

If collection doesn't exist, create it:

```bash
curl -X PUT http://localhost:6333/collections/{collection_name} \
  -H "Content-Type: application/json" \
  -d '{
    "vectors": {
      "size": 384,
      "distance": "Cosine",
      "on_disk": true
    },
    "sparse_vectors": {
      "bm25": {
        "modifier": "idf"
      }
    },
    "hnsw_config": {
      "on_disk": true,
      "m": 16,
      "ef_construct": 100
    },
    "optimizers_config": {
      "memmap_threshold": 20000,
      "indexing_threshold": 20000
    },
    "on_disk_payload": true,
    "quantization_config": {
      "scalar": {
        "type": "int8",
        "quantile": 0.99,
        "always_ram": true
      }
    }
  }'
```

### Step 3: Verify MCP Server Configuration

Check if qdrant-mcp is available. It should be configured at **user scope** (via Ansible).

```bash
# Check user-scope MCP servers
claude mcp list 2>/dev/null | grep -i qdrant
```

If not configured at user scope AND not in project .mcp.json:

```bash
# Add to project .mcp.json as fallback
# Read existing .mcp.json, add qdrant-mcp entry
```

The qdrant-mcp entry for .mcp.json:
```json
{
  "mcpServers": {
    "qdrant-mcp": {
      "type": "stdio",
      "command": "uvx",
      "args": ["mcp-server-qdrant"],
      "env": {
        "QDRANT_URL": "http://localhost:6333",
        "COLLECTION_NAME": "{collection_name}",
        "EMBEDDING_MODEL": "{embedding_model}"
      }
    }
  }
}
```

### Step 4: Index Project with code-index-mcp

```
mcp__code-index-mcp__set_project_path(path: "{project_root}")
mcp__code-index-mcp__build_deep_index()
```

### Step 4.5: Select Embedding Model

**CRITICAL**: The embedding model used for indexing MUST match the model configured in qdrant-mcp server. Mismatched models = garbage search results.

**Model selection logic**:

```python
# Detect project language by sampling files
# If ANY file contains Cyrillic or non-Latin characters → multilingual
# If project.yaml specifies language → use that
```

| Project Content | Model | Dims | Notes |
|----------------|-------|------|-------|
| English only | `sentence-transformers/all-MiniLM-L6-v2` | 384 | Fastest, EN-only |
| **Multilingual / Russian** | **`sentence-transformers/paraphrase-multilingual-MiniLM-L12-v2`** | 384 | **Default choice**, 50+ languages, same dims |
| Code-heavy (future) | `nomic-embed-text-v1.5` | 768 | Best quality, needs new collection |

**Default**: `paraphrase-multilingual-MiniLM-L12-v2` — safe default because:
- Same 384 dims as EN-only model (no collection changes needed)
- Works well for English too (0.50-0.66 score)
- Excellent for Russian (0.65-0.77 score)
- Supported by fastembed (used by qdrant-mcp server)

After selecting the model, ensure it is set in:
1. The indexing script (Step 5)
2. qdrant-mcp env var `EMBEDDING_MODEL` (Step 3)
3. `docs/project.yaml` → `context.rag.embedding_model`

### Step 5: Generate Embeddings and Upload to Qdrant

For bulk indexing (hundreds of files), use a Python script instead of MCP one-by-one:

```bash
# Check if dependencies are available
python3 -c "import sentence_transformers; import qdrant_client" 2>/dev/null
```

If not installed:
```bash
pip3 install sentence-transformers qdrant-client
```

Then write and run an indexing script tailored to the project:

```python
#!/usr/bin/env python3
"""Bulk index project files into Qdrant for semantic search."""

import os
import uuid
from pathlib import Path
from qdrant_client import QdrantClient
from qdrant_client.models import PointStruct
from sentence_transformers import SentenceTransformer

# Configuration
PROJECT_ROOT = "{project_root}"
COLLECTION = "{collection_name}"
QDRANT_URL = "http://localhost:6333"
# IMPORTANT: Must match EMBEDDING_MODEL in qdrant-mcp config!
EMBEDDING_MODEL = "{embedding_model}"  # default: paraphrase-multilingual-MiniLM-L12-v2

# File extensions to index (adapt per project)
CODE_EXTENSIONS = {
    ".py", ".js", ".ts", ".tsx", ".jsx", ".go", ".rs",
    ".java", ".kt", ".swift", ".rb", ".php", ".vue", ".svelte",
    ".md", ".mdx", ".yaml", ".yml", ".json", ".toml",
    ".html", ".css", ".scss", ".sql"
}

# Directories to skip
SKIP_DIRS = {
    "node_modules", ".git", ".next", "dist", "build",
    "__pycache__", ".venv", "venv", ".claude",
    "coverage", ".nyc_output"
}

def chunk_text(text: str, max_chars: int = 1500, overlap: int = 200) -> list[str]:
    """Split text into overlapping chunks."""
    if len(text) <= max_chars:
        return [text]
    chunks = []
    start = 0
    while start < len(text):
        end = start + max_chars
        chunks.append(text[start:end])
        start = end - overlap
    return chunks

def collect_files(root: str) -> list[Path]:
    """Collect indexable files from project."""
    files = []
    for dirpath, dirnames, filenames in os.walk(root):
        dirnames[:] = [d for d in dirnames if d not in SKIP_DIRS]
        for f in filenames:
            if Path(f).suffix in CODE_EXTENSIONS:
                files.append(Path(dirpath) / f)
    return files

def main():
    model = SentenceTransformer(EMBEDDING_MODEL)
    client = QdrantClient(url=QDRANT_URL)

    files = collect_files(PROJECT_ROOT)
    print(f"Found {len(files)} files to index")

    points = []
    for filepath in files:
        try:
            content = filepath.read_text(encoding="utf-8", errors="ignore")
        except Exception:
            continue

        rel_path = str(filepath.relative_to(PROJECT_ROOT))
        chunks = chunk_text(content)

        for i, chunk in enumerate(chunks):
            embedding = model.encode(chunk).tolist()
            points.append(PointStruct(
                id=str(uuid.uuid4()),
                vector=embedding,
                payload={
                    "file_path": rel_path,
                    "chunk_index": i,
                    "total_chunks": len(chunks),
                    "content": chunk[:2000],  # Truncate for payload
                    "extension": filepath.suffix,
                }
            ))

        # Batch upload every 100 points
        if len(points) >= 100:
            client.upsert(collection_name=COLLECTION, points=points)
            print(f"  Uploaded {len(points)} chunks...")
            points = []

    # Upload remaining
    if points:
        client.upsert(collection_name=COLLECTION, points=points)
        print(f"  Uploaded {len(points)} chunks...")

    info = client.get_collection(COLLECTION)
    print(f"Done! Collection '{COLLECTION}' has {info.points_count} points")

if __name__ == "__main__":
    main()
```

**Important**: Adapt `CODE_EXTENSIONS` and `SKIP_DIRS` based on the actual project tech stack detected in Phase 1.

### Step 6: Update project.yaml

Update the context section:

```yaml
context:
  strategy: "rag"
  repomix_token_estimate: {estimated_tokens}
  rag:
    indexed: true
    collection: "{collection_name}"
    embedding_model: "{embedding_model}"  # MUST match qdrant-mcp EMBEDDING_MODEL
    last_indexed: "{ISO timestamp}"
    indexed_files_count: {count}
    indexed_chunks_count: {total_chunks}
```

### Step 7: Verify

```bash
# Test a search
curl -s http://localhost:6333/collections/{collection_name} | python3 -c "
import json, sys
data = json.load(sys.stdin)
print(f'Status: {data[\"result\"][\"status\"]}')
print(f'Points: {data[\"result\"][\"points_count\"]}')
"

# Test code-index-mcp
# mcp__code-index-mcp__search_code_advanced(pattern: "main", max_results: 3)
```

## Output Report

After completion, output:

```
## RAG Setup Complete

**Project**: {project_path}
**Collection**: {collection_name}
**Files indexed**: {count}
**Chunks created**: {total_chunks}
**Qdrant status**: {green/yellow}
**code-index-mcp**: {configured/path set}
**Strategy**: rag

### Next Steps
- Team-lead will use RAG strategy for context pipeline
- Agents will have access to semantic search via qdrant-find
- Re-index after major codebase changes: `/rag-setup`
```

## Re-indexing

This skill can be called again to re-index a project. It will:
1. Clear existing points in the collection (for the specific project)
2. Re-index all files
3. Update project.yaml timestamps

## Integration Points

### Called by team-lead when:
- Preflight report shows DEGRADED due to missing RAG and project is large
- repomix snapshot exceeds 700k tokens during context strategy detection
- User explicitly requests RAG setup

### Called by project-setup in:
- Phase 7.5 when context strategy assessment determines RAG is needed

### Provides data for:
- rag-context skill (querying)
- preflight-checker (verification)
- All execution agents with RAG tools
