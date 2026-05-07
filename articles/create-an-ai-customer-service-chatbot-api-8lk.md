---
title: "Create an AI Customer Service Chatbot API"
url: "https://dev.to/makram_eltimani/create-an-ai-customer-service-chatbot-api-8lk"
author: "Makram El Timani"
category: "ai-assistant-api"
---

# Create an AI Customer Service Chatbot API

**Author:** Makram El Timani
**Published:** October 2, 2024

## Overview
Tutorial for building a customer service chatbot API using OpenAI's Assistant API and .NET. The implementation follows a three-endpoint pattern: opening a chat connection, sending user messages, and closing connections.

## Code Examples

### Service Initialization (C#)

```csharp
builder.Services.AddOpenAiClient(opt =>
{
    opt.ApiKey = builder.Configuration.GetValue<string>("OpenAiClientSecrets:ApiKey");
    opt.ApiUrl = builder.Configuration.GetValue<string>("OpenAiClientSecrets:ApiUrl");
});
```

### Opening Chat Connection (C#)

```csharp
public async Task<string> OpenChatConnection()
{
    var thread = await _openAiClient.Beta.Threads.Create(new CreateThread());
    return thread.Id!;
}
```

### Sending User Message (C#)

```csharp
public async Task<AssistantResponse> SendUserMessage(string threadId, string messageText)
{
    var message = await _openAiClient.Beta.Threads.Messages.CreateMessage(new CreateMessage
    {
        ThreadId = threadId!,
        Content = messageText,
        Role = "user",
    });

    var run = await _openAiClient.Beta.Threads.Runs.Create(new CreateRun
    {
        AssistantId = _assistant!.Id!,
        ThreadId = threadId,
    });

    while (run!.Status != Repository.OpenAi.Models.RunStatus.completed)
    {
        await Task.Delay(500);
        run = await _openAiClient.Beta.Threads.Runs.Retrieve(threadId!, run.Id!);
    }

    var responseMessage = await _openAiClient.Beta.Threads.Messages.List(threadId!, run.Id);
    string content = responseMessage.Data.First().Content[0].Text!.Value!;
    AssistantResponse assistantResponse = JsonSerializer.Deserialize<AssistantResponse>(content)!;
    return assistantResponse;
}
```

### Response Model (C#)

```csharp
public class AssistantResponse
{
    [JsonPropertyName("responseMessage")]
    public string ResponseMessage { get; set; } = string.Empty;

    [JsonPropertyName("foundResponse")]
    public bool FoundResponse { get; set; }

    [JsonPropertyName("customerAnxiety")]
    public int CustomerAnxiety { get; set; }
}
```
