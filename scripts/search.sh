#!/usr/bin/env bash
# Search one backend, print "year | title | id-or-url" lines.
# Usage: scripts/search.sh <openalex|arxiv|scholar|web|news> "<query>" [n]
set -uo pipefail
. "$(dirname "$0")/_env.sh"
src="${1:?usage: scripts/search.sh <openalex|arxiv|scholar|web|news> <query> [n]}"; q="${2:?query}"; n="${3:-10}"
serper() {
  need_key SERPER_API_KEY
  curl -s -X POST "https://google.serper.dev/$1" -H "X-API-KEY: $SERPER_API_KEY" -H "Content-Type: application/json" \
    -d "$(jq -n --arg q "$q" --argjson n "$n" '{q:$q,num:$n}')"
}
case "$src" in
  openalex)
    curl -s -G "https://api.openalex.org/works" --data-urlencode "search=$q" --data-urlencode "per_page=$n" \
      ${CONTACT_EMAIL:+--data-urlencode "mailto=$CONTACT_EMAIL"} \
      | jq -r '.results[] | "\(.publication_year) | \(.title) | \(.doi // .id)"' ;;
  arxiv)
    curl -s -G "https://export.arxiv.org/api/query" --data-urlencode "search_query=all:${q// / AND all:}" --data-urlencode "max_results=$n" \
      | awk '/<entry>/{e=1} e&&/<published>/{gsub(/.*<published>|-.*/,"");y=$0} e&&/<title>/{gsub(/.*<title>|<\/title>.*/,"");t=$0} e&&/<id>/{gsub(/.*<id>|<\/id>.*/,"");i=$0} /<\/entry>/{print y" | "t" | "i; e=0}' ;;
  scholar) serper scholar | jq -r '.organic[] | "\(.year // "-") | \(.title) | \(.link)"' | head -n "$n" ;;
  web)     serper search  | jq -r '.organic[] | "- | \(.title) | \(.link)"' | head -n "$n" ;;
  news)    serper news    | jq -r '.news[] | "\(.date) | \(.title) | \(.link)"' | head -n "$n" ;;
  *) echo "unknown backend: $src" >&2; exit 2 ;;
esac
