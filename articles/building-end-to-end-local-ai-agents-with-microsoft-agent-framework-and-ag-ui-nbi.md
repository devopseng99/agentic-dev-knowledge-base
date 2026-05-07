---
title: "Building End-to-End Local AI Agents with Microsoft Agent Framework and AG-UI"
url: "https://dev.to/stormhub/building-end-to-end-local-ai-agents-with-microsoft-agent-framework-and-ag-ui-nbi"
author: "Johnny Z"
category: "agent orchestration framework"
---

# Building End-to-End Local AI Agents with Microsoft Agent Framework and AG-UI

**Author:** Johnny Z
**Published:** November 23, 2025

## Overview
Demonstrates using the Microsoft Agent Framework with the AG-UI Protocol to build local AI agents. The AG-UI Protocol standardizes agent-to-user interaction, and the article shows how to connect an Ollama-backed agent through dependency injection in .NET.

## Key Concepts

### Service Configuration

```csharp
var builder = WebApplication.CreateBuilder(args);

// 1. Register the Ollama Client
builder.Services.AddTransient<IChatClient>(provider =>
{
    var factory = provider.GetRequiredService<IHttpClientFactory>();
    return new OllamaApiClient(factory.CreateClient("OllamaClient"), "phi4");
});

// 2. Register the AI Agent
builder.Services.AddKeyedTransient<ChatClientAgent>(
    "local-ollama-agent",
    (provider, key) =>
    {
        var options = new ChatClientAgentOptions
        {
            Id = key.ToString(),
            Name = "Local Assistant",
            Description = "An AI agent running on local Ollama.",
            ChatOptions = new ChatOptions { Temperature = 0 }
        };

        return provider.GetRequiredService<IChatClient>()
            .CreateAIAgent(options, provider.GetRequiredService<ILoggerFactory>());
    });
```

### Expose the AG-UI Endpoint

```csharp
var agent = app.Services.GetRequiredKeyedService<ChatClientAgent>("local-ollama-agent");

// Expose the agent on the root path
app.MapAGUI("/", agent);
```

### Connect a Client

```csharp
var chatClient = new AGUIChatClient(
    httpClient,
    "http://localhost:5000",
    provider.GetRequiredService<ILoggerFactory>());

var clientAgent = chatClient.CreateAIAgent(
    name: "local-client",
    description: "AG-UI Client Agent");
```

### Implementation Note
The AG-UI protocol mandates that all messages contain a messageId property. Native Ollama responses do not currently provide this.
