---
title: "Using Azure OpenAI Service to generate images with DALL-E in .NET"
url: "https://dev.to/esdanielgomez/using-azure-openai-service-to-generate-images-with-dall-e-in-net-49n9"
author: "Daniel Gomez"
category: "ai-media-generation"
---
# Using Azure OpenAI Service to generate images with DALL-E in .NET
**Author:** Daniel Gomez  **Published:** February 1, 2024

## Overview
This tutorial demonstrates how to integrate Azure OpenAI's DALL-E image generation capabilities into C# applications using the Azure OpenAI client library.

## Key Concepts

- Azure OpenAI Service integration with .NET
- DALL-E image generation from text prompts
- Required Azure credentials (API key, endpoint, deployment name)
- ImageGenerationOptions configuration
- Asynchronous API calls with the OpenAI client

```csharp
using Azure;
using Azure.AI.OpenAI;

namespace GenerativeAI;

public class AzureOpenAIDALLE
{
    const string key = "YOUR_KEY";
    const string endpoint = "https://YOUR_RESOURCE_NAME.openai.azure.com/";
    const string deploymentOrModelName = "YOUR_DEPLOYMENT";

    public async Task<string> GetContent(string prompt)
    {
        var client = new OpenAIClient(new Uri(endpoint), new AzureKeyCredential(key));
        var imageGenerationOptions = new ImageGenerationOptions
        {
            Prompt = prompt,
            DeploymentName = deploymentOrModelName,
            Size = new ImageSize("1024x1024"),
            ImageCount = 1
        };
        var response = await client.GetImageGenerationsAsync(imageGenerationOptions);
        return response.Value.Data[0].Url.AbsoluteUri;
    }
}
```

```csharp
var dalle = new AzureOpenAIDALLE();
var dallePrompt = "Generate a featured image about Thanksgiving dishes";
Console.WriteLine($"{await dalle.GetContent(dallePrompt)}");
```

NuGet Package: `Azure.AI.OpenAI`
