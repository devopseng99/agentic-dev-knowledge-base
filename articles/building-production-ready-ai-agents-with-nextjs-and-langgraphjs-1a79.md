---
title: "Building Production-Ready AI Agents with Next.js and LangGraph.js"
url: "https://dev.to/ialijr/building-production-ready-ai-agents-with-nextjs-and-langgraphjs-1a79"
author: "Ali Ibrahim"
category: "ai-agent-nextjs-react"
---

# Building Production-Ready AI Agents with Next.js and LangGraph.js

**Author:** Ali Ibrahim
**Published:** October 2, 2025

## Overview

Open-source template combining Next.js with LangGraph.js and Model Context Protocol (MCP) for building stateful AI agents with human-in-the-loop capabilities, persistent memory, and real-time streaming.

## Key Concepts

### Features
- **Dynamic Tool Loading:** Add MCP servers via web interface without code modifications
- **Human-in-the-Loop:** Review and approve/deny tool executions before execution
- **Persistent Memory:** PostgreSQL-backed conversation history using LangGraph checkpointer
- **Real-time Streaming:** Server-Sent Events with React Query for responsive UI

### Architecture Flow
1. User message submission
2. Agent processing and tool execution request
3. Graph interruption at tool_approval node
4. Frontend displays approval interface with tool specifics
5. User approval triggers agent continuation via Command
6. Real-time result streaming

### Quick Start

```bash
git clone https://github.com/IBJunior/fullstack-langgraph-nextjs-agent.git
cd fullstack-langgraph-nextjs-agent
pnpm install

cp .env.example .env.local
# Add your OPENAI_API_KEY or GOOGLE_API_KEY

docker compose up -d
pnpm prisma:migrate
pnpm dev
```

### Technology Stack
- **Frontend:** Next.js 15, React 19, TypeScript, Tailwind CSS, shadcn/ui
- **Backend:** Node.js, Prisma ORM, PostgreSQL
- **AI Framework:** LangGraph.js, @langchain/mcp-adapters
- **LLM Models:** OpenAI (GPT-4o, GPT-4-mini) & Google AI (Gemini)

### MCP Integration Benefits
- Dynamic tool addition/removal through UI
- Integration with official MCP server catalog
- Server configuration via environment variables
- Automatic tool name prefixing to prevent conflicts
