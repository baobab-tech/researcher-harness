# Agent Instructions

Read this whole file before starting. Then pick a skill from the table under Skills.

A research harness for any agent that can read files and run shell commands: Claude Code, Claude
Cowork, or another agent. Each research project lives in `projects/<slug>/` and its output is markdown.
Process skills live in `skills/<name>/SKILL.md`; API and retrieval references live in `tools/`;
executable tools live in `scripts/`. `CLAUDE.md` and `.claude/skills` are symlinks to these for Claude Code.

## Working from another workspace

When the human is in their own project and points you at this repo, bring the harness in rather
than working from memory of it. You need a local shell: clone, then run the scripts.

1. **Clone beside their work**, not into their source tree:

   ```bash
   git clone --depth 1 https://github.com/baobab-tech/researcher-harness .researcher-harness
   ```

   If `.researcher-harness/` exists, `git -C .researcher-harness pull` instead. Ask before adding
   it to their `.gitignore`, and never edit their agent config, `CLAUDE.md`, or settings without
   asking.

2. **Read `.researcher-harness/AGENTS.md`** (this file) and the skill for the task.

3. **Ask where the research project should live** at the intent checkpoint. Default:
   `research/<slug>/` in their workspace, so the output is theirs and is versioned with their
   work. Alternative: `.researcher-harness/projects/<slug>/`, when the research is throwaway or
   should stay out of their repo.

4. **Run scripts from the clone**; they work on a project anywhere:

   ```bash
   .researcher-harness/scripts/keys.sh
   .researcher-harness/scripts/search.sh academic "<query>" 10
   .researcher-harness/scripts/check.sh research/<slug>
   .researcher-harness/scripts/status.sh
   ```

   `status.sh` with no arguments covers the harness's own `projects/` and `research/*/` in the
   current directory.

5. **Keys** come from the environment or `.researcher-harness/.env`. Offer to create that file;
   it is gitignored inside the clone. Never write keys into their repo.

6. **Their existing material** (notes, drafts, data in their workspace) is evidence to check like
   any other. Copy what the project uses into `<project>/inputs/` and log it.

## Human in the loop

The human owns the question, the design, and the judgment on what the evidence means. The agent
does the searching, reading, extraction, and bookkeeping, and stops at checkpoints to hand
decisions back. A pass that runs start to finish without the human is a failed pass, however good
its sources.

### Checkpoints

Every skill marks its stops as **CHECKPOINT: <name>**. At each one, ask the human (see How to ask),
then wait for the answer.

| Checkpoint | When | Ask about |
|------------|------|-----------|
| **resume** | start of a session | which project, which waiting items to clear, now or later (`skills/resume/SKILL.md`) |
| **intent** | before anything else | purpose, the decision or use it feeds, audience, what they already know or believe, material they hold, what done looks like |
| **design** | before searching | question wording, sub-questions, method (see below), scope, criteria, sources they trust or distrust, named documents and people they know |
| **early findings** | after the first 3 to 5 sources | whether the direction, source mix, and depth are right; surprises so far |
| **sanity check** | before writing outputs | now or later, how many, one at a time or by file; then each claim against its source (`skills/sanity-check/SKILL.md`) |
| **draft** | after the output draft | framing, emphasis, what is stated too strongly, what is missing |
| **handoff** | before stopping | what is next, what is waiting on them |

Also stop, outside the schedule, when:

- a finding contradicts the human's stated priors or the brief's assumptions
- a source is blocked and a decision is needed on how to proceed
- scope needs to grow or shrink
- two credible sources disagree and the brief does not say which boundary governs

### How to ask

Use the channel your runtime gives you, in this order:

1. **A structured question tool**, where you have one: `AskUserQuestion` in Claude Code, or the
   equivalent ask-the-user tool in other agents. One question per decision, each with 2 to 4
   options, the recommended one first. The human answers with a click and can add a note.
2. **A shared document**, when the human needs to read before answering or has many items to go
   through: a markdown file in the project, or an artifact or doc if your runtime can publish one.
   Tell them where it is, what to mark, and how to hand it back; then read their marks and comments.
3. **A chat message** in the format of `templates/checkpoint.md`, when neither is available.

Then:

