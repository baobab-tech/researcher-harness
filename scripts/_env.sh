# Sourced by other scripts: loads .env from the repo root and checks required keys.
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
[ -f "$ROOT/.env" ] && { set -a; . "$ROOT/.env"; set +a; }
need_key() {
  for k in "$@"; do
    [ -n "${!k:-}" ] || { echo "missing $k: add it to $ROOT/.env (see .env.example)" >&2; exit 3; }
  done
}
