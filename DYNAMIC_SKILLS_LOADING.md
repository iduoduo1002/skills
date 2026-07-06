# Dynamic Journal Skills Loading System

## Overview

This system provides a comprehensive solution for dynamically loading academic journal submission and review skills based on your target journal. Instead of installing all 195+ journal skills at once, you can load skills for only the journal you're working with.

## Architecture

### Directory Structure

```
skills/
├── journals-available/          # All 195 journal skills (read-only source)
│   ├── AAAI/
│   │   ├── aaai-artifact-evaluation/
│   │   ├── aaai-author-response/
│   │   └── ... (12 AAAI skills)
│   ├── AEJ-Applied-Economics/
│   │   └── ... (12 journal skills)
│   └── ... (195 total journals)
│
├── journal-skills/              # Currently active journal skills (auto-managed)
│   └── (dynamically populated by loader)
│
├── tools/
│   ├── load_journal_skills.py  # Python loader implementation
│   ├── load-journal.sh         # Bash CLI wrapper
│   └── README.md               # Detailed tool documentation
│
├── .claude-plugin/
│   ├── marketplace.json        # Plugin configuration (updated by loader)
│   └── journal-config.json     # Current state tracking
│
└── ...
```

## Quick Start

### 1. List Available Journals

```bash
./tools/load-journal.sh list
```

Shows all 195 available journals with skill counts.

### 2. Interactive Loading (Recommended)

```bash
./tools/load-journal.sh
```

Interactive mode lets you:
- Browse available journals
- Search by name or number
- Automatically load selected journal's skills

### 3. Direct Loading

```bash
# Load by exact name
./tools/load-journal.sh AAAI

# Load with fuzzy matching
./tools/load-journal.sh "economic"
```

### 4. Check Current State

```bash
./tools/load-journal.sh current
```

Shows which journal is currently loaded and all its skills.

## How It Works

### Loading Process

1. **Lookup**: Python script finds the journal in `skills/journals-available/`
2. **Copy**: All skills for that journal are copied to `skills/journal-skills/`
3. **Update**: `marketplace.json` is updated with the new skill paths
4. **Activate**: Claude Code picks up the updated configuration automatically
5. **Track**: Current state is saved in `journal-config.json`

### Key Files

**load_journal_skills.py** - Main Python script
- `get_available_journals()`: List all journals
- `get_journal_skills(journal)`: Get skills for a journal
- `load_journal(journal)`: Execute the loading process
- Interactive and CLI modes

**load-journal.sh** - Bash wrapper
- User-friendly command line
- Help documentation
- Error handling

**marketplace.json** - Plugin configuration
- Lists active skills for Claude Code
- Updated dynamically on each load
- Maintains structure compatible with Anthropic skills system

**journal-config.json** - State tracking
```json
{
  "current_journal": "AAAI",
  "skills_count": 12,
  "skills": ["aaai-artifact-evaluation", ...]
}
```

## Example Workflows

### Scenario 1: Preparing for AAAI Submission

```bash
$ ./tools/load-journal.sh AAAI
✅ Successfully loaded 12 skills for AAAI
   Skills: aaai-artifact-evaluation, aaai-author-response, aaai-camera-ready...

# Now use skills in Claude:
# "Use the aaai-submission skill to prepare my paper"
# Claude automatically has access to all AAAI-specific guidance
```

### Scenario 2: Switching Between Journals

```bash
# Working on economics paper
$ ./tools/load-journal.sh "AEJ-Applied-Economics"

# Later, switch to management journal
$ ./tools/load-journal.sh "Academy-of-Management-Journal"

# Skills are automatically replaced
```

### Scenario 3: Finding the Right Journal

```bash
$ ./tools/load-journal.sh list | grep -i "machine\|learning"
# Browse machine learning conferences
$ ./tools/load-journal.sh "AISTATS"
```

## Supported Journals (Sample)

### AI & Machine Learning
- AAAI, AISTATS, Computer-Science-Conference, ICTAI

### Economics
- AEJ-Applied-Economics, AEJ-Macroeconomics, AER-Insights
- Annual-Review-of-Economics

### Management & Organization
- Academy-of-Management-Annals
- Academy-of-Management-Journal
- Academy-of-Management-Review
- Administrative-Science-Quarterly

### Social Sciences
- American-Anthropologist
- American-Sociological-Review
- American-Journal-of-Sociology
- American-Political-Science-Review

### And 175+ more!

See `./tools/load-journal.sh list` for the complete list.

## Advanced Usage

### Automation

Create a setup script for your project:

```bash
#!/bin/bash
# setup-journal-skills.sh

# Load journal skills for the project
python3 tools/load_journal_skills.py AAAI

# Run other setup commands
make test
npm install
```

### Integration with CI/CD

```yaml
# .github/workflows/test.yml
- name: Load Journal Skills
  run: python3 tools/load_journal_skills.py AAAI

- name: Run Tests
  run: make test
```

### Configuration Management

Check current configuration:

```bash
cat .claude-plugin/journal-config.json
cat .claude-plugin/marketplace.json
```

### Troubleshooting

**Journal not found?**
```bash
# Check exact name
./tools/load-journal.sh list | grep -i "your-keyword"
```

**Skills not loaded?**
```bash
# Verify directory contents
ls -la skills/journal-skills/

# Check configuration
./tools/load-journal.sh current
```

**Need to restore example skills?**
```bash
# Manually edit .claude-plugin/marketplace.json or
# Create a script to restore default configuration
```

## Data Source

Skills are sourced from [brycewang-stanford/Awesome-Journal-Skills](https://github.com/brycewang-stanford/Awesome-Journal-Skills), a comprehensive collection of academic journal submission guidelines and review processes.

## Benefits

✅ **Focused Learning**: Load only the skills you need
✅ **No Clutter**: Don't install 195 skills if you use one
✅ **Easy Switching**: Change journals in seconds
✅ **Automatic Updates**: marketplace.json updated automatically
✅ **State Tracking**: Know what's currently loaded
✅ **Extensible**: Easy to add more journals

## Future Enhancements

- [ ] Support for multiple simultaneous journals
- [ ] Skill search and filtering
- [ ] Cloud sync of current journal selection
- [ ] Custom journal skill creation
- [ ] Skill recommendations based on paper topic
- [ ] Integration with academic databases (arXiv, etc.)

## Technical Details

### Python Dependencies

```python
# Standard library only - no external dependencies
import os
import json
import sys
import shutil
from pathlib import Path
from typing import List, Dict, Optional
```

### File Permissions

```bash
chmod +x tools/load_journal_skills.py
chmod +x tools/load-journal.sh
```

### Configuration Format

Skills are organized following the [Agent Skills specification](http://agentskills.io), with each skill in its own directory containing a `SKILL.md` file.

## Support

For issues or questions:
1. Check `./tools/README.md` for detailed documentation
2. Run `./tools/load-journal.sh help` for CLI help
3. Review `DYNAMIC_SKILLS_LOADING.md` (this file)
4. Check journal-config.json for current state
