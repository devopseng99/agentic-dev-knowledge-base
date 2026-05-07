---
title: "Beyond the Hype: Building a Practical AI Memory Layer with Vector Databases"
url: "https://dev.to/midas126/beyond-the-hype-building-a-practical-ai-memory-layer-with-vector-databases-4l26"
author: "Midas126"
category: "agent-memory-vector-database"
---

# Beyond the Hype: Building a Practical AI Memory Layer with Vector Databases

**Author:** Midas126
**Published:** March 28, 2026

## Overview
Practical guide to building an AI memory layer using RAG with ChromaDB and OpenAI embeddings. Covers why LLMs cannot remember, the RAG architecture pattern, step-by-step memory service implementation, and advanced patterns like summarization and hierarchical memory.

## Key Concepts

### Setup

```python
import openai
import chromadb
from chromadb.config import Settings
import uuid
from datetime import datetime

openai.api_key = "your-openai-key"
chroma_client = chromadb.Client(Settings(
    chroma_db_impl="duckdb+parquet",
    persist_directory="./memory_db"
))
memory_collection = chroma_client.get_or_create_collection(name="agent_memory")
```

### Core Memory Functions

```python
def get_embedding(text):
    response = openai.embeddings.create(
        model="text-embedding-3-small",
        input=text
    )
    return response.data[0].embedding

def store_memory(conversation_text, metadata=None):
    if metadata is None:
        metadata = {}
    metadata['timestamp'] = metadata.get('timestamp', datetime.now().isoformat())
    mem_id = str(uuid.uuid4())
    embedding = get_embedding(conversation_text)
    memory_collection.add(
        embeddings=[embedding],
        documents=[conversation_text],
        metadatas=[metadata],
        ids=[mem_id]
    )

def query_memories(query_text, n_results=3, filter_metadata=None):
    query_embedding = get_embedding(query_text)
    results = memory_collection.query(
        query_embeddings=[query_embedding],
        n_results=n_results,
        where=filter_metadata
    )
    relevant_memories = []
    if results['documents']:
        for doc, meta, dist in zip(results['documents'][0], results['metadatas'][0], results['distances'][0]):
            relevant_memories.append({
                'content': doc,
                'metadata': meta,
                'relevance_score': 1 - dist
            })
    return relevant_memories
```

### Agent with Memory Integration

```python
def agent_with_memory(user_input, user_id="default_user"):
    relevant_past = query_memories(
        query_text=user_input,
        filter_metadata={"user_id": user_id}
    )

    memory_context = ""
    if relevant_past:
        memory_context = "## Relevant Past Context:\n"
        for mem in relevant_past:
            memory_context += f"- {mem['content']} (from {mem['metadata']['timestamp'][:10]})\n"

    system_prompt = f"""You are a helpful AI assistant with memory.
    {memory_context}
    Current User Query: {user_input}
    Use the context above if relevant."""

    response = openai.chat.completions.create(
        model="gpt-4-turbo-preview",
        messages=[{"role": "system", "content": system_prompt},
                  {"role": "user", "content": user_input}]
    )

    agent_response = response.choices[0].message.content

    store_memory(f"User: {user_input}", metadata={"user_id": user_id, "type": "user_query"})
    store_memory(f"Assistant: {agent_response}", metadata={"user_id": user_id, "type": "agent_response"})

    return agent_response
```

### Advanced Patterns

**Memory Summarization:**
```python
raw_memories = query_memories(query_text="", n_results=10)
summary_prompt = f"Summarize these key points concisely: {raw_memories}"
summary = call_llm(summary_prompt)
store_memory(summary, metadata={"type": "summary"})
```

**Hierarchical Memory:** Different types -- short-term (raw chats), long-term (summaries), core facts (user preferences)

**Forgetting:** Filter by recency, delete by ID (`collection.delete(ids=[...])`)
