---
title: "Why (and How) I Built a Go AI SDK"
url: "https://dev.to/vietanh/why-and-how-i-built-a-go-ai-sdk-26ob"
author: "anh"
category: "ai-agent-go-golang"
---

# Why (and How) I Built a Go AI SDK

**Author:** anh
**Published:** April 7, 2026

## Overview
GoAI is a unified Go AI SDK covering 22+ providers with only 2 core dependencies. Inspired by the Vercel AI SDK, it provides type-safe structured output via generics, functional options, streaming via goroutines/channels, MCP support, and observability hooks. Benchmarks show 24x faster cold start and 3x less memory than Vercel AI SDK.

## Key Concepts

### Unified API

```go
goai.GenerateText(ctx, model, opts...)
goai.StreamText(ctx, model, opts...)
goai.GenerateObject[T](ctx, model, opts...)
goai.StreamObject[T](ctx, model, opts...)
goai.Embed(ctx, model, value, opts...)
goai.EmbedMany(ctx, model, values, opts...)
goai.GenerateImage(ctx, model, opts...)
```

### Type-Safe Structured Output with Generics

```go
type Recipe struct {
    Name        string   `json:"name"`
    Ingredients []string `json:"ingredients"`
    Steps       []string `json:"steps"`
}

result, err := goai.GenerateObject[Recipe](ctx, model,
    goai.WithPrompt("A simple pasta recipe"),
)
// result.Object is Recipe, fully typed
```

### Functional Options Pattern

```go
result, err := goai.GenerateText(ctx, model,
    goai.WithSystem("You are a helpful assistant"),
    goai.WithPrompt("Hello"),
    goai.WithMaxSteps(3),
    goai.WithTools(searchTool, calculatorTool),
    goai.WithMaxRetries(2),
    goai.WithOnResponse(func(info goai.ResponseInfo) {
        log.Printf("latency=%v tokens=%d", info.Latency, info.Usage.TotalTokens)
    }),
)
```

### Streaming with Goroutines and Channels

```go
stream, _ := goai.StreamText(ctx, model, goai.WithPrompt("Tell me a story"))

for text := range stream.TextStream() {
    fmt.Print(text)
}

if err := stream.Err(); err != nil {
    log.Fatal(err)
}
```

### Provider Interface (3 interfaces)

```go
type LanguageModel interface {
    ModelID() string
    DoGenerate(ctx context.Context, params GenerateParams) (*GenerateResult, error)
    DoStream(ctx context.Context, params GenerateParams) (*StreamResult, error)
}

type EmbeddingModel interface {
    ModelID() string
    DoEmbed(ctx context.Context, values []string, params EmbedParams) (*EmbedResult, error)
    MaxValuesPerCall() int
}

type ImageModel interface {
    ModelID() string
    DoGenerate(ctx context.Context, params ImageParams) (*ImageResult, error)
}
```

### Provider-Defined Tools

```go
def := anthropic.Tools.WebSearch(anthropic.WithMaxUses(5))
tools := []goai.Tool{{
    Name:                   def.Name,
    ProviderDefinedType:    def.ProviderDefinedType,
    ProviderDefinedOptions: def.ProviderDefinedOptions,
}}

result, _ := goai.GenerateText(ctx, model,
    goai.WithPrompt("Search for Go AI libraries"),
    goai.WithTools(tools...),
)
```

### MCP Support

```go
transport := mcp.NewStdioTransport("npx", []string{"@modelcontextprotocol/server-filesystem", "/tmp"})
client := mcp.NewClient("myapp", "1.0", mcp.WithTransport(transport))
client.Connect(ctx)
defer client.Close()

mcpTools, _ := client.ListTools(ctx, nil)
tools := mcp.ConvertTools(client, mcpTools.Tools)

result, _ := goai.GenerateText(ctx, model,
    goai.WithPrompt("List files in /tmp"),
    goai.WithTools(tools...),
    goai.WithMaxSteps(3),
)
```

### Minimal Dependencies
- GoAI core: 2 dependencies
- vs Eino: 37, instructor-go: 41, Genkit Go: 129, LangChainGo: 170+

### Provider Switching (Same Code)

```go
model := openai.Chat("gpt-4o")
model := anthropic.Chat("claude-sonnet-4-20250514")
model := google.Chat("gemini-2.0-flash")
model := ollama.Chat("llama3")
```

### Performance Benchmarks (vs Vercel AI SDK)
- Cold start: 569us vs 13.89ms (24x faster)
- Memory per stream: 220KB vs 676KB (3x less)
- GenerateText: 55.7us/op vs 79.0us/op (1.4x faster)
