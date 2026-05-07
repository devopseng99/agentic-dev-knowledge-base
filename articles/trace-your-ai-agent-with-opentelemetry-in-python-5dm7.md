---
title: "Trace Your AI Agent With OpenTelemetry in Python"
url: "https://dev.to/klement_gunndu/trace-your-ai-agent-with-opentelemetry-in-python-5dm7"
author: "klement Gunndu"
category: "ai-agent-logging-tracing"
---

# Trace Your AI Agent With OpenTelemetry in Python

**Author:** klement Gunndu
**Published:** March 6, 2026

## Overview
For multi-step agents that call tools, chain prompts, and make decisions, tracing is the difference between debugging for 5 minutes and debugging for 5 hours. This article covers three implementation patterns: auto-instrumentation, custom spans, and backend export.

## Key Concepts

### Three Advantages of Tracing
1. **Latency attribution:** identifying which specific operation consumes time
2. **Causality tracking:** understanding how upstream decisions affect downstream failures
3. **Cost per request:** measuring token consumption for each step

### Key Attributes to Track
- `routing.tool_selected`: Documents agent path decisions
- `tool.success`: Indicates execution status
- `llm.token_count`: Enables cost tracking
- `agent.retry_count`: Detects failure patterns

## Code Examples

### Pattern 1: Auto-Instrumentation

```python
from opentelemetry.instrumentation.langchain import LangchainInstrumentor
LangchainInstrumentor().instrument()
```

Automatically wraps LLM calls, chain invocations, and tool executions in spans.

### Pattern 2: Custom Spans for Decision Points

```python
from opentelemetry import trace
tracer = trace.get_tracer("ai-agent")

with tracer.start_as_current_span("route_query") as span:
    span.set_attribute("routing.tool_selected", tool)
```

### Pattern 3: Backend Export

```python
from opentelemetry.exporter.otlp.proto.http.trace_exporter import OTLPSpanExporter
otlp_exporter = OTLPSpanExporter(endpoint="http://localhost:4318/v1/traces")
```

### Production Recommendations
- Implement trace sampling to manage data volume
- Set span limits (max_events, max_attributes) to prevent memory exhaustion
- Mark failures explicitly using StatusCode.ERROR for alerting
- Start with three spans: full request wrapper, LLM calls (auto-instrumented), and tool selection/execution logic -- covers 80% of production issues
