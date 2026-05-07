---
title: "Next-Gen Q&A: Retrieval-Augmented AI with Chroma Vector Store"
url: "https://dev.to/moni121189/next-gen-qa-retrieval-augmented-ai-with-chroma-vector-store-4kie"
author: "Chandrani Mukherjee"
category: "retrieval augmented generation agent"
---

# Next-Gen Q&A: Retrieval-Augmented AI with Chroma Vector Store

**Author:** Chandrani Mukherjee
**Published:** July 11, 2025

## Overview
Practical implementation of a RAG Q&A system using LangChain, ChromaDB, and SentenceTransformers. Demonstrates the complete pipeline from document loading through chunking, embedding, vector storage, retrieval, and LLM-powered answer generation.

## Key Concepts

### Tech Stack
- Python, LangChain, ChromaDB, OpenAI or HuggingFace LLMs
- SentenceTransformers (all-MiniLM-L6-v2)

### Installation

```bash
pip install langchain chromadb sentence-transformers openai
```

### Project Structure

```
.
├── rag_chroma_db/        # Chroma vector store
├── docs/
│   └── my_corpus.txt     # Your source document
└── rag_agent.py          # Main script
```

### Complete Implementation

```python
from langchain.embeddings import SentenceTransformerEmbeddings
from langchain.vectorstores import Chroma
from langchain.text_splitter import RecursiveCharacterTextSplitter
from langchain.document_loaders import TextLoader
from langchain.chains import RetrievalQA
from langchain.llms import OpenAI

# 1. Load documents
loader = TextLoader("docs/my_corpus.txt")
documents = loader.load()

# 2. Split into chunks
text_splitter = RecursiveCharacterTextSplitter(chunk_size=500, chunk_overlap=50)
chunks = text_splitter.split_documents(documents)

# 3. Embed and store in Chroma
embedding = SentenceTransformerEmbeddings(model_name="all-MiniLM-L6-v2")
vectordb = Chroma.from_documents(documents=chunks, embedding=embedding, persist_directory="rag_chroma_db")
vectordb.persist()

# 4. Set up retriever
retriever = vectordb.as_retriever(search_kwargs={"k": 3})

# 5. Set up LLM
llm = OpenAI(temperature=0)

# 6. Create RAG chain
qa = RetrievalQA.from_chain_type(llm=llm, retriever=retriever, return_source_documents=True)

# 7. Ask questions
query = "What is the main topic of the document?"
result = qa({"query": query})

print("Answer:", result["result"])
print("Sources:", result["source_documents"])
```

### API Key Configuration

```bash
export OPENAI_API_KEY="your-api-key"
```

```python
import os
os.environ["OPENAI_API_KEY"] = "your-api-key"
```

### Next Steps
- Add PDF loader with PyMuPDF or pdfminer.six
- Build UI with Streamlit or FastAPI
- Wrap retriever as LangChain Tool + Agent
- Deploy offline using HuggingFace LLMs
