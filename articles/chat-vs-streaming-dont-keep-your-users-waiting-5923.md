---
title: "Chat vs. Streaming: Don't Keep Your Users Waiting"
url: "https://dev.to/lukaswalter/chat-vs-streaming-dont-keep-your-users-waiting-5923"
author: "Lukas Walter"
category: "llm-streaming"
---

# Chat vs. Streaming: Don't Keep Your Users Waiting

**Author:** Lukas Walter
**Published:** April 28, 2026

## Overview
Examines two approaches for handling LLM responses in the Microsoft Agent Framework: blocking RunAsync vs streaming RunStreamingAsync.

## Code Examples

### RunAsync (Blocking)

```csharp
var response = await agent.RunAsync("Which guitar brands are most popular for rock and blues?");
Console.WriteLine(response);
```

### RunStreamingAsync (Real-Time)

```csharp
await foreach (var update in agent.RunStreamingAsync("Explain how Gibson and Fender guitars differ in sound, feel, and typical use cases."))
{
    Console.Write(update);
}
```

## When to Use What

**RunStreamingAsync:** Interactive apps (chatbots, console apps, Blazor WebAssembly, React frontends) where users observe live responses.

**RunAsync:** Automated background processes, scheduled jobs, webhooks, email processing. Also required for structured output (JSON/C# objects) since incomplete JSON cannot be deserialized.
