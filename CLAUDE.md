# Claude Instructions

A research harness. Each research project lives in `projects/<slug>/` and its output is markdown.
Process skills live in `.claude/skills/`; API and retrieval references live in `tools/`.

**Before any work on an existing project:** read its `brief.md`, `_queue.md`, and
[METHOD.md](METHOD.md). An update is audit, search, verify, prune, rebuild. A pass that only adds
new sources leaves the existing material wrong and every summary built on it wrong.

## What happens here

- Search for papers, agency and statutory documents, filings, datasets, and organisational disclosures
- Extract findings with their numbers, units, definitions, and boundaries
- Write one markdown file per source finding, always with a retrieved URL
- Synthesise those files into reviews, briefings, and perspective maps
- Log every search, including those that return nothing

## What does not happen here

- Building applications. Shell work is limited to `curl`, `jq`, `pdftotext`, and `scripts/check.sh`.

## Projects

```
projects/<slug>/
  brief.md        question, scope, inclusion criteria, distinctions that matter in this field
  README.md       summary of what the evidence establishes, rebuilt from sources/
  _index.md       one row per source file
  _log.md         searches run, including empty ones
  _queue.md       current state and what is next
  sources/        NNN-author-year-topic.md, one per finding
  outputs/        deliverables: review, briefing, perspectives map
```

Start one with the `new-project` skill. Templates are in `templates/`.

## Source hierarchy

Default ranking for a question about facts or numbers. A project's `brief.md` may adjust it.

1. **Measurement and primary data.** Instrumented systems, metered or administrative data, registries, trial data.
2. **Agency and statutory documents.** Statistical offices, regulators, court and legislative records, official filings.
3. **Peer-reviewed papers and preprints.** OpenAlex, arXiv, Crossref.
4. **Organisational disclosures.** Company reports, NGO reports, position papers. Primary evidence of what the organisation claims and how it counts.
5. **Journalism**, used only to reach a document or dataset otherwise unavailable. Cite the underlying document; the article's framing carries no weight.

A disclosure evidences what its author claims. It does not evidence whether the claim holds.

## Hard rules

0. **Verify before citing.** A figure entering a README, an output, or a reply to the user comes
   from a source retrieved in this pass, not from an existing source file.
1. **Every fact carries a URL that was actually retrieved.** Confirm it resolves.
2. **Confirm the record before writing.** Check the DOI against Crossref. If the returned title is
   not the paper, the DOI is wrong; if the author list does not match, the citation is wrong. See
   `tools/metadata.md`.
3. **No abstract-only write-ups.** If the finding cannot be established from the full text, skip
   the source or record exactly what could not be checked. Banned phrasings: "likely addresses",
   "presumably", "full paper needed", "implies the authors argue".
4. **Numbers carry units, boundary, and method.** State what is counted and what is excluded, and
   whether the statistic is a median, a mean, or a total.
5. **Name the epistemic status.** Measurement, estimate, projection, model output, opinion.
6. **One file per finding, not per topic.** Before writing, `grep -ril "<author>" projects/<slug>/`.
   If the source is held, extend that file or cross-link it.
7. **On topic.** Each source bears directly on the project question as scoped in `brief.md`.
   Relevance the source does not itself claim is not relevance.
8. **Record funding and affiliation** on every source file, including when there is no apparent conflict.
9. **The number must be in the source.** A figure derived by arithmetic on the source's prose is an
   estimate and is labelled as one. See `tools/verification.md`.
10. **`DELETE` is a valid outcome.** A file that misdescribes its source is worse than no file.

## Distinctions

Most apparent disagreements in a literature are boundary mismatches: two figures that count
different things. Every project's `brief.md` lists the distinctions that matter in its field
(for example: withdrawal against consumption, incidence against prevalence, announced against
delivered, nominal against real). Before reporting two figures as in conflict, establish that
they share a definition, population, period, and boundary.

## Source file format

Path: `projects/<slug>/sources/NNN-author-year-topic.md`. Template: `templates/source.md`.

## State, not changelog

Files describe the current state of the evidence. No `supersedes`, `corrected`,
`previously stated`, or `correction needed` annotations. When a file is wrong, write the right
thing; git history records the change and the commit message names it. Report corrections to the
user in conversation.

## Writing style

- Lead with the finding. State it once.
- Declarative. No verdict words: interesting, important, key, striking, alarming, powerful.
- No sentences about the document: "this section covers", "as noted above".
- Report uncertainty as ranges with the assumptions that produce them.
- Attribute contested claims to whoever made them. Do not adopt their framing.
- Where a claim is well evidenced, say so. The aim is to separate substantiated claims from unsubstantiated ones.

## Critical stance

Applied to every source, including congenial ones:

- Who funded it, who employs the authors
- What the boundary or sample excludes
- Self-reported or independently verified
- What a reader would want that the source does not give

A study reaching a dramatic conclusion gets the same scrutiny as one reaching a reassuring one.

## Skills

| Skill | Use |
|-------|-----|
| `new-project` | scaffold `projects/<slug>/` from a question |
| `background-research` | fast orientation: terms, actors, primary sources, established figures, open disputes |
| `lit-review` | systematic search, screening, extraction, and synthesis |
| `perspectives` | map positions on a contested question and the evidence under each |
| `source-review` | critical review of one paper, report, or disclosure |
| `verify` | audit a project against its sources and run the mechanical checks |

## Tools

| File | Holds |
|------|-------|
| `tools/openalex.md`, `tools/arxiv.md` | academic search, no key needed |
| `tools/openalex-api-reference.md`, `tools/arxiv-api-reference.md` | full API references |
| `tools/serper.md` | web, news, and scholar search; key in `.env` |
| `tools/jina.md` | fetch a URL or PDF as clean markdown |
| `tools/exa.md` | content extraction from open pages; weak for discovery |
| `tools/metadata.md` | Crossref, Semantic Scholar, Unpaywall; identity and full-text routes |
| `tools/primary-sources.md` | PDF extraction, reading official and organisational documents |
| `tools/archive.md` | Wayback Machine, for revised or removed pages |
| `tools/verification.md` | failure modes and the check suite |

Load keys with `set -a; source .env; set +a` from the repo root.

## Known environment gotchas

- `zsh` does not word-split unquoted variables. `for f in $list` iterates once. Use `while read`.
- `$d[0-9]` in zsh is array subscripting, not globbing. Use `"${d}"[0-9]*.md`.
- `WebFetch` returns binary for PDFs. Download and run `pdftotext -layout`, or use Jina.
- `curl -I` returns 403 where `GET` succeeds on several publishers. Do not validate with HEAD.