- **Ask what files cannot settle.** Read `brief.md`, `_queue.md`, and the decisions log first.
- **Batch.** At most four or five questions per checkpoint.
- **Offer options and a default.** Say what you will do if there is no answer.
- **Let them choose timing and depth.** Before a long review (a sanity check, a draft), ask whether
  now or later, and how much. "Later" is a valid answer: record it in `_queue.md`.
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
| "what exists on X", "how is X defined" | `scoping-review`, `evidence-gap-map`, `background-research` |
| "does X work", "how large is X" | `lit-review` (systematic), `rapid-review` under a deadline |
| "what do reviews already say" | `lit-review` restricted to systematic reviews (umbrella review) |
| "who argues what" | `positions-map` |
| "is this document right" | `source-review` |
| "what should we do" | `policy-brief`, built on one of the above |

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
  outputs/        briefing, review, positions map, brief, etc.  templates/outputs/
  _work/          working notes, one file per task or subagent    templates/notes.md
  inputs/         material the human provides                     checkpoint answers
  .cache/         raw fetched text, gitignored                    scripts/fetch.sh
```

Start one with the `new-project` skill. Checkpoints use the question tool where there is one, else `templates/checkpoint.md`;
sanity-check packets follow `templates/sanity-check.md`. Copy templates; do not write these files from memory.

## Evidence layers

Evidence moves through four layers. Each layer is written from the one below it, never from memory
or from a summary.

| Layer | Path | Contains | Written from |
|-------|------|----------|--------------|
| 0. Raw | `.cache/NNN.txt` | full text as fetched | `scripts/fetch.sh` |
| 1. Source | `sources/NNN-*.md` | one source's findings, numbers, boundary, funding, limits | layer 0 |
| 2. Claim | `claims.md` | one block per claim: statement, scope, period, attribution, kind, quote, status | layer 1 | layer 1 |
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

`claims.md` holds one block per claim. A claim is the unit an output cites, a human checks, and a
later pass re-verifies, so it carries everything needed to judge it without opening the output.

```markdown
### C007: Systematic review subtypes

