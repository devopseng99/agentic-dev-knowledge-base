---
title: "From 2 A.M. Frustrations to Smarter Repositories: How I Built an AI Assistant for GitHub"
url: "https://dev.to/golevkadesign/from-2-am-frustrations-to-smarter-repositories-how-i-built-an-ai-assistant-for-github-jj5"
author: "Golevka"
category: "full-code-examples"
---

# From 2 A.M. Frustrations to Smarter Repositories: How I Built an AI Assistant for GitHub
**Author:** Golevka
**Published:** January 7, 2025

## Overview
Development of PeterCat, an AI assistant platform providing GitHub repositories with intelligent code review and issue handling automation. Uses RAG with vector embeddings for repository context.

## Key Concepts

### GitHub Repository
https://github.com/petercat-ai/petercat

### Vector Search Implementation

```sql
return query
select
  id,
  content,
  1 - (rag_docs.embedding <=> query_embedding) as similarity
from rag_docs
order by rag_docs.embedding <=> query_embedding;
```

### Text Chunking for RAG

```python
from langchain_text_splitters import CharacterTextSplitter

text_splitter = CharacterTextSplitter(
  chunk_size=CHUNK_SIZE, chunk_overlap=CHUNK_OVERLAP
)
docs = text_splitter.split_documents(documents)
```

### Core Features
- PR Review Agent: evaluates code for functionality, security, performance
- Issue Handling Agent: searches repository issues and external sources
- Repository Vectorization: SHA-based duplicate detection, markdown filtering
- One-click deployment with automatic avatar and personality generation

### Technology Stack
- LangChain for agent construction
- OpenAI API integration
- Supabase with embedding storage (vector database)
- FastAPI backend
- AWS Lambda for asynchronous vectorization
- GitHub Webhooks and native GitHub App

### Stats
- 850+ GitHub stars
- 178 projects actively using the assistant
- Website: https://petercat.ai
