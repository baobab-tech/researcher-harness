---
name: perspectives
description: Map the positions on a contested question - who holds each view, the evidence and interests behind it, and whether each disagreement is empirical, definitional, or about values - producing projects/<slug>/outputs/perspectives.md. Use when the user asks for perspectives, viewpoints, stakeholder positions, both sides, the debate on X, or a steelman.
---

# Perspectives

Represent each position as its strongest proponents would, then show what evidence each rests on
and where positions actually conflict. This is a positions map, not a single-author Perspective
article.

Requires `projects/<slug>/brief.md`; run `new-project` first if missing. Output template:
`templates/outputs/perspectives.md`.

1. **Find positions in their holders' own words:** papers, consultation submissions, testimony,
   position papers, filings, official statements. Commentary about a position is a lead, not a
   source. Log searches.
2. **One source file per statement,** `Status: opinion` where the source argues and does not
   measure. Record the holder's funding, membership, and stake in the outcome.
3. **Trace each position's evidence.** For every factual claim a position rests on, fetch the cited
   source and check the claim is in it. Enter each into `claims.md`: `supported`, `contested`, or
   `unsupported`.
4. **Classify each disagreement:** empirical (the positions predict different facts; say what would
   settle it), definitional (they count different things; show the arithmetic), or values (same
   facts, different weights; name the values).
5. **Write** `outputs/perspectives.md` from the template. Apply the same scrutiny to every position,
   including the one that seems right.
6. **Close.** Rebuild `_index.md` and `README.md`, update `_queue.md`, run `scripts/check.sh <slug>`.
