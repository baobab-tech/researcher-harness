---
name: policy-brief
description: Policy brief - package the evidence in a project for a named decision-maker as problem, options with their costs and consequences, and implementation considerations, with the human choosing the options and whether to recommend. Produces projects/<slug>/outputs/policy-brief.md. Use when the user asks for a policy brief, evidence brief, briefing note for a decision-maker, options paper, or "what should we do about X".
---

# Policy brief

A product, not a review method: it sits on evidence already gathered (Lavis et al. 2009,
`projects/research-output-types/sources/008-*`). It describes the problem, what is known and not
known about the costs and consequences of options, and implementation considerations, for one
context.

Requires a project with verified sources and claims. If there is none, run `rapid-review` or
`lit-review` first and say so at the intent checkpoint. Output template:
`templates/outputs/policy-brief.md`.

1. **CHECKPOINT: intent.** Ask:
   - who decides, by when, and in what jurisdiction or organisation
   - which options are already on the table, and which are ruled out
   - constraints: budget, legal, political, timing
   - whether the brief presents options only or recommends one (options only is the default)
   - length and format the reader expects

2. **Frame the problem** from the project's claims: size, trend, who is affected, causes. Add local
   evidence (agency data, local reports) as new sources where the project lacks it. Every number
   carries a claim ID.

3. **CHECKPOINT: design, the options.** Propose three options (a familiar convention; adjust to
   the reader's), each a distinct approach, and ask the human to pick, merge, or replace them.

4. **For each option,** from the evidence: what it involves, benefits, harms, costs, how certain the
   evidence is, who gains and who loses, and what is not known. Where options combine, say which
   combinations are coherent.

5. **Implementation considerations:** barriers and enablers for each option in this context, from
   evidence where it exists and marked as judgment where it does not.

6. **CHECKPOINT: sanity check** (`skills/sanity-check/SKILL.md`), weighted to the claims that
   distinguish the options.

7. **Write** `outputs/policy-brief.md` from the template: key messages first, then problem,
   options, implementation, what is not known, method. A recommendation appears only if the human
   chose one at step 1, and it is labelled as a judgment.

8. **CHECKPOINT: draft.** Ask specifically whether any option reads as favoured beyond what its
   evidence supports. Revise, then close as in `lit-review`.
