#!/bin/bash

# Journal Skills Loader Wrapper
# Provides a convenient CLI interface for loading academic journal skills

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

# Change to project root
cd "$PROJECT_ROOT" || exit 1

# Check if Python script exists
if [ ! -f "tools/load_journal_skills.py" ]; then
    echo "❌ load_journal_skills.py not found!"
    exit 1
fi

# Show help
show_help() {
    cat << EOF
Usage: ./tools/load-journal.sh [COMMAND] [JOURNAL]

Commands:
  list              List all available journals
  current           Show currently loaded journal
  load <JOURNAL>    Load skills for a specific journal
  <JOURNAL>         Shorthand for 'load <JOURNAL>'
  help              Show this help message

Examples:
  # Interactive mode (browse and select journal)
  ./tools/load-journal.sh

  # Load specific journal
  ./tools/load-journal.sh AAAI
  ./tools/load-journal.sh load "AEJ-Applied-Economics"

  # List available journals
  ./tools/load-journal.sh list

  # Show current loaded journal
  ./tools/load-journal.sh current

EOF
}

# Main logic
if [ $# -eq 0 ]; then
    # Interactive mode
    python3 tools/load_journal_skills.py
elif [ "$1" = "help" ] || [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
    show_help
else
    # Pass all arguments to Python script
    python3 tools/load_journal_skills.py "$@"
fi
