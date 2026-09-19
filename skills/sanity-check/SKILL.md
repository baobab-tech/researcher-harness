---
name: sanity-check
description: Have the human spot-check claims against their sources before any output is written or shared - asking whether now or later, how many, and whether one at a time or by reviewing a file - then record their answers in claims.md. Use at the sanity-check checkpoint of every skill, before sharing any output, or when the user asks to check the findings.
---

# Sanity check

The human verifies a sample of claims against the sources themselves. This catches what automated
checks miss: a number read from the wrong table, a boundary misstated, a framing the source would
not sign.

## 1. Prepare the claims

Pick from `claims.md`, ranked so the most important come first:

1. **load-bearing:** cited most often, or the answer depends on them
2. **surprising:** contradict common belief or the human's priors in `brief.md`
3. **contested** or **derived:** status `contested`, or computed from the source's inputs
4. **coverage:** at least one per source type

For each claim, find the exact quote in the cached text (`.cache/`) and a direct link with page or
section. A claim you cannot quote is not ready; fix it before asking anyone to check it.

Write the ranked list to `outputs/_sanity-check.md` from `templates/sanity-check.md`. It is the
record whichever way the check runs.

## 2. Ask how they want to do it

One set-up question per item, with the structured question tool if you have one (see How to ask in
`AGENTS.md`):

- **When:** now (recommended) / later
- **How much:** quick, the top 3 / standard, the top 6 to 10 (recommended) / thorough, every
  load-bearing claim
- **How:** one at a time here (recommended when there is a question tool) / review the file and
  comment

If later: add the check to `_queue.md` under "Waiting on the human" with the packet path, say in the
output's Human review section that no claims were human-checked yet, and continue. Raise it again
at the next checkpoint or session start.

## 3a. One at a time

For each claim, in ranked order, ask one question:

- **Question text:** the claim ID and statement, the quote from the source, and the link
- **Options:** Confirmed / Wrong / Unsure / Skip. The human can add a note to any of them

Record each answer before asking the next. After every few claims, if the human's notes suggest
fatigue or a pattern (for example two `wrong` in a row from one source), ask whether to stop,
continue, or switch to checking that source in full.

## 3b. Review the file

Tell the human where the packet is: `outputs/_sanity-check.md`, or the artifact or doc you
published if your runtime can. Ask them to mark each row's "Your check" column `confirmed`, `wrong`,
or `unsure` and add notes, or to comment inline, then tell you when they are done. Read their marks
and comments back from the file or artifact.

## 4. Record

- `claims.md`, each claim's `Human` field: `confirmed YYYY-MM-DD`, `wrong`, or `unsure`, with the note in Note.
- `wrong`: fix the source file and the claim, then re-check every output citing it. If the error
  came from a pattern (a misread table, a wrong boundary), check the other claims from that source.
- A note asking for nuance or a narrower reading counts as `wrong`: revise the claim and every
  output citing it, check the same source's other claims for the same overreach, then ask the human
  to confirm the new wording.
- `unsure`: the output says the claim was queried.
- `brief.md` Decisions: one row for the check (date, mode, how many checked, results).
- Framing questions from the template ("stated too strongly?", "anything missing?") go at the end,
  in the same channel.

`scripts/check.sh` reports how many cited claims are human-confirmed and fails on any marked wrong.
