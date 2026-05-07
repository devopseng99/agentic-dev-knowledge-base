---
title: "How Tracing Works in Azure AI Foundry Agents"
url: "https://dev.to/willvelida/how-tracing-works-in-azure-ai-foundry-agents-5145"
author: "Will Velida"
category: "ai-agent-logging-tracing"
---

# How Tracing Works in Azure AI Foundry Agents

**Author:** Will Velida
**Published:** June 4, 2025

## Overview
How to implement tracing for Azure AI Foundry Agents using OpenTelemetry and Application Insights. Covers three approaches: Agents Playground UI, Application Insights connection, and code-level OpenTelemetry integration.

## Key Concepts

### Tracing Approaches
1. **Agents Playground:** Built-in Thread info and Metrics tabs showing step-by-step execution logs and token usage
2. **Application Insights:** Connect via Observability > Tracing in portal
3. **OpenTelemetry in Code:** Full programmatic tracing with custom spans

## Code Examples

### Install Required Packages

```python
pip install opentelemetry-sdk
pip install azure-core-tracing-opentelemetry
pip install opentelemetry-exporter-otlp
pip install azure-monitor-opentelemetry
```

### Initialize Tracing

```python
from azure.monitor.opentelemetry import configure_azure_monitor
from opentelemetry import trace

configure_azure_monitor(connection_string=app_insights_connection_string)
tracer = trace.get_tracer(__name__)
```

### Custom Function Tracing with Attributes

```python
span = trace.get_current_span()
span.set_attribute("requested_location", location)
```

### Important Note
PII information from function tool calls may appear in traces even when content recording is disabled -- this is a known bug.
