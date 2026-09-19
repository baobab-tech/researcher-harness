---
name: lit-review
description: Literature review (systematic, scoping, or rapid) - protocol agreed with the human, screening, full-text extraction, claims ledger, human sanity check, and synthesis in projects/<slug>/outputs/review.md. Use when the user asks for a literature, systematic, scoping, or evidence review, or "what does the research say about X".
---

# Literature review

Requires `projects/<slug>/brief.md` with intent and design recorded; run `new-project` first if
missing. If the project already holds sources, read `METHOD.md` first. Output template:
`templates/outputs/review.md`.

1. **Protocol.** Draft into `brief.md`: review type (systematic, scoping, or rapid, as chosen at
   design), databases and tools, query strings per sub-question with synonyms, date window,
   document types, screening criteria.

2. **CHECKPOINT: design** (protocol). Show the protocol and a test run: hit counts per query and
   the first ten titles. Ask whether the queries find what they expect, whether known key papers
   appear (ask them to name two or three), and whether the criteria are right. A known paper the
   search misses means the queries are wrong.

3. **Search.** Run every query with `scripts/search.sh` (or the raw APIs in `tools/`) and log it
   with hit count and what was kept, including zero-hit queries. Snowball from each included anchor
   through Semantic Scholar references and citations (`tools/metadata.md`). For a large review, run
   one subagent per sub-question as in `METHOD.md`, each with a `_work/<name>.md` notes file.

4. **Screen.** Title and abstract first, logging exclusions with reasons. Then full text: a source
   enters only if its text is in `.cache/` and meets the criteria. Keep counts for the Method table.
   Borderline calls go in a list for the next checkpoint; do not decide them alone.

5. **CHECKPOINT: early findings.** Report counts at each stage, the borderline list, and what the
   first included sources say. Ask for rulings on borderline sources and whether direction and
   depth are right.

6. **Extract.** One `sources/NNN-*.md` per included source from `templates/source.md`. Confirm the
   record with `scripts/doi.sh`, find each number in the cached text, record boundary, method,
   funding, epistemic status, and the design's weaknesses.

7. **Claims.** Enter every claim the review will use into `claims.md`, one block each with scope,
   period, attribution, kind, and quote (Claims ledger, `AGENTS.md`).

8. **CHECKPOINT: sanity check.** Run the `sanity-check` skill.

9. **Synthesise.** Write `outputs/review.md` from the template. Every number carries a claim ID.

10. **CHECKPOINT: draft.** Ask about the answer's strength, framing, and omissions. Revise.

11. **Close.** Rebuild `_index.md` and `README.md`, run `scripts/check.sh <slug>`, update
    `_queue.md`. **CHECKPOINT: handoff.**

For a map of the evidence without appraisal, use `skills/scoping-review/SKILL.md`; under a deadline,
`skills/rapid-review/SKILL.md`; for a matrix of where evidence exists, `skills/evidence-gap-map/SKILL.md`.
