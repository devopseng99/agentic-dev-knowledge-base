---
title: "Build a Frontend for your Microsoft Agent Framework (.NET) Agents with AG-UI"
url: "https://dev.to/copilotkit/build-a-frontend-for-your-microsoft-agent-framework-agents-with-ag-ui-40ge"
author: "Bonnie"
category: "agent-ui-frameworks"
---

# Build a Frontend for your Microsoft Agent Framework (.NET) Agents with AG-UI
**Author:** Bonnie
**Published:** November 13, 2025

## Overview
Guide for building UI for Microsoft Agent Framework .NET agents using AG-UI Protocol and CopilotKit, demonstrating the full integration from backend agent creation to frontend state synchronization.

## Key Concepts

### Setup
```bash
npx copilotkit@latest init -m microsoft-agent-framework
pnpm install
pnpm dev
```

### Backend (.NET)
```csharp
using Microsoft.Agents.AI.Hosting.AGUI.AspNetCore;

WebApplicationBuilder builder = WebApplication.CreateBuilder(args);
builder.Services.AddAGUI();
WebApplication app = builder.Build();
app.MapAGUI("/", agentFactory.CreateProverbsAgent());
```

### Agent Creation
```csharp
public AIAgent CreateProverbsAgent() {
    var chatClient = _openAiClient.GetChatClient("gpt-4o-mini").AsIChatClient();
    var chatClientAgent = new ChatClientAgent(chatClient,
        name: "ProverbsAgent",
        tools: [
            AIFunctionFactory.Create(GetProverbs),
            AIFunctionFactory.Create(SetProverbs),
            AIFunctionFactory.Create(GetWeather),
        ]);
    return new SharedStateAgent(chatClientAgent, _jsonSerializerOptions);
}
```

### Tool Definitions
```csharp
[Description("Get the current list of proverbs.")]
private List<string> GetProverbs() { return _state.Proverbs; }

[Description("Replace the entire list of proverbs.")]
private void SetProverbs(List<string> proverbs) { _state.Proverbs = [.. proverbs]; }
```
