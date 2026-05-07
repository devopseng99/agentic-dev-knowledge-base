---
title: "Everyone thinks ChatGPT is an AI agent. It's not."
url: "https://dev.to/austin_starks/everyone-thinks-chatgpt-is-an-ai-agent-its-not-1n0l"
author: "Austin Starks"
category: "ai-agent-trading-finance"
---

# Everyone thinks ChatGPT is an AI agent. It's not.

**Author:** Austin Starks
**Published:** April 13, 2026

## Overview

This article distinguishes between ChatGPT (a chatbot with tools) and true AI agents. An agent runs a loop: it thinks, picks an action, executes it through a tool, observes the result, and repeats until the task is done. ChatGPT requires user direction for each step. Part 2 of a 5-part "AI Agents from Scratch" series.

## Key Concepts

### Language Models and Statelessness

"A raw language model is stateless. It has no memory of you." The OpenAI Playground exemplifies the model in its purest form. ChatGPT represents "an app built on top of that model," adding memory and tool capabilities.

### Agent vs. Chatbot

"An agent runs a loop. It thinks, picks an action, executes it through a tool, observes the result, and repeats until the task is done." ChatGPT requires user direction for each step.

### System Prompts

A production system prompt contains: identity section, explicit directives, data sources/context, behavioral examples, and output format rules.

```python
# INSTRUCTIONS
You are Aurora, an AI trading assistant for NexusTrade.
You help users build, backtest, and manage trading strategies.
Always respond in JSON. forceJSON: true.
Never recommend a specific stock without a supporting backtest.
If the request is ambiguous, ask one clarifying question before proceeding.

# EXAMPLES
User: "I want to back test a trading strategy"
Assistant: {"tool": "backtest", "portfolio_id": "...", "start": "2022-01-01", "end": "2024-01-01"}

User: "Screen for high momentum stocks"
Assistant: {"tool": "screener", "query": "SELECT ticker FROM stocks WHERE rsi_14 > 70 ORDER BY momentum DESC"}

# OUTPUT FORMAT
Always respond in syntactically valid JSON.
No markdown fences. No explanation unless explicitly asked.
Schema: {"tool": string, "parameters": object}
```

### Tools and Execution

"The AI doesn't execute anything. Your code does." When a model outputs a tool call:

```json
{
  "tool": "backtest",
  "portfolio_id": "abc123",
  "start_date": "2022-01-01",
  "end_date": "2024-01-01"
}
```

System code parses it, invokes the API, retrieves results, and feeds them back. "The AI is deciding what to do. Your infrastructure is doing it."

### The Controller Pattern

Production applications use classifier-based routing:

1. **Classifier:** Routes incoming messages to appropriate sub-prompts
2. **Sub-prompts:** Focused, task-specific system instructions
3. **Tool lists:** Limited to relevant functions per task

NexusTrade employs 23 specialized sub-prompts with a classifier using `gemini-3.1-flash-lite-001` at temperature 0 and `forceJSON: true`.

### Model Context Protocol (MCP)

MCP provides standardized tool interfaces across systems -- "USB for AI agents."

```json
{
  "mcpServers": {
    "nexustrade": {
      "url": "https://nexustrade.io/api/mcp",
      "headers": { "Authorization": "Bearer <your-api-key>" }
    }
  }
}
```
