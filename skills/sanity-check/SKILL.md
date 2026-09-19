---
name: sanity-check
description: Prepare a spot-check packet of claims for the human to verify against the sources before any output is written or shared, then record their answers in claims.md. Use at the sanity-check checkpoint of every skill, before sharing any output, or when the user asks to check the findings.
---

# Sanity check

The human verifies a sample of claims against the sources themselves. This catches what automated
checks miss: a number read from the wrong table, a boundary misstated, a framing the source would
not sign.

1. **Pick claims** from `claims.md`, 5 to 10, covering:
   - **load-bearing:** cited most often, or the answer depends on them
   - **surprising:** contradict common belief or the human's priors in `brief.md`
   - **contested** or **derived:** status `contested`, or computed from the source's inputs
   - **one per source type**, so no class of evidence goes unchecked

2. **Build the packet** at `outputs/_sanity-check.md` from `templates/sanity-check.md`. For each
   claim: the statement, a direct link (with page or section), and the exact quote from the cached
   text that supports it. A claim you cannot quote is not ready; fix it first.

3. **CHECKPOINT: sanity check.** Send the packet with the framing questions from the template.

4. **Record answers** in the `Human` column of `claims.md`: `confirmed YYYY-MM-DD`, `wrong`, or
   `unsure`. For `wrong`: fix the source file and claim, then re-check every output citing it. For
   `unsure`: say in the output that the claim was queried. Log the check in the Decisions table of
   `brief.md`.

5. If no human answers, leave `Human` blank and state in the output's Human review section that no
   claims were human-checked.
