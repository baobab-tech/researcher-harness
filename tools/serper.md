# Serper

Google search via serper.dev. Key in `.env` as `SERPER_API_KEY`.

```bash
set -a; source .env; set +a

# Web
curl -s -X POST "https://google.serper.dev/search" -H "X-API-KEY: $SERPER_API_KEY" -H "Content-Type: application/json" \
  -d '{"q": "<named document> filetype:pdf"}' | jq '.organic[:10] | .[] | {title, link, snippet}'

# News
curl -s -X POST "https://google.serper.dev/news" -H "X-API-KEY: $SERPER_API_KEY" -H "Content-Type: application/json" \
  -d '{"q": "...", "tbs": "qdr:m"}' | jq '.news[:10] | .[] | {title, link, date}'

# Scholar
curl -s -X POST "https://google.serper.dev/scholar" -H "X-API-KEY: $SERPER_API_KEY" -H "Content-Type: application/json" \
  -d '{"q": "..."}' | jq '.organic[:10] | .[] | {title, link, year, citedBy}'
```

## Endpoints

| Endpoint | Use |
|----------|-----|
| `/search` | web results |
| `/news` | news articles, to reach the documents they report on |
| `/scholar` | academic papers |
| `/images` | images |

## Options

```json
{"q": "...", "num": 10, "gl": "us", "hl": "en", "tbs": "qdr:m"}
```

Time filters: `qdr:d`, `qdr:w`, `qdr:m`, `qdr:y`. Site scoping: `site:example.gov`.

Aim queries at named documents ("<agency> <year> <report title>") over topic keywords. Topic
queries return secondary restatement.
