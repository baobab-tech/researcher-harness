# Researcher Harness

**Version 0.** A folder of markdown skills, shell scripts, and templates that turns any file-and-shell
agent into a careful researcher: literature reviews, background briefings, perspective maps, and
critical reviews of single documents. Claude Code, Claude Cowork, and other agents use the same files.

Every claim in an output links to a markdown file recording one source, its numbers, their boundary
and method, its funding, and what it omits, each checked against the source's full text. The method
comes from [research-ai-energy](https://github.com/baobab-tech/research-ai-energy), a 126-source
corpus where verification found the most-quoted figure appeared in no version of its cited paper.

## Setup

```bash
git clone https://github.com/baobab-tech/researcher-harness && cd researcher-harness
cp .env.example .env          # add the keys you have; see below
brew install jq poppler       # jq and pdftotext; curl ships with macOS
```

Point an agent at the folder. Claude Code reads `CLAUDE.md` and `.claude/skills/` automatically;
other agents start from [AGENTS.md](AGENTS.md).

### API keys

| Key | Used by | Without it |
|-----|---------|------------|
| `CONTACT_EMAIL` | Unpaywall, OpenAlex polite pool | Unpaywall lookups are skipped |
| `SERPER_API_KEY` | `search.sh scholar\|web\|news` | only OpenAlex and arXiv search |
| `JINA_API_KEY` | `fetch.sh` for HTML pages | works keyless at a lower rate limit |
| `EXA_API_KEY` | content extraction per `tools/exa.md` | optional |

OpenAlex, arXiv, Crossref, Semantic Scholar, and the Wayback Machine need no key. Scripts exit with
code 3 and name the key when one is required and missing.

## Use

Ask in plain language:

- "Background research on municipal heat-pump subsidies in Canada"
- "Lit review: does a four-day week reduce burnout? Peer-reviewed, 2019 onward"
- "Map the perspectives on small modular reactors for data centres"
- "Review this paper: https://arxiv.org/abs/..."
- "Verify the heat-pumps project before I share it"

The agent creates `projects/<slug>/`, drafts a brief, asks about scope once, then runs the process.
[projects/research-output-types](projects/research-output-types/) is a worked example: a briefing on
the kinds of task and output researchers produce.

## Contents

| Path | Holds |
|------|-------|
| [AGENTS.md](AGENTS.md) | rules every agent follows: source hierarchy, hard rules, style. `CLAUDE.md` links here |
| [METHOD.md](METHOD.md) | how to run a pass: audit, search, verify, prune, rebuild |
| [skills/](skills/) | one `SKILL.md` per process; `.claude/skills` links here |
| [scripts/](scripts/) | `search.sh`, `doi.sh`, `fetch.sh`, `check.sh` |
| [tools/](tools/) | API references and retrieval routes, verification failure modes |
| [templates/](templates/) | brief, source file, index, log, queue, project README |
| `projects/<slug>/` | one research project |

### Skills

| Skill | Produces |
|-------|----------|
| `new-project` | `projects/<slug>/` with a drafted `brief.md` |
| `background-research` | `outputs/briefing.md`: terms, actors, primary sources, established figures, disputes, gaps |
| `lit-review` | `outputs/review.md`: protocol, screening counts, evidence by sub-question, quality, gaps |
| `perspectives` | `outputs/perspectives.md`: positions, their evidence and interests, and whether each disagreement is empirical, definitional, or about values |
| `source-review` | a claim-by-claim review of one document |
| `verify` | an audit: mechanical checks, re-pulled sources, pruned files, rebuilt summaries |

### Scripts

```bash
scripts/search.sh openalex "scoping review methodology" 10
scripts/doi.sh 10.1186/s12874-018-0611-x
scripts/fetch.sh https://arxiv.org/pdf/2304.03271 paper.txt
scripts/check.sh <slug> --urls
```

### A project

```
projects/<slug>/
  brief.md      question, scope, criteria, the distinctions that matter in this field
  README.md     what the evidence establishes, rebuilt from sources/
  _index.md     one row per source file
  _log.md       every search, including empty ones
  _queue.md     state and next steps
  sources/      NNN-author-year-topic.md
  outputs/      briefing, review, perspectives
```

## Open directions

Nothing below is decided.

- **More skills** for the output types in the
  [research-output-types briefing](projects/research-output-types/outputs/briefing.md): scoping
  review, rapid review, umbrella review, evidence gap map, policy brief, perspective piece.
- **MCP servers** wrapping the scripts, so agents without a shell can search, fetch, and verify.
- **A data layer**: a shared store of verified source records across projects, so a paper checked
  once is not re-checked from scratch.
- **A product**: hosted runs, shared projects, a reader for outputs.
