---
name: new-project
description: Scaffold a new research project under projects/<slug>/ from a question. Use when the user starts research on a new topic, or asks for a review, briefing, perspectives map, or source review on something that has no project yet.
---

# New project

1. Pick a short kebab-case slug. Check `projects/` for an existing project on the topic; extend it
   if one exists.
2. Create the structure from templates:

   ```bash
   p=projects/<slug>
   mkdir -p "$p/sources" "$p/outputs" "$p/_work" "$p/.cache"
   cp templates/brief.md "$p/brief.md"
   cp templates/queue.md "$p/_queue.md"
   cp templates/log.md "$p/_log.md"
   cp templates/index.md "$p/_index.md"
   cp templates/claims.md "$p/claims.md"
   cp templates/project-readme.md "$p/README.md"
   ```

3. Fill `brief.md` from the request. Draft sub-questions, scope, inclusion criteria, distinctions,
   canonical primary sources, and core terms from your knowledge of the field, marked as a draft.
4. Ask the user only what the request leaves open and what changes the work: recency window,
   admitted source types, depth (orientation or systematic), which sub-questions come first. One
   round, with the draft attached. If no user is available, choose defaults and record them in
   `brief.md` under Scope.
5. Record the answers, date `_queue.md`, and continue with the skill named in the brief's `Process`.
