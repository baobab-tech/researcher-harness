# Agent Instructions

Read this whole file before starting. Then pick a skill from the table under Skills.

A research harness for any agent that can read files and run shell commands: Claude Code, Claude
Cowork, or another agent. Each research project lives in `projects/<slug>/` and its output is markdown.
Process skills live in `skills/<name>/SKILL.md`; API and retrieval references live in `tools/`;
executable tools live in `scripts/`. `CLAUDE.md` and `.claude/skills` are symlinks to these for Claude Code.

## Human in the loop

The human owns the question, the design, and the judgment on what the evidence means. The agent
does the searching, reading, extraction, and bookkeeping, and stops at checkpoints to hand
decisions back. A pass that runs start to finish without the human is a failed pass, however good
its sources.

### Checkpoints

Every skill marks its stops as **CHECKPOINT: <name>**. At each one, send a message in the format of
`templates/checkpoint.md`, then wait.

| Checkpoint | When | Ask about |
|------------|------|-----------|
| **intent** | before anything else | purpose, the decision or use it feeds, audience, what they already know or believe, material they hold, what done looks like |
| **design** | before searching | question wording, sub-questions, method (see below), scope, criteria, sources they trust or distrust, named documents and people they know |
| **early findings** | after the first 3 to 5 sources | whether the direction, source mix, and depth are right; surprises so far |
| **sanity check** | before writing outputs | a packet of claims to spot-check against sources (`templates/sanity-check.md`) |
| **draft** | after the output draft | framing, emphasis, what is stated too strongly, what is missing |
| **handoff** | before stopping | what is next, what is waiting on them |

Also stop, outside the schedule, when:

- a finding contradicts the human's stated priors or the brief's assumptions
- a source is blocked and a decision is needed on how to proceed
- scope needs to grow or shrink
- two credible sources disagree and the brief does not say which boundary governs

### How to ask

- **Ask what files cannot settle.** Read `brief.md`, `_queue.md`, and the decisions log first.
- **Batch.** One message per checkpoint, at most five questions, numbered.
- **Offer options and a default.** Say what you will do if there is no answer.
- **Show your work.** Link the files you wrote so the human can read before answering.
- **Ask for their material.** Documents, data, prior research, notes, contacts. Save what they
  share to `inputs/` and log it. Human-provided material is evidence to check like any other, and
  a lead to follow.
- **Dig at intent.** A request names a topic; the intent is the decision behind it. "Why now?",
  "What would change your mind?", "Who will read this?" often reshape the question.

### Record every answer

Answers go in the Decisions table of `brief.md`, with date, checkpoint, and who answered. When no
human answers (an unattended run), choose the default, record it as `assumed`, carry it into
`_queue.md` under "Waiting on the human", and list it in the output's Human review section. Never
present an assumed decision as the human's.

### Involvement level

`brief.md` sets it at the intent checkpoint:

- **high**: every checkpoint
- **standard** (default): intent, design, sanity check, draft
- **light**: intent and sanity check

The sanity check is never skipped. No output is shared without a human having spot-checked a
sample of its claims, or the output saying plainly that none were checked.

### Method is a design decision

At the design checkpoint, offer the methods that fit the question and let the human choose:

| If the question is | Offer |
|--------------------|-------|
| "what exists on X" | scoping review, evidence map, background briefing |
| "does X work / how large is X" | systematic review, rapid review |
| "what do reviews already say" | umbrella review |
| "who argues what" | perspectives map |
| "is this document right" | source review |
| "what should we do" | policy brief built on one of the above |

Definitions and trade-offs: `projects/research-output-types/outputs/briefing.md`. Record the choice
and any adaptation in `brief.md` and in the output's Method section.

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

- Building applications. Shell work is limited to the scripts in `scripts/` and `curl`, `jq`, and `pdftotext`.

## Projects

```
projects/<slug>/
  brief.md        question, scope, criteria, distinctions         templates/brief.md
  _queue.md       current state and next steps                    templates/queue.md
  _log.md         every search, including empty ones              templates/log.md
  _index.md       one row per source file                         templates/index.md
  claims.md       every claim outputs use, with its sources       templates/claims.md
  README.md       what the evidence establishes                   templates/project-readme.md
  sources/        NNN-author-year-topic.md, one per finding       templates/source.md
  outputs/        briefing, review, perspectives, source reviews  templates/outputs/
  _work/          working notes, one file per task or subagent    templates/notes.md
  inputs/         material the human provides                     checkpoint answers
  .cache/         raw fetched text, gitignored                    scripts/fetch.sh
```

Start one with the `new-project` skill. Checkpoint messages follow `templates/checkpoint.md`; sanity-check
packets follow `templates/sanity-check.md`. Copy templates; do not write these files from memory.

## Evidence layers

Evidence moves through four layers. Each layer is written from the one below it, never from memory
or from a summary.

