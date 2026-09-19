# Internet Archive

Search archive.org and Wayback Machine. No API key needed.

## Quick Search (curl)

```bash
# Search texts/documents
curl -s "https://archive.org/advancedsearch.php?q=artificial+intelligence&mediatype=texts&output=json&rows=5" | jq '.response.docs[] | {title, identifier, date, downloads}'

# Search with year filter
curl -s "https://archive.org/advancedsearch.php?q=machine+learning+year:[2020+TO+2025]&output=json&rows=5" | jq '.response.docs[] | {title, date}'

# Get item metadata
curl -s "https://archive.org/metadata/arxiv-2303.08774" | jq '{title: .metadata.title, files: [.files[].name][:5]}'

# Wayback - check if URL is archived
curl -s "https://archive.org/wayback/available?url=openai.com" | jq '.archived_snapshots.closest'

# Wayback - list snapshots for URL
curl -s "https://web.archive.org/cdx/search/cdx?url=anthropic.com&output=json&limit=5" | jq '.[1:][] | {timestamp: .[1], status: .[4]}'
```

## Media Types

- `texts` - Books, papers, documents
- `audio` - Audio recordings
- `video` - Videos
- `software` - Software
- `web` - Web archives

## Sort Options

- `sort[]=downloads+desc` - most downloaded
- `sort[]=date+desc` - newest
- `sort[]=titleSorter+asc` - alphabetical
