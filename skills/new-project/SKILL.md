---
name: new-project
description: Start a research project under projects/<slug>/ by interviewing the human about intent, then scaffolding from templates. Use when the user starts research on a new topic, or asks for a review, briefing, map, positions map, policy brief, or source review on something that has no project yet.
---

# New project

1. **Check for an existing project.** Look in `projects/` for one on the same topic; if found, read
   its `brief.md` and `_queue.md` and ask whether to extend it.

   Run `scripts/keys.sh` (or `.researcher-harness/scripts/keys.sh`). If no web search provider is keyed, include that in the intent checkpoint:
   what it limits and which free key fills it (`tools/search-providers.md`).

2. **CHECKPOINT: intent.** Before scaffolding, ask the human, one question per item with the
   structured question tool if you have one (How to ask, `AGENTS.md`):
   - What is this for? What decision, paper, talk, or plan does it feed?
   - Who reads the output, and what do they already know?
   - What do you already know or believe about the answer? What would surprise you?
   - What have you already read, collected, or been sent? Please share it.
   - What does done look like: form, length, depth, deadline?
   - How involved do you want to be: high, standard, or light (see `AGENTS.md`)?

   Offer your reading of the request as a default for each. If answers raise new questions, ask
   one follow-up round; stop there.

3. **Scaffold.** `H` is the harness root (this repo, or `.researcher-harness/` when working from
   another workspace); `p` is where the human asked the project to live (default
   `$H/projects/<slug>`, or `research/<slug>/` in their own workspace).

   ```bash
   H=.; p=projects/<slug>            # or: H=.researcher-harness; p=research/<slug>
   mkdir -p "$p"/{sources,outputs,_work,inputs,.cache}
   cp "$H"/templates/brief.md "$p/brief.md"
   cp "$H"/templates/claims.md "$p/claims.md"
   cp "$H"/templates/queue.md "$p/_queue.md"
   cp "$H"/templates/log.md "$p/_log.md"
   cp "$H"/templates/index.md "$p/_index.md"
   cp "$H"/templates/project-readme.md "$p/README.md"
   ```

   Outside the harness, add `<slug>/.cache/` to the workspace's `.gitignore` (ask first) so cached
   full texts are not committed.

   Save anything the human shared to `inputs/` and note it in `_log.md`. Fill the Intent section of
   `brief.md` in their words, and record each answer in its Decisions table.

4. **Draft the design.** From the intent and your knowledge of the field: question, sub-questions,
   candidate methods (table in `AGENTS.md`), scope, criteria, distinctions, primary sources, core
   terms. Mark it as a draft.

5. **CHECKPOINT: design.** Send the draft `brief.md` with at most five questions: the question
   wording, the method choice (two or three options with trade-offs), scope limits, sources they
   trust or distrust, documents or people they know of. Record answers in Decisions.

6. Date `_queue.md` and continue with the skill for the chosen method.
