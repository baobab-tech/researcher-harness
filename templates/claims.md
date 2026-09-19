# Claims

Every factual claim and number used in `README.md` or `outputs/` appears here once, with the source
files that support it. Outputs cite claims by ID: `[C001]`. `scripts/check.sh` fails on an ID cited
in an output that is missing here, or a claim whose source file does not exist.

Status values:

- `supported`: the number or statement appears in every listed source, on the stated boundary
- `contested`: sources disagree on the same boundary; the Note says how
- `unsupported`: a claim made by someone that no retrieved source supports; kept so outputs can say so

The `Human` column records a person's spot-check: `confirmed YYYY-MM-DD`, `wrong` (fix before any output
uses it), `unsure`, or blank for unchecked. Only a human writes to it.

| ID | Claim | Value | Boundary | Sources | Status | Checked | Human | Note |
|----|-------|-------|----------|---------|--------|---------|-------|------|
