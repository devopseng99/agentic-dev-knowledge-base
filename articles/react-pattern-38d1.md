---
title: "ReAct Pattern"
url: https://dev.to/seahjs/react-pattern-38d1
author: seah-js
category: react-pattern
---

# ReAct Pattern

**Author:** seah-js
**Date Published:** February 4, 2026
**Tags:** #ai #machinelearning #beginners #agents

---

## Overview

ReAct stands for **Reasoning + Acting** -- an agent pattern that explicitly interleaves thinking with tool execution rather than answering in a single pass.

## Core Loop

The pattern follows this sequence:

1. **Thought** -- the model reasons about next steps
2. **Action** -- the model calls a tool (via formatted text like `Action: search[...]`)
3. **Observation** -- system injects real tool results back into context
4. **Repeat** until the model signals completion with a final answer

## Key Mechanism

The system uses **stop sequences** to intercept tool calls. The LLM generates text patterns representing tool invocations; the surrounding system detects, executes, and reinjects results as context. From the model's perspective, it's generating text -- the scaffolding handles actual execution.

## Practical Example

When asked "Should I go to the beach Saturday?", an agent might:

- Check weather forecast -> observe conditions
- Query tide information -> observe timing
- Synthesize observations into recommendations

Each step informs the next decision.

## Critical Failure Modes

**Infinite loops:** Models may loop indefinitely without convergence. Mitigation: enforce maximum iteration limits.

**Context degradation:** Token accumulation causes two problems:
- Attention becomes "diluted" across more tokens
- Models exhibit "lost in the middle" behavior, neglecting earlier reasoning

**Solution:** Compress context between steps using summarization buffers that keep recent exchanges verbatim while summarizing older ones -- a lossy but necessary tradeoff.

## Chain-of-Thought as Computation

Explicit reasoning isn't merely stylistic. Each generated token becomes context for the next forward pass, transforming fixed-depth (single pass) computation into variable-depth computation through token chaining. Generated tokens serve as working memory -- scratch space where intermediate computation is encoded.

## ReAct vs Alternatives

| Pattern | Strengths | Weaknesses |
|---------|-----------|-----------|
| **Pure tool calling** | Fast, fewer tokens | No reasoning before action |
| **Plan-first** | Strategic, sees dependencies | Brittle against unexpected results |
| **ReAct** | Adaptive, handles surprises | Short-sighted, myopic planning |

Production systems typically use **hybrid approaches**: establish rough plans but replan when observations diverge from expectations. Frameworks like LangGraph enable branching logic based on actual outcomes.

## Real-World Implementation

Pure ReAct rarely appears in production. Practical systems layer structure atop the core pattern: planning, memory management, guardrails, and fallbacks -- while retaining interleaved reasoning-action as the foundation.
