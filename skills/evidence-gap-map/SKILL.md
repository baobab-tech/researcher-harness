---
name: evidence-gap-map
description: Evidence and gap map - a systematic search coded into a matrix (usually interventions by outcomes) showing where evidence exists and where it does not, with a framework designed with the human. Produces projects/<slug>/outputs/evidence-gap-map.md and a CSV. Use when the user asks for an evidence map, evidence gap map, EGM, where the research gaps are across a field, or what evidence exists for each intervention and outcome.
---

# Evidence and gap map

Displays the available evidence on a question as a matrix; it does not synthesise findings.
Built with systematic review steps (Campbell guidance, White et al. 2020,
`projects/research-output-types/sources/007-*`). The framework is the most important design
decision and is made with the human.

Requires `projects/<slug>/brief.md`; run `new-project` first if missing. Output template:
`templates/outputs/evidence-gap-map.md`.

1. **CHECKPOINT: design, the framework.** Propose the two axes (default: intervention categories as
   rows, outcome categories as columns; alternatives such as intervention by region), their
   categories and subcategories, and the evidence types admitted (systematic reviews, primary
   studies, or both). Ask the human to revise, and name who else should shape it (the map's
   commissioner or users).

2. **Pilot the framework** by coding 5 to 10 known studies. **CHECKPOINT: early findings.** Show
   the pilot matrix and every study that did not fit a cell. Revise, refine, and define the
   categories with the human; repeat if needed.

3. **Search and screen** as in `skills/lit-review/SKILL.md`, comprehensively, logging counts.

4. **Code** each included study: a source file, plus one line per study in
   `outputs/evidence-gap-map.csv` with columns `source,title,year,design,row,column,country,notes`.
   A study with several interventions or outcomes gets one line per cell.

5. **CHECKPOINT: sanity check.** Ask the human to check a sample of coding decisions (study, cell,
   and the passage that justifies it), alongside the usual claims (`skills/sanity-check/SKILL.md`).

6. **Build the matrix** from the CSV: counts per cell, linked to the source files, with reviews and
   primary studies counted separately. Empty cells are gaps; cells with only low-quality or old
   evidence are named separately if the human asked for appraisal.

7. **Write** `outputs/evidence-gap-map.md`: framework, matrix, gaps, clusters of evidence ready for
   a systematic review, method. **CHECKPOINT: draft**, then close as in `lit-review`.
