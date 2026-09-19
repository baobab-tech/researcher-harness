# Verification

Failure modes that have appeared in real corpora built with this harness, and the checks that
catch them. The examples come from an AI-environmental-impact corpus; the patterns recur in any
field.

## Failure modes

### Manufactured relevance

A source about something else, with a relevance section the file's author invented. Found: a
building-construction water study, a chemical-site cooling tower, and general ESG theory, each
written up as evidence about data centres.

**Check:** does the source itself address the project question? If the relevance appears only in
the file, the file goes.

```bash
grep -ciE "<the project's core terms, OR-ed>" FILE
```

### Claims taken from a different paper

One file's two headline claims were verbatim from another study's abstract. The cited paper
contained neither.

**Check:** find each headline number in the retrieved full text. If it is not there, it is not the
paper's.

### Misattributed citation

One file named an author's first name as the lead surname, producing an author list that matches
no publication. A guessed DOI returned a paper on methane condensation in minitubes.

**Check:** confirm title and authors against Crossref, not against the existing file
(`tools/metadata.md`).

### Back-computed figures attributed to a source

The most-quoted figure in one corpus appeared in no version of the paper it was credited to. It had
been derived by dividing a superseded preprint's wording.

**Check:** the figure must appear in the source as a figure. A number reached by arithmetic on the
source's prose is the writer's estimate and is labelled as one. Check which version of a preprint
is cited; wording changes between versions.

### Boundary mismatch presented as disagreement

A scope-1 water figure set against a scope 1+2 total produced an apparent 40x to 100x gap. The
like-for-like ratio was 8.5x.

**Check:** before reporting two figures as conflicting, establish that they share a definition,
population, period, and boundary. List the recurring pairs for the field in `brief.md`.

### Ratio that does not follow from the source's own inputs

A paper reporting 130x to 1,500x gave inputs that yield 82x to 875x. A "~20x" efficiency claim
computed to 18.3x, of which 6.4x came from an input assumption unrelated to the thing claimed.

**Check:** recompute every published ratio from the source's stated inputs.

### Counterfactual not established

A comparison charged a human a pro-rata share of their entire annual footprint for the hours spent
on a task. The human emits the same whether performing the task or not.

**Check:** what would have happened otherwise? A baseline with no behavioural alternative
establishes nothing.

### Aggregate that is an artefact

An "average" computed as the reciprocal of an unweighted mean of six undated figures, four from
illustrative diagrams.

**Check:** what population, what period, what weighting. An average with no denominator is not an
average.

### Self-reported range with no common definition

"Savings up to 115%" aggregated 27 studies, each against its own baseline, with no metric defined.
A saving above 100% is the tell.

**Check:** does the review define the quantity it aggregates? If not, the range is not a range.

### Proxy panel presented as causal

A macro panel proxying the phenomenon by an unrelated stock variable over a period ending before
the phenomenon existed, with internal instruments and tiny coefficients beside large controls.

**Check:** state the proxy, the period, the estimator, and the coefficient against its own
controls.

### Laboratory demonstration presented as deployment

Simulated devices benchmarked against real hardware two generations newer; advantages that vanish
at realistic operating conditions.

**Check:** fabricated or simulated, at what scale, under what operating conditions, against what
baseline.

### Citation count as authority

"578 citations, exceptionally influential," against a current count of 1,361. Two counts were dated
before their paper was published.

**Check:** do not use citation counts as evidence. If recorded, date them and name the index.

## Mechanical checks

`scripts/check.sh <slug>` runs these against `projects/<slug>/`:

1. Index rows point at files that exist
2. Every source file appears in the index
3. No sequence-number collisions
4. Every source file has a `**URL:**` line
5. Relative links in `README.md`, `brief.md`, and `outputs/*.md` resolve
6. Format fields present: `Type`, `Published`, `## Finding`, `## Methodology`, `## Limitations`
7. Sources held in more than one file (needs a human judgment, not automatically wrong)
8. No changelog scaffolding (`supersede`, `correction needed`)
9. With `--urls`: every source URL resolves (403 counts as bot-blocked, not dead)
