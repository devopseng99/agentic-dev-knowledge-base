---
title: "[Patterns] AI Agent Error Handling That Actually Works"
url: "https://dev.to/rapidclaw/patterns-ai-agent-error-handling-that-actually-works-1a57"
author: "Tijo Gaucher"
category: "agent-error-handling-retry"
---

# [Patterns] AI Agent Error Handling That Actually Works

**Author:** Tijo Gaucher
**Published:** April 17, 2026

## Overview

Production-tested error handling patterns for AI agents: error classification, retry with backoff, circuit breakers, fallback chains, and timeout handling. Based on running 5 agents as a solo founder.

## Key Concepts

### Error Classification

```python
class ErrorClassifier:
    TRANSIENT_CODES = {429, 500, 502, 503, 504}

    @staticmethod
    def classify(error):
        if hasattr(error, 'status_code'):
            if error.status_code in ErrorClassifier.TRANSIENT_CODES:
                return "transient"
        if "timeout" in str(error).lower():
            return "transient"
        return "permanent"
```

### Retry with Backoff and Jitter

```python
import random
import time

def retry_with_backoff(fn, max_retries=3, base_delay=1.0):
    for attempt in range(max_retries):
        try:
            return fn()
        except Exception as e:
            if ErrorClassifier.classify(e) == "permanent":
                raise
            if attempt == max_retries - 1:
                raise
            delay = base_delay * (2 ** attempt)
            jitter = random.uniform(0, delay * 0.5)
            time.sleep(delay + jitter)
```

### Circuit Breaker

```python
class CircuitBreaker:
    def __init__(self, failure_threshold=5, recovery_time=60):
        self.failure_count = 0
        self.failure_threshold = failure_threshold
        self.recovery_time = recovery_time
        self.last_failure_time = None
        self.state = "closed"

    def call(self, fn):
        if self.state == "open":
            if time.time() - self.last_failure_time > self.recovery_time:
                self.state = "half-open"
            else:
                raise CircuitOpenError("Circuit breaker is open")
        try:
            result = fn()
            if self.state == "half-open":
                self.state = "closed"
                self.failure_count = 0
            return result
        except Exception as e:
            self.failure_count += 1
            self.last_failure_time = time.time()
            if self.failure_count >= self.failure_threshold:
                self.state = "open"
            raise
```

### Fallback Chains

```python
FALLBACK_CHAIN = [
    {"provider": "anthropic", "model": "claude-sonnet-4-20250514"},
    {"provider": "openai", "model": "gpt-4o-mini"},
    {"provider": "local", "model": "cached_response"},
]

def call_with_fallback(prompt, chain=FALLBACK_CHAIN):
    errors = []
    for option in chain:
        try:
            return call_model(option["provider"], option["model"], prompt)
        except Exception as e:
            errors.append(f"{option['provider']}: {e}")
            continue
    raise AllProvidersFailedError(
        f"All {len(chain)} providers failed: {'; '.join(errors)}"
    )
```

### Timeout Handling

```python
import asyncio

async def call_with_timeout(coro, timeout_seconds=30):
    try:
        return await asyncio.wait_for(coro, timeout=timeout_seconds)
    except asyncio.TimeoutError:
        raise TimeoutError(f"LLM call exceeded {timeout_seconds}s limit")
```

### Full Integration

```python
async def agent_execute(task):
    breaker = get_circuit_breaker("llm_calls")
    try:
        result = breaker.call(
            lambda: retry_with_backoff(
                lambda: call_with_fallback(task.prompt),
                max_retries=3
            )
        )
        return AgentResult(status="success", data=result)
    except CircuitOpenError:
        return AgentResult(
            status="degraded",
            data=get_cached_response(task),
            note="Using cached response - LLM circuit open"
        )
    except AllProvidersFailedError:
        return AgentResult(
            status="failed",
            data=None,
            note="All providers unavailable"
        )
```
