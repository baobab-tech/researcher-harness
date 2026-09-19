#!/usr/bin/env bash
# Search. Prints "year | title | url-or-id" lines; the provider used goes to stderr.
#
#   scripts/search.sh academic "<query>" [n]   OpenAlex, no key
#   scripts/search.sh web "<query>" [n]        first keyed provider in WEB_SEARCH_ORDER
#   scripts/search.sh news "<query>" [n]       Tavily (news topic) or Serper news
#   scripts/search.sh <provider> "<query>" [n]
#
# Providers: openalex arxiv semanticscholar crossref europepmc core   (no key)
#            tavily serper scholar brave exa jina                      (key; see scripts/keys.sh)
set -uo pipefail
. "$(dirname "$0")/_env.sh"
mode="${1:?usage: scripts/search.sh <academic|web|news|provider> <query> [n]}"; q="${2:?query}"; n="${3:-10}"
enc() { jq -rn --arg s "$1" '$s|@uri'; }

run() {
  echo "[search: $1]" >&2
  case "$1" in
    openalex)
      curl -s "https://api.openalex.org/works?search=$(enc "$q")&per_page=$n${CONTACT_EMAIL:+&mailto=$CONTACT_EMAIL}" \
        | jq -r '.results[] | "\(.publication_year) | \(.title) | \(.doi // .id)"' ;;
    arxiv)
      curl -s "https://export.arxiv.org/api/query?search_query=$(enc "all:${q// / AND all:}")&max_results=$n" \
        | awk '/<entry>/{e=1} e&&/<published>/{gsub(/.*<published>|-.*/,"");y=$0} e&&/<title>/{gsub(/.*<title>|<\/title>.*/,"");t=$0} e&&/<id>/{gsub(/.*<id>|<\/id>.*/,"");i=$0} /<\/entry>/{print y" | "t" | "i; e=0}' ;;
    semanticscholar)
      curl -s ${SEMANTIC_SCHOLAR_API_KEY:+-H "x-api-key: $SEMANTIC_SCHOLAR_API_KEY"} \
        "https://api.semanticscholar.org/graph/v1/paper/search?query=$(enc "$q")&limit=$n&fields=title,year,externalIds,url" \
        | jq -r 'if .data then .data[] | "\(.year) | \(.title) | \(if .externalIds.DOI then "https://doi.org/"+.externalIds.DOI else .url end)" else "error: \(.message // .code // "rate limited; retry or set SEMANTIC_SCHOLAR_API_KEY")" end' ;;
    crossref)
      curl -s "https://api.crossref.org/works?query=$(enc "$q")&rows=$n${CONTACT_EMAIL:+&mailto=$CONTACT_EMAIL}" \
        | jq -r '.message.items[] | "\(.issued["date-parts"][0][0]) | \(.title[0]) | https://doi.org/\(.DOI)"' ;;
    europepmc)
      curl -s "https://www.ebi.ac.uk/europepmc/webservices/rest/search?query=$(enc "$q")&format=json&pageSize=$n" \
        | jq -r '.resultList.result[] | "\(.pubYear) | \(.title) | \(if .doi then "https://doi.org/"+.doi else "https://europepmc.org/article/\(.source)/\(.id)" end)"' ;;
    core)
      curl -sL ${CORE_API_KEY:+-H "Authorization: Bearer $CORE_API_KEY"} "https://api.core.ac.uk/v3/search/works/?q=$(enc "$q")&limit=$n" \
        | jq -r 'if .results then .results[] | "\(.yearPublished) | \(.title) | \(.downloadUrl // (if .doi then "https://doi.org/"+.doi else "core:\(.id)" end))" else "error: \(.message // "CORE unavailable")" end' ;;
    tavily)
      need_key TAVILY_API_KEY
      curl -s -X POST https://api.tavily.com/search -H "Authorization: Bearer $TAVILY_API_KEY" -H "Content-Type: application/json" \
        -d "$(jq -n --arg q "$q" --argjson n "$n" --arg t "${TOPIC:-general}" '{query:$q,max_results:$n,search_depth:"basic",topic:$t}')" \
        | jq -r '.results[] | "\(.published_date // "-") | \(.title) | \(.url)"' ;;
    serper|scholar|serper-news)
      need_key SERPER_API_KEY
      ep=search; [ "$1" = scholar ] && ep=scholar; [ "$1" = serper-news ] && ep=news
      curl -s -X POST "https://google.serper.dev/$ep" -H "X-API-KEY: $SERPER_API_KEY" -H "Content-Type: application/json" \
        -d "$(jq -n --arg q "$q" --argjson n "$n" '{q:$q,num:$n}')" \
        | jq -r '(.organic // .news)[] | "\(.year // .date // "-") | \(.title) | \(.link)"' | head -n "$n" ;;
    brave)
      need_key BRAVE_API_KEY
      curl -s "https://api.search.brave.com/res/v1/web/search?q=$(enc "$q")&count=$n" -H "Accept: application/json" -H "X-Subscription-Token: $BRAVE_API_KEY" \
        | jq -r '.web.results[] | "\(.age // "-") | \(.title) | \(.url)"' ;;
    exa)
      need_key EXA_API_KEY
      curl -s -X POST https://api.exa.ai/search -H "x-api-key: $EXA_API_KEY" -H "Content-Type: application/json" \
        -d "$(jq -n --arg q "$q" --argjson n "$n" '{query:$q,numResults:$n}')" \
        | jq -r '.results[] | "\((.publishedDate // "-")[0:10]) | \(.title) | \(.url)"' ;;
    jina)
      need_key JINA_API_KEY
      curl -s "https://s.jina.ai/?q=$(enc "$q")" -H "Authorization: Bearer $JINA_API_KEY" -H "Accept: application/json" -H "X-Respond-With: no-content" \
        | jq -r '.data[] | "- | \(.title) | \(.url)"' | head -n "$n" ;;
    *) echo "unknown provider: $1" >&2; exit 2 ;;
  esac
}

case "$mode" in
  academic) run openalex ;;
  web)
    for p in $WEB_SEARCH_ORDER; do has "$(key_for "$p")" && { run "$p"; exit; }; done
    echo "no web search key set. Use 'academic', or add TAVILY_API_KEY or SERPER_API_KEY (tools/search-providers.md)" >&2; exit 3 ;;
  news)
    if has TAVILY_API_KEY; then TOPIC=news run tavily
    elif has SERPER_API_KEY; then run serper-news
    else echo "news search needs TAVILY_API_KEY or SERPER_API_KEY" >&2; exit 3; fi ;;
  *) run "$mode" ;;
esac
