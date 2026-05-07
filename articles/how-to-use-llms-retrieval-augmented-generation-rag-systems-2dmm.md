---
title: "How To Use LLMs: Retrieval-Augmented Generation (RAG Systems)"
url: "https://dev.to/dinakajoy/how-to-use-llms-retrieval-augmented-generation-rag-systems-2dmm"
author: "Odinaka Joy"
category: "retrieval augmented generation agent"
---

# How To Use LLMs: Retrieval-Augmented Generation (RAG Systems)

**Author:** Odinaka Joy
**Published:** August 29, 2025

## Overview
Practical guide to RAG covering retrieval models (Boolean, Probabilistic, Vector Space), text generation parameters, the eight-step RAG process, and a working LangChain implementation. Also introduces LongRAG and LightRAG as advanced variants.

## Key Concepts

### Eight-Step RAG Process
1. Data Collection (PDFs, webpages, docs)
2. Chunking into context-window-compatible pieces
3. Embedding into fixed-size semantic vectors
4. Storage in FAISS, Pinecone, ChromaDB
5. Input Query (embedded using matching model)
6. Retrieve top-k semantically similar chunks
7. Augment LLM prompt with retrieved chunks
8. Generate grounded, evidence-based response

### LangChain RAG Implementation

```python
from langchain.chains import RetrievalQA
from langchain.vectorstores import FAISS
from langchain.embeddings import OpenAIEmbeddings
from langchain.llms import OpenAI

# 1. Prepare documents
docs = ["LLMs are powerful", "RAG helps with private data"]

# 2. Create embeddings
embeddings = OpenAIEmbeddings()

# 3. Create vector store
vectorstore = FAISS.from_texts(docs, embeddings)

# 4. Build RAG chain
qa = RetrievalQA.from_chain_type(
    llm=OpenAI(),
    retriever=vectorstore.as_retriever()
)

# 5. Ask a question
question = "What is RAG?"

# 6. Execute and print result
result = qa.run(question)
print(result)
```

### Advanced Variants
- **LongRAG:** Larger token segments preserving context
- **LightRAG:** Graph-based retrieval addressing context fragmentation
