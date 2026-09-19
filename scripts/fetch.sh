#!/usr/bin/env bash
# Fetch a URL as text. PDFs go through pdftotext -layout; everything else through Jina Reader.
# Usage: scripts/fetch.sh <url> [outfile]   (stdout if no outfile)
set -uo pipefail
. "$(dirname "$0")/_env.sh"
url="${1:?usage: scripts/fetch.sh <url> [outfile]}"; out="${2:-/dev/stdout}"
tmp="$(mktemp)"; trap 'rm -f "$tmp"' EXIT
curl -sL --max-time 90 -A "Mozilla/5.0" "$url" -o "$tmp"
if file "$tmp" | grep -q PDF; then
  pdftotext -layout "$tmp" "$out"
else
  auth=(); [ -n "${JINA_API_KEY:-}" ] && auth=(-H "Authorization: Bearer $JINA_API_KEY")
  curl -s --max-time 90 "https://r.jina.ai/$url" "${auth[@]}" -o "$tmp"
  if grep -qiE "Just a moment|requiring CAPTCHA" "$tmp"; then
    echo "blocked by a bot check: $url (see tools/metadata.md for other routes)" >&2; exit 4
  fi
  cat "$tmp" > "$out"
fi
