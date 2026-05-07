---
title: "Context Engineering for AI Agents: A Practical Guide"
url: "https://dev.to/thedailyagent/context-engineering-for-ai-agents-a-practical-guide-5989"
author: "The Daily Agent"
category: "llm-agent-context-window"
---

# Context Engineering for AI Agents: A Practical Guide

**Author:** The Daily Agent
**Published:** March 15, 2026

## Overview
When agents work in demos but fail in production, the issue is context engineering. Production agents consume 60-80% of the context window before user input, degrading performance silently.

## Key Concepts

### Strategy 1: Sliding Window with Summarization

```python
def manage_conversation_context(
    messages: list[dict],
    system_prompt: str,
    max_recent_turns: int = 6,
    summary_model: str = "gpt-4o-mini",
) -> list[dict]:
    if len(messages) <= max_recent_turns:
        return [{"role": "system", "content": system_prompt}] + messages
    old_messages = messages[:-max_recent_turns]
    recent_messages = messages[-max_recent_turns:]
    summary_response = client.chat.completions.create(
        model=summary_model,
        messages=[
            {"role": "system", "content": "Summarize this conversation in under 200 tokens."},
            *old_messages,
        ],
        max_tokens=200,
    )
    summary = summary_response.choices[0].message.content
    return [
        {"role": "system", "content": system_prompt},
        {"role": "system", "content": f"Previous conversation summary: {summary}"},
        *recent_messages,
    ]
```

### Strategy 2: Dynamic Tool Injection

```python
def select_tools_for_step(
    task_description: str,
    all_tools: list[dict],
    max_tools: int = 5,
    classifier_model: str = "gpt-4o-mini",
) -> list[dict]:
    tool_names = [t["function"]["name"] for t in all_tools]
    response = client.chat.completions.create(
        model=classifier_model,
        messages=[
            {"role": "system", "content": f"Return JSON array of most relevant tool names. Max {max_tools} tools."},
            {"role": "user", "content": f"Task: {task_description}\nAvailable tools: {json.dumps(tool_names)}"},
        ],
    )
    selected_names = json.loads(response.choices[0].message.content)
    return [t for t in all_tools if t["function"]["name"] in selected_names]
```

### Context Budget Calculator

```python
def calculate_context_budget(model_limit, system_prompt, tools, history, retrieved_docs):
    enc = tiktoken.get_encoding("o200k_base")
    system_tokens = len(enc.encode(system_prompt))
    tool_tokens = sum(len(enc.encode(str(t))) for t in tools)
    history_tokens = sum(len(enc.encode(str(m))) for m in history)
    doc_tokens = sum(len(enc.encode(d)) for d in retrieved_docs)
    total_used = system_tokens + tool_tokens + history_tokens + doc_tokens
    utilization = (total_used / model_limit) * 100
    # Target: under 50% utilization before user input
```

Rule of thumb: If context exceeds 60% utilization before user input, apply engineering strategies.
