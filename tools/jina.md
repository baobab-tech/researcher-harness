# Jina Reader

`r.jina.ai` fetches a URL and returns clean markdown. It renders JavaScript and handles PDFs, the
two main reasons `WebFetch` fails.

`JINA_API_KEY` in `.env` raises rate limits; it does not change which sites are reachable. For a
multi-agent pass the rate limit binds, so use the key.

## Use

```bash
set -a; source .env; set +a
curl -s --max-time 60 "https://r.jina.ai/$URL" -H "Authorization: Bearer $JINA_API_KEY" -o "$TMPDIR/doc.md"
```

Prefix any URL with `https://r.jina.ai/`. No encoding needed.

## Reachability, tested September 2026

| Publisher | Result |
|---|---|
| ACM Digital Library | full text |
| MDPI (`www.mdpi.com`) | full text |
| State and agency PDFs | full text |
| IEEE Xplore | abstract and metadata only |
| Wiley (`onlinelibrary.wiley.com`) | blocked, Cloudflare interstitial |
| Elsevier (`sciencedirect.com`) | blocked, Cloudflare interstitial |
| `ferc.gov` | blocked |

A response beginning `Title: Just a moment...` or mentioning security verification is a failed
fetch. Do not retry in a loop. Fall back to the routes in `tools/metadata.md`.

## Headers

```bash
-H "x-respond-with: text"               # plain text instead of markdown
-H "x-with-images-summary: true"        # include image alt text and captions
-H "x-wait-for-selector: .article-body" # wait for slow JS pages
-H "x-target-selector: main"            # return a subtree only
-H "x-engine: direct"                   # follow the PDF, not the landing page
```

## PDFs

Handled directly. Table fidelity is lower than `pdftotext -layout`; for documents whose numbers
live in tables, download the PDF and extract it (`tools/primary-sources.md`).

## Limits

A fetcher, not a search engine or a verifier. Confirm the record with Crossref before writing
anything up, and read the retrieved text, not a summary of it.
