---
name: lit-review
description: Systematic literature review - search protocol, screening against inclusion criteria, full-text extraction one file per source, and a synthesis in projects/<slug>/outputs/review.md. Use when the user asks for a literature review, systematic or scoping review, evidence review, or "what does the research say about X".
---

# Literature review

Requires `projects/<slug>/brief.md` with a question, sub-questions, and inclusion criteria. Run
`new-project` first if it does not exist. Read `METHOD.md` if the project already holds sources.

## 1. Protocol

Write the search protocol into `brief.md` before searching:

- Databases and tools: OpenAlex, arXiv, Serper scholar, Semantic Scholar citation graph, plus the
  field's primary-source portals
- Query strings per sub-question, with synonyms
- Date window and document types
- Screening criteria (from `brief.md`)

## 2. Search

Run every query with `scripts/search.sh` (or the raw APIs in `tools/`) and log it in `_log.md` with the hit count and what was kept, including zero-hit
queries. Then snowball: for each included anchor paper, pull references and citations from
Semantic Scholar (`tools/metadata.md`) and screen those too.

For a large review, run one subagent per sub-question as described in `METHOD.md`: each gets the
brief, its starting file number, named targets, and exclusive ownership of its files.

## 3. Screen

Title and abstract screen first, logging exclusions with a reason in `_log.md`. Then full-text
screen: a source enters only if its full text is retrieved and it meets the criteria. Record the
counts at each stage (identified, screened, full-text assessed, included) for the review's
flow statement.

## 4. Extract

One file per included source, `templates/source.md`. Confirm the record on Crossref, find each
number in the full text, record boundary, method, funding, and epistemic status. Rate the design
in `## Methodology`: sample, comparator, measurement or model, what would change the result.

## 5. Synthesise

Write `outputs/review.md`:

```markdown
# [Question]: literature review

**Searched:** YYYY-MM-DD · **Included:** N of M screened

## Answer
[The answer to the question as the evidence supports it, with its confidence.]

## Evidence by sub-question
[Per sub-question: what the included sources establish, the figures with boundaries, where they
agree, where they disagree and whether the disagreement survives boundary arithmetic.]

## Quality of the evidence
[Designs, samples, funding patterns, what is measured against modelled.]

## Gaps
[What no included source establishes.]

## Method
[Databases, queries, dates, criteria, flow counts. Link _log.md.]
```

Every claim links to its source file. No figure appears that is not in a verified file.

## 6. Close

Rebuild `_index.md` and `README.md` from the final files, update `_queue.md`, run
`scripts/check.sh <slug>`.
