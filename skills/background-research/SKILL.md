---
name: background-research
description: Fast orientation on an unfamiliar topic - terminology, actors, canonical primary sources, established figures, open disputes - producing projects/<slug>/outputs/briefing.md, with the human checking direction and claims along the way. Use when the user wants to get up to speed, needs background before deeper work, or asks "what do we know about X".
---

# Background research

Goal: a reader new to the topic can name its terms, actors, data sources, established facts, and
live disputes, and knows where each claim comes from.

Requires `projects/<slug>/brief.md` with intent and design recorded; run `new-project` first if
missing. Output template: `templates/outputs/briefing.md`.

1. **Map the field.** Two or three broad searches with `scripts/search.sh` to find terms of art,
   the institutions that produce primary data, the main research groups and interested parties,
   and the reviews or agency reports everyone cites. Log each search.

2. **CHECKPOINT: early findings** (involvement high or standard: fold into the next checkpoint if
   light). Show the map: terms, actors, the 5 to 15 anchor sources you plan to read. Ask which are
   missing, which they distrust, and whether any sub-question should change.

3. **Pull the anchors.** `scripts/doi.sh` to confirm the record, `scripts/fetch.sh <url>
   .cache/NNN.txt` to save the text, then `sources/NNN-*.md` from `templates/source.md`. Include
   anything in `inputs/`.

   Anything you cannot retrieve goes to the human, batched, with what it would settle
   (`AGENTS.md`, When a source cannot be retrieved).

4. **Record claims** in `claims.md`, one block each with scope, period, attribution, kind, and the
   quote from the cached text (Claims ledger, `AGENTS.md`).

5. **Find the disputes.** For each contested claim, find who holds each position and check with
   boundary arithmetic whether the disagreement is real (`tools/verification.md`). Anything that
   contradicts the human's stated priors: stop and tell them before writing it up.

6. **CHECKPOINT: sanity check.** Run the `sanity-check` skill.

7. **Write** `outputs/briefing.md` from the template, citing claim IDs, with the Human review
   section filled.

8. **CHECKPOINT: draft.** Ask about framing, emphasis, anything stated too strongly, anything
   missing. Revise.

9. **Close.** Rebuild `_index.md` and `README.md`, run `scripts/check.sh <slug>`, update
   `_queue.md`. **CHECKPOINT: handoff.** Propose next steps (a lit review or positions map on a
   sub-question) and list what is waiting on them.
