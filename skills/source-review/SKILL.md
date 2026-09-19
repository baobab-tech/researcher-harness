---
name: source-review
description: Critical review of a single paper, report, dataset, or organisational disclosure - confirm identity, check every headline number against the text, recompute ratios, examine boundary, method, funding, and omissions. Use when the user shares a document or link and asks to review, assess, critique, fact-check, or peer-review it.
---

# Source review

Works inside a project, or standalone in `projects/_reviews/`. Output template:
`templates/outputs/source-review.md`.

1. **Retrieve the full text.** `scripts/doi.sh` finds open copies; `scripts/fetch.sh <url>
   .cache/<name>.txt` saves the text. Follow the retrieval order in `tools/metadata.md`. If only the
   abstract is reachable, stop and tell the user.
2. **Confirm identity** on Crossref: title, authors, venue, year. For preprints, name the version
   reviewed and whether later versions changed the claims.
3. **List the headline claims** as the document states them (abstract, conclusions, press release).
   Quote them.
4. **Check each claim against the body.** Is the number in the results or only the abstract?
   Recompute every ratio from the document's own inputs. What boundary, population, period, and
   baseline produce it? Measured, modelled, estimated, or projected, and which assumption moves it
   most? Is the counterfactual established?
5. **Examine the design** against the failure modes in `tools/verification.md`.
6. **Record interests:** funding, affiliations, the issuer's stake in the conclusion.
7. **Write** the review from the template.
8. Inside a project, also write or update the source file and its claims, and rebuild `_index.md`.
