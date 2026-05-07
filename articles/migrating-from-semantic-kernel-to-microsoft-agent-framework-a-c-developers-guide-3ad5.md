---
title: "Migrating from Semantic Kernel to Microsoft Agent Framework: A C# Developer's Guide"
url: "https://dev.to/bspann/migrating-from-semantic-kernel-to-microsoft-agent-framework-a-c-developers-guide-3ad5"
author: "Brian Spann"
category: "semantic-kernel"
---

# Migrating from Semantic Kernel to Microsoft Agent Framework: A C# Developer's Guide

**Author:** Brian Spann
**Published:** March 2, 2026
**Last Updated:** March 26, 2026
**Tags:** #csharp #dotnet #ai #azure

---

## Overview

Microsoft announced that the Microsoft Agent Framework has reached Release Candidate status at .NET Conf 2025. This consolidation merges Semantic Kernel and AutoGen into a unified framework for building AI agents in .NET.

---

## Key Changes and Rationale

### What Changed

Microsoft previously maintained two separate frameworks:
- **Semantic Kernel** — orchestration, plugins, and enterprise integration
- **AutoGen** — multi-agent conversations and research

The new Agent Framework unifies these by providing:
- Simple agent creation with minimal code
- Type-safe function tools
- Multi-agent workflows (sequential, concurrent, handoff, group chat)
- Built-in streaming and human-in-the-loop support
- Multi-provider support (Azure OpenAI, OpenAI, Anthropic, Ollama)
- Interoperability standards (A2A, MCP, AG-UI)

---

## Before and After: Creating an Agent

### Semantic Kernel (Legacy Approach)

```csharp
using Microsoft.SemanticKernel;
using Microsoft.SemanticKernel.ChatCompletion;

var builder = Kernel.CreateBuilder();
builder.AddAzureOpenAIChatCompletion(
    deploymentName: "gpt-4",
    endpoint: "https://your-resource.openai.azure.com/",
    apiKey: Environment.GetEnvironmentVariable("AZURE_OPENAI_KEY")!
);
var kernel = builder.Build();

var chat = kernel.GetRequiredService<IChatCompletionService>();
var history = new ChatHistory();
history.AddSystemMessage("You are a helpful assistant.");
history.AddUserMessage("Write a haiku about cloud computing.");

var response = await chat.GetChatMessageContentsAsync(history);
Console.WriteLine(response[0].Content);
```

### Microsoft Agent Framework (New Approach)

```csharp
using Azure.Identity;
using Microsoft.Agents.AI;
using OpenAI;

var agent = new OpenAIClient(
    new BearerTokenPolicy(new AzureCliCredential(), "https://ai.azure.com/.default"),
    new OpenAIClientOptions { Endpoint = new Uri("https://your-resource.openai.azure.com/openai/v1") })
    .GetResponsesClient("gpt-4.1")
    .AsAIAgent(
        name: "CloudPoet",
        instructions: "You are a helpful assistant."
    );

Console.WriteLine(await agent.RunAsync("Write a haiku about cloud computing."));
```

**Key Difference:** "The agent is treated as a first-class concept" rather than wiring services and kernels.

---

## Migrating Function Tools (Plugins)

### Semantic Kernel Plugin Style

```csharp
public class WeatherPlugin
{
    [KernelFunction("get_weather")]
    [Description("Gets the current weather for a location")]
    public string GetWeather(
        [Description("The city name")] string city)
    {
        return $"The weather in {city} is sunny, 72°F";
    }
}

// Registration
kernel.Plugins.AddFromType<WeatherPlugin>();
```

### Agent Framework Function Tool Style

```csharp
using Microsoft.Agents.AI;
using System.ComponentModel;

var weatherTool = AIFunction.Create(
    [Description("Gets the current weather for a location")]
    (string city) => $"The weather in {city} is sunny, 72°F",
    name: "get_weather"
);

var agent = chatClient.AsAIAgent(
    name: "WeatherBot",
    instructions: "You help users check the weather.",
    tools: [weatherTool]
);
```

---

## Multi-Agent Orchestration

### Sequential Workflow Example

