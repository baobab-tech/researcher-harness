---
name: lit-review
description: Systematic literature review - search protocol, screening against inclusion criteria, full-text extraction one file per source, claims ledger, and synthesis in projects/<slug>/outputs/review.md. Use when the user asks for a literature review, systematic or scoping review, evidence review, or "what does the research say about X".
---

# Literature review

Requires `projects/<slug>/brief.md` with a question, sub-questions, and inclusion criteria; run
`new-project` first if missing. If the project already holds sources, read `METHOD.md` first.
Output template: `templates/outputs/review.md`.

1. **Protocol.** Before searching, write into `brief.md`: databases and tools, query strings per
   sub-question with synonyms, date window, document types, screening criteria.
2. **Search.** Run every query with `scripts/search.sh` (or the raw APIs in `tools/`) and log it in
   `_log.md` with hit count and what was kept, including zero-hit queries. Snowball from each
   included anchor through Semantic Scholar references and citations (`tools/metadata.md`).
   For a large review, run one subagent per sub-question as described in `METHOD.md`, each with a
   `_work/<name>.md` notes file from `templates/notes.md`.
3. **Screen.** Title and abstract first, logging exclusions with reasons. Then full text: a source
   enters only if its full text is retrieved into `.cache/` and meets the criteria. Keep counts at
   each stage for the review's Method table.
4. **Extract.** One `sources/NNN-*.md` per included source from `templates/source.md`. Confirm the
   record with `scripts/doi.sh`, find each number in the cached text, record boundary, method,
   funding, epistemic status, and the design's weaknesses.
5. **Claims.** Enter every claim the review will use into `claims.md` with its sources and status.
6. **Synthesise.** Write `outputs/review.md` from the template. Every number carries a claim ID. No
   figure appears that is not in the ledger.
7. **Close.** Rebuild `_index.md` and `README.md`, update `_queue.md`, run `scripts/check.sh <slug>`.

For a scoping review, drop risk-of-bias appraisal, chart the evidence by type and concept, and
state in the Method section that the review maps evidence and does not answer an effectiveness
question (`projects/research-output-types/sources/004-munn-2018-scoping-vs-systematic.md`).
