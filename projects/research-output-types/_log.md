# Search Log

Searches performed, results found, and files created. Searches that returned nothing are recorded.

---

## 2026-09-19: first pass

1. Crossref + Unpaywall + Semantic Scholar on seven known DOIs (Grant & Booth 2009; Sutton 2019;
   Munn 2018 x2; Arksey & O'Malley 2005; Snilstveit 2016; Garritty 2021). All records matched.
2. Grant & Booth 2009: Salford repository PDF and Wiley both served Cloudflare interstitials, direct
   and via Jina. Serper "A typology of reviews" "14 review types" filetype:pdf returned a Semantic
   Scholar-hosted PDF, which was Price 2022's retrospective, not the paper -> 001. Other hits were
   PDF-spam domains; not used.
3. Sutton 2019: Wiley blocked (direct, Jina, Exa returned nothing). Serper found the White Rose
   accepted manuscript -> 002. Tables 3 and 4 not in the deposit.
4. Munn 2018 typology, PMC5761190 via Jina -> 003
5. Munn 2018 scoping vs systematic, PMC6245623 via Jina -> 004
6. Arksey & O'Malley 2005, White Rose PDF -> 005
7. Snilstveit 2016 (evidence gap maps): closed access, no repository copy. Replaced by Campbell EGM
   guidance, White 2020, PMC8356343 -> 007
8. Garritty 2021, PMC7557165 via Jina -> 006
9. Lavis 2009 policy briefs, BMC page via Jina -> 008
10. Serper "Nature journal content types Perspective Review Comment Analysis" -> nature.com
    other-subs and Nature Reviews Psychology content pages -> 009

Not searched: horizon scanning, landscape analysis, Delphi/consensus, stakeholder analysis,
non-health typologies.

## 2026-09-19: second fetch

11. Sutton 2019 Wiley full text via scripts/fetch.sh (Jina) succeeded; Table 3 (48 types by family)
    added to 002.
