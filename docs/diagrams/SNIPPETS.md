# README snippets

Paste each block where noted. Paths are relative to the repo root, so they work in `README.md`.
Each SVG has only a `viewBox`, so it fills the README column width. Light and dark colours
switch through `prefers-color-scheme` inside the file; no `<picture>` element is needed.

## workflow.svg

Under `## Human in the loop`, above the checkpoint table:

```markdown
![Workflow in two lanes, read top to bottom. Human checkpoints: intent, design, early findings after the first 3–5 sources, sanity check, draft, handoff. Agent steps between them: scaffold project, search, read and extract sources, record claims, write output. Every checkpoint answer is logged to brief.md.](docs/diagrams/workflow.svg)
```

## evidence-layers.svg

Under `## How the evidence flows`, in place of the ASCII diagram:

```markdown
![Evidence layers, left to right: 0 Raw (.cache/NNN.txt, full text, gitignored), 1 Source (sources/NNN-*.md, one file per source), 2 Claim (claims.md, C001 onward), 3 Output (outputs/*.md citing [C001]). scripts/check.sh validates the links from outputs to claims and from claims to source files. The human sanity check marks claims confirmed, wrong, or unsure; when a paywall or bot check blocks retrieval, the human supplies the file into the project's inputs folder.](docs/diagrams/evidence-layers.svg)
```

## agent-entry.svg

Under `## If you are an agent`, above the numbered steps:

```markdown
![Agent entry path: README.md, then AGENTS.md for the rules, then a skill picked by request type, then templates/ copied, then scripts/ run with keys.sh first. Keyless providers (OpenAlex, arXiv, Crossref, Europe PMC, CORE, Jina) are always available; keyed web search (Tavily, Serper, SerpApi, Brave, Exa, Jina) is used if keys are present.](docs/diagrams/agent-entry.svg)
```

## Editing

Labels are plain `<text>` elements. When a skill, checkpoint, or claim field is renamed, edit the
matching `<text>` in the SVG and the `<desc>` element at the top of the file.
