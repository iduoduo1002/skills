#!/bin/bash

# Install the Obsidian MCP server (bitbonsai/mcp-obsidian) into local Claude Code.
# Run on the machine that holds your Obsidian vault; a cloud session cannot reach it.
#
# Usage:
#   ./tools/setup-obsidian-mcp.sh /path/to/your/vault
#   ./tools/setup-obsidian-mcp.sh /path/to/your/vault --project   # write .mcp.json for this project only

set -e

VAULT="$1"
SCOPE="user"
[ "$2" == "--project" ] && SCOPE="project"

if [ -z "$VAULT" ] || [ ! -d "$VAULT" ]; then
    echo "Usage: $0 /absolute/path/to/obsidian/vault [--project]"
    echo "Vault directory not found: '$VAULT'"
    exit 1
fi

for cmd in claude npx; do
    command -v "$cmd" >/dev/null 2>&1 || { echo "❌ '$cmd' not found on PATH"; exit 1; }
done

VAULT="$(cd "$VAULT" && pwd)"

echo "🔌 Adding Obsidian MCP (scope: $SCOPE, vault: $VAULT)"
claude mcp add obsidian --scope "$SCOPE" -- npx -y @mauricio.wolff/mcp-obsidian@latest "$VAULT"

echo ""
echo "✅ Done. Verify with: claude mcp list"
echo "   Restart Claude Code, then ask it to list or search notes in your vault."
