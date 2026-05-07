---
title: "Building a C# Agent with Microsoft Agent Framework and Ollama"
url: "https://dev.to/bspann/building-a-c-agent-with-microsoft-agent-framework-and-ollama-26m4"
author: "Brian Spann"
category: "cloud-agents"
---

# Building a C# Agent with Microsoft Agent Framework and Ollama
**Author:** Brian Spann
**Published:** April 21, 2026

## Overview
Part 3 of "Running LLMs & Agents on Azure Container Apps" series. Covers building agents with Microsoft Agent Framework 1.0 (successor to Semantic Kernel + AutoGen), using Ollama for local inference, swappable backends, multi-turn conversations, function calling, smart routing, and a complete document triage agent example.

## Key Concepts

### Project Setup

```bash
dotnet new console -n OllamaAgent
cd OllamaAgent
dotnet add package Microsoft.Agents.AI --prerelease
dotnet add package Microsoft.Extensions.AI.Ollama --prerelease
```

### First Agent (3 Lines)

```csharp
using System;
using Microsoft.Agents.AI;
using Microsoft.Extensions.AI;

var chatClient = new OllamaChatClient(
    new Uri("https://your-ollama.azurecontainerapps.io"),
    modelId: "llama3:8b");

AIAgent agent = chatClient.AsAIAgent(
    instructions: "You are a helpful assistant running on self-hosted infrastructure.");

Console.WriteLine(await agent.RunAsync("What is Azure Container Apps?"));
```

### Swappable Backends

```csharp
AIAgent CreateAgent(bool useLocal = false)
{
    IChatClient client;

    if (useLocal)
    {
        client = new OllamaChatClient(
            new Uri(Environment.GetEnvironmentVariable("OLLAMA_URL")!),
            modelId: "llama3:8b");
    }
    else
    {
        client = new AzureOpenAIClient(
            new Uri(Environment.GetEnvironmentVariable("AZURE_OPENAI_ENDPOINT")!),
            new AzureKeyCredential(
                Environment.GetEnvironmentVariable("AZURE_OPENAI_KEY")!))
            .GetChatClient("gpt-4");
    }

    return client.AsAIAgent(
        instructions: "You are a helpful technical assistant.");
}
```

### Multi-Turn Conversations with Sessions

```csharp
var agent = chatClient.AsAIAgent(
    instructions: "You are a technical advisor for Azure deployments.");

var session = await agent.CreateSessionAsync();

var response1 = await agent.RunAsync(
    "I need to deploy a containerized ML model on Azure.", session);

var response2 = await agent.RunAsync(
    "What about GPU support?", session);
```

### Adding Tools (No Attributes Required)

```csharp
using System.ComponentModel;
using Microsoft.Agents.AI;
using Microsoft.Extensions.AI;

[Description("Gets the current weather for a location")]
static string GetWeather(string location)
{
    return $"Weather in {location}: 72F, Sunny";
}

[Description("Looks up an Azure resource's current status")]
static string CheckResourceStatus(string resourceName)
{
    return $"{resourceName}: Running, 0 errors in last 24h";
}

var agent = chatClient.AsAIAgent(
    instructions: "You are an operations assistant.",
    tools: [
        AIFunctionFactory.Create(GetWeather),
        AIFunctionFactory.Create(CheckResourceStatus)
    ]);
```

### Smart Routing Pattern

```csharp
public class SmartRouter
{
    private readonly AIAgent _localAgent;
    private readonly AIAgent _cloudAgent;

    public Task<AgentResponse> RouteAsync(string input, string taskType)
    {
        var agent = taskType switch
        {
            "classify" or "extract" or "summarize" => _localAgent,
            "reason" or "analyze" or "generate" => _cloudAgent,
            _ => _localAgent
        };
        return agent.RunAsync(input);
    }
}
```

### Document Triage Agent Example

```csharp
[Description("Classifies a document as: invoice, contract, support-ticket, or other")]
static string ClassifyDocument(string content) => "invoice";

[Description("Extracts vendor name, amount, and due date from an invoice")]
static string ExtractInvoiceFields(string content)
    => """{"vendor": "Contoso", "amount": 4250.00, "due": "2026-05-15"}""";

[Description("Routes a document to a review queue based on category and priority")]
static string RouteForReview(string category, string priority)
    => $"Routed {category} to {priority}-priority queue";

var triageAgent = chatClient.AsAIAgent(
    instructions: """
        You are a document triage agent. When given a document:
        1. Classify its type
        2. If it's an invoice, extract the key fields
        3. Route it for review based on category and urgency
        """,
    tools: [
        AIFunctionFactory.Create(ClassifyDocument),
        AIFunctionFactory.Create(ExtractInvoiceFields),
        AIFunctionFactory.Create(RouteForReview)
    ]);
```

### Semantic Kernel vs Agent Framework Quick Reference

| Semantic Kernel | Agent Framework |
|---|---|
| `Kernel.CreateBuilder()` | `new OllamaChatClient(...)` |
| `[KernelFunction]` attribute | `AIFunctionFactory.Create(method)` |
| `builder.Plugins.AddFromType<T>()` | `tools: [...]` parameter |
| `FunctionChoiceBehavior.Auto()` | Automatic |
| `ChatHistory` | `AgentSession` |
