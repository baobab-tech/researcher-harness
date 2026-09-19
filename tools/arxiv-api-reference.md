# arXiv API Reference

## Base URL
```
http://export.arxiv.org/api/query
```

## Query Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `search_query` | string | None | Search terms with field prefixes |
| `id_list` | string | None | Comma-delimited arXiv IDs |
| `start` | integer | 0 | Starting index for results |
| `max_results` | integer | 10 | Number of results (max 2000 per call) |
| `sortBy` | string | relevance | `relevance`, `lastUpdatedDate`, `submittedDate` |
| `sortOrder` | string | descending | `ascending` or `descending` |

## Search Field Prefixes

| Prefix | Field |
|--------|-------|
| `ti` | Title |
| `au` | Author |
| `abs` | Abstract |
| `co` | Comment |
| `jr` | Journal Reference |
| `cat` | Subject Category |
| `rn` | Report Number |
| `all` | All fields |

## Boolean Operators

- `AND` - both conditions must match
- `OR` - either condition matches
- `ANDNOT` - excludes results matching the second term

## Common Subject Categories

### Computer Science
- `cs.AI` - Artificial Intelligence
- `cs.CL` - Computation and Language (NLP)
- `cs.CV` - Computer Vision
- `cs.LG` - Machine Learning
- `cs.NE` - Neural and Evolutionary Computing
- `cs.HC` - Human-Computer Interaction
- `cs.CR` - Cryptography and Security
- `cs.SE` - Software Engineering

### Statistics
- `stat.ML` - Machine Learning

### Electrical Engineering
- `eess.AS` - Audio and Speech Processing

### Quantitative Biology/Finance
- `q-bio` - Quantitative Biology
- `q-fin` - Quantitative Finance

## Rate Limits

- Maximum 2000 results per request
- Maximum 30000 total results per query
- **Recommended**: 3-second delay between consecutive requests

## Response Format

Returns Atom 1.0 XML with:
- `<feed>` - Container with metadata
- `<opensearch:totalResults>` - Total matching papers
- `<entry>` - Individual paper entries containing:
  - `<id>` - arXiv URL
  - `<title>` - Paper title
  - `<summary>` - Abstract
  - `<author>` - Author names
  - `<published>` - Original submission date
  - `<updated>` - Last update date
  - `<category>` - Subject categories
  - `<link>` - Links to abstract, PDF, DOI

## Example Queries

### Search by author and title keyword
```
http://export.arxiv.org/api/query?search_query=au:bengio+AND+ti:attention&max_results=10
```

### Search by category (recent ML papers)
```
http://export.arxiv.org/api/query?search_query=cat:cs.LG&sortBy=submittedDate&sortOrder=descending&max_results=50
```

### Search abstract for specific terms
```
http://export.arxiv.org/api/query?search_query=abs:transformer+AND+abs:language+model&max_results=25
```

### Combine multiple conditions
```
http://export.arxiv.org/api/query?search_query=(cat:cs.AI+OR+cat:cs.CL)+AND+ti:safety&sortBy=lastUpdatedDate&max_results=100
```

### Get specific paper by ID
```
http://export.arxiv.org/api/query?id_list=2303.08774
```

### Pagination (get results 100-200)
```
http://export.arxiv.org/api/query?search_query=cat:cs.LG&start=100&max_results=100
```

## URL Encoding

- Spaces: `+` or `%20`
- Parentheses: `%28` and `%29`
- Quotes for phrases: `%22`

## Usage Notes

1. Always URL-encode special characters
2. Use parentheses to group boolean operations
3. Field prefixes are case-insensitive
4. Results sorted by relevance by default
5. Include polite delay between requests
6. Acknowledge arXiv in any public use: "Thank you to arXiv for use of its open access interoperability."

## Sources

- [arXiv API User Manual](https://info.arxiv.org/help/api/user-manual.html)
- [arXiv API Terms of Use](https://info.arxiv.org/help/api/tou.html)
