# Metadata

Wrapped by `scripts/doi.sh <doi>`. The calls below are for anything the script does not cover.

Verify a source's identity before writing about it. Crossref, Semantic Scholar, and Unpaywall are
free and need no key. Unpaywall requires a contact email: set `CONTACT_EMAIL` in `.env`.

## Mandatory check: confirm the record

```bash
DOI="10.1038/s41586-024-07487-w"
curl -s "https://api.crossref.org/works/$DOI" | jq -r '.message | {
  title: .title[0],
  authors: [.author[]? | "\(.given) \(.family)"] | join("; "),
  container: .["container-title"][0],
  year: (.published["date-parts"][0][0]),
  volume, page, publisher
}'
```

If the returned title does not match the paper, the DOI is wrong. If the author list does not
match the file's `**Source:**` line, the citation is wrong.

## Find a legal full-text copy

### Unpaywall

```bash
set -a; source .env; set +a
curl -s "https://api.unpaywall.org/v2/$DOI?email=$CONTACT_EMAIL" | jq -r '{
  is_oa, oa_status,
  pdf: .best_oa_location.url_for_pdf,
  landing: .best_oa_location.url_for_landing_page,
  host: .best_oa_location.host_type,
  repos: [.oa_locations[]? | select(.host_type=="repository") | .url_for_pdf]
}'
```

`oa_status`: `gold` (publisher OA), `green` (repository copy), `hybrid`, `bronze` (free to read,
no licence), `closed`.

`is_oa: true` does not mean retrievable. A gold-OA paper on a publisher that blocks automated
requests returns `url_for_pdf: null`; check `repos` for a green copy.

### Semantic Scholar

```bash
curl -s "https://api.semanticscholar.org/graph/v1/paper/DOI:$DOI?fields=title,year,authors,openAccessPdf,externalIds,publicationVenue" | jq
```

`externalIds` often carries an `ArXiv` id even when the publisher version is paywalled. Also
accepts `arXiv:<id>` and `CorpusID:<id>` as lookup keys.

Citation graph, for snowballing a review from a known paper:

```bash
curl -s "https://api.semanticscholar.org/graph/v1/paper/DOI:$DOI/references?fields=title,year,externalIds&limit=100" | jq -r '.data[].citedPaper | "\(.year) | \(.title) | \(.externalIds.DOI // "-")"'
curl -s "https://api.semanticscholar.org/graph/v1/paper/DOI:$DOI/citations?fields=title,year,externalIds&limit=100" | jq -r '.data[].citingPaper | "\(.year) | \(.title) | \(.externalIds.DOI // "-")"'
```

### Search when there is no DOI

```bash
curl -s -G "https://api.crossref.org/works" \
  --data-urlencode "query.bibliographic=<title words and first author>" \
  --data-urlencode "rows=5" \
  | jq -r '.message.items[] | "\(.DOI) | \(.title[0]) | \([.author[]?|.family]|join(", "))"'
```

## Citation counts

Not evidence. They go stale, vary by index, and say nothing about whether a claim is correct. If
recorded, date them and name the index.

## One check, three calls

```bash
verify_doi() {
  local doi="$1"
  echo "--- Crossref ---"
  curl -s "https://api.crossref.org/works/$doi" | jq -r '.message | "\(.title[0])\n\([.author[]?|"\(.given) \(.family)"]|join("; "))\n\(.["container-title"][0]) \(.published["date-parts"][0][0])"'
  echo "--- Unpaywall ---"
  curl -s "https://api.unpaywall.org/v2/$doi?email=$CONTACT_EMAIL" | jq -r '"oa=\(.is_oa) status=\(.oa_status) pdf=\(.best_oa_location.url_for_pdf // "none")"'
  echo "--- Semantic Scholar ---"
  curl -s "https://api.semanticscholar.org/graph/v1/paper/DOI:$doi?fields=openAccessPdf,externalIds" | jq -r '"pdf=\(.openAccessPdf.url // "none") arxiv=\(.externalIds.ArXiv // "none")"'
}
```

## Retrieval order

1. arXiv id from Semantic Scholar `externalIds`, then `https://arxiv.org/pdf/<id>`
2. Green repository copy from Unpaywall `oa_locations`
3. PMC, for anything biomedical or health-adjacent
4. Jina Reader on the publisher URL (`tools/jina.md`)
5. `pdftotext -layout` on a downloaded PDF, for table-heavy documents
6. Author's institutional page or personal site
7. If none works, say so in the file's Limitations and mark what was not checked

Elsevier (ScienceDirect) and Wiley serve a Cloudflare interstitial to every automated route. Do not
retry in a loop or try to defeat the check; find another copy or record the gap.
