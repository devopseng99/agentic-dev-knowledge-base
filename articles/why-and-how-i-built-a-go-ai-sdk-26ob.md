---
title: "Why (and How) I Built a Go AI SDK"
url: "https://dev.to/vietanh/why-and-how-i-built-a-go-ai-sdk-26ob"
author: "anh"
category: "rust-go-java-agents"
---

# Why (and How) I Built a Go AI SDK
**Author:** anh
**Published:** April 7, 2026

## Overview
GoAI: 22+ providers, 2 dependencies, type-safe generics (Go 1.25+). Mirrors Vercel AI SDK. SchemaFrom[T] for JSON Schema from structs. Built-in MCP support, provider-defined tools (web search, code execution), prompt caching (41-80% cost savings). Cold start 24x faster than Vercel AI SDK, 3x less memory.

## Key Concepts

```go
type Recipe struct {
    Name string `json:"name"`
    Ingredients []string `json:"ingredients"`
}
result, err := goai.GenerateObject[Recipe](ctx, model, goai.WithPrompt("A simple pasta recipe"))
// result.Object is Recipe, fully typed
```

```go
// MCP support
transport := mcp.NewStdioTransport("npx", []string{"@modelcontextprotocol/server-filesystem", "/tmp"})
client := mcp.NewClient("myapp", "1.0", mcp.WithTransport(transport))
mcpTools, _ := client.ListTools(ctx, nil)
tools := mcp.ConvertTools(client, mcpTools.Tools)
result, _ := goai.GenerateText(ctx, model, goai.WithTools(tools...), goai.WithMaxSteps(3))
```

| Metric | GoAI | Vercel AI SDK |
|--------|------|---------------|
| Cold start | 569us | 13.89ms (24x) |
| Memory | 220KB | 676KB (3x) |
| Streaming | 1.46ms/op | 1.62ms/op |

- Only 2 dependencies vs LangChainGo's 170+
- 90%+ test coverage with mock HTTP servers
