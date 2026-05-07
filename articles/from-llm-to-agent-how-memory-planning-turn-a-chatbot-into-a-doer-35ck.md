---
title: "From LLM to Agent: How Memory + Planning Turn a Chatbot Into a Doer"
url: "https://dev.to/superorange0707/from-llm-to-agent-how-memory-planning-turn-a-chatbot-into-a-doer-35ck"
author: "Dechun Wang"
category: "llm-agent-planning"
---

# From LLM to Agent: How Memory + Planning Turn a Chatbot Into a Doer

**Author:** Dechun Wang
**Published:** February 27, 2026

## Overview
Deep technical guide on the engineering decisions behind agent memory and planning. Covers short-term vs long-term memory design, CoT/ToT/GoT/XoT planning techniques, the ReAct loop, and includes a complete minimal agent implementation in Python.

## Key Concepts

### Agent = LLM + tools + a loop + state

A chatbot generates text. An agent executes a policy over time. The model is the policy engine; the loop is the runtime.

### Memory: Two Buckets

**Short-Term (Working Memory):** Current conversation, tool results, scratchpad notes. Limited by context window. Failure modes: context trimming (forgets constraints) and recency bias.

**Long-Term (Persistent Memory):** Vector DB embeddings, user profiles, task history. Needs structure: semantic content, metadata, write/read policies, and decay/TTL.

### Planning Techniques

**CoT (Chain-of-Thought):** Linear reasoning. Key benefit: model becomes steerable by externalizing intermediate state.

**ToT (Tree-of-Thought):** Expand multiple candidates, evaluate/score, select best branches, optionally backtrack. Expensive but valuable for high-stakes decisions.

**GoT (Graph-of-Thoughts):** Treats reasoning as states in a directed graph with merging, backtracking, and aggressive pruning. Avoids redundant work.

### ReAct Loop
1. Reason about what is missing
2. Act by calling a tool
3. Observe the result
4. Reflect and adjust

## Code Examples

### Minimal Agent with Memory + Planning

```python
from dataclasses import dataclass, field
from typing import Any, Dict, List
import time

def web_search(query: str) -> str:
    return f"[search-results for: {query}]"

def calc(expression: str) -> str:
    return str(eval(expression, {"__builtins__": {}}, {}))

@dataclass
class MemoryItem:
    text: str
    ts: float = field(default_factory=lambda: time.time())
    meta: Dict[str, Any] = field(default_factory=dict)

@dataclass
class MemoryStore:
    short_term: List[MemoryItem] = field(default_factory=list)
    long_term: List[MemoryItem] = field(default_factory=list)

    def remember_short(self, text: str, **meta):
        self.short_term.append(MemoryItem(text=text, meta=meta))

    def remember_long(self, text: str, **meta):
        self.long_term.append(MemoryItem(text=text, meta=meta))

    def retrieve_long(self, hint: str, k: int = 3) -> List[MemoryItem]:
        hits = [m for m in self.long_term if hint.lower() in m.text.lower()]
        return sorted(hits, key=lambda m: m.ts, reverse=True)[:k]

def propose_plans(task: str) -> List[str]:
    return [
        f"Search key facts about: {task}",
        f"Break task into steps, then execute: {task}",
        f"Ask a clarifying question: {task}",
    ]

def score_plan(plan: str) -> int:
    if "Search" in plan: return 3
    if "Break task" in plan: return 2
    return 1

def run_agent(task: str, memory: MemoryStore, max_steps: int = 6) -> str:
    recalled = memory.retrieve_long(hint=task)
    for item in recalled:
        memory.remember_short(f"Recalled: {item.text}", source="long_term")

    plans = propose_plans(task)
    plan = max(plans, key=score_plan)
    memory.remember_short(f"Chosen plan: {plan}")

    for step in range(max_steps):
        if "Search" in plan and step == 0:
            obs = web_search(task)
            memory.remember_short(f"Observation: {obs}", tool="web_search")
            continue
        if "calculate" in task.lower() and step == 1:
            obs = calc("6 * 7")
            memory.remember_short(f"Observation: {obs}", tool="calc")
            continue
        if step >= 2:
            break

    notes = "\n".join([f"- {m.text}" for m in memory.short_term[-8:]])
    return f"Task: {task}\n\nWhat I did:\n{notes}"

mem = MemoryStore()
mem.remember_long("User prefers concise outputs with clear bullets.", tag="preference")
print(run_agent("Write a short guide on LLM agents", mem))
```

### Production Failure Points
1. Tool reliability beats prompt cleverness (retries, validation, fallbacks)
2. Memory needs permissions and hygiene (consent, deletion pathways)
3. Planning needs evaluation signals (constraint checkers, critic models)
4. Observability is not optional (trace every tool call)
5. Security: agents amplify blast radius (allowlists, spend limits, sandboxing)
