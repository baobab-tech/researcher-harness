# Researcher Harness

Point an AI agent at this repo and it researches the way a careful researcher would.

- **Lightweight.** Markdown and bash. No build step, no server, no SDK, nothing to install.
- **Agent-driven.** The agent clones it, reads the rules, picks a skill, and runs the scripts.
- **Any agent with a shell.** Claude Code, Claude and ChatGPT desktop, other coding agents.
- **Twelve skills:** literature, scoping and rapid reviews, evidence gap maps, background
  briefings, positions maps, policy briefs, single-document reviews, audits.
- **Human in the loop.** The agent stops at named checkpoints: what the research is for, how to
  design it, what it is finding, claims to spot-check, the draft.
- **Traceable.** Every number in an output cites a claim; every claim carries its scope, period,
  attribution, status and a quote; every quote comes from a source read in full.
- **Checked by script.** `check.sh` fails on a broken citation, a missing field, or a claim a
  person marked wrong.
- **Free to run.** Academic search and page fetching need no API key; web search uses whichever
  key you have.

**Version 0.** Expect rough edges; the method is the stable part.

## Quick start

You do not need to clone this yourself. In an agent that can run commands on your machine, paste:

```
Use the research harness at https://github.com/baobab-tech/researcher-harness
for this: <your research question>
```

The agent clones the harness beside your work, asks what the research is for, and puts the project
in `research/<slug>/` in your workspace unless you say otherwise. To add it to a project you are
already working in, drop the question:

```
Add the research harness at https://github.com/baobab-tech/researcher-harness
to this project so we can use its research skills.
```

### Where this works

It needs a local shell: the agent has to clone the repo and run `curl`, `jq`, and `pdftotext`.

| App | Works | Notes |
|-----|-------|-------|
| Claude Code | ✅ | this repo was built in it |
| Claude desktop app | ✅ | tested |
| ChatGPT desktop app | ✅ | tested |
| ChatGPT on the web | ❌ | tested; browser, no shell |
| Gemini desktop app (macOS) | ❌ | tested; no local execution environment |
| Copilot desktop app (macOS) | ❌ | tested; no local execution environment |
| Other coding agents with shell access (Codex, Cursor, Copilot agent mode in an editor, Gemini CLI) | ❔ | should work |

An agent without a shell can still read the method over HTTP, starting at [llms.txt](llms.txt),
and follow it by hand without the scripts.

## 🤖 If you are an agent

![Agent entry path: README.md, then AGENTS.md for the rules, then a skill picked by request type, then templates/ copied, then scripts/ run with keys.sh first. Keyless providers (OpenAlex, arXiv, Crossref, Europe PMC, CORE, Jina) are always available; keyed web search (Tavily, Serper, SerpApi, Brave, Exa, Jina) is used if keys are present.](docs/diagrams/agent-entry.svg)

1. **Get the files.** Clone into your working directory so you can run the scripts:

   ```bash
   git clone --depth 1 https://github.com/baobab-tech/researcher-harness && cd researcher-harness
   ```

   Without a shell, read the files over HTTP from
   `https://raw.githubusercontent.com/baobab-tech/researcher-harness/main/<path>`, starting with
   [llms.txt](llms.txt), and follow the method without the scripts.

2. **Read [AGENTS.md](AGENTS.md).** It holds the rules: human-in-the-loop checkpoints, source
   hierarchy, hard rules, evidence layers, working files, the claims ledger, writing style.

3. **Pick the skill for the task** and read its `SKILL.md`. In a repo that already has projects,
   start with `resume`:

   | The user asks for | Skill | Output template |
   |-------------------|-------|-----------------|
   | continuing, what is pending | [resume](skills/resume/SKILL.md) | none |
   | research on a topic with no project yet | [new-project](skills/new-project/SKILL.md) | [brief](templates/brief.md) |
   | getting up to speed, "what do we know about X" | [background-research](skills/background-research/SKILL.md) | [briefing](templates/outputs/briefing.md) |
   | what the research says, a systematic review | [lit-review](skills/lit-review/SKILL.md) | [review](templates/outputs/review.md) |
   | what research exists, how X is defined or studied | [scoping-review](skills/scoping-review/SKILL.md) | [scoping-review](templates/outputs/scoping-review.md) |
   | an evidence answer by a deadline | [rapid-review](skills/rapid-review/SKILL.md) | [rapid-review](templates/outputs/rapid-review.md) |
   | where evidence exists and where it does not | [evidence-gap-map](skills/evidence-gap-map/SKILL.md) | [evidence-gap-map](templates/outputs/evidence-gap-map.md) |
   | the debate, the positions, both sides | [positions-map](skills/positions-map/SKILL.md) | [positions-map](templates/outputs/positions-map.md) |
   | options for a decision-maker | [policy-brief](skills/policy-brief/SKILL.md) | [policy-brief](templates/outputs/policy-brief.md) |
   | a critique or fact-check of one document | [source-review](skills/source-review/SKILL.md) | [source-review](templates/outputs/source-review.md) |
   | a human spot-check of findings | [sanity-check](skills/sanity-check/SKILL.md) | [sanity-check](templates/sanity-check.md) |
   | a check before sharing, or an update | [verify](skills/verify/SKILL.md) | [METHOD.md](METHOD.md) |

4. **Check your tools.** `bash`, `curl`, `jq`, `pdftotext`. Run `scripts/keys.sh`: every API key is
   optional, academic search and fetching work with none, and the scripts pick whichever providers
   are keyed (environment variables or `.env`). If web search is unavailable, tell the human and
   name the free tier that fills it ([tools/search-providers.md](tools/search-providers.md)).

