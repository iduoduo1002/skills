# CLAUDE.md - AI Assistant Guide for Skills Repository

## Repository Overview

This is the **Anthropic Skills Repository**, which contains Anthropic's implementation of skills for Claude. Skills are folders of instructions, scripts, and resources that Claude loads dynamically to improve performance on specialized tasks.

**Key Links:**
- Agent Skills Specification: https://agentskills.io/specification
- Public Documentation: https://support.claude.com/en/articles/12512176-what-are-skills

**Repository Purpose:**
- Demonstrate what's possible with Claude's skills system
- Provide reference implementations for skill development
- Showcase patterns ranging from creative applications to enterprise workflows
- House the document creation & editing skills that power Claude's document capabilities

**License Structure:**
- Many skills are open source (Apache 2.0)
- Document skills (docx, pdf, pptx, xlsx) are source-available but not open source
- Each skill contains its own LICENSE.txt file

## Repository Structure

```
skills/
├── README.md                     # Main repository documentation
├── THIRD_PARTY_NOTICES.md        # Third-party license attributions
├── CLAUDE.md                     # This file - AI assistant guide
├── .gitignore                    # Git ignore patterns
├── .claude-plugin/              # Claude Code plugin configuration
│   └── marketplace.json         # Plugin marketplace definitions
├── spec/                        # Agent Skills specification
│   └── agent-skills-spec.md     # Reference to agentskills.io
├── template/                    # Skill template for new skills
│   └── SKILL.md                 # Minimal skill template
└── skills/                      # All skill implementations
    ├── algorithmic-art/         # Creative algorithmic art generation
    ├── brand-guidelines/        # Anthropic brand styling
    ├── canvas-design/           # Canvas-based design tools
    ├── doc-coauthoring/         # Document collaboration guidelines
    ├── docx/                    # Word document processing (source-available)
    ├── frontend-design/         # Frontend design patterns
    ├── internal-comms/          # Internal communication templates
    ├── mcp-builder/             # MCP (Model Context Protocol) server builder
    ├── pdf/                     # PDF processing (source-available)
    ├── pptx/                    # PowerPoint processing (source-available)
    ├── skill-creator/           # Meta-skill for creating new skills
    ├── slack-gif-creator/       # Slack GIF generation
    ├── theme-factory/           # Theme creation and styling
    ├── web-artifacts-builder/   # Web artifact bundling
    ├── webapp-testing/          # Playwright-based web testing
    └── xlsx/                    # Excel spreadsheet processing (source-available)
```

## Skill Anatomy

Every skill follows a standardized structure:

### Required Files

**SKILL.md** (mandatory)
- Contains YAML frontmatter with required fields:
  - `name`: kebab-case identifier (e.g., "skill-creator")
  - `description`: Complete description of what the skill does and when to use it
  - `license`: License reference (usually "Complete terms in LICENSE.txt")
- Contains markdown body with instructions, examples, and guidelines
- Only loaded AFTER the skill triggers based on name/description matching

**LICENSE.txt** (standard practice)
- Contains license terms for the skill
- Present in all skills except the minimal template

### Optional Resource Directories

