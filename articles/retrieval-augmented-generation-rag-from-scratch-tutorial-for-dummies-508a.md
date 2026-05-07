---
title: "Retrieval Augmented Generation (RAG) from Scratch - Tutorial For Dummies"
url: https://dev.to/zachary62/retrieval-augmented-generation-rag-from-scratch-tutorial-for-dummies-508a
author: Zachary Huang
category: rag
---

# Retrieval Augmented Generation (RAG) from Scratch - Tutorial For Dummies

**Author:** Zachary Huang
**Published:** March 31, 2025
**Tags:** #ai #programming #python #rag

## Overview

This comprehensive guide introduces Retrieval Augmented Generation (RAG) systems to beginners, breaking down complex concepts into accessible explanations with practical code implementations using PocketFlow -- a minimalist 100-line framework.

## Key Concepts

### What is RAG?

The tutorial describes RAG using a librarian analogy: a system that retrieves relevant document chunks before generating answers, preventing hallucinations and enabling AI to reference specific knowledge bases.

**Core workflow steps:**
1. Document collection and processing
2. Breaking documents into chunks
3. Converting chunks into vectors (embeddings)
4. Creating searchable indexes
5. Retrieving relevant chunks when questions arrive
6. Generating grounded answers

### Chunking Strategies

The guide explores three approaches:

**Fixed-Size Chunking**
```python
def fixed_size_chunk(text, chunk_size=50):
    chunks = []
    for i in range(0, len(text), chunk_size):
        chunks.append(text[i:i+chunk_size])
    return chunks
```
Simple but risks splitting words mid-sentence.

**Sentence-Based Chunking**
```python
import nltk

def sentence_based_chunk(text, max_sentences=1):
    sentences = nltk.sent_tokenize(text)
    chunks = []
    for i in range(0, len(sentences), max_sentences):
        chunks.append(" ".join(sentences[i:i+max_sentences]))
    return chunks
```
Preserves semantic boundaries and meaning.

**Additional approaches:** paragraph-based, semantic, and hybrid methods depending on document types.

### Embeddings Fundamentals

Embeddings transform text into numerical vectors capturing semantic meaning. The tutorial progresses from simple character-frequency embeddings to AI-powered models.

**Simple embedding example:**
```python
def get_simple_embedding(text):
    embedding = np.zeros(26, dtype=np.float32)
    for char in text:
        embedding[ord(char) % 26] += 1.0
    norm = np.linalg.norm(embedding)
    if norm > 0:
        embedding /= norm
    return embedding
```

**Professional approach using OpenAI:**
```python
def get_openai_embedding(text):
    client = OpenAI(api_key=os.environ.get("OPENAI_API_KEY"))
    response = client.embeddings.create(
        model="text-embedding-ada-002",
        input=text
    )
    return np.array(response.data[0].embedding, dtype=np.float32)
```

### Vector Databases

Rather than comparing every chunk sequentially, vector databases use indexing algorithms (HNSW) and parallel processing to enable millisecond retrieval across millions of documents.

**Naive retrieval:**
```python
def retrieve_naive(question_embedding, chunk_embeddings):
    best_similarity, best_chunk_index = -1, -1
    for idx, chunk_embedding in enumerate(chunk_embeddings):
        similarity = get_similarity(question_embedding, chunk_embedding)
        if similarity > best_similarity:
            best_similarity, best_chunk_index = similarity, idx
    return best_chunk_index
```

**Optimized with vector indexing:**
```python
def create_index(chunk_embeddings):
    dimension = chunk_embeddings.shape[1]
    index = faiss.IndexFlatL2(dimension)
    index.add(chunk_embeddings)
    return index

def retrieve_index(index, question_embedding, top_k=5):
    _, chunk_indices = index.search(question_embedding, top_k)
    return chunk_indices
```

## RAG Architecture: Two Workflows

### Offline Flow (Preprocessing)
- Chunk documents into smaller pieces
- Generate embeddings for each chunk
- Build searchable vector index

### Online Flow (Query Processing)
- Embed incoming user questions
- Retrieve most relevant document chunks
- Generate answers using question + context

