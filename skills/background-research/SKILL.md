---
name: background-research
description: Fast orientation on an unfamiliar topic - terminology, actors, canonical primary sources, established figures, and open disputes - producing a briefing in projects/<slug>/outputs/briefing.md. Use when the user wants to get up to speed on a topic, needs background before deeper work, or asks "what do we know about X".
---

# Background research

Goal: a reader who knows nothing about the topic can, after the briefing, name the main terms,
actors, data sources, established facts, and live disputes, and knows where each claim comes from.

Requires `projects/<slug>/brief.md`. Run `new-project` first if it does not exist.

## Steps

1. **Map the field before collecting sources.** Two or three broad searches with `scripts/search.sh` (Serper web, OpenAlex
   sorted by citations, a recent review article) to identify:
   - the terms of art and how they are defined, including terms used inconsistently
   - the institutions that produce primary data (agencies, registries, statistics offices)
   - the main research groups and advocacy or industry bodies
   - the two or three recent reviews or agency reports everyone cites

   Log each search in `_log.md`. Add the canonical primary sources and the distinctions you find to
   `brief.md`.

2. **Pull the anchors.** Retrieve the full text of the recent reviews and the primary agency or
   statutory sources. Write a source file for each (`templates/source.md`), following the hard
   rules in `CLAUDE.md`. Aim for 5 to 15 files; depth on the anchors beats breadth.

3. **Find the disputes.** For each contested figure or claim, identify who holds each position,
   and check with boundary arithmetic whether the disagreement is real (`tools/verification.md`).

4. **Write `outputs/briefing.md`:**

   ```markdown
   # [Topic]: briefing

   ## Terms
   [Term: definition, and where usage varies.]

   ## Who produces the evidence
   [Agencies, datasets, research groups, interested parties, with their funding.]

   ## Established
   | Finding | Value | Boundary | Source |

   ## Contested
   [Each dispute: positions, who holds them, whether it is a real disagreement or a boundary mismatch.]

   ## Gaps
   [What no source establishes.]

   ## Where to go next
   [Sub-questions worth a lit-review or perspectives pass.]
   ```

   Every figure links to its source file.

5. **Rebuild** `_index.md` and `README.md` from the files that exist, update `_queue.md`, and run
   `scripts/check.sh <slug>`.
