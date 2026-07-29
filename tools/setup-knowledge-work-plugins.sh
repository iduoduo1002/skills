#!/bin/bash

# Setup script for anthropics/knowledge-work-plugins
#
# This repo lives in a different GitHub owner tier than this skills project,
# so it cannot be added as a source inside this remote session. Run this
# script on your local machine (where `claude` CLI is installed and
# authenticated) to install it there instead.
#
# Usage:
#   ./tools/setup-knowledge-work-plugins.sh                 # install PLUGINS below
#   ./tools/setup-knowledge-work-plugins.sh sales finance    # install specific plugins
#   ./tools/setup-knowledge-work-plugins.sh --list           # just show available plugins
#   ./tools/setup-knowledge-work-plugins.sh --all            # install all 11 official plugins

set -e

MARKETPLACE="anthropics/knowledge-work-plugins"

ALL_PLUGINS=(
    productivity
    sales
    customer-support
    product-management
    marketing
    legal
    finance
    data
    enterprise-search
    bio-research
    cowork-plugin-management
)

# Default selection for this project (chosen 2026-07-29: data + productivity)
DEFAULT_PLUGINS=(data productivity)

echo "🧩 knowledge-work-plugins Setup"
echo "================================"
echo ""

if ! command -v claude >/dev/null 2>&1; then
    echo "❌ 'claude' CLI not found on PATH."
    echo "   This script must run where Claude Code CLI is installed, not inside"
    echo "   this remote session (cross-tier repo restriction)."
    exit 1
fi

if [ "$1" == "--list" ]; then
    echo "Available plugins in $MARKETPLACE:"
    for p in "${ALL_PLUGINS[@]}"; do
        echo "  - $p"
    done
    exit 0
fi

echo "⬇️  Adding marketplace: $MARKETPLACE"
claude plugin marketplace add "$MARKETPLACE"
echo ""

if [ "$1" == "--all" ]; then
    TARGETS=("${ALL_PLUGINS[@]}")
elif [ "$#" -gt 0 ]; then
    TARGETS=("$@")
else
    TARGETS=("${DEFAULT_PLUGINS[@]}")
fi

echo "📦 Installing: ${TARGETS[*]}"
for plugin in "${TARGETS[@]}"; do
    echo ""
    echo "→ Installing $plugin@$MARKETPLACE"
    claude plugin install "$plugin@$MARKETPLACE"
done

echo ""
echo "✅ Done. Verify with: claude plugin list"