```csharp
using Microsoft.Agents.AI;
using Microsoft.Agents.AI.Workflows;

// Create specialized agents
ChatClientAgent writer = new(chatClient,
    "You are a concise copywriter. Create engaging marketing copy.",
    "writer");

ChatClientAgent reviewer = new(chatClient,
    "You are a thorough editor. Review the copy and suggest improvements.",
    "reviewer");

ChatClientAgent finalizer = new(chatClient,
    "You incorporate feedback and produce the final polished copy.",
    "finalizer");

// Build sequential workflow: writer -> reviewer -> finalizer
Workflow workflow = AgentWorkflowBuilder.BuildSequential(writer, reviewer, finalizer);

// Execute with streaming
List<ChatMessage> messages = [new(ChatRole.User, "Write a tagline for a cybersecurity startup.")];

await using StreamingRun run = await InProcessExecution.RunStreamingAsync(workflow, messages);
await run.TrySendMessageAsync(new TurnToken(emitEvents: true));

await foreach (WorkflowEvent evt in run.WatchStreamAsync())
{
    if (evt is AgentResponseUpdateEvent e)
    {
        Console.Write(e.Update.Text);
    }
}
```

### Concurrent Workflows

```csharp
// Research agents that work simultaneously
ChatClientAgent marketResearcher = new(chatClient,
    "Research market trends and competitor analysis.",
    "market_researcher");

ChatClientAgent techAnalyst = new(chatClient,
    "Analyze technical feasibility and implementation costs.",
    "tech_analyst");

ChatClientAgent riskAssessor = new(chatClient,
    "Identify potential risks and mitigation strategies.",
    "risk_assessor");

// All three run concurrently, results aggregated
Workflow parallelWorkflow = AgentWorkflowBuilder.BuildConcurrent(
    marketResearcher,
    techAnalyst,
    riskAssessor
);
```

### Handoff Patterns

```csharp
Workflow handoffWorkflow = AgentWorkflowBuilder.BuildHandoff(
    new HandoffConfig
    {
        Agents = [salesAgent, supportAgent, billingAgent],
        Router = routerAgent,  // Decides who handles each message
        AllowBacktrack = true
    }
);
```

---

## What About Planners?

| Semantic Kernel Component | Agent Framework Equivalent |
|---|---|
| FunctionCallingStepwisePlanner | Agent with tools + reasoning model |
| HandlebarsPlanner | Sequential workflows with templating |
| Custom planners | Graph-based workflow builder |

Modern reasoning models handle planning natively, reducing the need for explicit planners.

---

## Model Context Protocol (MCP) Integration

Agent Framework natively supports MCP, enabling agents to connect to any MCP-compatible tool server:

```csharp
var agent = chatClient.AsAIAgent(
    name: "DevAgent",
    instructions: "You help developers with their codebase.",
    mcpServers: [
        new McpServerConfig("filesystem", "uvx mcp-server-filesystem /workspace"),
        new McpServerConfig("github", "uvx mcp-server-github")
    ]
);
```

Agents automatically gain access to all exposed tools without additional plugin code.

---

## Migration Checklist

### 1. Update NuGet Packages

```bash
# Remove old packages
dotnet remove package Microsoft.SemanticKernel

# Add new packages
dotnet add package Microsoft.Agents.AI.OpenAI --prerelease
dotnet add package Microsoft.Agents.AI.Workflows --prerelease
dotnet add package Azure.Identity
```

### 2. Replace Kernel with Agents
- `Kernel` -> `IAIAgent` implementations
- `KernelFunction` -> `AIFunction`
- `IChatCompletionService` -> agent's `RunAsync()`

### 3. Convert Plugins to Tools
- `[KernelFunction]` methods -> `AIFunction.Create()` lambdas
- Plugins become tool collections passed to agents

### 4. Update Orchestration
- `AgentGroupChat` -> `AgentWorkflowBuilder` workflows
- Selection strategies -> `BuildHandoff()` with router
- Termination conditions -> workflow completion handlers

### 5. Test Incrementally
Test each migrated component before moving on.

---

## Should You Migrate Now?

**Migrate immediately if:**
- Starting a new project
- Need multi-agent orchestration
- Want MCP/A2A interoperability
- Hitting Semantic Kernel's complexity limits

**Wait if:**
- Have stable production code with no new requirements
- Need features not yet in the RC
- Team needs time for learning curve

The RC is production-stable. GA expected in Q1 2026.

---

## Key Takeaways

1. Agent Framework consolidates Semantic Kernel and AutoGen into a unified platform
2. The new API treats agents as first-class constructs, simplifying common patterns
3. Multi-agent workflows are significantly more straightforward with built-in builders
4. MCP integration opens doors to ecosystem tool connectivity
5. Migration is feasible incrementally; modern reasoning models reduce planner complexity

---

## Resources

- [Microsoft Agent Framework Documentation](https://learn.microsoft.com/en-us/agent-framework/)
- [Migration Guide from Semantic Kernel](https://learn.microsoft.com/en-us/agent-framework/migration-guide/from-semantic-kernel)
- [GitHub Repository](https://github.com/microsoft/agent-framework)
- [NuGet Packages](https://www.nuget.org/packages/Microsoft.Agents.AI/)
