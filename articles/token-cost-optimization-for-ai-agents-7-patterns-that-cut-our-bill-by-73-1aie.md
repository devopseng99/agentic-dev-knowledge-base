---
title: "Token Cost Optimization for AI Agents: 7 Patterns That Cut Our Bill by 73%"
url: "https://dev.to/rapidclaw/token-cost-optimization-for-ai-agents-7-patterns-that-cut-our-bill-by-73-1aie"
author: "Tijo Gaucher"
category: "agent-cost-optimization"
---

# Token Cost Optimization for AI Agents: 7 Patterns That Cut Our Bill by 73%

**Author:** Tijo Gaucher
**Published:** April 6, 2026
**Platform:** DEV Community

---

## Article Summary

Tijo Gaucher, founder of RapidClaw, details seven optimization strategies that reduced his company's LLM expenses by 73% over six months. The article combines practical code examples with real-world impact metrics.

---

## The 7 Optimization Patterns

### 1. Prompt Caching (31% savings contribution)

Leveraging provider support for cached prompts reduces token costs to approximately 10% of normal rates for repeated content.

**Key implementation:**
```python
messages = [
    {
        "role": "system",
        "content": [
            {
                "type": "text",
                "text": LARGE_SYSTEM_PROMPT + TOOL_DEFINITIONS,
                "cache_control": {"type": "ephemeral"}
            }
        ]
    },
    {"role": "user", "content": user_input}
]
```

### 2. Route by Complexity (19% savings contribution)

Classify tasks and route them to the least expensive model capable of handling the workload. The author reports 68% of agent calls now resolve using cheaper models.

```python
def route_model(task_type: str, context_size: int) -> str:
    if task_type in ("classify", "extract", "format"):
        return "haiku"
    if context_size > 50_000 or task_type == "reason":
        return "sonnet"
    return "haiku"
```

### 3. Trim Tool Definitions (3% savings contribution)

Reduce schema descriptions to essential information. The author eliminated ~1,400 tokens per turn through aggressive editing and moving examples to retrievable documentation.

### 4. Compact Conversation History (6% savings contribution)

Three complementary approaches:
- **Sliding window:** Retain only the last N turns verbatim
- **Summary compaction:** Replace older turns with compressed summaries
- **Memory extraction:** Store stable facts separately and inject only relevant data

```python
def compact_history(messages, threshold=20):
    if len(messages) < threshold:
        return messages
    old, recent = messages[:-10], messages[-10:]
    summary = cheap_summarize(old)
    return [{"role": "system", "content": f"Earlier context: {summary}"}] + recent
```

### 5. Cap Tool-Call Loops (2% savings contribution)

Implement hard iteration limits (default: 8 per turn) with budget guardrails to prevent runaway retry cycles.

### 6. Stream and Short-Circuit (1% savings contribution)

Stop token generation once necessary structured output is obtained, saving approximately 22% on output tokens for long-form responses.

```python
async for chunk in client.messages.stream(...):
    buffer += chunk.text
    if "<done>" in buffer:
        break
```

### 7. Self-Host Cheap Operations (11% savings contribution)

Deploy open-source models locally for embeddings, classification, and reranking, shifting marginal costs to fixed infrastructure expenses.

---

## Implementation Priority

For teams starting from scratch with one week to optimize:

1. **Prompt caching** -> **Loop caps** -> **Model routing** -> **History compaction**

These four alone achieve approximately 60% cost reduction without infrastructure changes.

---

## Key Takeaway

"Token economics is additive. Five mediocre optimizations beat one heroic one, and they're far easier to ship."
