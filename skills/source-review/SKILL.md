---
name: source-review
description: Critical review of a single paper, report, dataset, or organisational disclosure - confirm identity, check every headline number against the text, recompute ratios, examine boundary, method, funding, and omissions, with the human setting the review's focus. Use when the user shares a document or link and asks to review, assess, critique, fact-check, or peer-review it.
---

# Source review

Works inside a project, or standalone in `projects/_reviews/`. Output template:
`templates/outputs/source-review.md`.

1. **CHECKPOINT: intent** (short form). Ask why this document matters to them, which claims they
   care about, what they suspect, and what they will do with the review. Default: all headline
   claims, neutral stance.

2. **Retrieve the full text.** `scripts/doi.sh` finds open copies; `scripts/fetch.sh <url>
   .cache/<name>.txt` saves the text. If only the abstract is reachable, stop and ask whether they
   can supply the full text.

3. **Confirm identity** on Crossref. For preprints, name the version reviewed and whether later
   versions changed the claims.

4. **List the headline claims** as the document states them. Quote them.

5. **Check each claim against the body.** Is the number in the results or only the abstract?
   Recompute every ratio from the document's own inputs. What boundary, population, period, and
   baseline produce it? Measured, modelled, estimated, or projected? Is the counterfactual
   established? Examine the design against `tools/verification.md`.

6. **Record interests:** funding, affiliations, the issuer's stake in the conclusion.

7. **Write** the review from the template.

8. **CHECKPOINT: draft.** Show the verdict and the claims table. For each claim marked as not
   holding, give the page and quote so the human can confirm. Ask whether the verdict is stated at
   the strength they can defend.

9. Inside a project, also write or update the source file and its claims, and rebuild `_index.md`.
