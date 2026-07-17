---
name: academic-writing
description: >
  Use when the user asks to polish, revise, de-AI, or improve the prose of a research
  paper, thesis, grant proposal, conference abstract, cover letter to an editor, or
  reviewer response. Also use when a manuscript reads as generic, padded, or "written
  by ChatGPT" and needs to sound like careful scholarly writing. Fixes the real defects
  of AI-drafted academic text (cliché vocabulary, formulaic transitions, empty
  significance-inflation, over-listing, mechanical summaries, assistant-register tics)
  WITHOUT stripping the legitimate conventions of academic prose (calibrated hedging,
  scholarly semicolons, methods-section passive voice, structured contribution lists).
---

# Academic Writing Polish

Turns AI-drafted or flat manuscript text into prose that reads like a careful scholar wrote it.

This is an academic-register adaptation of the general-purpose `humanize` skill. It shares that
skill's diagnosis of what makes AI prose recognizable, but **inverts several of its rules**,
because the generic skill optimizes for a blog/essay voice and treats normal academic
conventions (hedging, semicolons, passive voice, enumerated contributions) as defects. In a
manuscript those are not defects. They are the register.

**What this skill is for:** making the writing genuinely better — clearer, less padded, less
templated — so it reads as considered scholarship. That is the goal, full stop. It is not a
tool for disguising fabricated or wholesale-generated content to slip past integrity review,
and it does not promise any particular score on any AI-detection system. Most journals permit
AI-assisted language editing; nearly all require you to disclose it and hold you responsible
for the content. Keep your use inside your venue's policy.

---

## Two jobs, held in tension

Every edit serves one of two goals. When they conflict, **accuracy and scholarly convention win.**

1. **Remove the AI-writing defects** (Part A). These hurt the paper regardless of detection:
   they make it read as generic, inflated, and unearned.
2. **Preserve the academic conventions** (Part B) that the generic humanize skill would wrongly
   delete. Hedging, passive voice, semicolons, and enumerated contributions are load-bearing in
   scholarly prose.

The failure mode to avoid: over-correcting a manuscript into a punchy first-person blog post.
A methods section that suddenly reads "So I just threw the data at a random forest and it
crushed it" is worse than the AI draft, not better.

---

## Part A — Defects to remove

### A1. Cliché / inflated vocabulary

Academic AI text overuses a recognizable register of empty elevation. Cut or replace:

| AI reflex | Do instead |
|---|---|
| delve into, explore (as filler), leverage (verb), utilize | examine, use, draw on, apply |
| robust (unquantified), comprehensive, holistic | say *what* is robust/complete, or cut |
| pivotal, crucial, vital, paramount, of paramount importance | state the specific consequence instead |
| a myriad of, a plethora of, a wide array of | many, or the actual count |
| shed light on, pave the way for, open new avenues | report the actual finding or implication |
| intricate, multifaceted, nuanced (as decoration) | keep only if you then specify the facets |
| in the realm of, in the landscape of, within the sphere of | in, for, among |
| this study seeks to / endeavors to / aims to delve | "This study examines…" / "We test whether…" |

Do not swap one fancy word for another. The fix for "utilize" is "use", not "employ".

### A2. Significance inflation (the biggest tell in academic AI text)

AI drafts assert importance instead of demonstrating it. Every claim of significance must be
**earned by a specific mechanism, number, or consequence**, or cut.

- "This finding is of paramount importance for the field." → what changes because of it? Say
  that: "This reverses the direction of the effect reported by Chen et al. (2021)."
- "Understanding X is crucial in today's rapidly evolving landscape." → delete the throat-clear;
  open with the actual gap.
- "plays a vital role in", "stands as a testament to", "marks a significant milestone" → replace
  with the concrete relationship: "regulates", "accounts for 38% of the variance", "is required for".

If you cannot name the specific consequence, the sentence is decoration and should go.

### A3. Formulaic transitions and connective overuse

AI text over-signposts. This is a genuine defect **and** a place where academic writing legitimately
uses more connectives than a blog. The rule is calibration, not elimination:

- Delete when the logical relation is already obvious: reflexive "Furthermore," "Moreover,"
  "Additionally," at the head of every paragraph.
- **Keep** connectives that carry real logical weight: "However," (genuine contrast), "Therefore,"
  (actual inference), "In contrast," "Consequently," "Nevertheless." These are correct scholarly
  usage, not tells, when the relation they name is real.
- Test: remove the connective and read the two sentences. If the logic survives unaided, the
  connective was filler — cut it. If the reader would misread the relation without it, keep it.

### A4. Over-structuring and reflexive listing

AI imposes bullet lists and numbered steps on prose that doesn't need them.

- Convert decorative bullet lists back into argued paragraphs where the items are related by
  reasoning, not just co-membership.
