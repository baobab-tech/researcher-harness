---
name: background-research
description: Fast orientation on an unfamiliar topic - terminology, actors, canonical primary sources, established figures, open disputes - producing projects/<slug>/outputs/briefing.md. Use when the user wants to get up to speed, needs background before deeper work, or asks "what do we know about X".
---

# Background research

Goal: a reader new to the topic can name its terms, actors, data sources, established facts, and
live disputes, and knows where each claim comes from.

Requires `projects/<slug>/brief.md`; run `new-project` first if missing. Output template:
`templates/outputs/briefing.md`.

1. **Map the field.** Two or three broad searches with `scripts/search.sh` (web, OpenAlex, a recent
   review) to find the terms of art, the institutions that produce primary data, the main research
   groups and interested parties, and the reviews or agency reports everyone cites. Log each search
   in `_log.md`. Add the primary sources and distinctions you find to `brief.md`.
2. **Pull the anchors.** For the recent reviews and primary sources: `scripts/doi.sh` to confirm
   the record, `scripts/fetch.sh <url> .cache/NNN.txt` to save the text, then write
   `sources/NNN-*.md` from `templates/source.md`. Aim for 5 to 15 sources; depth on anchors beats
   breadth.
3. **Record claims.** Each figure or statement the briefing will use becomes a row in `claims.md`,
   checked against the cached text.
4. **Find the disputes.** For each contested claim, find who holds each position and check with
   boundary arithmetic whether the disagreement is real (`tools/verification.md`). Mark the claims
   `contested` or `unsupported` as warranted.
5. **Write** `outputs/briefing.md` from the template, citing claim IDs.
6. **Close.** Rebuild `_index.md` and `README.md` from the files that exist, update `_queue.md`,
   run `scripts/check.sh <slug>`.
