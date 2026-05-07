---
title: "Build a RAG Copilot on Your Own Knowledge Base with CopilotKit, Pinecone, & Anthropic"
url: "https://dev.to/copilotkit/build-a-rag-copilot-on-your-own-knowledge-base-with-copilotkit-pinecone-anthropic-21m9"
author: "Nathan Tarbert"
category: "enterprise-clones"
---

# Build a RAG Copilot on Your Own Knowledge Base with CopilotKit, Pinecone, & Anthropic
**Author:** Nathan Tarbert
**Published:** January 29, 2025

## Overview
Build an AI-powered RAG copilot for a product knowledge base using Anthropic, Pinecone vector DB, and CopilotKit.

## Key Concepts

### Setup
```bash
npx create-next-app product-knowledge-base
yarn add @anthropic-ai/sdk @mantine/core @copilotkit/react-core @copilotkit/react-ui @copilotkit/runtime @pinecone-database/pinecone axios
```

### Project Structure
```
src/app/
├── api/
│   ├── copilotkit/route.ts
│   └── posts/route.ts
├── ui/components/KnowledgeBase.tsx
├── lib/types/post.ts
└── lib/data/data.ts
```

### CopilotKit Hooks
- `useCopilotAction` - Define custom AI-triggered actions
- `useCopilotReadable` - Provide context awareness
- `CopilotSidebar` - Ready-made UI component

### GitHub Repositories
- https://github.com/CopilotKit/CopilotKit
