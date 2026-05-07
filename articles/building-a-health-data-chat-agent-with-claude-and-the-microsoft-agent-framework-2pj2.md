---
title: "Building a Health Data Chat Agent with Claude and the Microsoft Agent Framework"
url: https://dev.to/willvelida/building-a-health-data-chat-agent-with-claude-and-the-microsoft-agent-framework-2pj2
author: Will Velida
category: ai-agent-development
---

# Building a Health Data Chat Agent with Claude and the Microsoft Agent Framework

**Author:** Will Velida
**Date Published:** March 10, 2026

---

## Overview

This article demonstrates creating a health data chat agent using the Microsoft Agent Framework with Claude as the LLM provider, rather than OpenAI or Azure foundry deployments.

## Key Architectural Decisions

### Agent Framework vs. Direct SDK

The Microsoft Agent Framework abstracts away manual tool-call loops. Instead of implementing while loops to handle tool invocations:

```csharp
AIAgent chatAgent = anthropicClient.AsAIAgent(
    model: "claude-sonnet-4-6",
    name: "BiotrackrChatAgent",
    instructions: systemPrompt,
    tools: [ AIFunctionFactory.Create(myTools.GetData) ]
);

await foreach (var update in chatAgent.RunStreamingAsync(messages))
{
    Console.Write(update);
}
```

The framework handles streaming, tool execution, and result feeding automatically.

## Implementation Details

### Setting Up Anthropic Provider

Install the NuGet package for Anthropic integration:

```bash
dotnet add package Microsoft.Agents.AI.Anthropic --prerelease
```

Register in `Program.cs`:

```csharp
using Anthropic;
using Microsoft.Agents.AI;

var anthropicApiKey = builder.Configuration.GetValue<string>("Biotrackr:AnthropicApiKey");
var modelName = builder.Configuration.GetValue<string>("Biotrackr:ChatAgentModel");
var systemPrompt = builder.Configuration.GetValue<string>("Biotrackr:ChatSystemPrompt")!;

AnthropicClient anthropicClient = new() { ApiKey = anthropicApiKey };

AIAgent chatAgent = anthropicClient.AsAIAgent(
    model: modelName,
    name: "BiotrackrChatAgent",
    instructions: systemPrompt,
    tools: [
        AIFunctionFactory.Create(activityTools.GetActivityByDate),
        AIFunctionFactory.Create(activityTools.GetActivityByDateRange),
        // ... additional tools
    ]
);
```

### Function Tools Pattern

Tools are plain C# methods with `[Description]` attributes. The framework uses reflection to generate JSON schemas:

```csharp
public class ActivityTools(IHttpClientFactory httpClientFactory, IMemoryCache cache)
{
    [Description("Get activity data (steps, calories, distance) for a specific date. " +
                 "Date format: YYYY-MM-DD.")]
    public async Task<string> GetActivityByDate(
        [Description("The date to get activity data for, in YYYY-MM-DD format")]
        string date)
    {
        if (!DateOnly.TryParse(date, out _))
            return """{"error": "Invalid date format. Use YYYY-MM-DD."}""";

        var cacheKey = $"activity:{date}";
        if (cache.TryGetValue(cacheKey, out string? cached))
            return cached!;

        var client = httpClientFactory.CreateClient("BiotrackrApi");
        var response = await client.GetAsync($"/activity/{date}");

        if (!response.IsSuccessStatusCode)
            return $"""{"error": "Activity data not found for {date}."}""";

        var result = await response.Content.ReadAsStringAsync();

        var ttl = DateOnly.Parse(date) == DateOnly.FromDateTime(DateTime.UtcNow)
            ? TimeSpan.FromMinutes(5)    // Today's data -- short TTL
            : TimeSpan.FromHours(1);     // Historical data -- long TTL
        cache.Set(cacheKey, result, ttl);

        return result;
    }
}
```

### AG-UI Protocol Integration

Expose the agent as a streaming SSE endpoint:

```csharp
builder.Services.AddAGUI();
var app = builder.Build();
app.MapAGUI("/", chatAgent);
```

This handles POST requests, runs the agent, and formats responses as SSE events compatible with frontend UI frameworks.

## System Prompt Design

Configuration-driven prompt stored in Azure App Configuration:

```
You are the Biotrackr health and fitness assistant. You help the user
understand their health data by querying activity, sleep, weight, and food
records using the available tools. Always use the tools to retrieve data
before answering. Present data clearly and concisely. You are not a medical
professional -- remind users to consult a healthcare provider for medical
advice.
```

**Key principles:**
- "Always use tools to retrieve data before answering" prevents hallucination
- Enforces read-only operations (all 12 tools are GET requests)
- Redirects medical questions to healthcare professionals
- Externalized configuration enables rapid iteration without redeployment

## Cost Optimization

### Prompt Caching

Anthropic caches identical prefixes at 10% cost. System prompt plus 12 tool definitions (~2,500 tokens) are cached across all requests.

### In-Memory Tool Result Caching

Adaptive TTLs reduce redundant API calls:
- Today's data: 5-minute TTL
- Historical data: 1-hour TTL
- Date ranges: 30-minute TTL
- Paginated queries: 15-minute TTL

### Rough Monthly Estimates

At ~15 conversations/day with 4 messages per conversation:
- Claude Sonnet: $8-12/month (with caching)
- Claude Haiku: $2-4/month (with caching)

Fixed overhead is ~2,500 tokens per request from system prompt and tool definitions.

## Current Limitations

The Anthropic provider in Agent Framework lacks feature parity with OpenAI:
- No code interpreter support
- No MCP (Model Context Protocol) tool support
- No web search capabilities
- No file search functionality

Workaround: Function tools call APIs directly via `HttpClient`.

## Known Caveats

- Packages are in preview (`1.0.0-rc3` for core, `1.0.0-preview` for hosting)
- Anthropic enforces 60 requests/minute at Tier 1 (default)
- Claude sometimes sends natural language dates ("yesterday") instead of formatted strings
- Input validation in tools catches malformed arguments and triggers self-correction

## Key Takeaways

1. The framework eliminates boilerplate for tool-call loops and streaming
2. Function tools via reflection-based schema generation simplify tool authoring
3. Configuration-driven system prompts enable rapid iteration and emergency updates
4. Prompt caching and in-memory result caching keep per-request costs reasonable
5. Provider-agnostic design allows future migration without changing application logic
6. Read-only tool definitions and explicit scope constraints provide security boundaries

## Resources

- [Microsoft Agent Framework](https://github.com/microsoft/agents)
- [Microsoft.Agents.AI.Anthropic on NuGet](https://www.nuget.org/packages/Microsoft.Agents.AI.Anthropic)
- [Anthropic Claude API docs](https://docs.anthropic.com/en/docs/)
- [Anthropic .NET SDK](https://github.com/anthropics/anthropic-sdk-dotnet)
- [AG-UI Protocol](https://docs.ag-ui.com/)
- [Anthropic Pricing](https://www.anthropic.com/pricing)
- [Biotrackr Source Code](https://github.com/willvelida/biotrackr)
