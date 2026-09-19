---
name: new-project
description: Scaffold a new research project under projects/<slug>/ from a question. Use when the user starts research on a new topic, asks for a lit review, background research, perspectives map, or source review on something that has no project yet.
---

# New project

1. Pick a short kebab-case slug from the question. Check `projects/` for an existing project on the
   same topic first; extend it if one exists.
2. Create the structure:

   ```bash
   p=projects/<slug>
   mkdir -p "$p/sources" "$p/outputs"
   cp templates/brief.md "$p/brief.md"
   cp templates/index.md "$p/_index.md"
   cp templates/log.md "$p/_log.md"
   cp templates/queue.md "$p/_queue.md"
   cp templates/project-readme.md "$p/README.md"
   ```

3. Fill `brief.md` from what the user said. Draft the sub-questions, scope, inclusion criteria,
   distinctions, canonical primary sources, and core terms from your own knowledge of the field,
   marked as a draft.
4. Ask the user only about decisions that change the work and that the request leaves open:
   recency window, which source types are admitted, breadth (quick orientation or systematic), and
   which sub-questions come first. One round of questions, with your draft attached.
5. Record the answers in `brief.md`, set the date in `_queue.md`, and hand off to the process skill
   named in `brief.md` (`background-research`, `lit-review`, `perspectives`, or `source-review`).
