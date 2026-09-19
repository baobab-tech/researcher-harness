---
name: scoping-review
description: Scoping review - map what evidence exists on a topic, its types, concepts, and gaps, without appraising quality or answering an effectiveness question, following Arksey and O'Malley's stages with the human as the consultation stage. Produces projects/<slug>/outputs/scoping-review.md. Use when the user asks for a scoping review, a map of the literature, what research exists on X, how X is defined or studied, or whether a systematic review is feasible.
---

# Scoping review

Maps a body of evidence: what exists, what kinds, how concepts are defined, how research is done,
where the gaps are. It does not appraise study quality, so it cannot say what works or find gaps
where existing research is poor; say so in the output. Basis: Arksey and O'Malley (2005), Munn et
al. (2018), in `projects/research-output-types/sources/004-*` and `005-*`.

Requires `projects/<slug>/brief.md`; run `new-project` first if missing. Output template:
`templates/outputs/scoping-review.md`. Shared mechanics (searching, screening, source files,
claims) follow `skills/lit-review/SKILL.md`; the differences are below.

1. **CHECKPOINT: design.** Agree with the human:
   - **purpose**, one or more of: types of evidence in a field; key concepts or definitions; how
     research is conducted; key characteristics of a concept; feasibility of a systematic review;
     knowledge gaps
   - **question** stated as population, concept, and context
   - **charting fields**: what to record from every source (for example design, population,
     setting, definition used, outcomes measured, country, year)
   - **breadth**: databases, grey literature, date window, languages

2. **Search** broadly and iteratively; refine terms as the vocabulary of the field becomes clear.
   Log every query and every refinement.

3. **Screen** against the criteria, keeping counts for the flow table. Borderline sources go to the
   human.

4. **Pilot the charting** on 3 to 5 sources. **CHECKPOINT: early findings.** Show the filled
   charting table; ask whether the fields capture what the human needs and whether the source mix
   looks right. Revise the fields before charting the rest.

5. **Chart** every included source: a source file (`templates/source.md`) plus a row in the
   output's charting table. Claims go in `claims.md` only for statements the output makes about
   the field (counts, definitions, patterns).

6. **CHECKPOINT: consultation.** Arksey and O'Malley's optional sixth stage, run as a checkpoint:
   show the emerging map and ask what practitioners or stakeholders the human knows would say is
   missing or misread. Ask whether to contact anyone.

7. **CHECKPOINT: sanity check.** Run `skills/sanity-check/SKILL.md`, including a sample of charting
   rows checked against their sources.

8. **Write** `outputs/scoping-review.md`: counts, charting summary, evidence by concept, gaps, and
   implications for research. No implications for practice: the review did not appraise evidence.

9. **CHECKPOINT: draft**, then close as in `lit-review` (rebuild index and README, `check.sh`,
   `_queue.md`, **CHECKPOINT: handoff**). Report with PRISMA-ScR in mind (Tricco et al. 2018,
   doi:10.7326/M18-0850).