5. **Stop at every CHECKPOINT** the skill names. Ask with your structured question tool if you
   have one; otherwise use [templates/checkpoint.md](templates/checkpoint.md).
   Start with the intent checkpoint: ask what the research is for before searching.

6. **Copy templates; do not write project files from memory.** `scripts/check.sh <slug>` before
   you report back.

## Human in the loop

![Workflow in two lanes, read top to bottom. Human checkpoints: intent, design, early findings after the first 3–5 sources, sanity check, draft, handoff. Agent steps between them: scaffold project, search, read and extract sources, record claims, write output. Every checkpoint answer is logged to brief.md.](docs/diagrams/workflow.svg)

| Checkpoint | The agent brings | The human decides |
|------------|------------------|-------------------|
| resume | every project's state and pending items | which project, what to clear first |
| intent | its reading of the request | purpose, audience, priors, material to share, involvement level |
| design | a draft brief and method options | question wording, method, scope, trusted sources |
| early findings | first sources, counts, borderline cases | direction, inclusion rulings |
| sanity check | ranked claims with links and quotes | now or later, how many, one at a time or by file; then confirmed, wrong, or unsure for each |
| draft | the output | framing, strength of claims, omissions |
| handoff | state and next steps | what comes next |

Agents ask through their structured question tool where they have one (`AskUserQuestion` in Claude
Code), or through a shared markdown file or artifact the human marks up. Answers are logged in each project's `brief.md`. The claims ledger records which claims a person
confirmed, and `scripts/check.sh` reports the count and fails on any claim a person marked wrong.
An unattended run records its defaults as `assumed` and says so in the output.

## How the evidence flows

![Evidence layers, left to right: 0 Raw (.cache/NNN.txt, full text, gitignored), 1 Source (sources/NNN-*.md, one file per source), 2 Claim (claims.md, C001 onward), 3 Output (outputs/*.md citing [C001]). scripts/check.sh validates the links from outputs to claims and from claims to source files. The human sanity check marks claims confirmed, wrong, or unsure.](docs/diagrams/evidence-layers.svg)

Alongside: `brief.md` (question and scope), `_log.md` (every search, including empty ones),
`_queue.md` (state and next steps, the handoff between sessions), `_work/` (per-task scratch
notes), `inputs/` (material the human shares). Details in [AGENTS.md](AGENTS.md).

A worked example: [projects/research-output-types](projects/research-output-types/), a 9-source
briefing on the kinds of task and output researchers produce, with its
[claims ledger](projects/research-output-types/claims.md).

## Tools

| Script | Does | Keys |
|--------|------|------|
| `scripts/keys.sh` | lists usable providers for the keys present | none |
| `scripts/status.sh [slug]` | project state and what waits on the human | none |
| `scripts/search.sh academic "<q>" [n]` | OpenAlex; also `arxiv`, `crossref`, `europepmc`, `core`, `semanticscholar` | none |
| `scripts/search.sh web "<q>" [n]` | first keyed provider among Tavily, Serper, SerpApi, Brave, Exa, Jina | any one |
| `scripts/search.sh news "<q>" [n]` | Tavily news or Serper news | either |
| `scripts/doi.sh <doi>` | confirm the record on Crossref, find open copies | `CONTACT_EMAIL` for Unpaywall |
| `scripts/fetch.sh <url> [out]` | URL or PDF to text via pdftotext, Jina, Tavily, Exa; exits 4 if all blocked | none required |
| `scripts/check.sh <slug> [--urls]` | links, index, numbering, fields, claim IDs, URLs | none |

Free tiers, coverage, and fallbacks for each provider: [tools/search-providers.md](tools/search-providers.md).
[tools/](tools/) documents each API directly, plus retrieval routes around publisher blocks and the
[verification failure modes](tools/verification.md) the rules exist to prevent.

## 🧑 For people

```bash
git clone https://github.com/baobab-tech/researcher-harness && cd researcher-harness
cp .env.example .env        # every key optional; add any you have
scripts/keys.sh             # shows what is usable
brew install jq poppler     # or apt-get install jq poppler-utils
```

Open the folder in Claude Code, Claude Cowork, Codex, or any agent that reads `AGENTS.md`, and ask
in plain language: "Lit review: does a four-day week reduce burnout? Peer-reviewed, 2019 onward."

## Conventions

The repo follows the common agent-harness conventions, so most agents find their way in without
configuration:

| Convention | Here |
|------------|------|
| `AGENTS.md` project instructions | [AGENTS.md](AGENTS.md); `CLAUDE.md` is a symlink to it |
| Agent Skills (`SKILL.md` with `name`/`description` frontmatter) | [skills/](skills/); `.claude/skills` is a symlink |
| `llms.txt` index for agents reading over HTTP | [llms.txt](llms.txt) |
| Tools as CLI scripts with plain-text output and exit codes | [scripts/](scripts/) |
| State in files, not in context | `_queue.md`, `_log.md`, `_work/`, `claims.md` |
| Subagents with exclusive file ownership | [METHOD.md](METHOD.md) |

## Open directions

Nothing below is decided.

- **Skills** for the output types in the
  [research-output-types briefing](projects/research-output-types/outputs/briefing.md): scoping
  review, rapid review, umbrella review, evidence gap map, policy brief.
- **MCP servers** wrapping the scripts, for agents without a shell.
- **A shared data layer** of verified source records and claims across projects, so a paper checked
  once is not re-checked from scratch.
- **A product** built on the same method.

## Licence

Documentation, skills, templates, and project content: [CC BY 4.0](LICENSE). Scripts in
[scripts/](scripts/): [MIT](scripts/LICENSE). Copyright 2026 Baobab Tech.

Quotations in project source files remain the property of their authors and are included as short
excerpts for verification. Cached full texts (`projects/*/.cache/`) are not committed.
