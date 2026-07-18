# Zotero Cross-Check

Used in Phase 4, only when Zotero MCP tools are available in the session alongside the Obsidian
MCP tools. Skip this file entirely if there's no Zotero connection — do not attempt to guess
bibliographic data without it.

## Matching a literature note to a Zotero item

Try, in order, stopping at the first confident match:

1. **By citekey**, if the note already has a `citekey` frontmatter field — search Zotero for an
   item with that citation key.
2. **By DOI**, if the note has a `doi` field — DOI is the most reliable identifier, prefer it
   over title matching when available.
3. **By title + first author + year**, using the Zotero search tools — treat this as confident
   only when title similarity is high and author/year both agree. A title-only match with no
   author/year corroboration is not confident.

If none of these produce a single confident match, put the note on the "unresolved" list for
Phase 5 rather than picking the closest-looking result.

## Reconciling fields

When a confident match is found, compare the Zotero item's metadata against the note's
frontmatter field by field (`authors`, `year`, `doi`, `journal`, `citekey`):

- **Note field missing, Zotero has it:** fill it in.
- **Note field present and matches Zotero:** leave as-is.
- **Note field present but conflicts with Zotero:** do not silently overwrite. Surface the
  conflict (old value vs. Zotero value) for the user to decide — the note's version may reflect
  a deliberate correction (e.g. a known error in the Zotero record) rather than staleness.
- **Zotero missing a field the note has:** leave the note's value alone; don't delete
  information Zotero doesn't have.

## Citekey formatting

If the vault doesn't already have an established citekey convention, propose Zotero's own
citation key (via Better BibTeX if the user has it, or Zotero's default key) as the canonical
`citekey` value, so it round-trips cleanly with `@citekey` citations elsewhere in the vault.
Confirm the convention with the user before applying it broadly, since changing citekeys after
the fact means updating every note that references the old key.

## Output for Phase 5

Two lists:

- **Reconciled**: notes updated from Zotero, with a short note of which fields changed.
- **Unmatched / conflicting**: notes with no confident Zotero match, or with field conflicts
  that need a human decision — include enough detail (note title, what was tried, what
  conflicted) that the user can resolve each one without re-deriving context.
