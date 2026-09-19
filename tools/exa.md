# Exa

Key in `.env` as `EXA_API_KEY`.

Use Exa for `/contents`. In a September 2026 test, neural search on a technical topic returned SEO
blog restatement and no primary sources, while content extraction on open pages returned clean
full text and beat `WebFetch`.

## Content extraction

```bash
set -a; source .env; set +a
curl -s -X POST "https://api.exa.ai/contents" \
  -H "x-api-key: $EXA_API_KEY" -H "Content-Type: application/json" \
  -d '{"urls":["https://arxiv.org/abs/2508.15734"],"text":true}' \
  | jq -r '.results[0].text' > "$TMPDIR/paper.txt"
```

Options:

```json
{
  "urls": ["..."],
  "text": {"maxCharacters": 100000, "includeHtmlTags": false},
  "highlights": {"query": "...", "numSentences": 3},
  "summary": {"query": "..."}
}
```

`highlights` and `summary` are model output, not source text. For verification, read `text`.

It does not defeat publisher bot-blocking. A gold-OA Wiley paper returned 0 characters.

## Search

```bash
curl -s -X POST "https://api.exa.ai/search" \
  -H "x-api-key: $EXA_API_KEY" -H "Content-Type: application/json" \
  -d '{"query":"...","numResults":10,"type":"neural","category":"research paper","startPublishedDate":"2026-01-01"}' \
  | jq -r '.results[] | "\(.publishedDate) | \(.title) | \(.url)"'
```

Treat every result as a lead to a primary document, never as a source. Secondary restatement of a
figure is how errors enter a corpus.

Domain-scoped search behaves as a site-scoped fetch and is the one search mode worth using:

```json
{"includeDomains": ["example-agency.gov", "example-regulator.org"]}
```

For discovery, prefer Serper aimed at named documents, OpenAlex and arXiv for academic work, and
Semantic Scholar citation graphs from a known paper.
