# Journal Skills Loader

A dynamic skills loading tool that allows you to automatically load skills for a specific academic journal.

> Also in this directory: `setup-knowledge-work-plugins.sh` installs selected plugins from
> `anthropics/knowledge-work-plugins` (an external marketplace in a different repo owner tier,
> so it must be run locally, not inside this remote session). See that script's header for usage.

## Overview

This tool manages a collection of 195+ academic journals and their submission/review skills. Instead of installing all skills at once, you can dynamically load skills for your target journal.

## Features

- **195+ Journals**: Support for major academic conferences and journals
- **Dynamic Loading**: Load skills for only your target journal
- **Interactive Selection**: User-friendly interactive interface
- **Configuration Management**: Automatically updates the marketplace configuration

## Usage

### List Available Journals

```bash
python3 tools/load_journal_skills.py list
```

This shows all 195 available journals with the number of skills each has.

### Load Skills for a Journal

#### Interactive Mode (Recommended)

```bash
python3 tools/load_journal_skills.py
```

This starts an interactive session where you can:
1. Browse available journals
2. Enter a journal number, name, or search term
3. Automatically load all skills for that journal

#### Direct Mode

```bash
# Load by exact journal name
python3 tools/load_journal_skills.py load AAAI

# Or just provide the name
python3 tools/load_journal_skills.py AAAI
```

#### Fuzzy Search

```bash
# Search for journals (matches are case-insensitive)
python3 tools/load_journal_skills.py load "nature"
```

### Show Currently Loaded Journal

```bash
python3 tools/load_journal_skills.py current
```

Shows which journal skills are currently active and lists all loaded skills.

## How It Works

1. **Skills Repository**: All 195 journals' skills are stored in `skills/journals-available/`
2. **Dynamic Loading**: The loader copies selected skills to `skills/journal-skills/`
3. **Configuration**: Updates `.claude-plugin/marketplace.json` to activate the selected journal's skills
4. **State Tracking**: Saves the current selection in `.claude-plugin/journal-config.json`

## Example Workflow

```bash
# 1. List available journals
python3 tools/load_journal_skills.py list

# 2. Load skills for AAAI conference
python3 tools/load_journal_skills.py AAAI

# 3. Check what's loaded
python3 tools/load_journal_skills.py current

# 4. Switch to a different journal (e.g., NeurIPS)
python3 tools/load_journal_skills.py NeurIPS
```

## Supported Journals (Sample)

- **Conferences**: AAAI, AISTATS, NeurIPS, ICML, ICCV, ECCV, ACL, EMNLP, ICLR
- **Economics**: AEJ-Applied-Economics, AEJ-Macroeconomics, AER-Insights
- **Management**: Academy-of-Management-Annals, Administrative-Science-Quarterly
- **And 185+ more!

## File Structure

```
skills/
├── journals-available/          # All 195 journals' skills (source)
│   ├── AAAI/
│   ├── NeurIPS/
│   ├── ICML/
│   └── ...
├── journal-skills/              # Currently active journal skills
│   └── (dynamically updated)
└── ...

.claude-plugin/
├── marketplace.json             # Plugin configuration (updated by loader)
└── journal-config.json          # Current journal state
```

## Advanced Usage

### Integration with Scripts

You can use the tool in scripts:

```bash
#!/bin/bash
# Auto-load skills for NeurIPS
python3 tools/load_journal_skills.py NeurIPS

# Then run tests or other operations
make test
```

### View Config

Check what's configured:

```bash
cat .claude-plugin/journal-config.json
```

## Troubleshooting

**Q: Journal name not found?**  
A: Use `python3 tools/load_journal_skills.py list` to see exact names. Names are case-sensitive.

**Q: No skills loaded?**  
A: Check that `skills/journals-available/` contains the journal directory.

**Q: How to go back to all example skills?**  
A: Load the `example-skills` plugin from marketplace settings, or manually restore the configuration.

## Notes

- Switching journals will replace the currently active journal skills
- Original journal data in `skills/journals-available/` is never modified
- Configuration changes are immediate and reflected in Claude Code
