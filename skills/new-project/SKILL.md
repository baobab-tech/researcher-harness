---
name: new-project
description: Start a research project under projects/<slug>/ by interviewing the human about intent, then scaffolding from templates. Use when the user starts research on a new topic, or asks for a review, briefing, perspectives map, or source review on something that has no project yet.
---

# New project

1. **Check for an existing project.** Look in `projects/` for one on the same topic; if found, read
   its `brief.md` and `_queue.md` and ask whether to extend it.

2. **CHECKPOINT: intent.** Before scaffolding, ask the human (format: `templates/checkpoint.md`):
   - What is this for? What decision, paper, talk, or plan does it feed?
   - Who reads the output, and what do they already know?
   - What do you already know or believe about the answer? What would surprise you?
   - What have you already read, collected, or been sent? Please share it.
   - What does done look like: form, length, depth, deadline?
   - How involved do you want to be: high, standard, or light (see `AGENTS.md`)?

   Offer your reading of the request as a default for each. If answers raise new questions, ask
   one follow-up round; stop there.

3. **Scaffold.**

   ```bash
   p=projects/<slug>
   mkdir -p "$p/sources" "$p/outputs" "$p/_work" "$p/inputs" "$p/.cache"
   for t in brief claims; do cp "templates/$t.md" "$p/$t.md"; done
   cp templates/queue.md "$p/_queue.md"; cp templates/log.md "$p/_log.md"
   cp templates/index.md "$p/_index.md"; cp templates/project-readme.md "$p/README.md"
   ```

   Save anything the human shared to `inputs/` and note it in `_log.md`. Fill the Intent section of
   `brief.md` in their words, and record each answer in its Decisions table.

4. **Draft the design.** From the intent and your knowledge of the field: question, sub-questions,
   candidate methods (table in `AGENTS.md`), scope, criteria, distinctions, primary sources, core
   terms. Mark it as a draft.

5. **CHECKPOINT: design.** Send the draft `brief.md` with at most five questions: the question
   wording, the method choice (two or three options with trade-offs), scope limits, sources they
   trust or distrust, documents or people they know of. Record answers in Decisions.

6. Date `_queue.md` and continue with the skill for the chosen method.
