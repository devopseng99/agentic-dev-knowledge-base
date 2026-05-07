---
title: "Vector Search & Code Embeddings: Building a Smart Knowledge Base with LangChain and FAISS"
url: "https://dev.to/blizzerand/vector-search-code-embeddings-building-a-smart-knowledge-base-with-langchain-and-faiss-m48"
author: "Manjunath"
category: "knowledge-base-embeddings"
---

# Vector Search & Code Embeddings: Building a Smart Knowledge Base with LangChain and FAISS

**Author:** Manjunath
**Published:** March 9, 2025

## Overview
Building a queryable knowledge base using vector embeddings with LangChain and FAISS for semantic similarity search.

## Code Examples

### Setup

```
pip install langchain faiss-cpu openai python-dotenv
```

### RagService Class

```python
import os
from dotenv import load_dotenv
from langchain.text_splitter import RecursiveCharacterTextSplitter
from langchain.embeddings import OpenAIEmbeddings
from langchain.vectorstores import FAISS
from langchain.docstore.document import Document

load_dotenv()

class RagService:
    def __init__(self, embedding_model="text-embedding-ada-002"):
        self.text_splitter = RecursiveCharacterTextSplitter(chunk_size=500, chunk_overlap=50)
        self.embeddings = OpenAIEmbeddings(model=embedding_model, openai_api_key=os.getenv("OPENAI_API_KEY"))
        self.vectorstore = None

    def train_from_string(self, input_string):
        document = Document(page_content=input_string)
        chunks = self.text_splitter.split_documents([document])
        self.vectorstore = FAISS.from_documents(chunks, self.embeddings)
        self.vectorstore.save_local("faiss_index")

    def query(self, query_text, top_k=5):
        if not self.vectorstore:
            self.vectorstore = FAISS.load_local("faiss_index", self.embeddings)
        results = self.vectorstore.similarity_search(query_text, k=top_k)
        return results
```

### Usage

```python
from rag_service import RagService

rag_service = RagService()

training_data = """
React is a popular JavaScript library for building user interfaces.
It manages state efficiently using hooks like useState, useEffect, and useReducer.
"""
rag_service.train_from_string(training_data)

query_result = rag_service.query("How do you manage global state in React?")
for result in query_result:
    print("-", result.page_content)
```
