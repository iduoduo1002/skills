# Vault Structure Advisory (optional, opt-in)

This file is **advisory, not part of the default Phase 1–5 auto-write workflow**. Formatting
fixes (frontmatter, tags, Markdown, wikilinks) are low blast-radius and safe to batch-apply with
confirmation. Restructuring folders, splitting/merging notes, or introducing a new
organizational scheme is a much bigger intervention — it touches many files at once and is
harder to reason about incrementally. Only act on this file if the user explicitly asks for
structural/organizational advice, not as an automatic add-on to a formatting cleanup request.

## Recommend, don't impose

Present these as options with tradeoffs, not a rewrite plan. If the vault already has a working
structure (even an idiosyncratic one), the default recommendation is to formalize and clean up
what's already there rather than migrate to a different system — a migration is disruptive and
often not worth it for a vault that's already functional.

## Folder structure: PARA as a default starting point

If the user has no structure yet or wants a rethink, **PARA** (Projects / Areas / Resources /
Archives) is a reasonable default for the top level:

- **Projects** — active work with a defined outcome and end date.
- **Areas** — ongoing responsibilities with no end date (health, finances, a role).
- **Resources** — reference material and other people's ideas (this is where literature notes
  typically live).
- **Archives** — anything from the above that's no longer active; move here, don't delete.

Keep nesting shallow — **more than 3–4 folder levels deep is usually a sign to use links/tags
instead of more folders.** Links and tags scale better than deep folder trees; folders answer
"where does this belong," tags answer "what is this about." A note generally belongs in exactly
one folder but can carry several tags.

## Zettelkasten-style permanent notes, if the user does synthesis work

For users doing research/writing synthesis (not just reference storage), a **Zettelkasten**
layer complements PARA rather than replacing it:

- **Literature notes** (in Resources) capture what a source says — these are what
  `zotero-crosscheck.md` operates on.
- **Permanent/evergreen notes** hold the user's own synthesized ideas, atomic (one idea per
  note), densely linked to each other. Keep these structurally distinct from literature notes
  (different folder or a `source-type` value) since they serve different purposes: literature
  notes are attributed to someone else, permanent notes are the user's own thinking.

## Maps of Content (MOCs): let them emerge, don't pre-build

A MOC is an index note that links out to a cluster of related notes — like a hand-curated
category page. **Don't create MOCs upfront.** The right moment is when the user notices they
have several notes on the same topic and can't find them easily — that's the signal to build a
MOC, not a decision made in advance. Suggest a MOC when the audit in Phase 1 turns up a cluster
of same-topic notes with no existing index linking them.

## Property types: configure once, not per-note

Obsidian's **Properties** feature (Settings → Properties view) lets the user define a field's
type globally — e.g. `date` is always type `date`, `rating` is always type `number`. Once set,
every note using that key inherits the type, which is what makes the field reliably sortable
and filterable (e.g. via Dataview). If the vault's frontmatter fields aren't typed yet, suggest
setting the types for the fields introduced by `frontmatter-schema.md` once, rather than
relying on every individual note being written with the right literal YAML type by hand.

## Prefer the vault's own automation over one-off fixes

Before treating formatting cleanup as a one-time pass, check whether the vault already has (or
would benefit from) plugins that make the fix durable instead of a single cleanup event:

- **Templater** — pre-populates frontmatter correctly at note-creation time, so new notes don't
  drift out of format again after this cleanup.
- **Linter** — auto-normalizes frontmatter field order and basic Markdown mechanics on save.
- **Dataview** — powers maintenance queries (see below) the user can re-run themselves later,
  rather than needing another full audit pass.

If these plugins are already installed (visible from the vault's `.obsidian/plugins/` via the
Obsidian MCP file-listing tool, or from existing Templater/Linter config files), prefer
suggesting a template/rule addition over repeating manual fixes. If they aren't installed,
mention them as an option rather than assuming the user wants new plugins added.

## Maintenance queries (Dataview)

If the Dataview plugin is present, these queries help the user self-service future audits
without going through this whole skill again. Offer to write them into a maintenance note
(e.g. `_vault-maintenance.md`) rather than running a one-off scan each time:

Orphan notes (no incoming or outgoing links):
```dataview
LIST
FROM ""
WHERE length(file.inlinks) = 0 AND length(file.outlinks) = 0
SORT file.mtime DESC
```

Stale AND orphaned (the combination worth flagging — stale alone is not inherently a problem):
```dataview
LIST file.mtime
FROM ""
WHERE length(file.inlinks) = 0 AND date(today) - file.mtime > dur(180 days)
SORT file.mtime ASC
```

Dangling links (links pointing to notes that don't exist) generally need a script/plugin (e.g.
the "Dangling Links" or "Vault Inspector" community plugins) rather than a pure Dataview query,
since Dataview only sees existing files. Mention this as a plugin recommendation if the user
wants ongoing dangling-link detection rather than a single audit pass.

## Safe renaming

Before doing any file-naming cleanup (`audit-checklist.md` §5), confirm the user has **Settings
→ Files & Links → "Automatically update internal links"** enabled. With it on, renaming or
moving a file through Obsidian (or the MCP rename/move tool, if the connected server exposes
one) updates all wikilinks pointing to it automatically. Without it, treat renames as high-risk
and prefer leaving the filename alone over manually rewriting every link.
