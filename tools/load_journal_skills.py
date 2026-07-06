#!/usr/bin/env python3
"""
Dynamic Journal Skills Loader

This tool allows you to dynamically load skills for a specific academic journal.
It manages the active skills in the marketplace configuration based on your target journal.
"""

import os
import json
import sys
import shutil
from pathlib import Path
from typing import List, Dict, Optional

PROJECT_ROOT = Path(__file__).parent.parent
JOURNALS_DIR = PROJECT_ROOT / "skills" / "journals-available"
JOURNAL_SKILLS_DIR = PROJECT_ROOT / "skills" / "journal-skills"
MARKETPLACE_FILE = PROJECT_ROOT / ".claude-plugin" / "marketplace.json"
CONFIG_FILE = PROJECT_ROOT / ".claude-plugin" / "journal-config.json"


def get_available_journals() -> List[str]:
    """Get list of available journals."""
    if not JOURNALS_DIR.exists():
        return []
    return sorted([d.name for d in JOURNALS_DIR.iterdir() if d.is_dir()])


def get_journal_skills(journal: str) -> List[str]:
    """Get list of skills available for a journal."""
    journal_path = JOURNALS_DIR / journal
    if not journal_path.exists():
        return []

    skills = []
    for item in journal_path.iterdir():
        if item.is_dir():
            skills.append(item.name)
    return sorted(skills)


def list_journals():
    """List all available journals."""
    journals = get_available_journals()
    if not journals:
        print("No journals found!")
        return

    print(f"\n{'Available Journals':^60}")
    print("=" * 60)

    for i, journal in enumerate(journals, 1):
        skill_count = len(get_journal_skills(journal))
        print(f"{i:3}. {journal:<40} ({skill_count} skills)")

    print("=" * 60)


def load_journal(journal: str) -> bool:
    """Load skills for a specific journal."""
    journals = get_available_journals()

    if journal not in journals:
        print(f"❌ Journal '{journal}' not found!")
        print(f"Available journals: {', '.join(journals[:5])}...")
        return False

    # Get skills for this journal
    skills = get_journal_skills(journal)
    if not skills:
        print(f"❌ No skills found for journal '{journal}'")
        return False

    # Clear existing journal-skills directory
    if JOURNAL_SKILLS_DIR.exists():
        shutil.rmtree(JOURNAL_SKILLS_DIR)
    JOURNAL_SKILLS_DIR.mkdir(parents=True, exist_ok=True)

    # Copy skills files from journals-available to journal-skills
    source_journal_dir = JOURNALS_DIR / journal
    for skill_name in skills:
        src_skill = source_journal_dir / skill_name
        dst_skill = JOURNAL_SKILLS_DIR / skill_name
        if src_skill.exists():
            shutil.copytree(src_skill, dst_skill)

    # Create skill paths (skills already include journal prefix)
    skill_paths = [f"./skills/journal-skills/{skill}" for skill in skills]

    # Load marketplace configuration
    with open(MARKETPLACE_FILE, 'r') as f:
        marketplace = json.load(f)

    # Find or create journal-skills plugin
    journal_plugin = None
    for plugin in marketplace['plugins']:
        if plugin['name'] == 'journal-skills':
            journal_plugin = plugin
            break

    if not journal_plugin:
        journal_plugin = {
            'name': 'journal-skills',
            'description': f'Skills for {journal}',
            'source': './',
            'strict': False,
            'skills': []
        }
        marketplace['plugins'].append(journal_plugin)

    # Update skills list
    journal_plugin['skills'] = skill_paths
    journal_plugin['description'] = f'Collection of skills for {journal} conference/journal submission and review'

    # Save updated configuration
    with open(MARKETPLACE_FILE, 'w') as f:
        json.dump(marketplace, f, indent=2)

    # Save current journal config
    config = {
        'current_journal': journal,
        'skills_count': len(skills),
        'skills': skills
    }

    with open(CONFIG_FILE, 'w') as f:
        json.dump(config, f, indent=2)

    print(f"\n✅ Successfully loaded {len(skills)} skills for {journal}")
    print(f"   Skills: {', '.join(skills[:3])}{'...' if len(skills) > 3 else ''}")
    print(f"\n   Configuration saved to: {MARKETPLACE_FILE}")

    return True


def show_current():
    """Show currently loaded journal skills."""
    if not CONFIG_FILE.exists():
        print("No journal currently loaded")
        return

    with open(CONFIG_FILE, 'r') as f:
        config = json.load(f)

    journal = config.get('current_journal', 'Unknown')
    skills_count = config.get('skills_count', 0)
    skills = config.get('skills', [])

    print(f"\n{'Current Journal Skills':^60}")
    print("=" * 60)
    print(f"Journal: {journal}")
    print(f"Skills Count: {skills_count}")
    print(f"\nSkills:")
    for skill in skills:
        print(f"  - {skill}")
    print("=" * 60)


def interactive_load():
    """Interactive journal selection."""
    journals = get_available_journals()

    if not journals:
        print("No journals available!")
        return False

    list_journals()

    while True:
        try:
            choice = input("\nEnter journal number (or name, or 'q' to quit): ").strip()

            if choice.lower() == 'q':
                return False

            # Try numeric input
            if choice.isdigit():
                idx = int(choice) - 1
                if 0 <= idx < len(journals):
                    journal = journals[idx]
                    return load_journal(journal)
                else:
                    print(f"Invalid number. Please enter 1-{len(journals)}")
            else:
                # Try fuzzy matching
                matches = [j for j in journals if choice.lower() in j.lower()]
                if matches:
                    if len(matches) == 1:
                        return load_journal(matches[0])
                    else:
                        print(f"Multiple matches: {', '.join(matches[:5])}")
                else:
                    print(f"Journal '{choice}' not found")

        except KeyboardInterrupt:
            print("\nCanceled")
            return False
        except Exception as e:
            print(f"Error: {e}")


def main():
    """Main entry point."""
    if len(sys.argv) < 2:
        # Interactive mode
        interactive_load()
    else:
        command = sys.argv[1].lower()

        if command == 'list':
            list_journals()
        elif command == 'current':
            show_current()
        elif command == 'load':
            if len(sys.argv) < 3:
                interactive_load()
            else:
                journal_arg = sys.argv[2]
                # Try exact match first, then case-insensitive
                journals = get_available_journals()
                journal = journal_arg if journal_arg in journals else next(
                    (j for j in journals if j.lower() == journal_arg.lower()), journal_arg
                )
                load_journal(journal)
        else:
            # Try to load as journal name (case-insensitive)
            journals = get_available_journals()
            journal = command.title().replace('-', ' ').replace(' ', '-') if command else command

            # Try exact match
            if journal not in journals:
                # Try case-insensitive match
                journal = next((j for j in journals if j.lower() == command.lower()), command)

            load_journal(journal)


if __name__ == '__main__':
    main()
