---
title: "Building AI agents with the Semantic Kernel SDK and Azure OpenAI"
url: "https://dev.to/willvelida/building-ai-agents-with-the-semantic-kernel-sdk-and-azure-openai-hbb"
author: "Will Velida"
category: "semantic-kernel"
---

# Building AI agents with the Semantic Kernel SDK and Azure OpenAI

**Author:** Will Velida
**Published:** March 4, 2024

---

## Overview

The Semantic Kernel SDK is an open-source framework enabling developers to integrate large language models (LLMs) into applications. The article demonstrates how to build AI agents using this SDK with Azure OpenAI.

## Key Concepts

### What is Semantic Kernel?

The SDK allows construction of custom AI agents—programs achieving predetermined goals with minimal human intervention. Semantic Kernel acts as an orchestration layer between application code and LLMs, abstracting away service-specific API details.

**Core Components:**
- **AI Orchestration Layer:** Integrates AI models and plugins
- **Connectors:** Bridge application code with AI models
- **Plugins:** Consist of prompts and specialized task functions

### Why Use It?

The framework addresses complexity in AI integration by "offering a simplified integration of AI capabilities into existing applications." It supports Azure OpenAI, OpenAI, and Hugging Face models across C#, Python, and Java.

---

## Building a Basic Application

### Prerequisites
- .NET 8 SDK
- Visual Studio Code
- Azure OpenAI deployment

### Setup Steps

**Create console project:**
```bash
dotnet new console -o MyFirstSKProject
cd MyFirstSKProject
```

**Install dependencies:**
```bash
dotnet add package Microsoft.SemanticKernel
dotnet add package Microsoft.Extensions.Configuration --version 8.0.0
```

### Implementation

**Configuration (appsettings.json):**
```json
{
    "DEPLOYMENT_MODEL":"",
    "AZURE_OPEN_AI_ENDPOINT":"",
    "AZURE_OPEN_AI_KEY":""
}
```

**Kernel initialization:**
```csharp
using Microsoft.SemanticKernel;
using Microsoft.Extensions.Configuration;

var configuration = new ConfigurationBuilder()
    .AddJsonFile("appsettings.json")
    .Build();

var builder = Kernel.CreateBuilder();

builder.Services.AddAzureOpenAIChatCompletion(
    configuration["DEPLOYMENT_MODEL"],
    configuration["AZURE_OPEN_AI_ENDPOINT"],
    configuration["AZURE_OPEN_AI_KEY"]
);

var kernel = builder.Build();
```

**Test invocation:**
```csharp
var result = await kernel.InvokePromptAsync(
    "Give me a list of leg exercises that I can do in the gym"
);

Console.WriteLine(result);
```

---

## Key Takeaway

Semantic Kernel simplifies AI integration by providing abstraction over model-specific APIs, lowering the barrier for developers to incorporate LLMs into their applications.

**Resources:**
- [Semantic Kernel Overview](https://learn.microsoft.com/en-us/semantic-kernel/overview/)
- [GitHub Repository](https://github.com/microsoft/semantic-kernel)
