# arXiv

Search preprints. No API key needed. Returns XML.

## Quick Search (curl)

```bash
# Search all fields
curl -s "https://export.arxiv.org/api/query?search_query=all:LLM+energy&max_results=5" | grep -E "<title>|<summary>" | head -20

# Search by category (cs.AI = AI, cs.LG = ML, cs.CL = NLP)
curl -s "https://export.arxiv.org/api/query?search_query=cat:cs.AI&sortBy=submittedDate&max_results=5"

# Search title + abstract
curl -s "https://export.arxiv.org/api/query?search_query=ti:transformer+AND+abs:efficiency&max_results=5"

# Search by author
curl -s "https://export.arxiv.org/api/query?search_query=au:bengio&max_results=5"

# Get specific paper by ID
curl -s "https://export.arxiv.org/api/query?id_list=2303.08774"
```

## Search Prefixes

| Prefix | Field |
|--------|-------|
| `ti:` | Title |
| `au:` | Author |
| `abs:` | Abstract |
| `cat:` | Category |
| `all:` | All fields |

## Categories

- `cs.AI` - Artificial Intelligence
- `cs.LG` - Machine Learning
- `cs.CL` - NLP/Computational Linguistics
- `cs.CV` - Computer Vision

## Sort Options

- `sortBy=submittedDate` - newest first
- `sortBy=lastUpdatedDate` - recently updated
- `sortBy=relevance` - most relevant (default)
