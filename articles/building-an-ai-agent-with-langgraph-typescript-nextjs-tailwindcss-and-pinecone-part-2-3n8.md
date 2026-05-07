---
title: "Building an AI Agent with LangGraph, TypeScript, Next.js, TailwindCSS, and Pinecone - Part 2"
url: "https://dev.to/bobbyhalljr/building-an-ai-agent-with-langgraph-typescript-nextjs-tailwindcss-and-pinecone-part-2-3n8"
author: "Bobby Hall Jr"
category: "ai-agent-nextjs-react"
---

# Building an AI Agent with LangGraph, TypeScript, Next.js, TailwindCSS, and Pinecone - Part 2

**Author:** Bobby Hall Jr
**Published:** February 17, 2025

## Overview

Extends the foundational AI agent project with multi-agent architecture, persistent memory via Pinecone, enhanced chat interface, and external API integration.

## Key Concepts

### Four Primary Enhancements
1. **Multi-Agent Architecture** -- Specialized agents for delegated task handling
2. **Persistent Memory Systems** -- Pinecone stores interactions for contextual recall
3. **Enhanced Chat Interface** -- Real-time conversation rendering with dynamic responses
4. **External Integration** -- API calls for data retrieval

### Multi-Agent Workflow (`/lib/multiAgentGraph.ts`)
Uses LangGraph to create a directed workflow:
- A "General Query Agent" processes user input via OpenAI's GPT-4
- A "Memory Agent" stores queries in Pinecone for future reference
- Agents execute sequentially through graph edges

### API Enhancement (`/pages/api/ask.ts`)
The updated endpoint retrieves previous context from Pinecone before generating responses, enabling the AI to reference historical interactions.

### Frontend Component (`pages/index.tsx`)
A React component displays bidirectional conversation flow, storing exchanges in component state and rendering chronologically.

### Future Directions
- Multimodal input support
- Production deployment on Vercel
- Enhanced UI/UX patterns
- User-specific personalization
