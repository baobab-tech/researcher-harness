#!/usr/bin/env bash
# Mechanical checks for one project. Usage: scripts/check.sh <slug> [--urls]
set -uo pipefail

cd "$(dirname "$0")/.."
slug="${1:?usage: scripts/check.sh <slug> [--urls]}"
p="projects/$slug"
[ -d "$p" ] || { echo "no such project: $p"; exit 2; }
fail=0
flag() { echo "$1"; fail=1; }

shopt -s nullglob
files=("$p"/sources/[0-9]*.md)
echo "== $p: ${#files[@]} source files"

# 1. Index rows point at files that exist
grep -oE '\(sources/[0-9]{3}-[^)]+\.md\)' "$p/_index.md" | tr -d '()' | while read -r b; do
  [ -f "$p/$b" ] || echo "BROKEN index row: $p/$b"
done | grep . && fail=1

# 2. Every source file appears in the index
for f in "${files[@]}"; do
  grep -q "(sources/$(basename "$f"))" "$p/_index.md" || flag "ORPHAN $f"
done

# 3. No sequence-number collisions
dups=$(for f in "${files[@]}"; do basename "$f" | cut -c1-3; done | sort | uniq -d)
[ -n "$dups" ] && flag "NUMBER COLLISION: $dups"

# 4. Every source file has a URL
for f in "${files[@]}"; do grep -q '^\*\*URL:\*\*' "$f" || flag "NO URL $f"; done

# 5. Relative links in summaries resolve
for m in "$p/README.md" "$p/brief.md" "$p"/outputs/*.md; do
  [ -f "$m" ] || continue
  d=$(dirname "$m")
  grep -oE '\]\([^)#:]+\.md\)' "$m" | sed -E 's/^\]\(|\)$//g' | sort -u | while read -r l; do
    [ -e "$d/$l" ] || echo "MISSING link in $m: $l"
  done
done | grep . && fail=1

# 6. Format compliance
for field in '^\*\*Type:' '^\*\*Published:' '^## Finding' '^## Methodology' '^## Limitations'; do
  for f in "${files[@]}"; do grep -qE "$field" "$f" || flag "MISSING $field in $f"; done
done

# 7. Sources held in more than one file (judgment call, reported not failed)
grep -h '^\*\*URL:\*\*' "${files[@]}" /dev/null 2>/dev/null | sed 's/^\*\*URL:\*\* *//' | sort | uniq -c | awk '$1>1 {print "SHARED URL (check findings differ):", $2}'

# 8. No changelog scaffolding
grep -lniE 'supersede|correction needed|previously stated|corrected excerpt' \
  "${files[@]}" "$p/README.md" "$p"/outputs/*.md 2>/dev/null | sed 's/^/CHANGELOG TEXT in /' | grep . && fail=1

# 9. Claims ledger: unique IDs, source files exist, every cited ID is defined
if [ -f "$p/claims.md" ]; then
  ids=$(grep -oE "^\| C[0-9]{3} " "$p/claims.md" | tr -d "| ")
  dup=$(echo "$ids" | sort | uniq -d); [ -n "$dup" ] && flag "DUPLICATE CLAIM ID: $dup"
  grep -oE "sources/[0-9]{3}-[^)| ]+\.md" "$p/claims.md" | sort -u | while read -r s; do
    [ -f "$p/$s" ] || echo "CLAIM CITES MISSING FILE: $s"
  done | grep . && fail=1
  grep -ohE "\[C[0-9]{3}\]" "$p/README.md" "$p"/outputs/*.md 2>/dev/null | tr -d "[]" | sort -u | while read -r c; do
    echo "$ids" | grep -qx "$c" || echo "UNDEFINED CLAIM $c cited in outputs"
  done | grep . && fail=1
  echo "claims: $(echo "$ids" | grep -c .) defined, $(grep -ohE "\[C[0-9]{3}\]" "$p/README.md" "$p"/outputs/*.md 2>/dev/null | sort -u | wc -l | tr -d " ") cited"
  cited=$(grep -ohE "\[C[0-9]{3}\]" "$p/README.md" "$p"/outputs/*.md 2>/dev/null | tr -d "[]" | sort -u)
  human=$(awk -F"|" -v c="$(echo $cited)" 'BEGIN{n=split(c,a," ");for(i=1;i<=n;i++)w[a[i]]=1} $2~/C[0-9]/{id=$2;gsub(/ /,"",id); if(w[id]&&$9~/confirmed/)k++} END{print k+0}' "$p/claims.md")
  echo "human-confirmed: $human of the cited claims"
  awk -F"|" '$2~/C[0-9]/ && $9~/wrong/{gsub(/ /,"",$2); print "CLAIM MARKED WRONG BY HUMAN: " $2}' "$p/claims.md" | grep . && fail=1
  [ -f "$p/brief.md" ] && grep -qE "\| *assumed *\| *$" "$p/brief.md" && echo "NOTE: brief.md has assumed decisions awaiting the human"
else
  echo "no claims.md"
fi

# 10. URLs resolve (slow; opt in). 403 = bot-blocked, not dead.
if [ "${2:-}" = "--urls" ]; then
  grep -h '^\*\*URL:\*\*' "${files[@]}" /dev/null | sed 's/^\*\*URL:\*\* *//' | sort -u | while read -r u; do
    c=$(curl -s -o /dev/null -w "%{http_code}" -L --max-time 20 "$u")
    case "$c" in 200|202|301|302|403) ;; *) echo "URL FAIL $c $u";; esac
  done | grep . && fail=1
fi

[ "$fail" -eq 0 ] && echo "OK" || { echo "FAILED"; exit 1; }
