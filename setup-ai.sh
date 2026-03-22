#!/bin/bash
set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo ""
echo -e "${BLUE}============================================${NC}"
echo -e "${BLUE}  AI RAG System for Claude Code${NC}"
echo -e "${BLUE}  Qdrant + MCP Servers${NC}"
echo -e "${BLUE}============================================${NC}"
echo ""

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# Pre-flight
echo -e "${YELLOW}Pre-flight checks...${NC}"

if ! command -v ansible-playbook &> /dev/null; then
    echo -e "${RED}ERROR: Ansible not found. Run install.sh first.${NC}"
    exit 1
fi

if ! command -v docker &> /dev/null; then
    echo -e "${RED}ERROR: Docker not found. Run install.sh first.${NC}"
    exit 1
fi

if ! docker info &> /dev/null; then
    echo -e "${RED}ERROR: Docker is not running. Start Docker Desktop.${NC}"
    exit 1
fi

echo -e "${GREEN}  Ansible: OK${NC}"
echo -e "${GREEN}  Docker:  OK${NC}"

# Install collections
if [ -f "$SCRIPT_DIR/requirements.yml" ]; then
    ansible-galaxy collection install -r "$SCRIPT_DIR/requirements.yml" 2>/dev/null || echo -e "${YELLOW}Warning: collection install failed, continuing...${NC}"
fi

echo ""
echo -e "${BLUE}Installing AI RAG system...${NC}"
echo ""

ansible-playbook -i inventory/hosts.ini all.yml --tags ai -e ai_rag_enabled=true "$@"

echo ""
echo -e "${GREEN}============================================${NC}"
echo -e "${GREEN}  AI RAG System Ready!${NC}"
echo -e "${GREEN}============================================${NC}"
echo ""
echo "  Qdrant:     http://localhost:6333"
echo "  Verify:     claude mcp list"
echo "  Health:     curl http://localhost:6333/healthz"
echo ""
