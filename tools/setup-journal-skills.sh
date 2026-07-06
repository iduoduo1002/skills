#!/bin/bash

# Setup script for Journal Skills System
# Downloads and prepares the journal skills database

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
JOURNALS_DIR="$PROJECT_ROOT/skills/journals-available"
TEMP_DIR="/tmp/awesome-journals-$$"

echo "📚 Journal Skills System Setup"
echo "=============================="
echo ""

# Check if already set up
if [ -d "$JOURNALS_DIR" ] && [ "$(ls -1 "$JOURNALS_DIR" | wc -l)" -gt 100 ]; then
    echo "✅ Journal skills already set up (found $(ls -1 "$JOURNALS_DIR" | wc -l) journals)"
    exit 0
fi

echo "⬇️  Downloading Awesome-Journal-Skills repository..."
cd /tmp

# Clone if not exists
if [ ! -d "$TEMP_DIR" ]; then
    git clone https://github.com/brycewang-stanford/Awesome-Journal-Skills.git "$TEMP_DIR" 2>&1 | tail -3
else
    echo "Using existing clone from $TEMP_DIR"
fi

echo "📁 Setting up journal directories..."

# Create journals-available directory
mkdir -p "$JOURNALS_DIR"

# Copy all journal skills
cd "$TEMP_DIR"
count=0
for dir in *-Skills; do
    journal_name="${dir%-Skills}"
    if [ -d "$dir/skills" ]; then
        mkdir -p "$PROJECT_ROOT/skills/journals-available/$journal_name"
        cp -r "$dir/skills"/* "$PROJECT_ROOT/skills/journals-available/$journal_name/" 2>/dev/null || true
        count=$((count + 1))
    fi
done

echo "✅ Setup complete!"
echo ""
echo "Summary:"
echo "--------"
echo "📍 Journal skills location: $JOURNALS_DIR"
echo "📊 Journals available: $count"
echo ""
echo "Next steps:"
echo "1. Load a journal with: ./tools/load-journal.sh AAAI"
echo "2. List journals with: ./tools/load-journal.sh list"
echo "3. Check current journal: ./tools/load-journal.sh current"
echo ""
echo "Cleanup:"
echo "--------"
rm -rf "$TEMP_DIR"
echo "Temporary files cleaned up"

exit 0
