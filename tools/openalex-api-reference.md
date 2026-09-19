# OpenAlex API Reference

## Overview

OpenAlex is a fully open catalog of the global research system with 240M+ scholarly works.

## Base URL
```
https://api.openalex.org
```

## Authentication

- **Not required** for basic access
- **Recommended**: Add `mailto` parameter for better rate limits
  ```
  ?mailto=your-email@domain.com
  ```

## Rate Limits

- 100,000 requests/day without email
- Higher limits with email parameter
- Premium tiers available at [openalex.org/pricing](https://openalex.org/pricing)

## Entity Endpoints

| Endpoint | Description | Count |
|----------|-------------|-------|
| `/works` | Scholarly papers, books, datasets | 240M+ |
| `/authors` | Researchers | 90M+ |
| `/sources` | Journals, repositories | 250K+ |
| `/institutions` | Universities, organizations | 100K+ |
| `/topics` | Research topics | 4K+ |
| `/publishers` | Publishing organizations | 10K+ |
| `/funders` | Funding bodies | 30K+ |

## Query Parameters

| Parameter | Description | Example |
|-----------|-------------|---------|
| `filter` | Filter results | `filter=publication_year:2024` |
| `search` | Full-text search | `search=machine learning` |
| `sort` | Sort results | `sort=cited_by_count:desc` |
| `per-page` | Results per page (max 200) | `per-page=100` |
| `page` | Page number | `page=2` |
| `group-by` | Aggregate by field | `group-by=publication_year` |
| `select` | Return specific fields only | `select=id,title,doi` |
| `mailto` | Your email (recommended) | `mailto=you@email.com` |

## Filter Syntax

### Basic format
```
filter=field:value
```

### Multiple filters (AND)
```
filter=field1:value1,field2:value2
```

### OR within same field
```
filter=field:value1|value2
```

### AND within same field
```
filter=field:value1+value2
```

### Negation (NOT)
```
filter=field:!value
```

### Comparison operators
```
filter=cited_by_count:>100
filter=publication_year:<2020
```

## Common Work Filters

| Filter | Description | Example |
|--------|-------------|---------|
| `publication_year` | Year published | `publication_year:2024` |
| `from_publication_date` | Published after | `from_publication_date:2024-01-01` |
| `to_publication_date` | Published before | `to_publication_date:2024-12-31` |
| `cited_by_count` | Citation count | `cited_by_count:>50` |
| `is_oa` | Open access | `is_oa:true` |
| `type` | Work type | `type:article` |
| `institutions.id` | By institution | `institutions.id:I97018004` |
| `authorships.author.id` | By author | `authorships.author.id:A123456` |
| `primary_topic.id` | By topic | `primary_topic.id:T12345` |
| `doi` | By DOI | `doi:10.1038/s41586-024-07487-w` |

### Work Types
`article`, `book`, `book-chapter`, `dataset`, `dissertation`, `preprint`, `review`

## Search Syntax

### Basic search
```
search=neural networks
```

### Boolean operators (UPPERCASE required)
```
search=(transformer AND attention) NOT vision
```

### Phrase matching
```
search="large language models"
```

### Field-specific search
```
filter=title.search:transformer
filter=abstract.search:safety
filter=display_name.search:anthropic
```

### Disable stemming
```
filter=title.search.no_stem:safety
```

## Sorting

```
sort=field:direction
```

| Sort Field | Description |
|------------|-------------|
| `cited_by_count` | Number of citations |
| `publication_date` | Date published |
| `relevance_score` | Search relevance (default for search) |

Directions: `asc` or `desc`

## Example Queries

### Recent highly-cited AI papers
```
https://api.openalex.org/works?filter=primary_topic.id:T10140,from_publication_date:2023-01-01,cited_by_count:>100&sort=cited_by_count:desc&per-page=50&mailto=you@email.com
```

### Search for LLM safety papers
```
https://api.openalex.org/works?search="large language model" AND safety&filter=from_publication_date:2022-01-01&sort=relevance_score:desc&per-page=25
```

### Papers from specific institution
```
https://api.openalex.org/works?filter=institutions.id:https://openalex.org/I97018004,publication_year:2024&sort=cited_by_count:desc
```

### Get author info
```
https://api.openalex.org/authors?search=yoshua bengio
```

### Get single work by OpenAlex ID
```
https://api.openalex.org/works/W2741809807
```

### Get single work by DOI
```
https://api.openalex.org/works/doi:10.1038/s41586-024-07487-w
```

### Group by year (publication stats)
```
https://api.openalex.org/works?filter=institutions.id:I97018004&group-by=publication_year
```

### Open access papers only
```
https://api.openalex.org/works?filter=is_oa:true,from_publication_date:2024-01-01&search=machine learning
```

## Response Structure (Work Object)

```json
{
  "id": "https://openalex.org/W1234567890",
  "doi": "https://doi.org/10.1234/example",
  "title": "Paper Title",
  "publication_year": 2024,
  "publication_date": "2024-03-15",
  "type": "article",
  "cited_by_count": 42,
  "is_oa": true,
  "authorships": [
    {
      "author": {
        "id": "https://openalex.org/A123456",
        "display_name": "Author Name",
        "orcid": "https://orcid.org/0000-0001-2345-6789"
      },
      "institutions": [...]
    }
  ],
  "primary_topic": {
    "id": "https://openalex.org/T12345",
    "display_name": "Artificial Intelligence"
  },
  "abstract_inverted_index": {...},
  "referenced_works": [...],
  "related_works": [...]
}
```

## Pagination

- Default: 25 results per page
- Maximum: 200 results per page (`per-page=200`)
- Use `page` parameter for subsequent pages
- Or use cursor-based pagination with `cursor` parameter for large result sets

## Tips

1. Always include `mailto` parameter for better rate limits
2. Use `select` to return only needed fields (faster responses)
3. Use `filter` over `search` when possible (more precise)
4. Combine filters with commas for AND logic
5. Use `group-by` for aggregations instead of fetching all results
6. Results are returned as JSON by default

## Sources

- [OpenAlex Documentation](https://docs.openalex.org/)
- [OpenAlex Quickstart](https://docs.openalex.org/quickstart-tutorial)
- [Filter Entity Lists](https://docs.openalex.org/how-to-use-the-api/get-lists-of-entities/filter-entity-lists)
- [Search Entities](https://docs.openalex.org/how-to-use-the-api/get-lists-of-entities/search-entities)
