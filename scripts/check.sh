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

# 9. Claims ledger: IDs, required fields, source links, cited IDs, human marks, recheck dates
if [ -f "$p/claims.md" ]; then
  ids=$(grep -oE "^### C[0-9]{3}" "$p/claims.md" | cut -c5-)
  dup=$(echo "$ids" | sort | uniq -d); [ -n "$dup" ] && flag "DUPLICATE CLAIM ID: $dup"
  grep -oE "sources/[0-9]{3}-[^)| ]+\.md" "$p/claims.md" | sort -u | while read -r s; do
    [ -f "$p/$s" ] || echo "CLAIM CITES MISSING FILE: $s"
  done | grep . && fail=1
  cited=$(grep -ohE "\[C[0-9]{3}\]" "$p/README.md" "$p"/outputs/*.md 2>/dev/null | tr -d "[]" | sort -u)
  for c in $cited; do echo "$ids" | grep -qx "$c" || echo "UNDEFINED CLAIM $c cited in outputs"; done | grep . && fail=1
  ctmp=$(mktemp)
  awk -v today="$(date +%Y-%m)" -v cited=" $(echo $cited) " '
    function finish() {
      if (id == "") return
      n = split("Statement Scope Period Attributed_to Kind Sources Status Checked Recheck Human", req, " ")
      for (i = 1; i <= n; i++) { k = req[i]; gsub(/_/, " ", k)
        if (!(k in f)) print "MISSING FIELD " k " in " id
        else if (f[k] == "" && k != "Human") print "EMPTY FIELD " k " in " id }
      if (f["Kind"] != "inference" && f["Quote"] == "") print "NO QUOTE in " id
      if (f["Kind"] == "inference" && f["Depends on"] == "") print "INFERENCE WITHOUT Depends on in " id
      if (f["Human"] ~ /^wrong/) print "CLAIM MARKED WRONG BY HUMAN: " id
      if (f["Recheck"] ~ /^[0-9][0-9][0-9][0-9]-[0-9][0-9]/ && substr(f["Recheck"],1,7) < today) print "RECHECK DUE " id " (" f["Recheck"] ")"
      if (index(cited, " " id " ")) { nc++; if (f["Human"] ~ /^confirmed/) nh++ }
      total++
      split("", f)
    }
    /^### C[0-9][0-9][0-9]/ { finish(); id = substr($2, 1, 4); next }
    id != "" && /^- \*\*[A-Za-z ]+:\*\*/ {
      line = $0; sub(/^- \*\*/, "", line); k = line; sub(/:\*\*.*/, "", k)
      v = line; sub(/^[^*]*:\*\* ?/, "", v); f[k] = v
    }
    END { finish(); printf "claims: %d defined, %d cited, %d of the cited human-confirmed\n", total, nc, nh }
  ' "$p/claims.md" > "$ctmp" 2>&1 || true
  grep -vE "^claims:|^RECHECK DUE" "$ctmp" | grep . && fail=1
  grep -E "^claims:|^RECHECK DUE" "$ctmp"
  rm -f "$ctmp"
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
