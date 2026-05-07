---
title: "Building an AI Agent with LangGraph, TypeScript, Next.js, TailwindCSS, and Pinecone"
url: https://dev.to/bobbyhalljr/building-an-ai-agent-with-langgraph-typescript-nextjs-tailwindcss-and-pinecone-3bkb
author: Bobby Hall Jr
category: ai-agents-typescript
---

# Building an AI Agent with LangGraph, TypeScript, Next.js, TailwindCSS, and Pinecone

**Author:** Bobby Hall Jr
**Published:** February 16, 2025
**Modified:** February 17, 2025

---

## Overview

This tutorial guides developers through creating an AI-powered assistant that leverages multiple modern technologies. The agent processes user queries, retrieves contextual knowledge from vector databases, and generates intelligent responses.

## Tech Stack

- **LangGraph** -- Workflow orchestration and agent definition
- **TypeScript & Next.js** -- Full-stack development framework
- **TailwindCSS** -- UI styling
- **Pinecone** -- Vector database for semantic memory storage
- **OpenAI API** -- LLM-powered response generation

---

## Implementation Steps

### Step 1: Project Setup

Initialize the application with dependencies:

```bash
npx create-next-app@latest ai-agent-app --typescript --tailwind --use-npm
cd ai-agent-app
npm install @pinecone-database/pinecone langgraph openai axios dotenv
```

Configure environment variables in `.env.local`:

```
NEXT_PUBLIC_OPENAI_API_KEY=your_openai_api_key
NEXT_PUBLIC_PINECONE_API_KEY=your_pinecone_api_key
NEXT_PUBLIC_PINECONE_ENVIRONMENT=your_pinecone_env
NEXT_PUBLIC_PINECONE_INDEX=your_pinecone_index
```

### Step 2: Backend Workflow (`/lib/langgraph.ts`)

```typescript
import { OpenAI } from "openai";
import { Pinecone } from "@pinecone-database/pinecone";
import { Graph, Node, Edge } from "langgraph";

type AIContext = { query: string; response: string };

const openai = new OpenAI(process.env.NEXT_PUBLIC_OPENAI_API_KEY!);
const pinecone = new Pinecone({
  apiKey: process.env.NEXT_PUBLIC_PINECONE_API_KEY!,
  environment: process.env.NEXT_PUBLIC_PINECONE_ENVIRONMENT!,
});

const aiGraph = new Graph<AIContext>();

const aiNode = new Node(async (ctx) => {
  const vectorStore = pinecone.index(process.env.NEXT_PUBLIC_PINECONE_INDEX!);
  const results = await vectorStore.query({ topK: 5, query: ctx.query });

  const messages = [
    { role: "system", content: "You are an AI assistant." },
    { role: "user", content: `${ctx.query}\nRelevant Data: ${JSON.stringify(results)}` },
  ];

  const completion = await openai.chat.completions.create({
    model: "gpt-4",
    messages,
  });

  ctx.response = completion.choices[0].message.content;
});

aiGraph.addNode("AI Processing", aiNode);
aiGraph.addEdge(new Edge("Start", "AI Processing"));

export { aiGraph };
```

### Step 3: API Endpoint (`/pages/api/ask.ts`)

```typescript
import { NextApiRequest, NextApiResponse } from "next";
import { aiGraph } from "../../lib/langgraph";

export default async function handler(req: NextApiRequest, res: NextApiResponse) {
  if (req.method !== "POST") return res.status(405).json({ error: "Method Not Allowed" });

  const { query } = req.body;
  if (!query) return res.status(400).json({ error: "Missing query" });

  const context = { query, response: "" };
  await aiGraph.run(context);

  return res.json({ response: context.response });
}
```

### Step 4: Frontend UI (`/pages/index.tsx`)

```typescript
import { useState } from "react";

export default function Home() {
  const [query, setQuery] = useState("");
  const [response, setResponse] = useState("");

  const handleSubmit = async () => {
    const res = await fetch("/api/ask", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ query }),
    });
    const data = await res.json();
    setResponse(data.response);
  };

  return (
    <div className="container mx-auto p-6">
      <h1 className="text-2xl font-bold">AI Agent Chat</h1>
      <input
        type="text"
        placeholder="Ask a question..."
        value={query}
        onChange={(e) => setQuery(e.target.value)}
        className="w-full p-2 border rounded mt-4"
      />
      <button onClick={handleSubmit} className="mt-4 bg-blue-500 text-white p-2 rounded">Ask</button>
      {response && <p className="mt-4 p-3 bg-gray-100 rounded">{response}</p>}
    </div>
  );
}
```

## Running the Application

```bash
npm run dev
```

Visit `http://localhost:3000` to test the AI agent with live vector-based knowledge retrieval.

---

## Key Takeaways

- Modern AI agents combine workflow orchestration with vector databases for context-aware responses
- TypeScript ensures type safety across the stack
- Pinecone enables semantic search beyond traditional keyword matching
- The architecture scales for business automation and document analysis use cases

---

## Suggested Enhancements

- Implement multi-agent workflows for complex task decomposition
- Add persistent conversation memory for context retention
- Deploy to Vercel or cloud infrastructure for production scalability
