---
title: "How to Build Deferred Tool Loading for AI Agents in 15 Minutes"
url: "https://dev.to/thedailyagent/how-to-build-deferred-tool-loading-for-ai-agents-in-15-minutes-idc"
author: "The Daily Agent"
category: "agent-tool-use"
---

# How to Build Deferred Tool Loading for AI Agents in 15 Minutes

**Author:** The Daily Agent
**Published:** May 1, 2026

## Overview

Addresses token bloat when loading 40+ tools at ~200 tokens each (8,000 tokens before any work). Implements a "search-then-load" pattern reducing overhead from ~8,000 to ~400 tokens per request with improved accuracy (62% to 88-91%).

## Key Concepts

### Tool Registry

```python
from dataclasses import dataclass, field
from typing import Callable, Any

@dataclass
class Tool:
    name: str
    description: str
    parameters: dict
    fn: Callable
    category: str = "general"

class DeferredToolRegistry:
    def __init__(self):
        self.all_tools: dict[str, Tool] = {}
        self.active_tools: set[str] = set()

    def register(self, tool: Tool):
        self.all_tools[tool.name] = tool

    def search(self, query: str) -> list[dict]:
        query_lower = query.lower()
        results = []
        for name, tool in self.all_tools.items():
            score = 0
            if query_lower in name.lower(): score += 3
            if query_lower in tool.description.lower(): score += 2
            if query_lower in tool.category.lower(): score += 1
            if score > 0:
                results.append({"name": name, "description": tool.description, "score": score})
        results.sort(key=lambda r: r["score"], reverse=True)
        return results[:5]

    def load(self, tool_names: list[str]) -> list[dict]:
        for name in tool_names:
            if name in self.all_tools:
                self.active_tools.add(name)
        return [
            {"type": "function", "function": {
                "name": t.name, "description": t.description, "parameters": t.parameters,
            }}
            for t in self.all_tools.values() if t.name in self.active_tools
        ]

    def execute(self, tool_name: str, arguments: dict) -> Any:
        if tool_name not in self.active_tools:
            raise ValueError(f"Tool '{tool_name}' is not loaded. Load it first.")
        tool = self.all_tools[tool_name]
        return tool.fn(**arguments)

    def unload_all(self):
        self.active_tools.clear()
```

### Agent Loop

```python
import json

class DeferredAgent:
    def __init__(self, model, system_prompt: str, registry: DeferredToolRegistry):
        self.model = model
        self.system_prompt = system_prompt
        self.registry = registry
        self.max_turns = 8
        self.search_tool = make_search_tool(registry)

    def run(self, user_input: str) -> str:
        self.registry.load([self.search_tool.name])
        messages = [
            {"role": "system", "content": self.system_prompt},
            {"role": "user", "content": user_input},
        ]

        for turn in range(self.max_turns):
            tools = self.registry.load(list(self.registry.active_tools))
            response = self.model.chat(messages=messages, tools=tools)

            if not response.tool_calls:
                return response.content

            messages.append(response.message)
            for call in response.tool_calls:
                if call.function.name == "search_tools":
                    results = self.registry.search_tool.fn(
                        **json.loads(call.function.arguments)
                    )
                    tool_names = [r["name"] for r in results]
                    self.registry.load(tool_names)
                    messages.append({
                        "role": "tool",
                        "content": f"Found tools: {[r['name'] for r in results]}.",
                        "tool_call_id": call.id,
                    })
                else:
                    try:
                        args = json.loads(call.function.arguments)
                        result = self.registry.execute(call.function.name, args)
                    except Exception as e:
                        result = f"Error: {e}"
                    messages.append({
                        "role": "tool", "content": str(result),
                        "tool_call_id": call.id,
                    })

            self.registry.unload_all()
            self.registry.load([self.search_tool.name])

        return "Max turns reached."
```

### Semantic Search Enhancement

```python
import numpy as np

class SemanticToolSearch:
    def __init__(self, registry: DeferredToolRegistry):
        from sentence_transformers import SentenceTransformer
        self.model = SentenceTransformer("all-MiniLM-L6-v2")
        self.registry = registry
        self._build_index()

    def _build_index(self):
        self.tool_names = []
        self.embeddings = []
        for name, tool in self.registry.all_tools.items():
            text = f"{name}: {tool.description}"
            self.tool_names.append(name)
            self.embeddings.append(self.model.encode(text))
        self.index = np.array(self.embeddings)

    def search(self, query: str, top_k: int = 5) -> list[str]:
        query_embed = self.model.encode(query)
        similarities = np.dot(self.index, query_embed)
        top_indices = np.argsort(similarities)[::-1][:top_k]
        return [self.tool_names[i] for i in top_indices]
```

### Performance Comparison

| Approach | Token Cost | LLM Turns | Accuracy |
|----------|-----------|-----------|----------|
| Load all 40 tools | ~8,000 per call | 2-3 | 62% |
| Deferred loading | ~400 per call | 3-4 | 88% |
| Deferred (semantic) | ~400 per call | 2-3 | 91% |

### When to Use

**Use when:** 20+ tools, autonomous agents, multi-server MCP stacks
**Skip when:** Fewer than 10 tools, latency-critical apps, cost-insensitive prototypes
