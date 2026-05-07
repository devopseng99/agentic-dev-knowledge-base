---
title: "RAG Systems 101: Build Your First Retrieval-Augmented Generation System"
url: https://dev.to/echsee/rag-systems-101-build-your-first-retrieval-augmented-generation-system-1675
author: Harshit Chaturvedi
category: rag
---

# RAG Systems 101: Build Your First Retrieval-Augmented Generation System

**Author:** Harshit Chaturvedi
**Published:** October 13, 2025

---

## Overview

This comprehensive guide demonstrates creating a functional RAG (Retrieval-Augmented Generation) system within 30 minutes using Next.js 15, Supabase with pgvector, and OpenAI APIs. The author showcases a live implementation on their portfolio website at harshitchaturvedi.com.

## What is RAG?

RAG combines language models with custom knowledge bases to deliver contextually accurate responses. Instead of relying solely on training data, the system retrieves relevant information from your specific data repository before generating answers -- enabling domain-specific, up-to-date responses with source attribution.

**Key capabilities:**
- Question answering on proprietary knowledge bases
- Current information delivery
- Context-aware, sourced responses
- Complex domain queries
- Transparent attribution

---

## Implementation Architecture

### Tech Stack
- **Frontend:** Next.js 15 with TypeScript and Tailwind CSS
- **Vector Database:** Supabase with pgvector extension
- **Embeddings & Generation:** OpenAI APIs
- **Type Safety:** TypeScript throughout

### Step-by-Step Build Process

#### 1. Project Initialization
```bash
npx create-next-app@latest my-rag-system --typescript --tailwind --app
cd my-rag-system
npm install @supabase/supabase-js openai
```

#### 2. Database Schema Setup
Create PostgreSQL extension and embeddings table with vector similarity indexing:

```sql
CREATE EXTENSION IF NOT EXISTS vector;

CREATE TABLE content_embeddings (
  id bigserial PRIMARY KEY,
  content_id text NOT NULL,
  content_title text NOT NULL,
  section_type text NOT NULL,
  content text NOT NULL,
  metadata jsonb,
  embedding vector(1536),
  created_at timestamp with time zone DEFAULT now()
);

CREATE INDEX ON content_embeddings
  USING ivfflat (embedding vector_cosine_ops)
  WITH (lists = 100);

ALTER TABLE content_embeddings ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Public read access" ON content_embeddings
  FOR SELECT TO public USING (true);
```

#### 3. Content Chunking Strategy
Breaking source material into semantic pieces enables better retrieval:

```typescript
// src/lib/content-chunker.ts
export interface ContentChunk {
  contentId: string;
  contentTitle: string;
  sectionType: string;
  content: string;
  metadata: Record<string, any>;
}

export function chunkContent(item: any): ContentChunk[] {
  const chunks: ContentChunk[] = [];

  // Overview chunk for general context
  chunks.push({
    contentId: item.id,
    contentTitle: item.title,
    sectionType: 'overview',
    content: `${item.title}. ${item.description}`,
    metadata: { description: item.description }
  });

  // Additional section chunks
  if (item.problem) {
    chunks.push({
      contentId: item.id,
      contentTitle: item.title,
      sectionType: 'problem',
      content: `Problem: ${item.problem}`,
      metadata: { problem: item.problem }
    });
  }

  return chunks;
}
```

#### 4. Embedding Generation
Convert text into 1536-dimensional vectors using OpenAI's efficient embedding model:

```typescript
// src/lib/embeddings.ts
import OpenAI from 'openai';

const openai = new OpenAI({
  apiKey: process.env.OPENAI_API_KEY,
});

export async function generateEmbedding(text: string): Promise<number[]> {
  const response = await openai.embeddings.create({
    model: 'text-embedding-3-small',
    input: text.trim(),
  });
  return response.data[0].embedding;
}

export async function generateEmbeddings(texts: string[]): Promise<number[][]> {
  const BATCH_SIZE = 100;
  const embeddings: number[][] = [];

  for (let i = 0; i < texts.length; i += BATCH_SIZE) {
    const batch = texts.slice(i, i + BATCH_SIZE);
    const response = await openai.embeddings.create({
      model: 'text-embedding-3-small',
      input: batch.map(t => t.trim()),
    });
    embeddings.push(...response.data.map(d => d.embedding));
  }
  return embeddings;
}
```

#### 5. RAG Service Layer
Core retrieval and formatting logic:

```typescript
// src/lib/rag-service.ts
export interface RAGContext {
  content: string;
  source: string;
  similarity: number;
}

export async function searchContent(
  query: string,
  options: { threshold?: number; limit?: number } = {}
): Promise<RAGContext[]> {
  const { threshold = 0.2, limit = 8 } = options;

  const queryEmbedding = await generateEmbedding(query);

  const { data, error } = await supabase.rpc('match_content', {
    query_embedding: queryEmbedding,
    match_threshold: threshold,
    match_count: limit,
  });

  if (error) return [];

  return data.map((row: any) => ({
    content: row.content,
    source: `${row.content_title} - ${row.section_type}`,
    similarity: row.similarity
  }));
}

export function formatRAGContext(contexts: RAGContext[]): string {
  if (contexts.length === 0) return '';

  const formatted = contexts.map((ctx, index) =>
    `[${index + 1}] ${ctx.content} (Source: ${ctx.source})`
  ).join('\n\n');

  return `Relevant context:\n\n${formatted}`;
}
```

#### 6. Vector Similarity Search Function
PostgreSQL function performing cosine similarity comparison:

