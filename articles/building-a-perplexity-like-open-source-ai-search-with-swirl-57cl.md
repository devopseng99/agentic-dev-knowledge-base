---
title: "Building a Perplexity-like Open Source AI Search with SWIRL"
url: "https://dev.to/swirl/building-a-perplexity-like-open-source-ai-search-with-swirl-57cl"
author: "Saurab Rai"
category: "enterprise-clones"
---

# Building a Perplexity-like Open Source AI Search with SWIRL
**Author:** Saurab Rai
**Published:** October 24, 2024

## Overview
Build a Perplexity-like AI-powered search system using SWIRL, an open-source tool that connects to 100+ apps and uses LLMs for contextually relevant results.

## Key Concepts

### Docker Setup
```bash
curl https://raw.githubusercontent.com/swirlai/swirl-search/main/docker-compose.yaml -o docker-compose.yaml
docker-compose pull && docker-compose up
```

### Environment Variables
```bash
export MSAL_CB_PORT=8000
export MSAL_HOST=localhost
export OPENAI_API_KEY='your-OpenAI-API-key'
```

### Three Critical Components
1. Natural Language Understanding via LLMs with prompt engineering
2. Multi-source Search Capability from diverse sources
3. AI-Powered Answer Generation with source citations

### Features
- Google PSE (Programmable Search Engine) built-in
- Result re-ranking for relevance
- AI summary generation with source citations
- 100+ app connectors (Slack, Teams, Drive, SharePoint)

### GitHub Repositories
- https://github.com/swirlai/swirl-search
