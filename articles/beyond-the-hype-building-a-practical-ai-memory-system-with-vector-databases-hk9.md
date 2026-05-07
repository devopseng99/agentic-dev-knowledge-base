---
title: "Beyond the Hype: Building a Practical AI Memory System with Vector Databases"
url: "https://dev.to/midas126/beyond-the-hype-building-a-practical-ai-memory-system-with-vector-databases-hk9"
author: "Midas126"
category: "agent-memory-vector-database"
---

# Beyond the Hype: Building a Practical AI Memory System with Vector Databases

**Author:** Midas126
**Published:** April 1, 2026

## Overview
Practical guide to building long-term memory for AI agents using vector databases. Covers how embeddings work, building a memory class with ChromaDB and OpenAI, and advanced patterns like memory summarization and hierarchical memory.

## Key Concepts

### How AI Memory Works: Vectors and Similarity Search

1. **Ingest & Embed:** Send text to an embedding model to get its vector
2. **Store:** Store vector with original text as metadata in vector database
3. **Query:** Embed the query and find most similar stored vectors
4. **Retrieve & Inject:** Take original text from similar vectors and inject into LLM context window

### Setup

```bash
pip install chromadb openai tiktoken
```

### AgentMemory Class

```python
import chromadb
from chromadb.config import Settings
import openai
import hashlib

class AgentMemory:
    def __init__(self, persist_directory="./agent_memory"):
        self.client = chromadb.PersistentClient(path=persist_directory)
        self.collection = self.client.get_or_create_collection(
            name="agent_memories",
            metadata={"hnsw:space": "cosine"}
        )
        openai.api_key = "your-api-key-here"
        self.embedding_model = "text-embedding-3-small"

    def _generate_id(self, text: str) -> str:
        return hashlib.md5(text.encode()).hexdigest()

    def remember(self, text: str, metadata: dict = None):
        response = openai.embeddings.create(
            model=self.embedding_model,
            input=text
        )
        embedding = response.data[0].embedding
        if metadata is None:
            metadata = {}
        metadata["text"] = text
        self.collection.add(
            embeddings=[embedding],
            metadatas=[metadata],
            ids=[self._generate_id(text)]
        )

    def recall(self, query: str, n_results: int = 3) -> list:
        response = openai.embeddings.create(
            model=self.embedding_model,
            input=query
        )
        query_embedding = response.data[0].embedding
        results = self.collection.query(
            query_embeddings=[query_embedding],
            n_results=n_results,
            include=["metadatas", "distances"]
        )
        memories = []
        if results['metadatas']:
            for meta in results['metadatas'][0]:
                memories.append(meta["text"])
        return memories
```

### Integrating Memory into an Agent

```python
class CodingAssistant:
    def __init__(self):
        self.memory = AgentMemory()

    def chat(self, user_input: str):
        relevant_context = self.memory.recall(user_input)
        prompt_context = "\n".join([f"- {mem}" for mem in relevant_context])
        system_message = f"""You are a helpful coding assistant. Below is relevant context:
        {prompt_context}
        Use this context to provide informed, consistent help."""

        response = f"Simulated response using context: {relevant_context}"

        if "prefer" in user_input or "use" in user_input:
            self.memory.remember(user_input, metadata={"type": "user_preference"})

        return response

assistant = CodingAssistant()
assistant.chat("I'm building a web API and I prefer using FastAPI over Flask.")
response = assistant.chat("What Python framework should I use for my new project?")
```

### Advanced Memory Patterns

**Memory Summarization:**
```python
if conversation_turns > 10:
    summary = llm_call(f"Summarize key facts and preferences from: {recent_chats}")
    self.memory.remember(summary, metadata={"type": "periodic_summary"})
    clear_recent_chat_buffer()
```

### Tool Comparison
- **Vector Databases:** Pinecone (managed), Weaviate (hybrid search), Qdrant (Rust, high performance), ChromaDB (open-source)
- **Embedding Models:** OpenAI embeddings, Sentence Transformers (local), Cohere Embed
