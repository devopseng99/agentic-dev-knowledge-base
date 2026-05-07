---
title: "Azure AI Agent Service: Your First Production-Ready AI Agent in C#"
url: "https://dev.to/bspann/azure-ai-agent-service-your-first-production-ready-ai-agent-in-c-4pg4"
author: "Brian Spann"
category: "cloud-agents"
---

# Azure AI Agent Service: Your First Production-Ready AI Agent in C#
**Author:** Brian Spann
**Published:** February 17, 2026

## Overview
Part 1 of a 5-part series introducing Azure AI Agent Service as a managed platform for building and deploying AI agents. Covers core architecture (Agents, Threads, Messages, Runs), project setup, agent creation, conversation management, and streaming responses in C#.

## Key Concepts

### Project Client Setup

```csharp
using Azure;
using Azure.AI.Projects;
using Azure.Identity;

var endpoint = Environment.GetEnvironmentVariable("AZURE_AI_FOUNDRY_PROJECT_ENDPOINT")
    ?? throw new InvalidOperationException("Set AZURE_AI_FOUNDRY_PROJECT_ENDPOINT");

var credential = new DefaultAzureCredential();
var projectClient = new AIProjectClient(new Uri(endpoint), credential);
```

### Agent Creation

```csharp
var agentOptions = new CreateAgentOptions(
    model: "gpt-4o",
    name: "CustomerSupportAgent",
    instructions: "You are a helpful customer support agent..."
);

var agent = await projectClient.CreateAgentAsync(agentOptions);
```

### Thread and Message Management

```csharp
var thread = await projectClient.CreateThreadAsync();

await projectClient.CreateMessageAsync(
    thread.Value.Id,
    MessageRole.User,
    "Hi! I need help with my order ORD-12345"
);
```

### Async Run Execution

```csharp
var run = await projectClient.CreateRunAsync(thread.Value.Id, agent.Value.Id);

while (run.Value.Status == RunStatus.Queued || run.Value.Status == RunStatus.InProgress)
{
    await Task.Delay(500);
    run = await projectClient.GetRunAsync(thread.Value.Id, run.Value.Id);
}
```

### Streaming Responses

```csharp
await foreach (var update in projectClient.CreateRunStreamingAsync(
    thread.Value.Id,
    agent.Value.Id))
{
    switch (update)
    {
        case MessageContentUpdate contentUpdate:
            Console.Write(contentUpdate.Text);
            break;
    }
}
```

### Core Architecture
- **Agents**: AI entities with specific personas and tool access
- **Threads**: Conversation containers managing history
- **Messages**: Individual conversation turns
- **Runs**: Single execution instances with status tracking
