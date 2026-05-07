---
title: "Watching Your Agents Work: Logs, Traces, and Metrics for Reliable AI Workflows"
url: "https://dev.to/kowshik_jallipalli_a7e0a5/watching-your-agents-work-logs-traces-and-metrics-for-reliable-ai-workflows-4eom"
author: "Kowshik Jallipalli"
category: "ai-agent-logging-tracing"
---

# Watching Your Agents Work: Logs, Traces, and Metrics for Reliable AI Workflows

**Author:** Kowshik Jallipalli
**Published:** February 27, 2026

## Overview
When an autonomous AI agent fails, it might silently retry a broken tool five times, burn $2 in tokens, and return a hallucinated response. This article shows how to instrument agentic workflows with OpenTelemetry for debugging, cost tracking, and alerting.

## Key Concepts

### Key Pitfalls
- **Payload Bloat:** Logging entire RAG contexts (50,000+ tokens) inflates ingestion costs
- **PII Leakage:** LLM prompts often contain sensitive user data; blindly logging to centralized platforms risks compliance violations
- **Orphaned Spans:** Multi-agent systems using async queues lose trace context unless serialized into message headers
- **TTFT Metrics:** Time-to-first-token reveals whether bottlenecks originate in vector DB retrieval or LLM reasoning

## Code Examples

### Full Agent Tracing with OpenTelemetry

```python
import os
import json
from opentelemetry import trace
from opentelemetry.sdk.trace import TracerProvider
from opentelemetry.sdk.trace.export import ConsoleSpanExporter, SimpleSpanProcessor

provider = TracerProvider()
processor = SimpleSpanProcessor(ConsoleSpanExporter())
provider.add_span_processor(processor)
trace.set_tracer_provider(provider)

tracer = trace.get_tracer("support_agent_service")

def tool_check_billing(customer_id: str) -> str:
    return f"Customer {customer_id} is on the Pro plan."

@tracer.start_as_current_span("agent_execution")
def run_support_agent(ticket_id: str, user_query: str):
    parent_span = trace.get_current_span()
    parent_span.set_attribute("app.ticket_id", ticket_id)
    parent_span.set_attribute("app.user_query", user_query)

    # Step 1: Tool Call Phase
    with tracer.start_as_current_span("tool_call:check_billing") as tool_span:
        customer_id = "cus_123"
        tool_span.set_attribute("tool.name", "check_billing")
        tool_span.set_attribute("tool.input", json.dumps({"customer_id": customer_id}))

        try:
            result = tool_check_billing(customer_id)
            tool_span.set_attribute("tool.output", result)
            tool_span.set_status(trace.StatusCode.OK)
        except Exception as e:
            tool_span.record_exception(e)
            tool_span.set_status(trace.StatusCode.ERROR)
            raise e

    # Step 2: LLM Generation Phase
    with tracer.start_as_current_span("llm_call:claude_3_5") as llm_span:
        llm_span.set_attribute("llm.model", "claude-3-5-sonnet-latest")
        mock_response = "Based on your Pro plan, I can help you with..."
        llm_span.set_attribute("llm.usage.prompt_tokens", 450)
        llm_span.set_attribute("llm.usage.completion_tokens", 85)
        llm_span.set_attribute("llm.response", mock_response)

    return mock_response

run_support_agent("tkt_8991", "Why was I charged twice?")
```

### Recommended Next Steps
1. **Cost Dashboard:** Export OTel spans to Grafana/Datadog; query sum(llm.usage.prompt_tokens) grouped by agent name
2. **AI-Native Platforms:** LangSmith, Braintrust, Helicone for purpose-built observability
3. **Tool Failure Alerting:** Slack alerts when error ratios exceed 5% within 10-minute windows
