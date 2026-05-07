---
title: "Azure OpenAI Error Handling in Semantic Kernel"
url: "https://dev.to/stormhub/azure-openai-error-handling-in-semantic-kernel-21j5"
author: "Johnny Z"
category: "agent-error-handling-retry"
---

# Azure OpenAI Error Handling in Semantic Kernel

**Author:** Johnny Z
**Published:** January 8, 2025

## Overview

Explores HTTP error handling approaches for Azure OpenAI with Microsoft's Semantic Kernel, particularly addressing rate-limit errors (429 responses). Three approaches with increasing control.

## Key Concepts

### Default Approach (Built-in Retry)

```csharp
var builder = Kernel.CreateBuilder();
builder.AddAzureOpenAIChatCompletion(
    deploymentName: "gpt-4o-2024-08-06",
    endpoint: "https://resource-name.openai.azure.com",
    apiKey: "api-key");
```

Includes built-in retry policy with 3 automatic attempts, exponential backoff, and support for `retry-after` HTTP header.

### HttpClient Approach (Custom Retry)

```csharp
var factory = provider.GetRequiredService<IHttpClientFactory>();
var httpClient = factory.CreateClient("azure:gpt-4o");

var builder = Kernel.CreateBuilder();
builder.AddAzureOpenAIChatCompletion(
    deploymentName: "gpt-4o-2024-08-06",
    endpoint: "https://resource-name.openai.azure.com",
    apiKey: "api-key",
    httpClient: httpClient);
```

Providing an HttpClient disables default retries, allowing custom logic:

```csharp
services.AddHttpClient("azure:gpt-4o")
    .AddStandardResilienceHandler()
    .Configure(options =>
    {
        options.Retry.MaxRetryAttempts = 5;
    });
```

### AzureOpenAIClient Approach (Maximum Control)

```csharp
var clientOptions = new AzureOpenAIClientOptions
{
    Transport = new HttpClientPipelineTransport(httpClient),
    RetryPolicy = new ClientRetryPolicy(maxRetries: 5)
};
```

### Key Recommendation
The default setup may not suit scenarios with frequent token limit issues. The AzureOpenAIClient approach provides maximum control when you already register that client.
