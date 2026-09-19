---
name: verify
description: Audit an existing research project - run mechanical checks, re-check load-bearing claims against full text, prune files that misdescribe their sources, rebuild summaries. Use before updating or sharing a project, or when the user asks to check, audit, or verify one.
---

# Verify

Phases 0, 3, 4, 5, and 6 of `METHOD.md` for `projects/<slug>/`.

1. **Mechanical checks.** `scripts/check.sh <slug> --urls`. Fix broken links, orphans, collisions,
   missing fields, and undefined claim IDs first.
2. **Load-bearing claims.** Every claim ID cited in `README.md` or `outputs/`. List them with their
   source files.
3. **Uncited statements.** Every number or factual statement in `README.md` or `outputs/` with no
   claim ID.
4. **Re-check each load-bearing claim** against the source's full text (`.cache/` if present,
   otherwise refetch): confirm the record with `scripts/doi.sh`, find the number, confirm boundary,
   method, funding, status, and relevance to `brief.md`. Outcome per source file: `OK`, `FIXED`
   (rewrite it to match the source), or `DELETE`. Update claim statuses to match. Use subagents
   with exclusive file lists for large projects.
5. **Prune** in the order in `METHOD.md`. Commit removals with the reason in the message.
6. **Rebuild** `_index.md`, `README.md`, and affected outputs from the surviving files and claims,
   not by editing the old versions. Cut statements no claim supports.
7. **Report in conversation:** counts per outcome, every correction with old and new claim, every
   statement cut. Files carry the corrected state only.