## Building RAG with PocketFlow

The tutorial demonstrates a complete implementation using six connected nodes:

### Node Architecture

**PocketFlow BaseNode structure:**
```python
class BaseNode:
    def __init__(self):
        self.params, self.successors = {}, {}

    def add_successor(self, node, action="default"):
        self.successors[action] = node
        return node

    def prep(self, shared): pass
    def exec(self, prep_res): pass
    def post(self, shared, prep_res, exec_res): pass

    def run(self, shared):
        p = self.prep(shared)
        e = self.exec(p)
        return self.post(shared, p, e)
```

### Implementation Example: ChunkDocumentsNode

```python
class ChunkDocumentsNode(BatchNode):
    def prep(self, shared):
        return shared["texts"]

    def exec(self, text):
        return fixed_size_chunk(text)

    def post(self, shared, prep_res, exec_res_list):
        all_chunks = []
        for chunks in exec_res_list:
            all_chunks.extend(chunks)
        shared["texts"] = all_chunks
        print(f"Created {len(all_chunks)} chunks")
        return "default"
```

### Query Processing: EmbedQueryNode

```python
class EmbedQueryNode(Node):
    def prep(self, shared):
        return shared["query"]

    def exec(self, query):
        query_embedding = get_embedding(query)
        return np.array([query_embedding], dtype=np.float32)

    def post(self, shared, prep_res, exec_res):
        shared["query_embedding"] = exec_res
        return "default"
```

### Document Retrieval: RetrieveDocumentNode

```python
class RetrieveDocumentNode(Node):
    def prep(self, shared):
        return (shared["query_embedding"],
                shared["index"],
                shared["texts"])

    def exec(self, inputs):
        query_embedding, index, texts = inputs
        distances, indices = index.search(query_embedding, k=1)
        best_idx = indices[0][0]
        return {
            "text": texts[best_idx],
            "index": best_idx,
            "distance": distances[0][0]
        }

    def post(self, shared, prep_res, exec_res):
        shared["retrieved_document"] = exec_res
        return "default"
```

### Answer Generation: GenerateAnswerNode

```python
class GenerateAnswerNode(Node):
    def prep(self, shared):
        return shared["query"], shared["retrieved_document"]

    def exec(self, inputs):
        query, retrieved_doc = inputs
        prompt = f"""
Briefly answer the question based on context:
Question: {query}
Context: {retrieved_doc['text']}
Answer:
"""
        return call_llm(prompt)

    def post(self, shared, prep_res, exec_res):
        shared["generated_answer"] = exec_res
        return "default"
```

### Connecting Flows

```python
# Offline processing
chunk_docs_node = ChunkDocumentsNode()
embed_docs_node = EmbedDocumentsNode()
create_index_node = CreateIndexNode()

chunk_docs_node >> embed_docs_node >> create_index_node
offline_flow = Flow(start=chunk_docs_node)

# Online query handling
embed_query_node = EmbedQueryNode()
retrieve_doc_node = RetrieveDocumentNode()
generate_answer_node = GenerateAnswerNode()

embed_query_node >> retrieve_doc_node >> generate_answer_node
online_flow = Flow(start=embed_query_node)
```

## Key Takeaways

- "RAG dramatically improves AI responses for specific documents" by grounding answers in actual content rather than training data alone
- Chunking strategy significantly impacts retrieval quality -- aim for "just right" chunk sizes between too-large and too-small extremes
- Advanced embeddings from AI models capture semantic relationships that simple frequency-based approaches miss
- Vector databases enable RAG systems to scale to millions of documents through intelligent indexing
- RAG's elegance lies in combining two simple workflows: offline indexing and online retrieval-augmented generation
- PocketFlow demonstrates RAG implementation in approximately 100 lines, making the architecture transparent and learnable

## Resources

- **GitHub:** [PocketFlow RAG Cookbook](https://github.com/The-Pocket/PocketFlow/tree/main/cookbook/pocketflow-rag)
- **Documentation:** https://the-pocket.github.io/PocketFlow/
- **TypeScript Version:** Available for non-Python implementations
