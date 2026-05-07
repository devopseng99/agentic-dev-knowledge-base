---
title: "A Survey of LLM-based Deep Search Agents (2026)"
url: "https://dev.to/24p0748_arhamali_896c9e/a-survey-of-llm-based-deep-search-agents-2026-2771"
author: "24P-0748 Arham Ali"
category: "llm-research-evals"
---
# A Survey of LLM-based Deep Search Agents (2026)
**Author:** 24P-0748 Arham Ali  **Published:** May 7, 2026

## Overview
Survey of LLM-based search agents that go beyond traditional keyword matching — systems that comprehend queries deeply, decompose them into sub-questions, conduct iterative searches, and synthesize findings into comprehensive answers.

## Key Concepts

### Three Primary Agent Architectures

**1. Single Agent Search**
One LLM manages understanding, retrieval, and response generation. Effective for simpler tasks but limited for complex queries requiring multi-step reasoning or diverse source types.

**2. Multi-Agent Search**
Specialized agents collaborate on planning, searching, and result synthesis. Provides greater capability for complex research tasks through division of cognitive labor.

**3. RAG (Retrieval Augmented Generation)**
Connects LLMs to external documents, reducing hallucinations and improving accuracy. Currently the most prevalent approach in industry applications.

### Connections to Classical AI
The survey reveals structural parallels between modern LLM agents and classical AI:
- Search algorithms (BFS, DFS, A*) parallel how agents strategically plan information retrieval
- Agent design mirrors Goal-Based and Learning Agent frameworks
- Constraint satisfaction principles apply when agents balance relevance, recency, and source trustworthiness

### Key Finding
LLM search agents essentially execute heuristic searches across information space, analogous to A* pathfinding in state spaces. The "intelligence" consists of learning effective heuristics for information relevance.

### Research Gaps Identified
- No standardized evaluation benchmarks for multi-step research quality
- Limited work on citation verification and source reliability scoring
- Underexplored: agents that update search strategy based on partial results
- Memory and context management across extended research sessions

### Evaluation Dimensions
1. Answer accuracy vs. gold standard
2. Source diversity and citation quality
3. Query decomposition effectiveness
4. Hallucination rate on factual claims
5. Latency and cost per research task
