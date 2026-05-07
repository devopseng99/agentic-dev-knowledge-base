---
title: "From PDF to Summary: Building an AI Agent with Python & Vector Databases"
url: "https://dev.to/datatoinfinity/from-pdf-to-summary-building-an-ai-agent-with-python-vector-databases-basic-b2f"
author: "datatoinfinity"
category: "ai-agent-pdf"
---

# From PDF to Summary: Building an AI Agent with Python & Vector Databases

**Author:** datatoinfinity
**Published:** August 11, 2025

## Overview
An AI-powered tool that condenses lengthy PDFs and responds to inquiries based solely on their content, using Python, LangChain, Hugging Face, and Supabase vector database.

## Key Concepts

### Workflow
1. Extract text from PDF documents
2. Divide text into manageable segments
3. Convert chunks into vector embeddings
4. Store embeddings in Supabase
5. Execute similarity searches for relevant content
6. Refine responses using language models

## Code Examples

### Supabase Vector Setup

```sql
CREATE EXTENSION IF NOT EXISTS vector SCHEMA extensions;

CREATE TABLE documents1 (
    id TEXT PRIMARY KEY,
    text TEXT,
    pdf_id TEXT,
    embedding VECTOR(384)
);

CREATE FUNCTION match_documents(
    query_embedding VECTOR(384),
    match_count INT
) RETURNS TABLE (
    id TEXT,
    text TEXT
) LANGUAGE plpgsql STABLE AS $$
BEGIN
    RETURN QUERY
    SELECT documents1.id, documents1.text
    FROM documents1
    ORDER BY documents1.embedding <-> query_embedding
    LIMIT match_count;
END;
$$;
```

### PDF Text Extraction & Chunking

```python
import pdfplumber

def extract_and_chunk(pdf_path, chunk_size=500):
    with pdfplumber.open(pdf_path) as pdf:
        text = "".join(page.extract_text() or "" for page in pdf.pages)
    chunks = [text[i:i+chunk_size] for i in range(0, len(text), chunk_size)]
    return chunks
```

### Embedding Storage

```python
from supabase import create_client
from sentence_transformers import SentenceTransformer

supabase = create_client(supabase_url, supabase_key)
model = SentenceTransformer('all-MiniLM-L6-v2')

chunks = extract_and_chunk("Sample.pdf")
embeddings = model.encode(chunks).tolist()

data = [
    {"id": f"chunk_{i}", "text": chunk, "embedding": embedding, "pdf_id": "doc1"}
    for i, (chunk, embedding) in enumerate(zip(chunks, embeddings))
]
supabase.table("documents1").insert(data).execute()
```

### Query Search

```python
query = "What is the topic?"
query_embedding = model.encode(query).tolist()

response = supabase.rpc(
    "match_documents",
    {"query_embedding": query_embedding, "match_count": 3}
).execute()

relevant_chunks = [row["text"] for row in response.data]
```

### Response Refinement with Mixtral-8x7B

```python
from huggingface_hub import InferenceClient

client = InferenceClient(api_key=os.getenv("HUGGINGFACEHUB_API_TOKEN"))

response = client.chat.completions.create(
    model="mistralai/Mixtral-8x7B-Instruct-v0.1",
    messages=[
        {"role": "system", "content": "You are an expert technical editor."},
        {"role": "user", "content": prompt}
    ],
    temperature=0.7,
    max_tokens=500
)
```
