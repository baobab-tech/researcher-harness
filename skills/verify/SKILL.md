---
name: verify
description: Audit an existing research project - run the mechanical checks, re-pull load-bearing sources against full text, prune files that misdescribe their sources, and rebuild the summaries. Use before updating a project, before sharing its outputs, or when the user asks to check, audit, or verify a project.
---

# Verify

Follows phases 0, 3, 4, 5, and 6 of `METHOD.md` for `projects/<slug>/`.

1. **Mechanical checks.** `scripts/check.sh <slug> --urls`. Fix broken links, orphans, collisions,
   and missing fields first.

2. **Find load-bearing files.** Every source file linked from `README.md` or `outputs/`, and every
   file carrying a number. List them.

3. **Find unsupported claims.** Every figure and factual claim in `README.md` and `outputs/` that
   links to no source file.

4. **Re-pull each load-bearing file's source** against full text. For each:
   - confirm the record on Crossref
   - find every number from the file in the source
   - confirm boundary, method, funding, epistemic status
   - check relevance against `brief.md` using the source's own text

   Outcome per file: `OK`, `FIXED` (rewrite the file to match the source), or `DELETE`. Use
   subagents with exclusive file lists for large projects.

5. **Prune** in the order given in `METHOD.md`. Commit removals with the reason in the message.

6. **Rebuild** `_index.md`, `README.md`, and affected `outputs/` from the surviving files, not by
   editing the old versions. Cut any claim that no verified file supports.

7. **Report to the user** in conversation: counts per outcome, every correction with the old and
   new claim, and every claim cut. Files carry the corrected state only.
