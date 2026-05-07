---
title: "AI Agent Error Handling: 4 Resilience Patterns in Python"
url: "https://dev.to/nebulagg/ai-agent-error-handling-4-resilience-patterns-in-python-12of"
author: "The Daily Agent"
category: "ai-agents-resilience"
---

# AI Agent Error Handling: 4 Resilience Patterns in Python

**Author:** The Daily Agent
**Published:** March 23, 2026

## Overview

This guide addresses a critical operational challenge: LLM-powered agents fail differently than traditional software. Rather than deterministic errors, they encounter rate limits, context window overflows, content policy rejections, and response format drift. The article presents four battle-tested patterns for building resilient AI agents using pure Python.

## Why AI Agents Fail Differently

Traditional APIs fail predictably (connection errors, auth failures). LLM systems introduce non-deterministic failure modes:

- **Rate limits (429)** fluctuate with provider load
- **Context window overflow** accumulates silently through conversation history
- **Content policy rejections** vary between providers
- **Response format drift** occurs with model updates
- **Partial or malformed responses** break downstream parsing

The key insight: these aren't bugs to eliminate but operational realities requiring engineering solutions.

## Pattern 1: Smart Retry with Exponential Backoff

Not all errors deserve retries. Retrying permanent failures (bad API keys, malformed requests) wastes resources, while failing fast on transient errors loses recoverable requests.

**Error Classification Strategy:**

Three categories guide retry decisions:
- **TRANSIENT** (429, 500, 502, 503, timeouts) -> retry with backoff
- **PERMANENT** (auth failures, bad requests) -> fail immediately
- **DEGRADED** (context length exceeded, content filters) -> switch to fallback

The implementation uses exponential backoff (1s, 2s, 4s, capped at 60s) with random jitter to prevent thundering herd problems when multiple agents retry simultaneously after shared outages.

**Critical Production Details:**
- Always set timeouts on LLM calls (30 seconds recommended)
- Track token spend across retries—three retries multiply costs significantly
- Implement budget caps for autonomous agents

## Pattern 2: Model Fallback Chains

While retries handle transient failures within a single provider, fallback chains route requests to alternative models when primary providers fail.

**Architecture:**
Each model in the chain receives its own retry protection. If retries exhaust, the chain automatically proceeds to the next model. The chain structure enables:
- Primary -> high-quality models
- Secondary -> alternative providers (avoid provider-specific outages)
- Tertiary -> cost-optimized models (cheaper, always available)

**Practical Chain Example:**
GPT-4o (primary) -> Claude Sonnet (different provider) -> GPT-4o-mini (cost tier)

The implementation normalizes response formats across providers, making fallbacks transparent to downstream code.

## Pattern 3: Circuit Breaker for Tool Calls

Retries and fallbacks address individual request failures. Circuit breakers solve cascading failures: when external services are down, naive retries waste 30 seconds per request before failing.

**Three States:**
- **CLOSED** - Normal operation, requests pass through
- **OPEN** - Service confirmed down, immediate rejections (prevents wasted retries)
- **HALF_OPEN** - Testing recovery with probe requests

After 5 consecutive failures, the circuit opens for 60 seconds. Once timeout elapses, one probe request tests recovery. Two successful probes reset to closed state.

This prevents hammering struggling providers while enabling quick recovery detection.

## Pattern 4: Graceful Degradation

The final pattern handles scenarios where no perfect solution exists. When LLM responses fail structural validation or hit context limits, the system smoothly reduces functionality rather than crashing.

**Degradation Strategies:**
- Shorter summaries when context nears limits
- Template-based responses when LLM fails
- Cached responses from previous similar queries
- Reduced capability mode (simpler prompts, fewer tool calls)

## Key Takeaways

Production AI agents require layered resilience:

1. **Retry layer** handles transient blips within 30 seconds
2. **Fallback layer** routes around sustained provider issues
3. **Circuit breaker layer** prevents cascading failures across your system
4. **Degradation layer** maintains functionality when all recovery paths fail

These patterns work together: fast failure from circuit breakers prevents retry thundering; fallback chains ensure requests eventually succeed; graceful degradation keeps the user experience functional.

The implementations provided are dependency-free and compatible with any LLM provider (OpenAI, Anthropic, open-source models).
