---
title: "Experimenting mcp-go, AnythingLLM and local LLM executions"
url: "https://dev.to/rkatz/experimenting-mcp-go-anythingllm-and-local-llm-executions-549a"
author: "Ricardo Katz"
category: "rust-go-java-agents"
---

# Experimenting mcp-go, AnythingLLM and local LLM executions
**Author:** Ricardo Katz
**Published:** April 21, 2025

## Overview
Integrates MCP with Go SDK and AnythingLLM using local Llama 3.2 3B model. Builds a weather forecast tool querying National Weather Service API. Demonstrates MCP server registration, tool handler implementation, and AnythingLLM @agent invocation.

## Key Concepts

```go
type Forecast struct {
    Properties struct {
        Periods []struct {
            Name, Temperature, ShortForecast, DetailedForecast string
        } `json:"periods,omitempty"`
    } `json:"properties,omitempty"`
}
```

```json
{
    "mcpServers": {
        "weather": {
            "command": "/path/to/forecast"
        }
    }
}
```
