# Researcher Harness

A repository Claude Code works inside to research any topic: literature reviews, background
briefings, perspective maps, and critical reviews of single documents. Every claim in an output
links to a markdown file recording one source, its numbers, their boundary and method, its funding,
and what it omits, each checked against the source's full text.

The method and tools come from [research-ai-energy](https://github.com/baobab-tech/research-ai-energy),
a 126-source corpus where a verification pass found that the most-quoted figure appeared in no
version of its cited paper. The rules here exist to prevent that.

## Quick start

```bash
cp .env.example .env     # add SERPER_API_KEY, EXA_API_KEY, JINA_API_KEY, CONTACT_EMAIL
claude
```

Then ask for the work in plain language:

- "Background research on municipal heat-pump subsidies in Canada"
- "Lit review: does four-day work week reduce burnout? Peer-reviewed, 2019 onward"
- "Map the perspectives on nuclear SMRs for data centres"
- "Review this paper: https://arxiv.org/abs/..."
- "Verify the heat-pumps project before I share it"

Claude creates `projects/<slug>/`, drafts a brief, asks about scope once, then runs the process.

## Skills

In `.claude/skills/`, loaded by Claude Code automatically.

| Skill | Produces |
|-------|----------|
| `new-project` | `projects/<slug>/` with a drafted `brief.md` |
| `background-research` | `outputs/briefing.md`: terms, actors, primary sources, established figures, disputes, gaps |
| `lit-review` | `outputs/review.md`: protocol, screening counts, evidence by sub-question, quality, gaps |
| `perspectives` | `outputs/perspectives.md`: positions, their evidence and interests, empirical against definitional against values disagreements |
| `source-review` | a claim-by-claim review of one document |
| `verify` | an audit: mechanical checks, re-pulled sources, pruned files, rebuilt summaries |

## Layout

| Path | Holds |
|------|-------|
| [CLAUDE.md](CLAUDE.md) | rules Claude follows: source hierarchy, hard rules, style |
| [METHOD.md](METHOD.md) | how to run a pass: audit, search, verify, prune, rebuild |
| [tools/](tools/) | API references: OpenAlex, arXiv, Serper, Jina, Exa, Crossref/Unpaywall/Semantic Scholar, Wayback, PDF extraction, verification failure modes |
| [templates/](templates/) | brief, source file, index, log, queue, project README |
| [scripts/check.sh](scripts/check.sh) | mechanical checks for one project |
| `projects/<slug>/` | one research project |

A project:

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

## Checks

```bash
scripts/check.sh <slug>          # links, orphans, numbering, required fields, duplicates
scripts/check.sh <slug> --urls   # also confirm every source URL resolves
```

## Requirements

Claude Code, `curl`, `jq`, `pdftotext` (`brew install poppler`). OpenAlex, arXiv, Crossref,
Semantic Scholar, Unpaywall, and the Wayback Machine need no key. Serper, Exa, and Jina keys go in
`.env`, which is gitignored.
