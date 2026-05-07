---
title: "RAG Evaluation Beyond Recall@K: Faithfulness, Coverage, Robustness"
url: "https://dev.to/gabrielanhaia/rag-evaluation-beyond-recallk-faithfulness-coverage-robustness-223i"
author: "Gabriel Anhaia"
category: "llm-research-evals"
---
# RAG Evaluation Beyond Recall@K: Faithfulness, Coverage, Robustness
**Author:** Gabriel Anhaia  **Published:** May 5, 2026

## Overview
Recall@K is an incomplete evaluation metric for RAG systems — it measures retrieval presence but misses three critical failure modes: faithfulness (are answers grounded?), coverage (are all chunks used?), and robustness (do paraphrased queries produce equivalent answers?).

## Key Concepts

### The Recall@K Problem
"Recall@5 on the eval set is 0.92" yet users still receive unsupported facts. Recall@K stays silent on whether models consume the retrieved context or generate from prior knowledge. High Recall@K with low faithfulness means the retriever works but the generator ignores it.

### Four Metrics Required for Complete RAG Evaluation

**1. Recall@K (Existing)**
Whether relevant documents appear in the top K results. Necessary but not sufficient.

**2. Faithfulness**
Whether answer claims are actually supported by retrieved chunks — not hallucinations disguised as citations.

```python
def faithfulness_score(answer: str, retrieved_chunks: list[str], judge) -> float:
    claims = extract_claims(answer)
    supported = [
        judge.is_supported(claim, retrieved_chunks)
        for claim in claims
    ]
    return sum(supported) / len(claims) if claims else 1.0
```

**3. Coverage**
How many distinct chunks the model actually uses, detecting when a system leans on one chunk while fetching five.

```python
def coverage_score(answer: str, retrieved_chunks: list[str]) -> float:
    cited_indices = extract_citation_indices(answer)
    return len(set(cited_indices)) / len(retrieved_chunks)
```

**4. Robustness**
Whether paraphrased questions produce semantically equivalent answers.

```python
def robustness_score(question: str, paraphrase: str, rag_pipeline) -> float:
    answer1 = rag_pipeline.query(question)
    answer2 = rag_pipeline.query(paraphrase)
    return nli.semantic_equivalence(answer1, answer2)
```

### Diagnostic 2x2 Framework

| Recall@K | Faithfulness | Diagnosis |
|----------|-------------|-----------|
| Low | Any | Retriever problem — fix chunking/indexing |
| High | Low | Generator problem — model ignoring context |
| High | High, low coverage | Over-reliance on single chunk |
| All high, low robustness | Query sensitivity — embed normalization needed |

### Implementation Approach
The harness uses:
- JSON-based judge calls at temperature=0 for stability
- Citation tag parsing for coverage attribution
- Pairwise entailment checks for robustness
- Minimal dependencies: openai, numpy, stdlib
