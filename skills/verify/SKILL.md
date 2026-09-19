---
name: verify
description: Audit an existing research project - run mechanical checks, re-check load-bearing claims against full text, prune files that misdescribe their sources, rebuild summaries, and have the human spot-check the result. Use before updating or sharing a project, or when the user asks to check, audit, or verify one.
---

# Verify

Phases 0, 3, 4, 5, and 6 of `METHOD.md` for `projects/<slug>/`.

1. **Mechanical checks.** `scripts/check.sh <slug> --urls`. Fix broken links, orphans, collisions,
   missing fields, and undefined claim IDs.

2. **Load-bearing claims.** Every claim ID cited in `README.md` or `outputs/`, with its source files.

3. **Uncited statements.** Every number or factual statement in `README.md` or `outputs/` with no
   claim ID.

4. **CHECKPOINT: design** (audit scope). Report counts from steps 1 to 3 and ask how deep to go:
   every load-bearing claim, a sample, or specific sub-questions. Ask whether anything has changed
   in their understanding since the project was written.

5. **Re-check claims** against full text (`.cache/` if present, else refetch): confirm the record
   with `scripts/doi.sh`, find the number, confirm boundary, method, funding, status, and relevance
   to `brief.md`. Outcome per source file: `OK`, `FIXED`, or `DELETE`. Deletions of load-bearing
   files wait for the human's agreement at the next checkpoint.

6. **CHECKPOINT: sanity check.** Run the `sanity-check` skill on the claims that changed plus a
   sample of those that did not. Include proposed deletions.

7. **Prune and rebuild** `_index.md`, `README.md`, and affected outputs from the surviving files and
   claims, not by editing old versions. Commit removals with the reason in the message.

8. **Report** in conversation: counts per outcome, every correction with old and new claim, every
   statement cut. **CHECKPOINT: handoff.**
