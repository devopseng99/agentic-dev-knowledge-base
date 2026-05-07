---
title: "Migrating from Semantic Kernel to Microsoft Agent Framework: A C# Developer's Guide"
url: "https://dev.to/bspann/migrating-from-semantic-kernel-to-microsoft-agent-framework-a-c-developers-guide-3ad5"
author: "Brian Spann"
category: "agent-sdks"
---

# Migrating from Semantic Kernel to Microsoft Agent Framework
**Author:** Brian Spann
**Published:** March 2, 2026

## Overview
Guide to migrating from Semantic Kernel to the unified Microsoft Agent Framework (RC), which merges Semantic Kernel and AutoGen into a single framework.

## Key Concepts

### Legacy Kernel Approach
```csharp
var builder = Kernel.CreateBuilder();
builder.AddAzureOpenAIChatCompletion(...);
var kernel = builder.Build();
```

### New Agent Framework Approach
```csharp
var agent = chatClient.AsAIAgent(
    name: "CloudPoet",
    instructions: "You are a helpful assistant."
);
```

### Key Changes
- Plugins transitioned from `[KernelFunction]` attributes to `AIFunction.Create()` lambdas
- Purpose-built workflow patterns: sequential, concurrent, handoff routing
- Native MCP (Model Context Protocol) support for automatic tool server access
