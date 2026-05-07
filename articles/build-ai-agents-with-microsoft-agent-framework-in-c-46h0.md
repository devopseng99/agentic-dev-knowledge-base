---
title: "Build AI Agents with Microsoft Agent Framework in C#"
url: "https://dev.to/mashrulhaque/build-ai-agents-with-microsoft-agent-framework-in-c-46h0"
author: "Mashrul Haque"
category: "semantic-kernel"
---

# Build AI Agents with Microsoft Agent Framework in C#

**Author:** Mashrul Haque
**Published:** January 1, 2026
**Last Updated:** January 2, 2026

## Overview

Microsoft Agent Framework is a unified platform for building AI agents in C#, consolidating AutoGen and Semantic Kernel into a single framework. It provides native support for conversation memory, tool orchestration, and multi-agent workflows.

## Key Features

- **Thread-based state management** for persistent conversation context
- **Tool integration** through C# method attributes
- **Multi-agent coordination** with specialized agent roles
- **Provider abstraction** supporting OpenAI, Azure OpenAI, and Ollama
- **Built-in telemetry and filters** for production deployments

## Getting Started

### Installation

```shell
dotnet add package Azure.AI.OpenAI --version 2.1.0
dotnet add package Azure.Identity --version 1.17.1
dotnet add package Microsoft.Extensions.AI.OpenAI --version 10.1.1-preview.1.25612.2
dotnet add package Microsoft.Agents.AI.OpenAI --version 1.0.0-preview.251219.1
```

### Basic Agent Example

```csharp
using Microsoft.Agents.AI;
using Microsoft.Extensions.AI;
using OpenAI;

AIAgent agent = new OpenAIClient("your-api-key")
  .GetChatClient("gpt-4o-mini")
  .AsIChatClient()
  .CreateAIAgent(instructions: "You help developers find accurate technical information.");

var response = await agent.RunAsync("What is C#?");
Console.WriteLine(response);
```

## Memory Management with Threads

Threads maintain conversation history automatically:

```csharp
AIAgent agent = new OpenAIClient("your-api-key")
  .GetChatClient("gpt-4o-mini")
  .AsIChatClient()
  .CreateAIAgent(instructions: "You are a helpful technical assistant.");

AgentThread thread = agent.GetNewThread();

// First turn
var response1 = await agent.RunAsync(
    "What's the difference between IAsyncEnumerable and Task<List>?",
    thread
);

// Second turn - context is remembered
var response2 = await agent.RunAsync(
    "Which one should I use for streaming large datasets?",
    thread
);
```

## Tool Integration

Agents can call C# methods as tools using attributes:

```csharp
using System.ComponentModel;
using Microsoft.Extensions.AI;

[Description("Gets the current weather for a location")]
async Task<string> GetWeather([Description("City name")] string city)
{
    await Task.Delay(500);
    return $"Sunny, 72°F in {city}";
}

var chatClient = new OpenAIClient("your-api-key")
  .GetChatClient("gpt-4o-mini")
  .AsIChatClient();

AIAgent weatherAgent = chatClient.CreateAIAgent(
    name: "WeatherAgent",
    instructions: "You provide weather information.",
    tools: [AIFunctionFactory.Create(GetWeather)]
);

var response = await weatherAgent.RunAsync("What's the weather in Seattle?");
```

## Multi-Agent Workflows

Coordinate specialized agents for complex tasks:

```csharp
var openAIClient = new OpenAIClient("your-api-key");

var researchAgent = openAIClient
    .GetChatClient("gpt-4o-mini")
    .AsIChatClient()
    .CreateAIAgent(instructions: "You find and verify technical information. Be concise.");

var writerAgent = openAIClient
    .GetChatClient("gpt-4o-mini")
    .AsIChatClient()
    .CreateAIAgent(instructions: "You write clear, concise documentation based on research.");

// Research phase
var researchThread = researchAgent.GetNewThread();
var researchResult = await researchAgent.RunAsync(
    "Provide key technical facts about: async/await in C#",
    researchThread
);

// Writing phase
var writerThread = writerAgent.GetNewThread();
var documentation = await writerAgent.RunAsync(
    $"Based on this research, write a brief explanation:\n\n{researchResult}",
    writerThread
);
```

## Agent Framework vs. Semantic Kernel

Agent Framework provides "agents that maintain context across numerous conversation turns" and handles "graph-based execution, conditional routing, persistent threads" natively, whereas Semantic Kernel requires custom plumbing for these features.

## Production Readiness

- **Status:** Public preview (GA expected early 2026)
- **Microsoft.Extensions.AI layer:** Generally available and supported
- **Agent Framework:** Preview with possible breaking changes
- **Recommendation:** Suitable for new projects with pinned package versions

## Key Considerations

**Breaking Changes:** Monitor GitHub releases during preview period

**Token Costs:** Long conversation threads accumulate tokens; implement summarization strategies

**Error Handling:** Tools must return agent-understandable responses on failure

**Testing:** Unit testing tools is straightforward; multi-turn conversation testing requires careful approach

## Comparison Matrix

| Feature | Agent Framework | Semantic Kernel |
|---------|-----------------|-----------------|
| Conversation Memory | Native | Requires custom implementation |
| Thread Management | Built-in | Not included |
| Multi-agent Coordination | Native | Requires orchestration |
| Tool Integration | Simple attributes | Function calling |

## Frequently Asked Questions

**Migration Path:** The framework supports migration from AutoGen and Semantic Kernel with minimal rewrites.

**Model Support:** Works with any provider implementing `IChatClient` from Microsoft.Extensions.AI.

**Preview Status:** Breaking changes possible; existing AutoGen/Semantic Kernel workloads supported through migration paths.

## Resources

- [Microsoft Agent Framework Documentation](https://learn.microsoft.com/en-us/agent-framework/overview/agent-framework-overview)
- [Microsoft.Extensions.AI Libraries](https://learn.microsoft.com/en-us/dotnet/ai/microsoft-extensions-ai)
- [GitHub Releases](https://github.com/microsoft/agent-framework/releases)
