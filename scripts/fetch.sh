#!/usr/bin/env bash
# Fetch a URL as text, trying each available route in turn. The route used goes to stderr.
#   PDF -> pdftotext -layout; otherwise Jina Reader (keyless works) -> Tavily extract -> Exa contents.
# Usage: scripts/fetch.sh <url> [outfile]   (stdout if no outfile). Exits 4 if every route is blocked.
set -uo pipefail
. "$(dirname "$0")/_env.sh"
url="${1:?usage: scripts/fetch.sh <url> [outfile]}"; out="${2:-/dev/stdout}"
tmp="$(mktemp)"; trap 'rm -f "$tmp"' EXIT
blocked() { [ ! -s "$tmp" ] || [ "$(wc -c <"$tmp")" -lt 500 ] || grep -qiE "Just a moment|requiring CAPTCHA|Access Denied|enable JavaScript and cookies" "$tmp"; }
done_with() { echo "[fetch: $1]" >&2; cat "$tmp" > "$out"; exit 0; }

curl -sL --max-time 90 -A "Mozilla/5.0" "$url" -o "$tmp"
if file "$tmp" | grep -q PDF; then pdftotext -layout "$tmp" - > "$tmp.txt" && mv "$tmp.txt" "$tmp" && done_with pdftotext; fi

auth=(); has JINA_API_KEY && auth=(-H "Authorization: Bearer $JINA_API_KEY")
curl -s --max-time 90 "https://r.jina.ai/$url" "${auth[@]}" -o "$tmp"; blocked || done_with jina

if has TAVILY_API_KEY; then
  curl -s --max-time 90 -X POST https://api.tavily.com/extract -H "Authorization: Bearer $TAVILY_API_KEY" -H "Content-Type: application/json" \
    -d "$(jq -n --arg u "$url" '{urls:[$u]}')" | jq -r '.results[0].raw_content // empty' > "$tmp"; blocked || done_with tavily
fi
if has EXA_API_KEY; then
  curl -s --max-time 90 -X POST https://api.exa.ai/contents -H "x-api-key: $EXA_API_KEY" -H "Content-Type: application/json" \
    -d "$(jq -n --arg u "$url" '{urls:[$u],text:true}')" | jq -r '.results[0].text // empty' > "$tmp"; blocked || done_with exa
fi
echo "blocked on every available route: $url" >&2
echo "next: a repository copy (tools/metadata.md), or ask the human to paste the text or drop the" >&2
echo "file into <project>/inputs/ and log it under 'Waiting on the human' in _queue.md" >&2
exit 4
