---
title: "4 Types of Hallucinations: One Detection Pattern Per Type"
url: "https://dev.to/gabrielanhaia/4-types-of-hallucinations-one-detection-pattern-per-type-1pjb"
author: "Gabriel Anhaia"
category: "llm-research-evals"
---
# 4 Types of Hallucinations: One Detection Pattern Per Type
**Author:** Gabriel Anhaia  **Published:** May 5, 2026

## Overview
Four distinct hallucination failure modes in LLMs, each requiring different detection approaches. Treating hallucination as a single category masks the underlying failure modes — granular detection enables better diagnostics.

## Key Concepts

### Why Four Types Matter
A "hallucination = true" flag doesn't help engineers fix the problem. Different hallucination types require different architectural mitigations: factual fabrication needs RAG, tool-call hallucinations need existence checks, etc.

### Type 1: Factual Fabrication
**What it is:** Invented entities — citations, dates, statistics, names — that don't exist in authoritative sources.

**Detection pattern:**
```python
def detect_factual_fabrication(output: str, trusted_db) -> list[str]:
    citations = extract_citations(output)
    return [c for c in citations if not trusted_db.exists(c)]
```

### Type 2: Intrinsic Contradiction
**What it is:** Output statements that contradict each other within the same response or across responses.

**Detection pattern:**
```python
def detect_contradiction(output: str, n_samples: int = 5) -> float:
    # Sample multiple responses to same prompt
    responses = [model.generate(output) for _ in range(n_samples)]
    # Measure NLI agreement across samples
    agreements = [nli.entails(r1, r2) for r1, r2 in combinations(responses, 2)]
    return sum(agreements) / len(agreements)  # Low score = inconsistent
```

### Type 3: Prompt-vs-Output Divergence
**What it is:** Responses that ignore or contradict user-provided input context.

**Detection pattern:**
```python
def detect_divergence(prompt_context: str, output: str) -> bool:
    # Check if output is entailed by provided context
    return nli.entails(premise=prompt_context, hypothesis=output)
```

### Type 4: Tool-Call Hallucination
**What it is:** Valid schema structures referencing non-existent resources — deleting a user ID that was never created, querying a record that doesn't exist.

**Detection pattern:**
```python
def detect_tool_hallucination(tool_call: dict, resolver) -> bool:
    resource_id = tool_call.get("resource_id")
    if resource_id and not resolver.exists(resource_id):
        return True  # Hallucinated reference
    return False
```

### Integrated Detection Harness

```python
class HallucinationDetector:
    def __init__(self, trusted_db, nli_model, resolver):
        self.trusted_db = trusted_db
        self.nli = nli_model
        self.resolver = resolver

    def detect(self, prompt: str, output: str, tool_calls: list = None) -> dict:
        results = {
            "factual_fabrications": self.detect_factual_fabrication(output),
            "contradictions": self.detect_contradiction(output),
            "divergence": self.detect_divergence(prompt, output),
            "tool_hallucinations": [],
        }
        if tool_calls:
            results["tool_hallucinations"] = [
                tc for tc in tool_calls
                if self.detect_tool_hallucination(tc, self.resolver)
            ]
        return results
```

### Key Principle
Each detection pattern accepts pluggable backends — existing infrastructure (citation lookups, NLI classifiers, database resolvers) can be integrated without rebuilding detection logic. This enables incremental adoption starting with the highest-risk failure type for your application.
