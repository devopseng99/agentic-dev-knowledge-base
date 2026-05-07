---
title: "Integrate a Copilot Studio Agent into an Existing .NET App Using Agents SDK"
url: "https://dev.to/vimaltwit/integrate-a-copilot-studio-agent-into-an-existing-net-app-using-agents-sdk-248e"
author: "Vimal"
category: "cloud-agents"
---

# Integrate a Copilot Studio Agent into an Existing .NET App Using Agents SDK
**Author:** Vimal
**Published:** April 19, 2026

## Overview
Walkthrough for integrating Microsoft Copilot Studio agents into .NET applications using the Microsoft Agents SDK. Covers SSE streaming, DI registration, conversation initialization, and query execution.

## Key Concepts

### NuGet Packages

```csharp
<PackageReference Include="Microsoft.Agents.CopilotStudio.Client" Version="1.3.176" />
<PackageReference Include="Microsoft.Identity.Client" Version="4.78.0" />
```

### Configuration

```json
{
  "CopilotStudio": {
    "EnvironmentId": "<env-id>",
    "SchemaName": "<agent-schema-name>",
    "TenantId": "<tenant-id>",
    "AppClientId": "<app-client-id>"
  }
}
```

### Architecture
- .NET API with Server-Sent Events (SSE) endpoint
- Retrieval layer using Agents SDK
- Copilot agent with grounding data

### Implementation Flow
1. Register DI: `AddKeyedScoped<IDocumentStreamingService, CopilotStudioDocumentRetrievalService>`
2. Initialize conversation via `StartConversationAsync()`
3. Query with `AskQuestionAsync()`
4. Stream responses via SSE: `data: {json}\n\n`

### Prerequisites
- Agent created in Copilot Studio with knowledge source
- .NET API with app registration having "Copilot Studio.Copilots.Invoke" permissions
