#!/usr/bin/env bash
# Confirm a DOI's record and find full-text routes. Usage: scripts/doi.sh <doi>
set -uo pipefail
. "$(dirname "$0")/_env.sh"
doi="${1:?usage: scripts/doi.sh <doi>}"
echo "--- Crossref"
curl -s "https://api.crossref.org/works/$doi" | jq -r '.message | "title:   \(.title[0])\nauthors: \([.author[]?|"\(.given) \(.family)"]|join("; "))\nvenue:   \(.["container-title"][0]) \(.published["date-parts"][0][0])"'
if [ -n "${CONTACT_EMAIL:-}" ]; then
  echo "--- Unpaywall"
  curl -s "https://api.unpaywall.org/v2/$doi?email=$CONTACT_EMAIL" | jq -r '"oa=\(.is_oa) status=\(.oa_status) pdf=\(.best_oa_location.url_for_pdf // "none")\nrepos: \([.oa_locations[]?|select(.host_type=="repository")|.url_for_pdf // .url]|join(" "))"'
else
  echo "--- Unpaywall skipped: set CONTACT_EMAIL in .env"
fi
echo "--- Semantic Scholar"
curl -s ${SEMANTIC_SCHOLAR_API_KEY:+-H "x-api-key: $SEMANTIC_SCHOLAR_API_KEY"} "https://api.semanticscholar.org/graph/v1/paper/DOI:$doi?fields=openAccessPdf,externalIds" | jq -r '"pdf=\(.openAccessPdf.url // "none") arxiv=\(.externalIds.ArXiv // "none") pmc=\(.externalIds.PubMedCentral // "none")"'
