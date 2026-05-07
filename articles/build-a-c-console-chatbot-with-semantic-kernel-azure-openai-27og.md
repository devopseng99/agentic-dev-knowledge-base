---
title: "Build a C# Console Chatbot with Semantic Kernel & Azure OpenAI"
url: "https://dev.to/lovelacecoding/build-a-c-console-chatbot-with-semantic-kernel-azure-openai-27og"
author: "Lou Creemers"
category: "cloud-agents"
---

# Build a C# Console Chatbot with Semantic Kernel & Azure OpenAI
**Author:** Lou Creemers
**Published:** July 15, 2025

## Overview
Step-by-step guide for building a .NET console chatbot with Semantic Kernel and Azure OpenAI. Covers project setup, User Secrets for API key management, streaming GPT-4o-Mini responses, and common error troubleshooting.

## Key Concepts

### Project Setup

```bash
mkdir SKConsole && cd SKConsole
dotnet new console -n SKConsole
cd SKConsole
dotnet add package Microsoft.SemanticKernel
dotnet add package Microsoft.SemanticKernel.AzureOpenAI
dotnet add package Microsoft.Extensions.Configuration
dotnet add package Microsoft.Extensions.Configuration.UserSecrets
```

### User Secrets

```bash
dotnet user-secrets init
dotnet user-secrets set OPENAI_API_KEY "<your-key>"
```

### Complete Program

```csharp
using Microsoft.SemanticKernel;
using Microsoft.SemanticKernel.ChatCompletion;
using Microsoft.Extensions.Configuration;

var configuration = new ConfigurationBuilder()
    .AddUserSecrets<Program>()
    .Build();

var kernel = Kernel.CreateBuilder()
    .AddAzureOpenAIChatCompletion(
        deploymentName: "o4-mini",
        endpoint: "https://myfoundryresource.openai.azure.com/",
        apiKey: configuration["OPENAI_API_KEY"]
    )
    .Build();

var chat = kernel.GetRequiredService<IChatCompletionService>();

const string systemPrompt = "You are a concise assistant.";
Console.WriteLine("Ask me anything (press Enter on empty line to quit)");

while (true)
{
    string? user = Console.ReadLine();
    if (string.IsNullOrWhiteSpace(user)) break;

    var turn = new ChatHistory();
    turn.AddSystemMessage(systemPrompt);
    turn.AddUserMessage(user);

    await foreach (var chunk in chat.GetStreamingChatMessageContentsAsync(turn))
        Console.Write(chunk.Content);

    Console.WriteLine();
}
```

### Common Errors
- **404 Resource not found**: Verify deployment name and endpoint
- **400 OperationNotSupported**: Deploy as Global Standard, not Batch
- **Null API key**: Ensure AddUserSecrets executes before key access
