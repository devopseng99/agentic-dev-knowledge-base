---
title: "How to Implement LLM Tool-calling with Go and Ollama"
url: "https://dev.to/calvinmclean/how-to-implement-llm-tool-calling-with-go-and-ollama-237g"
author: "Calvin McLean"
category: "rust-go-java-agents"
---

# How to Implement LLM Tool-calling with Go and Ollama
**Author:** Calvin McLean
**Published:** June 16, 2025

## Overview
Tool-calling implementation with Go and Ollama's API. LLM generates structured JSON for function calls; Go controller executes and feeds output back. Demonstrates weather tool with Modelfile system prompt, then extends to tour availability search. Key insight: programs become tool collections with LLM controlling flow.

## Key Concepts

```go
req := &api.ChatRequest{
    Model: model,
    Messages: messages,
    Tools: api.Tools{
        api.Tool{
            Type: "function",
            Function: api.ToolFunction{
                Name: "getCurrentWeather",
                Description: "Get current weather in a location",
                Parameters: api.ToolFunctionParameters{
                    Type: "object",
                    Required: []string{"location"},
                    Properties: map[string]api.ToolFunctionProperty{
                        "location": {Type: api.PropertyType{"string"}},
                    },
                },
            },
        },
    },
}
```
