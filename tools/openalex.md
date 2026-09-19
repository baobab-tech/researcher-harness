# OpenAlex

Search 240M+ academic papers. No API key needed. Add `&mailto=$CONTACT_EMAIL` for the polite pool.

## Quick Search (curl)

```bash
# Search papers by topic
curl -s "https://api.openalex.org/works?search=AI+energy+consumption&per_page=5" | jq '.results[] | {title, year: .publication_year, citations: .cited_by_count, doi}'

# Filter by year (2024-2025)
curl -s "https://api.openalex.org/works?search=large+language+model&filter=publication_year:2024-2025&per_page=5" | jq '.results[] | {title, year: .publication_year, citations: .cited_by_count}'

# Most cited papers on topic
curl -s "https://api.openalex.org/works?search=transformer+neural+network&sort=cited_by_count:desc&per_page=5" | jq '.results[] | {title, citations: .cited_by_count}'

# Open access only
curl -s "https://api.openalex.org/works?search=climate+AI&filter=is_oa:true&per_page=5" | jq '.results[] | {title, pdf: .open_access.oa_url}'

# Get paper by DOI
curl -s "https://api.openalex.org/works/doi:10.1038/s41586-024-07487-w" | jq '{title, year: .publication_year, citations: .cited_by_count}'
```

## Key Filters

| Filter | Example |
|--------|---------|
| Year range | `filter=publication_year:2023-2025` |
| Min citations | `filter=cited_by_count:>100` |
| Open access | `filter=is_oa:true` |
| Type | `filter=type:article` |

## Sort Options

- `sort=cited_by_count:desc` - most cited
- `sort=publication_date:desc` - newest
- `sort=relevance_score:desc` - most relevant