```sql
CREATE OR REPLACE FUNCTION match_content(
  query_embedding vector(1536),
  match_threshold float default 0.7,
  match_count int default 5
)
RETURNS TABLE (
  id bigint,
  content_id text,
  content_title text,
  section_type text,
  content text,
  similarity float
)
LANGUAGE plpgsql
AS $$
BEGIN
  RETURN QUERY
  SELECT
    content_embeddings.id,
    content_embeddings.content_id,
    content_embeddings.content_title,
    content_embeddings.section_type,
    content_embeddings.content,
    1 - (content_embeddings.embedding <=> query_embedding) as similarity
  FROM content_embeddings
  WHERE 1 - (content_embeddings.embedding <=> query_embedding) > match_threshold
  ORDER BY content_embeddings.embedding <=> query_embedding
  LIMIT match_count;
END;
$$;
```

#### 7. Chat API Endpoint
Orchestrates retrieval and generation:

```typescript
// src/app/api/chat/route.ts
import { NextRequest, NextResponse } from 'next/server';
import OpenAI from 'openai';
import { searchContent, formatRAGContext } from '@/lib/rag-service';

const openai = new OpenAI({
  apiKey: process.env.OPENAI_API_KEY,
});

export async function POST(request: NextRequest) {
  const { message, conversationHistory = [] } = await request.json();

  // Retrieve relevant context
  const ragContexts = await searchContent(message);
  const ragContext = formatRAGContext(ragContexts);

  // Generate response with context
  const completion = await openai.chat.completions.create({
    model: 'gpt-4o-mini',
    messages: [
      {
        role: 'system',
        content: `Use this context to answer: ${ragContext}`
      },
      ...conversationHistory,
      { role: 'user', content: message }
    ],
    temperature: 0.7,
  });

  return NextResponse.json({
    reply: completion.choices[0]?.message?.content || 'Sorry, I could not generate a response.',
    sources: ragContexts.map(ctx => ctx.source)
  });
}
```

#### 8. Data Ingestion Pipeline
Populates vector database with content:

```typescript
// src/app/api/ingest/route.ts
export async function POST(request: NextRequest) {
  // Authorization check
  const authHeader = request.headers.get('authorization');
  if (authHeader !== `Bearer ${process.env.CRON_SECRET}`) {
    return NextResponse.json({ error: 'Unauthorized' }, { status: 401 });
  }

  const contentItems = []; // Your content here

  let totalChunks = 0;
  for (const item of contentItems) {
    const chunks = chunkContent(item);
    const texts = chunks.map(chunk => chunk.content);
    const embeddings = await generateEmbeddings(texts);

    const records = chunks.map((chunk, index) => ({
      content_id: chunk.contentId,
      content_title: chunk.contentTitle,
      section_type: chunk.sectionType,
      content: chunk.content,
      metadata: chunk.metadata,
      embedding: embeddings[index]
    }));

    await supabase.from('content_embeddings').insert(records);
    totalChunks += chunks.length;
  }

  return NextResponse.json({
    success: true,
    message: `Successfully ingested ${totalChunks} chunks`
  });
}
```

#### 9. Frontend Chat Component
User-facing interface:

```typescript
// src/components/chat-window.tsx
'use client';
import { useState } from 'react';

export default function ChatWindow() {
  const [messages, setMessages] = useState<any[]>([]);
  const [input, setInput] = useState('');

  const handleSend = async () => {
    const userMessage = { role: 'user', content: input };
    setMessages([...messages, userMessage]);

    const response = await fetch('/api/chat', {
      method: 'POST',
      body: JSON.stringify({
        message: input,
        conversationHistory: messages
      }),
    });

    const data = await response.json();
    setMessages(prev => [...prev,
      { role: 'assistant', content: data.reply, sources: data.sources }
    ]);
    setInput('');
  };

  return (
    <div className="flex flex-col h-screen">
      <div className="flex-1 overflow-auto p-4">
        {messages.map((msg, i) => (
          <div key={i} className={`mb-4 ${msg.role === 'user' ? 'text-right' : ''}`}>
            <p className="text-sm font-semibold">{msg.role}</p>
            <p>{msg.content}</p>
            {msg.sources && (
              <p className="text-xs text-gray-500 mt-2">
                Sources: {msg.sources.join(', ')}
              </p>
            )}
          </div>
        ))}
      </div>
      <div className="p-4 border-t">
        <input
          value={input}
          onChange={(e) => setInput(e.target.value)}
          onKeyPress={(e) => e.key === 'Enter' && handleSend()}
          className="w-full p-2 border rounded"
          placeholder="Ask a question..."
        />
      </div>
    </div>
  );
}
```

---

## Key Takeaways

1. **Chunking Strategy:** Breaking content into semantic pieces with metadata dramatically improves retrieval precision versus monolithic documents.

2. **Vector Similarity Search:** The cosine similarity operator (`<=>`) in pgvector efficiently finds matching content by comparing high-dimensional embeddings.

3. **Prompt Architecture:** Injecting retrieved context into system messages guides the LLM to answer based on your knowledge base rather than general training data.

4. **Batch Processing:** Processing embeddings in groups of 100 balances API efficiency against rate limits.

5. **Source Attribution:** Including retrieval sources builds user trust and enables fact-checking against original materials.

6. **Security Considerations:** Protecting data ingestion endpoints with authentication tokens prevents unauthorized knowledge base modifications.

This architecture scales from prototype chatbots to production customer support systems with minimal modifications to core logic.
