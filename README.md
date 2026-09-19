# Researcher Harness

Research methods, verification rules, templates, and shell tools that any AI agent can pick up to
produce literature reviews, background briefings, perspective maps, and document reviews. Every
number in an output traces through a claims ledger to a source file, and from there to the source's
full text.

**Version 0.** Markdown and bash only: no build step, no server, no SDK.

## If you are an agent

1. **Get the files.** Clone into your working directory so you can run the scripts:

   ```bash
   git clone --depth 1 https://github.com/baobab-tech/researcher-harness && cd researcher-harness
   ```

   Without a shell, read the files over HTTP from
   `https://raw.githubusercontent.com/baobab-tech/researcher-harness/main/<path>`, starting with
   [llms.txt](llms.txt), and follow the method without the scripts.

2. **Read [AGENTS.md](AGENTS.md).** It holds the rules: source hierarchy, hard rules, evidence
   layers, working files, the claims ledger, writing style.

3. **Pick the skill for the task** and read its `SKILL.md`:

   | The user asks for | Skill | Output template |
   |-------------------|-------|-----------------|
   | research on a topic with no project yet | [new-project](skills/new-project/SKILL.md), then one below | [brief](templates/brief.md) |
   | getting up to speed, "what do we know about X" | [background-research](skills/background-research/SKILL.md) | [briefing](templates/outputs/briefing.md) |
   | a literature, systematic, or scoping review | [lit-review](skills/lit-review/SKILL.md) | [review](templates/outputs/review.md) |
   | the debate, the positions, both sides | [perspectives](skills/perspectives/SKILL.md) | [perspectives](templates/outputs/perspectives.md) |
   | a critique or fact-check of one document | [source-review](skills/source-review/SKILL.md) | [source-review](templates/outputs/source-review.md) |
   | a check before sharing, or an update | [verify](skills/verify/SKILL.md) and [METHOD.md](METHOD.md) | none |

4. **Check your tools.** `bash`, `curl`, `jq`, `pdftotext`. API keys come from environment
   variables or a `.env` file at the repo root. Each script names a missing key and exits 3; work
   on with the keyless backends.

5. **Copy templates; do not write project files from memory.** `scripts/check.sh <slug>` before
   you report back.

## How the evidence flows

```
fetch            extract             assert               write
  │                 │                   │                    │
.cache/NNN.txt → sources/NNN-*.md → claims.md [C001] → outputs/*.md
 raw full text    one per source     one row per claim   prose citing claim IDs
 (gitignored)     boundary, funding  status: supported,  every number carries
                  limits, URL        contested,          an ID
                                     unsupported
```

Alongside: `brief.md` (question and scope), `_log.md` (every search, including empty ones),
`_queue.md` (state and next steps, the handoff between sessions), `_work/` (per-task scratch
notes). Details in [AGENTS.md](AGENTS.md).

A worked example: [projects/research-output-types](projects/research-output-types/), a 9-source
briefing on the kinds of task and output researchers produce, with its
[claims ledger](projects/research-output-types/claims.md).

## Tools

| Script | Does | Keys |
|--------|------|------|
| `scripts/search.sh openalex\|arxiv "<q>" [n]` | academic search | none |
| `scripts/search.sh scholar\|web\|news "<q>" [n]` | Google search via Serper | `SERPER_API_KEY` |
| `scripts/doi.sh <doi>` | confirm the record on Crossref, find open copies | `CONTACT_EMAIL` for Unpaywall |
| `scripts/fetch.sh <url> [out]` | URL or PDF to text; exits 4 on a bot check | `JINA_API_KEY` optional |
| `scripts/check.sh <slug> [--urls]` | links, index, numbering, fields, claim IDs, URLs | none |

[tools/](tools/) documents each API directly, plus retrieval routes around publisher blocks and the
[verification failure modes](tools/verification.md) the rules exist to prevent.

## For people

```bash
git clone https://github.com/baobab-tech/researcher-harness && cd researcher-harness
cp .env.example .env        # SERPER_API_KEY, JINA_API_KEY, EXA_API_KEY, CONTACT_EMAIL
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
