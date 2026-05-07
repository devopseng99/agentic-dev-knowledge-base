---
title: "Why Your AI Agent Forgets Everything (And How to Fix It)"
url: "https://dev.to/klement_gunndu/why-your-ai-agent-forgets-everything-and-how-to-fix-it-2gj8"
author: "klement Gunndu"
category: "knowledge-base-embeddings"
---

# Why Your AI Agent Forgets Everything (And How to Fix It)

**Author:** klement Gunndu
**Published:** February 23, 2026

## Overview
A three-level framework for implementing robust agent memory: file-based, vector store, and knowledge graph. Start with the simplest solution that meets requirements.

## Code Examples

### Level 1: File-Based Memory

```python
import json

class SimpleFileMemory:
    def __init__(self, filename="agent_memory.json"):
        self.filename = filename
        self.memory = self._load_memory()

    def _load_memory(self):
        try:
            with open(self.filename, 'r') as f:
                return json.load(f)
        except FileNotFoundError:
            return {}

    def _save_memory(self):
        with open(self.filename, 'w') as f:
            json.dump(self.memory, f, indent=4)

    def get(self, key, default=None):
        return self.memory.get(key, default)

    def set(self, key, value):
        self.memory[key] = value
        self._save_memory()
```

### Level 2: Vector Store Memory (LangChain + ChromaDB)

```python
from langchain_community.embeddings import OpenAIEmbeddings
from langchain_community.vectorstores import Chroma
from langchain.memory import VectorStoreRetrieverMemory

vectorstore = Chroma(embedding_function=OpenAIEmbeddings(), persist_directory="./chroma_db_memory")
retriever = vectorstore.as_retriever(search_kwargs={"k": 2})
memory = VectorStoreRetrieverMemory(retriever=retriever)

# Learning phase
memory.save_context({"input": "My favorite color is blue."}, {"output": "Okay, I'll remember that."})
memory.save_context({"input": "My dog's name is Buddy."}, {"output": "Buddy, cute name!"})

# Recall phase - "What is my favorite hue?" finds "blue" semantically
```

### Level 3: Knowledge Graph Memory

```python
from langchain.memory import ConversationKGMemory

memory = ConversationKGMemory(llm=llm, verbose=True)
conversation = ConversationChain(llm=llm, memory=memory)

conversation.predict(input="My name is Charlie. I work at Acme Corp.")
conversation.predict(input="Acme Corp develops AI software and is based in New York.")

# Can now answer: "Where is Acme Corp located?" and "What does my company do?"
# Knowledge graph stores entity-relationship triples
```

## When to Use Which

| Level | Best For | Avoid When |
|-------|----------|------------|
| File-Based | Explicit small facts, IDs, flags | Need semantic understanding |
| Vector Store | Large unstructured text, semantic recall | Need entity relationships |
| Knowledge Graph | Multi-hop reasoning, rich profiles | Simple tasks, overhead exceeds benefit |
