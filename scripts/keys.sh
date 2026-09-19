#!/usr/bin/env bash
# Report which providers are usable with the keys present. Run at the start of any task.
set -uo pipefail
. "$(dirname "$0")/_env.sh"
row() { printf "%-16s %-8s %s\n" "$1" "$2" "$3"; }
echo "Search and fetch providers (see tools/search-providers.md for free tiers)"
echo
row PROVIDER STATUS USE
for p in openalex arxiv semanticscholar crossref europepmc core; do row "$p" ready "academic search, no key"; done
for p in tavily serper serpapi brave exa jina; do
  k=$(key_for "$p")
  if has "$k"; then row "$p" ready "web search ($k)"; else row "$p" "no key" "set $k to enable"; fi
done
has CONTACT_EMAIL && row unpaywall ready "open-access lookup in doi.sh" || row unpaywall "no key" "set CONTACT_EMAIL to enable"
echo
avail=""; for p in $WEB_SEARCH_ORDER; do has "$(key_for "$p")" && avail="$avail $p"; done
if [ -n "$avail" ]; then
  echo "web search order:$avail"
else
  echo "web search: none available. Academic search and fetch.sh (Jina keyless) still work."
  echo "Ask the human for a free key: TAVILY_API_KEY (1,000 credits/month) or SERPER_API_KEY (2,500 queries once)."
fi
fetchers="pdftotext jina"; has TAVILY_API_KEY && fetchers="$fetchers tavily"; has EXA_API_KEY && fetchers="$fetchers exa"
echo "fetch chain: $fetchers"
for b in curl jq pdftotext; do command -v "$b" >/dev/null || echo "MISSING BINARY: $b"; done
