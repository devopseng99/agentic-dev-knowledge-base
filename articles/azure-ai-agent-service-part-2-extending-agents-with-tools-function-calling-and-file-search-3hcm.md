---
title: "Azure AI Agent Service Part 2: Extending Agents with Tools, Function Calling, and File Search"
url: "https://dev.to/bspann/azure-ai-agent-service-part-2-extending-agents-with-tools-function-calling-and-file-search-3hcm"
author: "Brian Spann"
category: "cloud-agents"
---

# Azure AI Agent Service Part 2: Extending Agents with Tools, Function Calling, and File Search
**Author:** Brian Spann
**Published:** February 18, 2026

## Overview
Part 2 of a 5-part series on Azure AI Agent Service covering function calling, file search (built-in RAG), code interpreter, and combining multiple tools for complex agent workflows in C#.

## Key Concepts

### Defining a Function Tool

```csharp
using Azure.AI.Projects;

var getWeatherTool = new FunctionToolDefinition(
    name: "get_current_weather",
    description: "Gets the current weather for a specified city",
    parameters: BinaryData.FromObjectAsJson(new
    {
        type = "object",
        properties = new
        {
            city = new
            {
                type = "string",
                description = "The city name, e.g., 'Seattle' or 'London'"
            },
            units = new
            {
                type = "string",
                @enum = new[] { "celsius", "fahrenheit" },
                description = "Temperature units"
            }
        },
        required = new[] { "city" }
    })
);
```

### Creating an Agent with Tools

```csharp
using Azure.AI.Projects;
using Azure.Identity;

var connectionString = Environment.GetEnvironmentVariable("AZURE_AI_PROJECT_CONNECTION");
var client = new AgentsClient(connectionString, new DefaultAzureCredential());

var agent = await client.CreateAgentAsync(
    model: "gpt-4o",
    name: "WeatherAssistant",
    instructions: "You are a helpful weather assistant. Use the get_current_weather " +
                  "function when users ask about weather conditions.",
    tools: new List<ToolDefinition> { getWeatherTool }
);
```

### Handling Function Calls

```csharp
var thread = await client.CreateThreadAsync();
await client.CreateMessageAsync(
    thread.Value.Id,
    MessageRole.User,
    "What's the weather like in Seattle right now?"
);

var run = await client.CreateRunAsync(thread.Value.Id, agent.Value.Id);

while (run.Value.Status == RunStatus.Queued ||
       run.Value.Status == RunStatus.InProgress ||
       run.Value.Status == RunStatus.RequiresAction)
{
    await Task.Delay(500);
    run = await client.GetRunAsync(thread.Value.Id, run.Value.Id);

    if (run.Value.Status == RunStatus.RequiresAction)
    {
        var toolCalls = run.Value.RequiredAction.SubmitToolOutputs.ToolCalls;
        var toolOutputs = new List<ToolOutput>();

        foreach (var toolCall in toolCalls)
        {
            if (toolCall is RequiredFunctionToolCall functionCall)
            {
                var result = await ExecuteFunction(
                    functionCall.Name,
                    functionCall.Arguments
                );
                toolOutputs.Add(new ToolOutput(functionCall.Id, result));
            }
        }

        run = await client.SubmitToolOutputsToRunAsync(
            thread.Value.Id,
            run.Value.Id,
            toolOutputs
        );
    }
}
```

### File Search (Built-in RAG)

```csharp
var vectorStore = await client.CreateVectorStoreAsync(
    name: "ProductDocs",
    expiresAfter: new VectorStoreExpirationPolicy(
        anchor: VectorStoreExpirationPolicyAnchor.LastActiveAt,
        days: 30
    )
);

foreach (var path in filePaths)
{
    using var stream = File.OpenRead(path);
    var file = await client.UploadFileAsync(
        stream,
        AgentFilePurpose.Agents,
        Path.GetFileName(path)
    );
    await client.CreateVectorStoreFileAsync(
        vectorStore.Value.Id,
        file.Value.Id
    );
}
```

### Combining Tools for Complex Workflows

```csharp
var agent = await client.CreateAgentAsync(
    model: "gpt-4o",
    name: "CustomerSupportAgent",
    instructions: """
        You are a customer support agent with access to:
        - Product documentation (use file search for how-to questions)
        - Customer account system (to look up account details)
        - Service status (to check for outages)
        - Ticket system (to escalate complex issues)
        """,
    tools: tools,
    toolResources: new ToolResources
    {
        FileSearch = new FileSearchToolResource
        {
            VectorStoreIds = { vectorStore.Value.Id }
        }
    }
);
```

### Best Practices
1. Write clear, specific function descriptions
2. Return JSON from functions for structured agent responses
3. Handle errors gracefully with suggestions
4. Keep functions single-purpose
5. Include relevant context in results
