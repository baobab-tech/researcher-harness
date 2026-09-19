---
name: positions-map
description: Map the positions on a contested question - who holds each view, the evidence and interests behind it, and whether each disagreement is empirical, definitional, or about values - with the human checking that each position is fairly stated, producing projects/<slug>/outputs/positions-map.md. Use when the user asks for perspectives, viewpoints, stakeholder positions, both sides, the debate on X, or a steelman.
---

# Positions map

Represent each position as its strongest proponents would, then show what evidence each rests on
and where positions actually conflict. This is a positions map, not a single-author Perspective
article.

Requires `projects/<slug>/brief.md` with intent and design recorded; run `new-project` first if
missing. Output template: `templates/outputs/positions-map.md`.

1. **Find positions in their holders' own words:** papers, consultation submissions, testimony,
   position papers, filings, official statements. Commentary about a position is a lead, not a
   source. Log searches.

2. **CHECKPOINT: early findings.** List the positions found and who holds each. Ask: which
   positions are missing, which holders are mischaracterised, where the human stands (so the map
   can be checked for tilt toward it), and who they know who holds each view.

3. **One source file per statement,** `Status: opinion` where the source argues and does not
   measure. Record the holder's funding, membership, and stake in the outcome.

4. **Trace each position's evidence.** For every factual claim a position rests on, fetch the cited
   source and check the claim is in it. Enter each into `claims.md` as `supported`, `contested`, or
   `unsupported`.

5. **Classify each disagreement:** empirical (say what would settle it), definitional (show the
   arithmetic), or values (name the values).

6. **CHECKPOINT: sanity check.** Run the `sanity-check` skill. Include at least one claim from each
   position, and ask the human whether each position's strongest argument is stated as its holders
   would state it.

7. **Write** `outputs/positions-map.md` from the template, with the same scrutiny for every position.

8. **CHECKPOINT: draft.** Ask specifically whether any position reads weaker or stronger than its
   evidence. Revise.

9. **Close.** Rebuild `_index.md` and `README.md`, run `scripts/check.sh <slug>`, update
   `_queue.md`. **CHECKPOINT: handoff.**