- **Statement:** Munn et al. (2018) divide systematic reviews into ten types by the question asked.
- **Value:** 10 types
- **Scope:** medical and health sciences; excludes scoping, rapid, umbrella, and literature reviews
- **Period:** typology as published January 2018
- **Context:** proposed by JBI methodologists; not derived from a sample of published reviews
- **Attributed to:** Munn, Stern, Aromataris, Lockwood, Jordan (JBI)
- **Kind:** classification
- **Sources:** [003](sources/003-munn-2018-ten-systematic-review-types.md), Background
- **Quote:** "ten different types of systematic review foci are listed below"
- **Status:** supported
- **Checked:** 2026-09-19
- **Recheck:** stable
- **Human:** confirmed 2026-09-19
- **Note:**
```

| Field | Holds | Required |
|-------|-------|----------|
| Statement | one sentence that stands alone: who says what, about what, when. "Google reported a 2.3% fall in 2025 operational emissions", not "emissions fell 2.3%" | yes |
| Value | number, unit, and statistic (median, mean, total, range); `none` for qualitative claims | no |
| Scope | what is counted and what is excluded: population, geography, system boundary, sample | yes |
| Period | the time the claim is about: "calendar 2024", "FY25", "as of March 2022", "2019-2023". Absolute dates only | yes |
| Context | conditions it holds under: assumptions, baseline or comparator, method, setting | when it changes the reading |
| Attributed to | whoever asserts it. `this project` for the project's own inferences | yes |
| Kind | `measurement`, `estimate`, `projection`, `model output`, `definition`, `classification`, `expert judgment`, `opinion`, or `inference` | yes |
| Sources | links to source files, each with a locator: page, table, section | yes |
| Quote | exact words from the cached source text that support the claim | yes, except `inference` |
| Depends on | claim IDs an `inference` or derived figure is computed from | for `inference` |
| Status | `supported`, `contested`, or `unsupported` | yes |
| Checked | date the agent last found it in the source | yes |
| Recheck | a month (`2027-03`) after which the claim may be out of date, or `stable` | yes |
| Human | `confirmed YYYY-MM-DD`, `wrong`, `unsure`, or empty. Only a human answer fills it | field present |
| Note | how contested sources differ; anything else a checker needs | no |

Rules:

- **One claim per block.** The same number with a different scope or period is a different claim.
- **Time.** Period is when the claim is true of; the source's publication date lives in its source
  file; Checked is when this project verified it. A claim about the present needs an as-of date.
  Set Recheck for anything that changes: prices, counts in live databases, policies, pledges,
  rankings, software versions, free tiers. `scripts/check.sh` reports claims past their Recheck.
- **Attribution.** State a claim as its source's claim ("X report", "X estimate") unless it is a
  measurement anyone could repeat. A source's framing is not a fact.
- **Inferences** are claims too: Kind `inference`, Attributed to `this project`, Depends on the claims
  they rest on. Outputs phrase them as inference.
- **Status.** `supported`: in every listed source on the stated scope and period. `contested`:
  sources on the same scope and period disagree; Note says how. `unsupported`: asserted somewhere,
  found in no retrieved source; kept so outputs can say so.
- **Human `wrong`** blocks every output citing the claim until it is fixed.
- **IDs are permanent.** A deleted claim's ID is not reused.
- `scripts/check.sh` fails on a cited ID missing from the ledger, a claim missing a required field, a
  claim citing a missing source file, or a claim a human marked `wrong`.

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
| continuing, "where were we", what is pending | `resume` | none |
| research on a topic with no project yet | `new-project`, then one below | `templates/brief.md` |
| getting up to speed, "what do we know about X" | `background-research` | `templates/outputs/briefing.md` |
| what the research says, a systematic review | `lit-review` | `templates/outputs/review.md` |
| what research exists, how X is defined or studied | `scoping-review` | `templates/outputs/scoping-review.md` |
| an evidence answer by a deadline | `rapid-review` | `templates/outputs/rapid-review.md` |
| where evidence exists and where it does not, by category | `evidence-gap-map` | `templates/outputs/evidence-gap-map.md` |
| the debate, the positions, stakeholders, both sides | `positions-map` | `templates/outputs/positions-map.md` |
| what a decision-maker should consider, options | `policy-brief` | `templates/outputs/policy-brief.md` |
| a review, critique, or fact-check of one document | `source-review` | `templates/outputs/source-review.md` |
| a human spot-check of findings | `sanity-check` | `templates/sanity-check.md` |
| a check before sharing, or an update to a project | `verify`, then `METHOD.md` | none; reports in conversation |

Every skill writes source files with `templates/source.md` and claims with `templates/claims.md`.
Output types with no skill yet (umbrella review, meta-analysis, qualitative evidence synthesis,
realist review): see `projects/research-output-types/outputs/briefing.md` and the 48 types in its
source `002`, adapt the nearest skill, and state the adaptation in the output's Method section.

## Scripts

Run from the repo root. Each loads `.env` itself and exits 3 naming any missing key. Every key is
optional: the scripts use what is present and fall back to keyless providers. Before a project, run
`scripts/keys.sh`; if web search is unavailable, say so at the intent checkpoint and name the free
tier that fills the gap (`tools/search-providers.md`).

| Script | Does |
|--------|------|
| `scripts/keys.sh` | which providers are usable with the keys present; run first |
| `scripts/status.sh [slug]` | every project's claims, human checks, assumed decisions, recheck dates, and what waits on the human |
| `scripts/search.sh academic\|web\|news "<query>" [n]` | search, choosing a provider by the keys present; or name one: `openalex`, `arxiv`, `crossref`, `europepmc`, `core`, `semanticscholar`, `tavily`, `serper`, `scholar`, `serpapi`, `serpapi-scholar`, `brave`, `exa`, `jina` |
| `scripts/doi.sh <doi>` | confirm a record on Crossref; find OA copies via Unpaywall and Semantic Scholar |
| `scripts/fetch.sh <url> [out]` | URL to text: `pdftotext` for PDFs, then Jina, Tavily, Exa as keys allow; exits 4 if all are blocked |
| `scripts/check.sh <slug> [--urls]` | mechanical checks on a project |

## Tool references

| File | Holds |
|------|-------|
| `tools/search-providers.md` | every provider: coverage, key, free tier, fallbacks, how to add one |
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
