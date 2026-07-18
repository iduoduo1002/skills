---
name: obsidian-format-management
description: Audits and normalizes formatting across an Obsidian vault via its MCP tools (frontmatter/YAML fields, tag taxonomy, Markdown conventions, wikilinks, file naming) and cross-checks literature notes against a connected Zotero library. Use when the user asks to clean up, standardize, audit, or fix formatting/metadata in Obsidian notes or literature notes, to reconcile Obsidian citation fields with Zotero, or to build a tag/frontmatter convention for a vault. Requires an Obsidian MCP connection (and optionally a Zotero MCP connection) to already be available as tools in the session — check for them first and tell the user how to connect if missing.
---

# Obsidian Format Management

## Overview

This skill audits and normalizes the *formatting* layer of an Obsidian vault — frontmatter,
tags, Markdown conventions, wikilinks, and file names — and, where a Zotero MCP connection is
also available, cross-checks literature notes against Zotero for authors/year/DOI/citekey
accuracy. It does not touch note *content* or opinions expressed in notes, only structure and
metadata.

This is a **write-capable** workflow against the user's real vault. Treat every batch of writes
as a risky, hard-to-reverse action: confirm before writing, never silently rewrite the whole
vault in one shot.

## Step 0: Confirm the tools actually exist

Obsidian and Zotero MCP connections are almost always **local** servers (e.g. Obsidian's Local
REST API plugin on `127.0.0.1:27124`, Zotero's local HTTP server on `localhost:23119`). They
are not always present in every session — a session running in a remote/cloud container
generally cannot reach them at all.

Before doing anything else:

1. Check the current tool list (and `ToolSearch` for deferred tools) for Obsidian tools (e.g.
   `list_files_in_vault`, `get_file_contents`, `search`, `patch_content`, `append_content`) and
   Zotero tools (e.g. item search/get-by-key tools).
2. If Obsidian tools are missing, stop and tell the user: this skill needs an Obsidian MCP
   connection in *this* session (local Claude Code with the vault's Local REST API plugin
   configured, or a remote MCP endpoint reachable from this environment). Do not fabricate
   vault contents or pretend to have made changes.
3. If only Zotero tools are missing, proceed with vault-only formatting work and skip
   `references/zotero-crosscheck.md` (Phase 4), noting the limitation to the user.

## Safety rules (apply for the whole task)

- **Ask about backup once, up front.** Confirm the vault is under version control or otherwise
  backed up before the first write. If not, tell the user and let them decide whether to
  proceed.
- **Read-only audit first, always.** Never modify a note before the user has seen and confirmed
  the audit report in Step 1.
- **Batch, don't blanket-rewrite.** Group changes (e.g. by folder, note type, or fix category)
  and get confirmation per batch rather than writing the entire vault in one pass. For large
  vaults, propose a batch size (e.g. 20–30 notes) and ask before continuing to the next batch.
- **Keep a running changelog note.** Create/append to `_format-cleanup-log.md` in the vault
  (via the Obsidian MCP write tools) recording, per file, what changed and why. This is the
  audit trail if something needs to be reverted.
- **When uncertain, list it, don't guess.** Ambiguous cases (unclear tag merges, broken links
  with no obvious target, notes that don't match any Zotero entry) go into an "unresolved" list
  for the user, never a silent best-effort fix.

## Workflow

### Phase 1 — Audit (read-only)

Use the Obsidian MCP tools to enumerate the vault and classify notes (literature notes /
permanent notes / daily notes / MOCs-indexes / other). Then scan for the format issues listed
in `references/audit-checklist.md` and produce a single report: counts per issue type, plus a
representative file list for each. Present this report and stop — do not proceed to Phase 2
until the user reviews it and says what to fix and in what order.

### Phase 2 — Frontmatter normalization

Apply the field schema in `references/frontmatter-schema.md`: consistent field order, filled-in
defaults by note type, consistent date format. Write in confirmed batches per the safety rules
above.

### Phase 3 — Tags, Markdown, and links

- Normalize tags per `references/audit-checklist.md`'s tag rules (case, separators, hierarchy,
  duplicates). Build an explicit "old tag → new tag" mapping and get it confirmed *before*
  applying it vault-wide — a bad merge is easy to make and tedious to undo.
- Fix Markdown mechanics: heading-level jumps, mixed list bullets, trailing whitespace, stray
  blank lines.
- Find and report broken `[[wikilink]]` targets; fix the unambiguous ones (e.g. the target was
  renamed and there's exactly one plausible match), list the rest for the user.

### Phase 4 — Zotero cross-check (only if Zotero tools are available)

For each literature note, look up the corresponding Zotero item (by citekey, title, or DOI) and
reconcile authors/year/DOI/journal/citekey against it. Follow
`references/zotero-crosscheck.md` for the matching and conflict-resolution approach. Notes with
no confident Zotero match go on a separate list — do not invent bibliographic data.

### Phase 5 — Wrap-up

Summarize: files touched, issues fixed by category, what's left in the "unresolved" lists, and
the path to `_format-cleanup-log.md`.

## References

- `references/audit-checklist.md` — the full list of format issues to detect in Phase 1, and
  the normalization rules used in Phase 3 (tags, Markdown, links, file names).
- `references/frontmatter-schema.md` — the YAML frontmatter field set, ordering, and per-note-type
  defaults used in Phase 2. If the user already has their own frontmatter convention, adapt this
  schema to match theirs rather than imposing it.
- `references/zotero-crosscheck.md` — how to match literature notes to Zotero items and resolve
  conflicts in Phase 4.
