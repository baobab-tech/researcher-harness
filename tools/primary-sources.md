# Primary Sources

Agency reports, statutory data, regulatory and court filings, and organisational disclosures hold
the defensible numbers. Most are PDFs and need extraction before they are readable.

## PDF extraction

`WebFetch` returns unparsed binary for PDFs. Download and convert:

```bash
curl -sL "https://example.org/report.pdf" -o "$TMPDIR/r.pdf"
pdftotext -layout "$TMPDIR/r.pdf" - | less          # -layout preserves table columns
pdftotext -layout -f 12 -l 30 "$TMPDIR/r.pdf" -     # page range only
```

Without `-layout`, table columns interleave and numbers bind to the wrong row. For HTML landing
pages that hide the PDF behind JavaScript, use `tools/jina.md`.

## Where to look

Record the canonical primary sources for a field in the project's `brief.md`. Common classes:

| Class | Holds | Typical access |
|-------|-------|----------------|
| National statistics offices | official series, revisions, methodology notes | HTML tables, CSV, API |
| Regulators and agencies | filings, dockets, orders, consultations | docket portals, PDF |
| Courts and legislatures | judgments, bill text, committee evidence | official portals |
| Intergovernmental bodies | cross-country datasets, scenario reports | PDF, xlsx |
| Registries | trials, company filings, permits | queryable portals |
| Organisational disclosures | annual, sustainability, and impact reports | PDF |

## Reading official series

- Find the methodology note and the revision history. Series are revised without prominence.
- Record the vintage: which release the figure comes from.
- State the unit and whether it is nominal or real, seasonally adjusted or not, per capita or total.

## Reading pipelines and stages

Many quantities pass through stages: proposed, approved, funded, built, operating; or enrolled,
randomised, completed, reported. Attrition at each stage is often severe and sources report stages
interchangeably. State which stage a figure refers to.

## Reading organisational disclosures

- Find every alternative accounting the document reports. The gap between two methods often
  carries the headline claim.
- Note the reporting boundary: which subsidiaries, regions, and facilities are included.
- Check the restatement note. Prior-year figures are frequently revised.
- Separate what is audited or assured from what is self-reported.

## Superseded claims

Use the Wayback Machine (`tools/archive.md`) on pages that change. A pledge that was revised or
removed is a finding. Record the snapshot timestamp and quote both versions.
