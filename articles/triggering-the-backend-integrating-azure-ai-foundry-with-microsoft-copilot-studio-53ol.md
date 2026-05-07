---
title: "Triggering the Backend - Integrating Azure AI Foundry with Microsoft Copilot Studio"
url: "https://dev.to/holgerimbery/triggering-the-backend-integrating-azure-ai-foundry-with-microsoft-copilot-studio-53ol"
author: "Holger Imbery"
category: "cloud-agents"
---

# Triggering the Backend - Integrating Azure AI Foundry with Microsoft Copilot Studio
**Author:** Holger Imbery
**Published:** September 27, 2025

## Overview
Two approaches for integrating Azure AI Foundry models into Microsoft Copilot Studio: Azure Functions with Agent Flows for complex scenarios, and direct model integration (BYOM) for simpler cases. Includes three use cases (email classification, visual issue detection, legal document summarization) with a full .NET 8 Azure Function implementation.

## Key Concepts

### Azure Function Implementation

```csharp
using System.Net;
using System.Net.Http.Headers;
using System.Text;
using System.Text.Json;
using Azure.Core;
using Azure.Identity;
using Microsoft.Azure.Functions.Worker;
using Microsoft.Azure.Functions.Worker.Http;
using Microsoft.Extensions.Logging;

public class InvokeModel
{
    private readonly HttpClient _http;
    private readonly string _endpoint = Environment.GetEnvironmentVariable("AI_ENDPOINT")!;
    private readonly string _modelOrDeployment = Environment.GetEnvironmentVariable("AI_MODEL_OR_DEPLOYMENT")!;

    public record ChatRequest(string prompt, string? system, float? temperature);
    public record ChatMessage(string role, string content);

    [Function("invoke-model")]
    public async Task<HttpResponseData> Run(
        [HttpTrigger(AuthorizationLevel.Function, "post", Route = "invoke")] HttpRequestData req)
    {
        var body = await JsonSerializer.DeserializeAsync<ChatRequest>(req.Body);

        var messages = new[]
        {
            new ChatMessage("system", body.system ?? "You are a helpful assistant."),
            new ChatMessage("user", body.prompt)
        };

        var payload = new { model = _modelOrDeployment, messages, temperature = body.temperature ?? 0.2f };

        var request = new HttpRequestMessage(HttpMethod.Post, BuildUrl());
        request.Content = new StringContent(
            JsonSerializer.Serialize(payload), Encoding.UTF8, "application/json");
        await AddAuthAsync(request);

        var res = await _http.SendAsync(request);
        var outResp = req.CreateResponse(res.StatusCode);
        await outResp.WriteStringAsync(await res.Content.ReadAsStringAsync());
        return outResp;
    }

    private async Task AddAuthAsync(HttpRequestMessage request)
    {
        if (!string.IsNullOrWhiteSpace(_apiKey))
        {
            request.Headers.Add("api-key", _apiKey);
            return;
        }
        var credential = new DefaultAzureCredential();
        var token = await credential.GetTokenAsync(
            new TokenRequestContext(new[] { "https://cognitiveservices.azure.com/.default" }));
        request.Headers.Authorization = new AuthenticationHeaderValue("Bearer", token.Token);
    }
}
```

### Request/Response Format

```json
{
  "prompt": "Summarize this text: ...",
  "system": "You are a concise enterprise assistant.",
  "temperature": 0.2
}
```

### Security
- Prefer Entra ID + Managed Identity from Function to model endpoint
- Avoid persisted API keys
- Use API Management for enterprise governance
