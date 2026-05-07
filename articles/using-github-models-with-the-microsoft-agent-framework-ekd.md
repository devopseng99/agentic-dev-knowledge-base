---
title: "Using GitHub Models with the Microsoft Agent Framework"
url: "https://dev.to/willvelida/using-github-models-with-the-microsoft-agent-framework-ekd"
author: "Will Velida"
category: "ai-agents"
---

# Using GitHub Models with the Microsoft Agent Framework

**Author:** Will Velida
**Published:** January 9, 2026

## Overview

This article demonstrates how to build AI agents using the Microsoft Agent Framework with GitHub Models, avoiding costs associated with Azure Foundry during development and testing.

## Key Concepts

### Microsoft Agent Framework
An open-source toolkit for constructing AI agents and agentic workflows in Python and C#. It extends both Semantic Kernel and AutoGen, unifying agent development approaches. The framework supports individual agents that process inputs and call tools, plus workflows connecting multiple agents for complex tasks.

### GitHub Models
A GitHub workspace offering free LLM access for testing and development. It provides prompt refinement tools and output evaluation capabilities. "Essentially, if you don't want to pay money just to test which LLM your agent should use, GitHub Models is the best way to do that," though usage limits apply.

## Implementation Steps

### 1. Generate a PAT Token
Navigate to the GitHub Models marketplace, select a model (e.g., gpt-5-mini), and create a Personal Access Token with read-only permissions for the Models scope.

### 2. Configure the Project
Initialize user secrets in a C# console application:
```shell
dotnet user-secrets init
dotnet user-secrets set "GH_PAT" "<your-token>"
```

### 3. Install Dependencies
```shell
dotnet add package Microsoft.Agents.AI.OpenAI --prerelease
dotnet add package OpenTelemetry
dotnet add package OpenTelemetry.Exporter.Console
```

### 4. Set Up Configuration
Load user secrets and configure the OpenAI client pointing to the GitHub Models endpoint:
```csharp
var endpoint = new Uri("https://models.github.ai/inference");
var model = "openai/gpt-5-mini";
var githubPAT = config["GH_PAT"];
```

### 5. Create Agent with OpenTelemetry
Instantiate the agent with OpenTelemetry instrumentation for logging and monitoring interactions.

### 6. Manage Conversation State
Agents are stateless, so conversation threads must be explicitly created and passed:
```csharp
AgentThread agentThread = agent.GetNewThread();
Console.WriteLine(await agent.RunAsync("Your prompt", agentThread));
```

### 7. Persist and Resume Conversations
Serialize threads to JSON for storage:
```csharp
string serialized = agentThread.Serialize(JsonSerializerOptions.Web).GetRawText();
await File.WriteAllTextAsync(filePath, serialized);
```

Reload conversations using the same agent type:
```csharp
AgentThread resumedThread = agent.DeserializeThread(reloadedData, JsonSerializerOptions.Web);
```

## Telemetry Output

The framework exports detailed OpenTelemetry traces including model information, token usage, response IDs, and operation metadata to configured exporters.

## Important Notes

- The Microsoft Agent Framework was in preview as of January 2026; API changes should be anticipated
- Always use the same agent type when deserializing threads
- GitHub Models have usage limits despite being free

## Conclusion

GitHub Models provides a cost-effective development environment for Agent Framework applications, eliminating unnecessary Azure expenditures during the testing phase.
