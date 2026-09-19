# Method

How to run a pass on a project: a first build or an update. Derived from a corpus refresh that
added 82 new source files without reopening any of the existing 148, after which verification
found the corpus's most-quoted figure appeared in no version of its cited paper, one file named
the wrong authors and took its claims from a different study, and several files asserted
relevance their sources never claimed.

Read `tools/verification.md` alongside this.

## The governing rule

**Adding sources is half the job. The other half is verifying what is already here.**

Plan every pass as audit, search, verify, prune, rebuild.

## Phases

### Phase 0. Audit

Skip on a new project. Otherwise run `scripts/check.sh <slug>` and write an audit establishing:

- How many source files, how many unique sources, how much duplication
- Which files are cited in `README.md` or `outputs/`, or carry numbers (these are load-bearing)
- Which files barely mention the project's subject (candidates for off-topic)
- Which files lack a boundary, a funding note, or a `Type` field
- Which claims in `README.md` and `outputs/` have no supporting file

The last matters most. A headline claim with no file behind it is unsourced or mis-sourced, and it
has usually been repeated.

### Phase 1. Ask before scoping

This is the intent and design checkpoint (`AGENTS.md`, Human in the loop). Decisions that belong to
the human: breadth, recency window, which source types are admitted, which sub-questions come
first, whether outputs get rewritten. Ask once, with the audit attached. Do not ask about anything
`brief.md` already settles.

### Phase 2. Search in parallel, one agent per sub-question

Give every agent:

- The shared brief: `brief.md`, the source hierarchy, the file format, the hard rules
- Its starting file number, so numbering never collides
- Named targets. "Find the agency's 2025 series and its revision note" beats a keyword
- Instructions to report negative results

Agents write only their own source files. They do not edit `_index.md`, `README.md`, or
`outputs/`; the orchestrator rebuilds those from the final file state.

### Checkpoint after Phase 2

Early findings: counts per sub-question, borderline sources, surprises. The human rules on
borderline sources and redirects if needed.

### Phase 3. Verify what the summaries cite

Every file a summary cites, or that carries a number, is re-pulled against full text: confirm
each number exists in the source, attach the boundary, record funding, state the epistemic status.
If the source cannot be reached, say so in the file and mark what was not checked.

### Phase 4. Prune

Remove, in order:

1. Sources whose relevance was asserted by the file, not claimed by the source
2. Duplicate write-ups. One canonical file per source
3. Files whose claims did not survive verification and cannot be repaired

Removals are recoverable from git. The commit message records the reason.

### Checkpoint after Phase 4

Sanity check (`skills/sanity-check/SKILL.md`): the human spot-checks changed and load-bearing
claims, and agrees to deletions of load-bearing files, before summaries are rebuilt.

### Phase 5. Rebuild summaries from the final state

Regenerate `_index.md` from the files that exist. Rewrite `README.md` and any `outputs/` from the
verified numbers, not by editing the previous version. A summary rewritten by editing the old one
carries the old one's errors forward.

### Phase 6. Mechanical checks

`scripts/check.sh <slug>`. Nothing ships with a broken link, an orphaned file, a numbering
collision, or an unresolvable URL.

### Phase 7. Commit

One commit per phase group, with corrections named in the message. Then the handoff checkpoint:
what is next and what is waiting on the human.

## Subagent design

- **Exclusive file ownership.** Each agent owns a sub-question or an explicit file list.
- **One agent per source when a source spans sub-questions.** Five write-ups of one paper made
  five different claims about it. Reading it once settles all five.
- **Named targets in the prompt.** Specific documents, disputed figures, questions to settle.
- **Errors go in the report, not the files.** The file gets the corrected version.
- **Tell agents what is already established** so they can cross-check against it.

Two agents independently recovering the same figure from the same source is stronger evidence than
either alone.

## Cross-checks

**Duplicate disagreement.** When one source has several write-ups, compare them. Incompatible
claims mean at least one is wrong, usually both written from the abstract.

**Boundary arithmetic.** When two figures for one quantity differ by a large factor, compute
whether a boundary difference explains the ratio before calling it a dispute.

**Derivation from the source's own inputs.** Recompute every reported ratio from the source's
stated inputs. Published ratios that do not follow from their own inputs are common.
