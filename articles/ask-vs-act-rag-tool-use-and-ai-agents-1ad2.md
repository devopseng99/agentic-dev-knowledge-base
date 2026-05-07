---
title: "Ask vs Act: RAG, Tool Use and AI Agents"
url: "https://dev.to/matheuscamarques/ask-vs-act-rag-tool-use-and-ai-agents-1ad2"
author: "Matheus de Camargo Marques"
category: "immutable-arch-rust-flink"
---
# Ask vs Act: RAG, Tool Use and AI Agents
**Author:** Matheus de Camargo Marques  **Published:** March 17, 2026

## Overview
Part 3 of 5 in the "CQRS and architecture for AI agents" series. CQRS applied to AI agents: distinguishing observation (Query/RAG) from interaction (Command/Tool Use). Treating knowledge retrieval identically to corporate actions is a fundamental architectural error.

## Key Concepts
| Dimension | Read Path (Ask) | Write Path (Act) |
|-----------|-----------------|-----------------|
| Nature | Observational, semantic, side-effect free | Mutating, deterministic, structured |
| Data source | Vector DBs, Data Lakes, caches | Central transactional model, main API |
| Consistency | Eventual consistency acceptable | Strong consistency, ACID required |
| Concurrency | Massive parallelization | Sequential logical processing |
| AI governance | Hallucination mitigation via facts | Damage prevention via interceptors |

Query Side (RAG):
- Requests converted to embeddings, queried against vector DBs using ANN algorithms (HNSW or LSH)
- Workflow: user question → embedding → vector search → returned documents → context injected into prompt → LLM → answer
- Optimization: multimodel databases (pgvector), managed services (Pinecone, Qdrant), hybrid search (BM25 + semantic)

Command Side (Tool Execution):
- Writes demand deterministic validation against source of truth
- Commands encapsulated separately
- Human-in-the-Loop approval for high-risk operations
- Forensic traceability through encapsulation