**scripts/** - Executable code
- Python scripts (.py), shell scripts (.sh), or JavaScript (.js)
- Used for deterministic, repeated operations
- May be executed without loading into context
- Example: `scripts/rotate_pdf.py`, `scripts/with_server.py`

**references/** or **reference/** - Documentation
- Markdown files with detailed reference material
- Loaded into context only when Claude determines it's needed
- Keeps SKILL.md lean while providing detailed information
- Examples: `references/schema.md`, `references/api_docs.md`

**assets/** - Output resources
- Files used in generated output, not loaded into context
- Templates, images, icons, boilerplate code, fonts
- Examples: `assets/logo.png`, `assets/template.pptx`

**examples/** - Sample implementations
- Example code or configuration files
- Demonstrates usage patterns

**themes/** or **templates/** - Content collections
- Pre-defined themes or template files
- Skill-specific naming based on purpose

### Skill Structure Patterns

**Pattern 1: Minimal** (4 skills)
```
skill-name/
├── SKILL.md
└── LICENSE.txt
```
Used by: brand-guidelines, doc-coauthoring, frontend-design, xlsx

**Pattern 2: Simple** (6 skills)
```
skill-name/
├── SKILL.md
├── LICENSE.txt
└── [single-directory]/  # examples/, themes/, scripts/, etc.
```
Used by: internal-comms, theme-factory, slack-gif-creator, canvas-design, algorithmic-art

**Pattern 3: Dual-Directory** (5 skills)
```
skill-name/
├── SKILL.md
├── LICENSE.txt
├── references/
├── scripts/
└── [optional-files]
```
Used by: mcp-builder, skill-creator, docx, pptx, webapp-testing

**Pattern 4: Complex Nested** (docx/pptx)
```
skill-name/
├── SKILL.md
├── LICENSE.txt
├── [reference-files].md
├── scripts/
│   ├── *.py
│   └── templates/
└── ooxml/
    ├── scripts/validation/
    └── schemas/
```

## Development Workflow

### Creating a New Skill

Follow the skill creation process from `skills/skill-creator/SKILL.md`:

**Step 1: Understand the Skill**
- Gather concrete examples of how the skill will be used
- Identify specific scenarios, file types, or tasks that trigger it
- Ask clarifying questions about functionality

**Step 2: Plan Reusable Contents**
- Analyze examples to identify reusable resources
- Determine what scripts, references, and assets would be helpful
- Consider token efficiency and context window usage

**Step 3: Initialize the Skill**
```bash
python skills/skill-creator/scripts/init_skill.py <skill-name> --path skills/
```
This creates:
- Skill directory with template SKILL.md
- Example directories: scripts/, references/, assets/
- TODO placeholders for customization

**Step 4: Implement the Skill**
- Create reusable resources first (scripts, references, assets)
- Test all scripts by running them
- Delete unused example files
- Write SKILL.md following conventions
- Keep SKILL.md under 500 lines (split into references if longer)

**Step 5: Package the Skill**
```bash
python skills/skill-creator/scripts/package_skill.py <path/to/skill-folder> [output-dir]
```
This will:
- Validate YAML frontmatter and structure
- Check naming conventions and file organization
- Create a .skill file (zip with .skill extension) if validation passes

**Step 6: Iterate**
- Test skill on real tasks
- Identify struggles or inefficiencies
- Update SKILL.md or resources
- Repackage and test again

### Validating a Skill

Quick validation without packaging:
```bash
python skills/skill-creator/scripts/quick_validate.py <path/to/skill-folder>
```

## Key Conventions

### Naming Conventions

**Skill Names:**
- Use lowercase kebab-case: `skill-name`
- Must match directory name
- Should reflect primary functionality

**Directory Names:**
- `scripts/` - executable code
- `references/` or `reference/` - documentation
- `assets/` - output resources
- `examples/` - sample implementations
- `templates/` - template files
- `themes/` - thematic content

**File Names:**
- Python: snake_case (e.g., `convert_pdf_to_images.py`)
- Markdown: lowercase (e.g., `reference.md`, `forms.md`)
- Shell scripts: kebab-case (e.g., `bundle-artifact.sh`)

### SKILL.md Format

Always follow this structure:

```markdown
---
name: skill-name
description: Complete description including what it does and when to use it. Be specific about triggers, file types, and scenarios.
license: Complete terms in LICENSE.txt
---

# Skill Title

## Overview
[1-2 sentences explaining what this skill enables]

## [Section 1]
[Instructions, examples, guidelines]

## [Section 2]
[More content as needed]
```

**Critical Guidelines:**
- Use imperative/infinitive form in instructions
- Include trigger conditions in `description`, not in body
- Keep body under 500 lines
- Reference bundled resources clearly
- Avoid deeply nested references (keep one level deep)
- Include table of contents for files >100 lines

### Progressive Disclosure

Skills use three-level loading:
1. **Metadata** (name + description) - Always in context (~100 words)
2. **SKILL.md body** - When skill triggers (<5k words)
3. **Bundled resources** - As needed by Claude (variable)

**Best Practices:**
- Keep SKILL.md concise - challenge every paragraph
- Move detailed information to reference files
- Link to references with clear "when to use" guidance
- Default assumption: Claude is already smart, add only what's unique

### Documentation Standards

**What to Include:**
- Essential procedural knowledge
- Domain-specific details
- Workflow guidance
- Examples demonstrating usage

**What to Exclude:**
- README.md files
- INSTALLATION_GUIDE.md
- QUICK_REFERENCE.md
- CHANGELOG.md
- Setup and testing procedures
- User-facing documentation

Keep only what an AI agent needs to execute the task.

## Git Workflow

### Branch Naming

When working on features, use branches with this pattern:
```
claude/[descriptive-name]-[SESSION_ID]
```

**CRITICAL:** Branch names MUST start with `claude/` and end with the matching session ID, or push will fail with 403 error.

### Standard Git Operations

**Checking Status:**
```bash
git status
git diff
git log --oneline -10
```

**Creating Feature Branch:**
```bash
git checkout -b claude/add-new-skill-ABC123
```

**Committing Changes:**
```bash
# View changes
git status
git diff

# Stage files
git add path/to/files

# Commit with descriptive message
git commit -m "Add new skill for X functionality

- Created SKILL.md with instructions
- Added helper scripts for Y
- Included reference documentation"
```

**Pushing Changes:**
```bash
# Push with upstream tracking
git push -u origin claude/branch-name-ABC123

# Retry on network failures (up to 4 times with exponential backoff: 2s, 4s, 8s, 16s)
```

**Creating Pull Request:**
```bash
# After pushing, create PR
gh pr create --title "Add new skill" --body "$(cat <<'EOF'
## Summary
- Brief description of changes

## Test plan
- [ ] Validated SKILL.md format
- [ ] Tested scripts
- [ ] Packaged successfully
EOF
)"
```

### Git Safety Protocols

**NEVER:**
- Update git config
- Run destructive commands (force push, hard reset) without explicit user request
- Skip hooks (--no-verify, --no-gpg-sign)
- Force push to main/master
- Commit files with secrets (.env, credentials.json)
- Use git commands with -i flag (interactive mode not supported)

**ALWAYS:**
- Check current branch before committing
- Review diff before committing
- Use descriptive commit messages
- Push to feature branches, not main

## Common Tasks

### Exploring the Repository

**Find skills by pattern:**
```bash
# List all skills
ls -la skills/

# Find SKILL.md files
find skills/ -name "SKILL.md"

# Search for specific content
grep -r "pattern" skills/ --include="*.md"
```

**Analyze skill structure:**
```bash
# View specific skill
ls -la skills/skill-name/

# Read SKILL.md
cat skills/skill-name/SKILL.md
```

### Working with Skills

**Test a skill locally:**
1. Read SKILL.md to understand requirements
2. Check for scripts in scripts/ directory
3. Run scripts with --help first
4. Test functionality as described

**Update an existing skill:**
1. Read current SKILL.md and resources
2. Identify what needs to change
3. Update files following conventions
4. Validate with quick_validate.py
5. Package with package_skill.py
6. Test thoroughly

### Plugin Development

**Marketplace Configuration:**
The `.claude-plugin/marketplace.json` file defines plugin sets:
- `document-skills`: xlsx, docx, pptx, pdf
- `example-skills`: All other skills

**Adding skill to plugin:**
Edit `marketplace.json` to add skill path to appropriate plugin's `skills` array.

## AI Assistant Guidelines

### When Working in This Repository

**DO:**
- Read SKILL.md files completely before making changes
- Follow the skill creation process in order
- Use the initialization and packaging scripts
- Keep SKILL.md concise (under 500 lines)
- Test scripts before adding them
- Follow naming conventions strictly
- Include clear descriptions in frontmatter
- Reference bundled resources explicitly
- Validate before packaging

**DON'T:**
- Create extraneous documentation (README, etc.)
- Duplicate information between SKILL.md and references
- Make SKILL.md overly verbose
- Skip validation steps
- Commit without testing
- Force push or use destructive git commands
- Add unnecessary files to skills

### Token Efficiency

Remember: **The context window is a public good.**

- Challenge every paragraph: "Does Claude really need this?"
- Prefer concise examples over verbose explanations
- Split large SKILL.md files into references
- Use progressive disclosure patterns
- Default assumption: Claude is smart, add only what's unique

### Code Quality Standards

**For Scripts:**
- Test by running them before committing
- Include --help output for usability
- Use clear, descriptive names
- Add minimal comments (code should be self-documenting)
- Handle errors appropriately

**For Documentation:**
- Use imperative form
- Provide concrete examples
- Link to external references
- Keep it scannable with headers

**Security:**
- No command injection vulnerabilities
- No XSS, SQL injection, or OWASP top 10 issues
- Validate at system boundaries only
- Don't add unnecessary error handling

## Reference Information

### Key Files Locations

- Skill template: `template/SKILL.md`
- Init script: `skills/skill-creator/scripts/init_skill.py`
- Package script: `skills/skill-creator/scripts/package_skill.py`
- Validate script: `skills/skill-creator/scripts/quick_validate.py`
- Marketplace config: `.claude-plugin/marketplace.json`

### External Documentation

- Agent Skills Specification: https://agentskills.io/specification
- What are skills: https://support.claude.com/en/articles/12512176-what-are-skills
- Using skills in Claude: https://support.claude.com/en/articles/12512180-using-skills-in-claude
- Creating custom skills: https://support.claude.com/en/articles/12512198-creating-custom-skills
- Blog post: https://anthropic.com/engineering/equipping-agents-for-the-real-world-with-agent-skills

### Skill Categories

**Creative & Design:**
- algorithmic-art, canvas-design, frontend-design, theme-factory

**Development & Technical:**
- mcp-builder, skill-creator, webapp-testing, web-artifacts-builder

**Enterprise & Communication:**
- brand-guidelines, doc-coauthoring, internal-comms, slack-gif-creator

**Document Processing (Source-Available):**
- docx, pdf, pptx, xlsx

## Current Repository State

**Branch:** claude/add-claude-documentation-CDTUw
**Status:** Clean working directory
**Recent commits:**
- 69c0b1a: Add link to Agent Skills specification website
- be229a5: Fix links in agent skills specification
- f232228: Split agent-skills-spec into separate guides
- 0075614: Add doc-coauthoring skill and update example skills
- ef74077: Move example skills into dedicated folder

**Total Skills:** 16 (12 open source + 4 source-available document skills)

## Troubleshooting

### Common Issues

**Validation fails:**
- Check YAML frontmatter format (name, description required)
- Verify skill name matches directory name
- Ensure description is complete and informative
- Check file organization matches conventions

**Script execution fails:**
- Verify Python/shell interpreter available
- Check file permissions (should be executable)
- Review script dependencies (requirements.txt)
- Test with --help first

**Git push fails with 403:**
- Verify branch starts with `claude/`
- Verify branch ends with correct session ID
- Retry with exponential backoff on network errors

**Context window concerns:**
- Split large SKILL.md into reference files
- Move detailed documentation to references/
- Use progressive disclosure patterns
- Keep SKILL.md under 500 lines

---

**Last Updated:** 2026-01-18
**Repository:** anthropics/skills
**Purpose:** Guide AI assistants working with the Skills repository
