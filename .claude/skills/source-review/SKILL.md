---
name: source-review
description: Critical review of a single paper, report, dataset, or organisational disclosure - confirm identity, check every headline number against the text, recompute ratios, and examine boundary, method, funding, and omissions. Use when the user shares a document or link and asks to review, assess, critique, fact-check, or peer-review it.
---

# Source review

Works inside a project (`projects/<slug>/sources/`) or standalone (write to
`projects/_reviews/outputs/<author-year-short-title>.md`).

## Steps

1. **Retrieve the full text.** Follow the retrieval order in `tools/metadata.md`. If only the
   abstract is reachable, stop and tell the user; do not review an abstract.

2. **Confirm identity.** Crossref for title, authors, venue, year. For preprints, note which version
   is being reviewed and whether later versions changed the claims.

3. **List the headline claims** as the document states them: abstract, conclusions, press release
   if one exists. Quote them.

4. **Check each claim against the body.**
   - Is the number in the results, or only in the abstract or summary?
   - Recompute every ratio and percentage from the document's own inputs.
   - What boundary, population, period, and baseline produce the number?
   - Is it measured, modelled, estimated, or projected? What are the assumptions, and which one
     moves the result most?
   - Is the counterfactual established?

5. **Examine the design** against the failure modes in `tools/verification.md`.

6. **Record interests:** funding, author affiliations, the publisher's or issuer's stake in the
   conclusion.

7. **Write the review:**

   ```markdown
   # Review: [Title]

   **Source:** [authors, year, venue] · **URL:** · **DOI:** · **Version reviewed:**
   **Funding and affiliation:**

   ## Verdict
   [Which claims the document supports, which it does not, in two to four sentences.]

   ## Claims checked
   | Claim as stated | Where in text | Holds? | Note |

   ## Method
   [Design, data, boundary, assumptions, sensitivity.]

   ## Omissions
   [What a reader would need that the document does not give.]

   ## Relation to other evidence
   [Other sources that confirm or contradict, if known.]
   ```

8. If the review belongs to a project, also write or update the project's source file for this
   document and rebuild `_index.md`.