- **Exception, and it matters (see B4):** genuinely enumerable content — a set of contributions,
  formal hypotheses (H1, H2, H3), inclusion/exclusion criteria, experimental conditions — is
  *correctly* presented as a list in academic writing. Do not flatten those into prose.
- Cut micro-structure imposed on single paragraphs: the topic-sentence → three-bullet →
  restatement shape.

### A5. Mechanical summary and restatement

- Delete paragraph-final sentences that restate the paragraph's own topic sentence.
- Cut "In conclusion," / "In summary," / "To summarize," as openers. A Discussion or Conclusion
  section is allowed to synthesize — but it should advance interpretation, not recite results
  already stated. A real conclusion says what the results *mean* and what's still open, not
  "In summary, we did X, found Y, and conclude Z."
- Kill the abstract-style recap wedged into the introduction's final paragraph *and* repeated
  again in the discussion. Say each thing once, in its right place.

### A6. RLHF / assistant-register tics

These leak from the chat model into drafts and never belong in a manuscript:

- "It is important to note that", "It is worth noting that", "It should be emphasized that" →
  if the point matters, state it directly; the framing adds nothing.
- "Notably," "Interestingly," "Importantly," as sentence-openers signalling the reader where to
  be impressed → cut; let the finding carry its own weight.
- Balanced "On one hand… on the other hand…" offered reflexively where the evidence actually
  points one way → state where it points.
- "That's a great question", "Certainly", "Of course", "I hope this helps", meta-commentary about
  the writing itself → strip on sight.
- Overly perfect symmetric tricolons and chiasmus ("we tested widely, sampled deeply, and
  analyzed carefully") → academic prose is asymmetric; break the pattern.

### A7. Vague attribution and citation-shaped filler

- "Studies have shown", "Research suggests", "It is widely believed", "Many scholars argue" with
  no citation → name the studies and cite them, or delete the claim. This is both an AI tell and
  a scholarship failure.
- "Recent advances in the field" → which advances, whose, what year.

---

## Part B — Academic conventions to PRESERVE

The generic humanize skill would strip each of these as an "AI tell". In a manuscript, **do not.**

### B1. Calibrated hedging is correct, not a defect

Scientific claims must be scoped to the evidence. Hedging that reflects genuine epistemic limits
is good scientific writing, not softening to cut.

- **Keep:** "These results suggest that…", "may contribute to", "is consistent with", "under the
  conditions tested", "we did not observe", "the data are compatible with". These calibrate a
  claim to what was actually shown.
- **Cut only** the *reflexive institutional* hedge that softens with no epistemic content:
  "it could perhaps be argued that it may in some cases potentially be relevant". That is padding,
  not calibration.
- The test: does the hedge track a real limit of the evidence? Keep it. Does it merely make a
  firm result sound timid? Tighten it. Never convert a properly-scoped "suggests" into an
  overclaiming "proves".

### B2. Passive voice is legitimate in Methods (and sometimes elsewhere)

- **Keep** the passive where the agent is irrelevant or the process is the subject: "Samples were
  incubated at 37 °C for 24 h." "Participants were randomly assigned to conditions." Forcing "We
  incubated the samples" everywhere is a stylistic preference some venues hold, but it is not a
  correctness fix, and many fields prefer the passive in methods.
- **Do** cut passive that only hides responsibility or dodges a claim in the Discussion:
  "mistakes were made", "it was decided". There, active voice is clearer.
- Follow the target journal's convention. Some (e.g. many life-science journals) expect passive
  methods; others (many CS/ML venues) prefer active "We". Match the venue, don't impose one rule.

### B3. Scholarly semicolons and colons are fine

- **Keep** semicolons joining closely related independent clauses, and — importantly — separating
  list items that themselves contain commas: "Group A (n = 24; mean age 31); Group B (n = 27;
  mean age 29)." The generic skill bans semicolons outright; academic prose uses them correctly
  and often.
- **Keep** the colon introducing a list, a definition, or an elaboration after a complete clause.
- Only fix genuinely wrong usage (a semicolon where a comma or period belongs).

### B4. Structured contributions, hypotheses, and criteria stay structured

- Enumerated contribution lists ("Our contributions are threefold: (1)… (2)… (3)…"), formal
  hypotheses (H1–Hn), and inclusion/exclusion criteria are **standard, expected** academic
  structure. Keep them as lists. This is the direct opposite of the generic skill's
  "structural flattening" lever, and the opposite is correct here.

### B5. Discipline-specific terminology stays

- Technical terms of art are not "cliché vocabulary". "Robustness check" in econometrics,
  "ablation" in ML, "confound" in psychology, "in vivo" in biology — keep them. A1's ban on
  "robust" targets the *unquantified adjective* ("a robust framework"), not the methodological
  term "robustness".

### B6. Field register and formality

