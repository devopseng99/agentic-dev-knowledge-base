---
title: "Building AI agents with the Semantic Kernel SDK and Azure OpenAI"
url: "https://dev.to/willvelida/building-ai-agents-with-the-semantic-kernel-sdk-and-azure-openai-hbb"
author: "Will Velida"
category: "agent-sdks"
---

# Building AI agents with the Semantic Kernel SDK and Azure OpenAI
**Author:** Will Velida
**Published:** March 4, 2024

## Overview
Using Semantic Kernel SDK as an abstraction layer for integrating LLMs into C# applications, demonstrated through a medical clinic booking system.

## Key Concepts

### Kernel Setup
```csharp
var builder = Kernel.CreateBuilder();
builder.Services.AddAzureOpenAIChatCompletion(
    configuration["DEPLOYMENT_MODEL"],
    configuration["AZURE_OPEN_AI_ENDPOINT"],
    configuration["AZURE_OPEN_AI_KEY"]
);
var kernel = builder.Build();
```

### Invoking Prompts
```csharp
var result = await kernel.InvokePromptAsync(
    "Give me a list of leg exercises that I can do in the gym");
```

- Supports C#, Python, and Java
- Connectors bridge application code to AI models
- Plugins contain prompts and specialized functions
