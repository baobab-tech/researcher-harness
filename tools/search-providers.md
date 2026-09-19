# Search providers

`scripts/search.sh` and `scripts/fetch.sh` use whichever providers have keys, and fall back to
keyless ones. `scripts/keys.sh` prints what is usable right now. No key is required to start:
academic search and page fetching work without one.

## What works with no keys

| Provider | Covers | Via |
|----------|--------|-----|
| OpenAlex | 240M+ scholarly works, all disciplines | `search.sh academic` or `openalex` |
| arXiv | preprints: physics, CS, maths, quantitative fields | `search.sh arxiv` |
| Crossref | DOI metadata for most journal articles | `search.sh crossref`, `doi.sh` |
| Europe PMC | biomedical and life sciences, many full texts | `search.sh europepmc` |
| CORE | open-access full texts from repositories | `search.sh core` |
| Semantic Scholar | papers and citation graphs | `search.sh semanticscholar`; the shared keyless pool often returns 429 |
| Jina Reader | any URL or PDF as text | `fetch.sh`, at a lower rate limit |
| Wayback Machine | archived pages | `tools/archive.md` |

What is missing without keys: general web search (agency reports, filings, organisational
documents, news). For most research questions that gap matters; ask the human for one free key.

## Keyed providers

Free tiers read from each provider's pricing page on 2026-09-19. They change; recheck before
relying on one.

| Provider | Variable | Free tier | Search | Fetch | Notes |
|----------|----------|-----------|--------|-------|-------|
| Tavily | `TAVILY_API_KEY` | 1,000 credits/month, no card ([pricing](https://www.tavily.com/pricing)) | yes, 1 credit (basic) | yes, 1 credit per 5 URLs | built for agents; returns page snippets; `news` topic |
| Serper | `SERPER_API_KEY` | 2,500 queries once, no card ([serper.dev](https://serper.dev)) | Google web, news, scholar | no | best for named documents and `filetype:pdf` |
| SerpApi | `SERPAPI_API_KEY` | 250 searches/month, 50/hour ([pricing](https://serpapi.com/pricing), as reported 2026-09-19) | Google web (`serpapi`) and Scholar (`serpapi-scholar`) | no | many other engines available through its API |
| Brave | `BRAVE_API_KEY` | $5 credit/month; card required for identity ([pricing](https://brave.com/search/api/)) | independent index | no | |
| Exa | `EXA_API_KEY` | $10 credit/month ([pricing](https://exa.ai/pricing)) | neural search | yes, clean text | search returns secondary content for technical topics; strong for fetch |
| Jina | `JINA_API_KEY` | 10M tokens per new key ([reader](https://jina.ai/reader)) | yes (`s.jina.ai`) | yes | key raises fetch rate limits |
| Semantic Scholar | `SEMANTIC_SCHOLAR_API_KEY` | free on application | papers | no | removes the 429s |
| CORE | `CORE_API_KEY` | free registration for a higher rate | papers | full text | works keyless |

Not wired into the scripts, available to agents with the right runtime:

- **You.com** offers keyless search over MCP at `https://api.you.com/mcp?profile=free`, 100
  queries a day ([you.com/api](https://you.com/api)). Agents that support MCP servers can add it.
- **Firecrawl** (1,000 credits/month, [pricing](https://www.firecrawl.dev/pricing)) and **Linkup**
  ("4,000 queries for free", [pricing](https://www.linkup.so/pricing)) have free tiers; add them to
  `search.sh` the same way as the others if needed.

## Choosing

Set `WEB_SEARCH_ORDER` in `.env` to change which keyed provider `search.sh web` tries first.
Default: `tavily serper serpapi brave exa jina`.

| Need | Use |
|------|-----|
| papers on a topic | `academic` (OpenAlex), then `crossref` or `europepmc` for the field |
| a named report, filing, or dataset | `serper` with the exact title, or `tavily` |
| recent developments | `news` |
| citations of a known paper | Semantic Scholar graph (`tools/metadata.md`) |
| a page behind JavaScript or a PDF | `fetch.sh` |

Every search result is a lead, never a source. Open the document it points to.

## When a provider is missing

Scripts exit 3 and name the missing variable. The agent then:

1. continues with what is available, and says in `_log.md` which providers were used
2. at the next checkpoint, tells the human what the gap costs (for example: "no web search, so
   agency reports are found only through citations in papers") and names the free tier that fills it
3. records the human's answer in `brief.md`

## Adding a provider

Add a case to `run()` in `scripts/search.sh` that prints `year | title | url` lines, a line to
`key_for()` in `scripts/_env.sh`, a row to `scripts/keys.sh`, a variable to `.env.example`, and a
row to the table above.
