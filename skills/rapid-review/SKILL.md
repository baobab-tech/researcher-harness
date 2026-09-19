---
name: rapid-review
description: Rapid review - a systematic review with shortcuts agreed with the human in advance and declared in the output, for a decision that cannot wait. Produces projects/<slug>/outputs/rapid-review.md. Use when the user needs an evidence answer by a deadline, asks for a rapid review, rapid evidence assessment, or quick but defensible evidence summary.
---

# Rapid review

"A form of knowledge synthesis that accelerates the process of conducting a traditional systematic
review through streamlining or omitting various methods" (Cochrane Rapid Reviews Methods Group,
Garritty et al. 2021). The defining feature is negotiation with the person who needs the answer
(Sutton et al. 2019). Basis: `projects/research-output-types/sources/006-*` and `002-*`.

Requires `projects/<slug>/brief.md`; run `new-project` first if missing. Output template:
`templates/outputs/rapid-review.md`. Shared mechanics follow `skills/lit-review/SKILL.md`.

1. **CHECKPOINT: design, with the shortcut menu.** Establish the deadline and the decision the
   answer feeds. Then offer shortcuts as a multi-select question, each with its risk:

   | Shortcut | Risk |
   |----------|------|
   | limit to recent years | loses older studies; can change pooled results |
   | limit languages or settings | misses evidence from excluded contexts |
   | fewer databases | misses studies indexed elsewhere |
   | start from existing systematic reviews, then update | inherits their scope and errors |
   | skip grey literature, or search it last | misses unpublished and agency evidence |
   | narrow outcomes to those the decision needs | other effects go unreported |
   | single-pass extraction with verification of a sample | extraction errors survive |

   Record every chosen shortcut, with its reason, in `brief.md`. The output lists them all.

2. **Search and screen** within the agreed limits. Title and abstract screening is done twice, not
   once: the Cochrane group recommends against single-reviewer screening. Here the second pass is
   an independent subagent screening the same records without seeing the first pass's decisions;
   disagreements go to the human at the next checkpoint.

3. **CHECKPOINT: early findings.** Report counts, the screening disagreements for the human to rule
   on, and whether the evidence is on track to answer the question by the deadline. Offer to cut
   scope further if not.

4. **Extract** into source files and claims. Risk of bias: one pass, verified by a second (the
   Cochrane group recommends one reviewer with another verifying all judgments), limited to the
   outcomes the decision needs.

5. **Certainty.** Grade certainty per outcome with GRADE, as Cochrane recommends for rapid reviews,
   and record it in the claims (Context field).

6. **CHECKPOINT: sanity check** (`skills/sanity-check/SKILL.md`), then **write**
   `outputs/rapid-review.md`: answer first, shortcuts and their risks, evidence by outcome with
   certainty, what the shortcuts may have missed.

7. **CHECKPOINT: draft**, then close as in `lit-review`.
