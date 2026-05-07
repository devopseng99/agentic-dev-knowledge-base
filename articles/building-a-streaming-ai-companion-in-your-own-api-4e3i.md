---
title: "Building a streaming AI companion in your own API"
url: "https://dev.to/samvanhoutte/building-a-streaming-ai-companion-in-your-own-api-4e3i"
author: "Sam Vanhoutte"
category: "cloud-agents"
---

# Building a streaming AI companion in your own API
**Author:** Sam Vanhoutte
**Published:** May 2, 2026

## Overview
Building an AI conversational assistant for Libelo (nature/hiking discovery platform) using Azure AI Foundry, routed through a custom API for security, monitoring, validation, and resilience. Uses SSE streaming, structured card responses, and anti-hallucination tracking.

## Key Concepts

### Azure AI Project Client Setup

```csharp
services.AddSingleton<AIProjectClient>(sp =>
{
    var options = sp.GetRequiredService<IOptions<CompanionOptions>>().Value;
    return new AIProjectClient(
        new Uri(options.AzureAIProjectEndpoint),
        new DefaultAzureCredential());
});
```

### Why Route Through Your Own API
- **Security**: Azure credentials stay server-side; clients authenticate via JWT
- **Monitoring**: OpenTelemetry traces for requests, latency, tokens, errors
- **Validation**: FluentValidation checks context before agent sees it
- **Resilience**: Polly retry pipeline handles transient errors

### Tools Implemented
ParkStatusTool, WeatherTool, RecentSightingsTool, UserFavouritesTool, EmitCardsTool

### Anti-Hallucination Pattern
Tracks surfaced IDs (from tools) vs emitted IDs (from model). Only cards both retrieved and claimed are included in responses.

### Streaming
Server-Sent Events (SSE) stream text deltas immediately, then send final envelope with validated message and card array.