| Layer | Path | Contains | Written from |
|-------|------|----------|--------------|
| 0. Raw | `.cache/NNN.txt` | full text as fetched | `scripts/fetch.sh` |
| 1. Source | `sources/NNN-*.md` | one source's findings, numbers, boundary, funding, limits | layer 0 |
| 2. Claim | `claims.md` | one row per claim, citing layer-1 files, with a status | layer 1 |
| 3. Output | `outputs/*.md`, `README.md` | prose for a reader, citing claim IDs `[C001]` | layer 2 |

- Save every fetched full text to `.cache/` named by its source number. Verification re-reads it
  there without refetching. It is gitignored because full texts are often copyrighted.
- A claim enters `claims.md` only after its number or statement has been found in the layer-0 text.
- Every number and factual statement in an output carries a claim ID. A sentence with no ID is the
  author's own inference and reads as one ("this suggests", "taken together").
- When a source file changes, re-check the claims that cite it and the outputs that cite those.
  `grep -n "sources/NNN-" claims.md` finds them.

## Working files

Agents lose context; files do not. Write state down as you go.

- **`_queue.md`** is the handoff. Update it before stopping: what is done, what is next, what is
  blocked. A new session or agent starts by reading it.
- **`_log.md`** takes every search as it is run: query, tool, hit count, what was kept and why.
- **`_work/<name>.md`** holds one task's or one subagent's scratch: leads, partial reads, dead ends,
  and a "Report back" section for the orchestrator. Outputs never cite it. Fold it into source files
  and the log when the task ends, then delete it.
- **Subagents** each get a brief, a starting file number, and exclusive ownership of the files they
  write. Only the orchestrator edits `_index.md`, `claims.md`, `README.md`, and `outputs/`.
  Subagents never contact the human: they put questions in their notes file's "Report back"
  section, and the orchestrator batches them into the next checkpoint.

## Claims ledger

`claims.md` is a table: ID, claim, value, boundary, source files, status, date checked, note.

- One row per distinct claim. The same number on a different boundary is a different claim.
- `supported`: found in every listed source on the stated boundary.
- `contested`: sources on the same boundary disagree. The note says how.
- `unsupported`: asserted somewhere, found in no retrieved source. Kept so outputs can say so.
- `Human` records a person's spot-check: `confirmed YYYY-MM-DD`, `wrong`, `unsure`, or blank. Only a
  human answer fills it. A `wrong` claim is fixed before any output cites it.
- IDs are permanent. A deleted claim's ID is not reused.
- `scripts/check.sh` fails on a cited ID missing from the ledger or a ledger row citing a missing file.

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

Each is a markdown file at `skills/<name>/SKILL.md` with `name` and `description` frontmatter, in
the Agent Skills format. Agents without native skill loading pick a row below and read that file
before starting.

| The user asks for | Skill | Output template |
|-------------------|-------|-----------------|
| research on a topic with no project yet | `new-project`, then one below | `templates/brief.md` |
| getting up to speed, "what do we know about X" | `background-research` | `templates/outputs/briefing.md` |
| a literature, systematic, or evidence review | `lit-review` | `templates/outputs/review.md` |
| the debate, the positions, stakeholders, both sides | `perspectives` | `templates/outputs/perspectives.md` |
| a review, critique, or fact-check of one document | `source-review` | `templates/outputs/source-review.md` |
| a check before sharing, or an update to a project | `verify`, then `METHOD.md` | none; reports in conversation |
| checking findings before an output is written or shared | `sanity-check` | `templates/sanity-check.md` |

Every skill writes source files with `templates/source.md` and claims with `templates/claims.md`.
Output types with no skill yet (scoping review, rapid review, evidence gap map, policy brief):
see `projects/research-output-types/outputs/briefing.md` for their definitions, adapt the nearest
skill, and state the adaptation in the output's Method section.

## Scripts

Run from the repo root. Each loads `.env` itself and exits 3 naming any missing key.

| Script | Does |
|--------|------|
| `scripts/search.sh <openalex\|arxiv\|scholar\|web\|news> "<query>" [n]` | search one backend; prints `year \| title \| id` |
| `scripts/doi.sh <doi>` | confirm a record on Crossref; find OA copies via Unpaywall and Semantic Scholar |
| `scripts/fetch.sh <url> [out]` | URL to text: PDFs via `pdftotext -layout`, pages via Jina; exits 4 on a bot check |
| `scripts/check.sh <slug> [--urls]` | mechanical checks on a project |

## Tool references

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

For raw `curl` calls in the references, load keys with `set -a; source .env; set +a` from the repo root.

## Known environment gotchas

- `zsh` does not word-split unquoted variables. `for f in $list` iterates once. Use `while read`.
- `$d[0-9]` in zsh is array subscripting, not globbing. Use `"${d}"[0-9]*.md`.
- `WebFetch` returns binary for PDFs. Download and run `pdftotext -layout`, or use Jina.
- `curl -I` returns 403 where `GET` succeeds on several publishers. Do not validate with HEAD.
