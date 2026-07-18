# Audit Checklist

Used in Phase 1 (detection) and Phase 3 (normalization rules) of the main workflow.

## 1. Frontmatter issues

For every note, check:

- Missing frontmatter block entirely (common in quick-captured notes).
- Missing fields expected for the note's type (see `frontmatter-schema.md`).
- Inconsistent field naming for the same concept (`tag` vs `tags`, `date` vs `created`,
  `author` vs `authors`).
- Inconsistent value formats: dates not in `YYYY-MM-DD`, `tags` as a single string instead of a
  list, booleans written as `"true"`/`"false"` strings instead of YAML booleans.
- Field order varies note-to-note (cosmetic, but worth normalizing for scanability).

Report grouped by note type, with counts and a sample of affected file paths (don't dump every
path into the report — link out or offer to list on request if the count is large).

## 2. Tag issues

- Case inconsistency: `#Research` vs `#research`.
- Separator inconsistency: `#machine-learning` vs `#machine_learning` vs `#MachineLearning`.
- Near-duplicate tags that should merge: `#todo` / `#to-do` / `#TODO`.
- Flat tags that should be hierarchical, or vice versa: `#ml` sitting alongside
  `#area/ml/nlp` when it's clearly the same topic.
- Same tag present both in frontmatter `tags:` and as an inline `#tag` in the body — decide
  with the user which is canonical, don't just delete one.

**Normalization rule of thumb:** lowercase, hyphen-separated, hierarchical with `/` where a
clear parent/child relationship exists (e.g. `area/health`, `project/thesis`). Always produce
the full old→new mapping and get it confirmed before a vault-wide rename — tag renames are easy
to get wrong and tedious to undo one note at a time.

## 3. Markdown mechanics

- Heading level skips (`#` straight to `###`).
- Mixed list bullet characters (`-`, `*`, `+`) within the same document or across the vault.
- Trailing whitespace, multiple consecutive blank lines.
- Inconsistent emphasis markers (`_italic_` vs `*italic*`, `__bold__` vs `**bold**`).
- Mixed-language punctuation in prose (e.g. full-width `，。` mixed with half-width `,.` in the
  same sentence) if the vault is in a language where this matters.

These are generally safe to auto-fix in batches without per-file confirmation, as long as the
user has approved the rule set in Phase 1's report.

## 4. Wikilinks

- `[[Link]]` targets that don't resolve to any file in the vault (broken links).
- Links pointing to an old name after a file was renamed, where exactly one existing file is a
  plausible rename target — safe to auto-fix.
- Links with ambiguous or no plausible target — list for the user, don't guess.
- Orphaned notes: no other note links to them, and they don't appear in any MOC/index. Not
  necessarily a "bug" on its own — flag it, don't auto-fix it. It's worth escalating to the user
  specifically when a note is **both** orphaned and stale (unmodified for a long stretch,
  e.g. 180+ days): that combination is a much stronger "this got lost" signal than either alone.
  If the vault has Dataview, `vault-structure-advisory.md` has ready-to-use queries for both
  checks that the user can keep re-running after this audit.
- Alias mismatches: a link's display text via `[[Target|Alias]]` doesn't match any `aliases:`
  entry on the target note, when the vault otherwise uses `aliases:` consistently.

## 5. File naming

- Inconsistent casing or spacing conventions across the vault (only flag if the vault already
  has a clear dominant convention — don't invent one unprompted).
- Date-stamped notes (daily notes, meeting notes) with inconsistent date formats in the
  filename.
- Special characters that cause link/search friction (e.g. `:`, `/` outside of folder
  structure).

File renames change wikilink targets throughout the vault — always confirm with the user before
renaming, and rely on the Obsidian MCP tools' native rename/move operation (if available) so
internal links update automatically, rather than manually rewriting every link.
