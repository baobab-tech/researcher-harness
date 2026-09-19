#!/usr/bin/env bash
# One-screen state of every project, or one: sources, claims, human checks, what waits on the human.
# Usage: scripts/status.sh [slug]
set -uo pipefail
cd "$(dirname "$0")/.."
shopt -s nullglob
slugs=("$@"); [ ${#slugs[@]} -eq 0 ] && for d in projects/*/; do [ -f "$d/brief.md" ] && slugs+=("$(basename "$d")"); done
[ ${#slugs[@]} -eq 0 ] && { echo "no projects yet: start one with skills/new-project"; exit 0; }
today=$(date +%Y-%m)
for s in "${slugs[@]}"; do
  p="projects/$s"
  src=("$p"/sources/[0-9]*.md); outs=("$p"/outputs/[!_]*.md)
  updated=$(grep -m1 -oE "Last updated: [0-9-]+" "$p/_queue.md" 2>/dev/null | cut -d' ' -f3)
  process=$(grep -m1 -oE "^\*\*Process:\*\* .*" "$p/brief.md" | sed 's/\*\*Process:\*\* //')
  echo "== $s  (${process:-no process set}; queue updated ${updated:-never})"
  if [ -f "$p/claims.md" ]; then
    cited=" $(grep -ohE "\[C[0-9]{3}\]" "$p/README.md" "${outs[@]}" 2>/dev/null | tr -d '[]' | sort -u | tr '\n' ' ') "
    awk -v today="$today" -v cited="$cited" '
      /^### C[0-9]/ { id = substr($2, 1, 4); n++; if (index(cited, " " id " ")) c++ }
      /^- \*\*Human:\*\* confirmed/ { if (index(cited, " " id " ")) h++ }
      /^- \*\*Human:\*\* wrong/ { w = w " " id }
      /^- \*\*Recheck:\*\* [0-9]{4}-[0-9]{2}/ { if (substr($3, 1, 7) < today) r = r " " id }
      END {
        printf "   %d claims, %d cited in outputs, %d of those human-confirmed\n", n, c, h
        if (w != "") print "   marked wrong by human:" w
        if (r != "") print "   recheck due:" r
      }' "$p/claims.md"
  fi
  echo "   ${#src[@]} sources, ${#outs[@]} outputs"
  assumed=$(grep -cE "\| *assumed *\| *$" "$p/brief.md")
  [ "$assumed" -gt 0 ] && echo "   $assumed decisions assumed, awaiting the human (brief.md)"
  waiting=$(awk '/^## Waiting on the human/{f=1; next} /^## /{f=0} f && /^- /' "$p/_queue.md" 2>/dev/null)
  [ -n "$waiting" ] && { echo "   waiting on the human:"; echo "$waiting" | sed 's/^/     /'; }
  next=$(awk '/^## Next/{f=1; next} /^## /{f=0} f && /^- \[ \]/' "$p/_queue.md" 2>/dev/null | head -3)
  [ -n "$next" ] && { echo "   next:"; echo "$next" | sed 's/^/     /'; }
done
