---
name: perspectives
description: Map the positions on a contested question - who holds each view, what evidence and interests stand behind it, and where the disagreement is real versus definitional - producing projects/<slug>/outputs/perspectives.md. Use when the user asks for perspectives, viewpoints, stakeholder positions, both sides, the debate on X, or a steelman.
---

# Perspectives

Goal: represent each position as its strongest proponents would, then show what evidence each
rests on and where positions actually conflict.

Requires `projects/<slug>/brief.md`. Run `new-project` first if it does not exist.

## Steps

1. **Identify positions from primary statements.** Find each position in its holders' own words:
   papers, submissions to consultations, testimony, position papers, filings, official statements.
   Commentary about a position is a lead, not a source. Log searches in `_log.md`.

2. **One source file per statement.** `templates/source.md`, with `Type` set appropriately and
   `Status: opinion` where the source argues rather than measures. Record the holder's funding,
   membership, and interest in the outcome.

3. **Trace each position's evidence.** For every factual claim a position rests on, find the
   underlying source and write it up, or record that none is cited. Verify the claim appears in the
   source it cites.

4. **Classify each disagreement:**
   - **Empirical:** the positions predict different facts. Say what evidence would settle it and
     whether it exists.
   - **Definitional:** the positions count different things. Show the boundary arithmetic.
   - **Values:** the positions agree on facts and weigh them differently. Name the values.

5. **Write `outputs/perspectives.md`:**

   ```markdown
   # [Question]: perspectives

   ## Positions
   ### [Position, stated as its holders would]
   **Held by:** [actors, with interests and funding]
   **Strongest argument:** ...
   **Evidence cited:** [links to source files, with whether each claim checked out]
   **Weakest point:** ...

   ## Where they disagree
   | Point | Position A | Position B | Kind | What would settle it |

   ## Common ground
   ## Unsupported claims
   [Claims made by any side that no source supports.]
   ```

   Same scrutiny for every position, including the one that seems right.

6. **Close:** rebuild `_index.md` and `README.md`, update `_queue.md`, run `scripts/check.sh <slug>`.
