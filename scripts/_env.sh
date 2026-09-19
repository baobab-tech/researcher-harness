# Sourced by other scripts. Loads .env from the repo root (environment variables already set win),
# and defines helpers for optional keys.
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
if [ -f "$ROOT/.env" ]; then
  while IFS='=' read -r k v; do
    [[ "$k" =~ ^[A-Z_][A-Z0-9_]*$ ]] || continue
    v="${v%$'\r'}"; v="${v#[\"\']}"; v="${v%[\"\']}"
    [ -n "${!k:-}" ] || export "$k=$v"
  done < "$ROOT/.env"
fi

has() { [ -n "${!1:-}" ]; }

need_key() {
  for k in "$@"; do
    has "$k" || { echo "missing $k. Add it to $ROOT/.env or the environment; free tiers: tools/search-providers.md" >&2; exit 3; }
  done
}

# Default order for web search when no provider is named. Override with WEB_SEARCH_ORDER in .env.
WEB_SEARCH_ORDER="${WEB_SEARCH_ORDER:-tavily serper serpapi brave exa jina}"

key_for() {
  case "$1" in
    tavily) echo TAVILY_API_KEY ;; serper|scholar) echo SERPER_API_KEY ;; serpapi) echo SERPAPI_API_KEY ;; brave) echo BRAVE_API_KEY ;;
    exa) echo EXA_API_KEY ;; jina) echo JINA_API_KEY ;; *) echo "" ;;
  esac
}