- Do not inject contractions, rhetorical questions, first-person anecdote, or breezy fragments
  into a manuscript to make it "sound human". The scholarly register *is* the human voice here.
  A careful researcher writing formally is not an AI tell.

---

## Section-by-section calibration

**Abstract.** Cut every "This paper delves into…" opener; open with the problem or the gap. One
clause of background, then aim/method/result/implication. No significance inflation — the result
is the significance. Usually the most padded part of an AI draft; expect to cut 20–30%.

**Introduction.** Kill the "In today's rapidly evolving world" throat-clear. Establish the gap
with real citations (fix A7). Keep the funnel structure (broad → gap → this study) — it's
convention, not a tell. End with a genuine contribution statement, structured if you have
discrete contributions (B4).

**Related work / literature review.** Replace "Studies have shown" filler with named, cited
claims. Vary sentence structure so it doesn't read as a citation list with connective glue.
Group by theme or argument, not one-paragraph-per-paper.

**Methods.** Preserve passive voice and precise, repetitive phrasing (B2) — reproducibility
needs exactness, not literary variety. Do not "add burstiness" here; uniform, precise sentences
are a feature. Keep enumerated procedures and criteria (B4).

**Results.** State findings with calibrated hedging (B1) and specific numbers. Cut "Interestingly"
/ "Notably" openers (A6); let effect sizes and CIs speak. No significance inflation (A2).

**Discussion.** This section *interprets* and is allowed connectives and synthesis. Cut mechanical
result-recitation (A5); keep genuine interpretation, limitations, and hedged implications (B1).
Limitations paragraphs should name real limits, not perform false modesty.

**Cover letters / reviewer responses.** More latitude for direct first person ("We thank the
reviewer…", "We have revised…"). Still cut assistant tics (A6) and inflation (A2). Be specific
about what changed and where (page/line).

---

## Revision protocol

Given a manuscript passage to polish:

1. **Identify the section and target venue** (if stated). Register and passive-voice conventions
   depend on both. If the venue is unknown and it matters, ask once, briefly; otherwise apply the
   field-neutral defaults above and note the assumption at the end.

2. **First pass — remove defects (Part A).** Cut cliché vocabulary, earned-nothing significance
   claims, filler transitions, decorative lists, mechanical restatement, assistant tics, and
   uncited "studies have shown" filler.

3. **Second pass — protect conventions (Part B).** Re-read what you changed. Did you strip a
   properly-scoped hedge into an overclaim? Restore it. Did you flatten a legitimate hypothesis
   list or contributions list? Put it back. Did you rewrite passive methods into forced active
   voice against the field's norm? Revert. Did you inject contractions or a rhetorical question?
   Remove them.

4. **Accuracy gate — the one that outranks everything.** Never change a claim's strength, scope,
   or content to improve the prose. "Suggests" does not become "proves"; "in the mice we tested"
   does not become "in mammals". If a rewrite would alter what the science asserts, keep the
   original wording. **Do not invent citations, numbers, sample sizes, or specifics to satisfy
   A2/A7.** If a claim needs a citation or a number the draft doesn't supply, flag it for the
   author rather than fabricating it.

5. **Output the revised passage only.** Then, if either applies, append after a blank line as
   plain text:
   - a short list of any claims that need a citation or a specific number the author must supply
     (from step 4), and
   - any venue/section assumption you made in step 1.

   No changelog of word swaps, no preamble. If the author wants a tracked-changes view, they'll ask.

---

## What this skill does NOT do

- Guarantee any score on any AI-detection system. That is not the goal and not a claim made here.
- Fabricate citations, data, numbers, or specifics to make claims sound grounded (step 4).
- Change what the science asserts — strength, scope, or content — for the sake of style.
- Convert scholarly prose into a casual first-person voice. The formal register is intentional.
- Override the target journal's style guide. When this skill and the venue's guide conflict, the
  venue wins.

---

## Quick reference: invert these generic-humanize rules for academic text

| Generic humanize rule | Academic override |
|---|---|
| Ban all semicolons | Keep scholarly semicolons, esp. in comma-bearing lists (B3) |
| Ban passive voice | Keep passive in Methods and where the agent is irrelevant (B2) |
| Strip all hedging | Keep evidence-calibrated hedging; cut only empty softeners (B1) |
| Flatten all lists into prose | Keep contribution lists, hypotheses, criteria (B4) |
| Add contractions / first-person / fragments for "voice" | Keep the formal register (B6) |
| Maximize sentence-length variance everywhere | Methods stays uniform and precise; don't force burstiness there |
| Cut all transition words | Keep connectives that name a real logical relation (A3) |

The defect-removal parts (A1, A2, A4-decorative, A5, A6, A7) carry over from the generic skill
unchanged. The overrides above are why a manuscript needs *this* skill and not that one.
