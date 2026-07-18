# Frontmatter Schema

Default field set and ordering used in Phase 2. Treat this as a **starting proposal, not a
mandate** — if the vault already has an established frontmatter convention (visible from
scanning existing notes in Phase 1), adapt to that instead of overwriting it with this schema.
Confirm the final schema with the user before applying it across notes.

## Common fields (all note types)

| Field     | Format                          | Notes                                             |
|-----------|----------------------------------|----------------------------------------------------|
| `title`   | string                           | Defaults to the filename (without extension) if missing. |
| `aliases` | list of strings                  | Omit the key entirely if empty, rather than `aliases: []`, unless the vault's convention keeps empty keys. |
| `tags`    | list of strings                  | See tag normalization rules in `audit-checklist.md`. |
| `date`    | `YYYY-MM-DD`                     | Creation date. Use the file's actual creation metadata from the Obsidian MCP tool if available, rather than guessing. |
| `status`  | one of a small controlled set (e.g. `seed`, `growing`, `evergreen`, or `draft`, `active`, `archived`) | Only add if the user's workflow uses a status concept — don't invent one. |

## Literature note fields (add on top of common fields)

| Field      | Format               | Notes                                                                 |
|------------|----------------------|------------------------------------------------------------------------|
| `citekey`  | string, e.g. `smith2023learning` | Should match the Zotero item's citation key exactly (see `zotero-crosscheck.md`). |
| `authors`  | list of strings, `"Last, First"` | |
| `year`     | integer               | |
| `doi`      | string                | Omit if the work has no DOI (preprints, books) rather than leaving empty. |
| `journal`  | string                | Omit for non-journal sources (books, websites, preprints) — don't force the field. |
| `source-type` | one of `journal-article`, `book`, `preprint`, `website`, `chapter`, etc. | Helps downstream queries/dataview distinguish source types. |

## Proposed field order

```yaml
---
title:
aliases:
tags:
date:
status:
citekey:
authors:
year:
doi:
journal:
source-type:
---
```

Common fields first, literature-specific fields after, omitted fields simply absent (don't pad
with empty values) unless the vault's existing convention does otherwise.

## Applying this in Phase 2

1. For each note, read current frontmatter (if any) via the Obsidian MCP `get_file_contents`-style
   tool.
2. Compute the target frontmatter: keep existing values, fill gaps from defaults where safe
   (e.g. `title` from filename), leave anything requiring judgment (citekey, DOI, authors) for
   Phase 4 if it's a literature note.
3. Show a diff-style preview per batch before writing (old frontmatter block vs. new).
4. Write via the Obsidian MCP patch/update tool, preserving the note body untouched.
5. Log the change in `_format-cleanup-log.md`.
