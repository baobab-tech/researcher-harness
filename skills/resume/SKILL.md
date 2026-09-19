---
name: resume
description: Start of a session in this harness - check keys, show every project's state and what is waiting on the human, and let the human choose what to do next. Use at the start of any session, or when the user says continue, resume, where were we, or what's pending.
---

# Resume

Agents start each session without memory; the files carry state. This skill reads them and hands
the choice of what to do to the human.

1. **Tools.** Run `scripts/keys.sh`. Note which providers are missing; mention it only if the
   chosen work needs them.

2. **State.** Run `scripts/status.sh`. For each project it shows claims, human checks, assumed
   decisions, claims marked wrong or due for recheck, what waits on the human, and the next steps.

3. **Items that block sharing come first:**
   - claims marked `wrong` by the human: fix before anything else
   - pending sanity checks on outputs the human may share
   - assumed decisions the human has not confirmed
   - claims past their Recheck month

4. **CHECKPOINT: resume.** Ask the human, one question per item, with the structured question tool
   if you have one:
   - which project (or a new one, via `new-project`)
   - what to do: clear a waiting item (list them as options), continue the next step in
     `_queue.md`, or something else
   - for a waiting sanity check or confirmation: now or later

5. **Load context** for the chosen project before acting: `brief.md` (intent, design, decisions),
   `_queue.md`, and the skill named in the brief's Process. Read `METHOD.md` if the work is an
   update.

6. Record the answers in the project's Decisions table and continue with the chosen skill.
