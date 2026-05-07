---
title: "Azure AI Agent Service Part 5: Deploying Multi-Agent Systems to Azure AI Foundry"
url: "https://dev.to/bspann/deploying-multi-agent-systems-to-azure-ai-foundry-azure-ai-agent-service-part-5-3pk2"
author: "Brian Spann"
category: "cloud-agents"
---

# Azure AI Agent Service Part 5: Deploying Multi-Agent Systems to Azure AI Foundry
**Author:** Brian Spann
**Published:** February 18, 2026

## Overview
Final part of a 5-part series covering production deployment of multi-agent systems to Azure AI Foundry. Includes infrastructure as code with Bicep, production agent host in ASP.NET Core, agent initialization service, Container Apps scaling, token budget management, CI/CD pipelines, and Azure Monitor dashboards.

## Key Concepts

### Bicep Infrastructure

```bicep
param environment string = 'prod'
param location string = resourceGroup().location
param baseName string = 'aiagents'

resource aiHub 'Microsoft.MachineLearningServices/workspaces@2024-04-01' = {
  name: hubName
  location: location
  kind: 'Hub'
  identity: { type: 'SystemAssigned' }
  properties: {
    friendlyName: 'AI Agents Hub (${environment})'
    storageAccount: storageAccount.id
    keyVault: keyVault.id
    applicationInsights: appInsights.id
  }
}

resource aiProject 'Microsoft.MachineLearningServices/workspaces@2024-04-01' = {
  name: projectName
  location: location
  kind: 'Project'
  identity: { type: 'SystemAssigned' }
  properties: {
    friendlyName: 'Multi-Agent System (${environment})'
    hubResourceId: aiHub.id
  }
}
```

### Agent Initialization Service

```csharp
public class AgentInitializationService : IHostedService
{
    public async Task StartAsync(CancellationToken cancellationToken)
    {
        var agentsClient = _client.GetAgentsClient();
        var agentConfigs = _configuration
            .GetSection("Agents")
            .Get<List<AgentConfiguration>>() ?? new();

        foreach (var config in agentConfigs)
        {
            var agent = await GetOrCreateAgentAsync(agentsClient, config, cancellationToken);
            _orchestrator.RegisterAgent(config.Role, agent);
        }
    }
}
```

### Production Configuration

```json
{
  "Agents": [
    {
      "Name": "coordinator-agent-prod",
      "Role": "Coordinator",
      "Model": "gpt-4o",
      "Instructions": "Analyze incoming requests and delegate to specialist agents."
    },
    {
      "Name": "research-agent-prod",
      "Role": "Researcher",
      "Model": "gpt-4o",
      "Tools": ["file_search"]
    },
    {
      "Name": "analyst-agent-prod",
      "Role": "Analyst",
      "Model": "gpt-4o",
      "Tools": ["code_interpreter"]
    }
  ]
}
```

### Container Apps Scaling

```bicep
resource containerApp 'Microsoft.App/containerApps@2023-05-01' = {
  name: 'aiagent-host'
  properties: {
    template: {
      scale: {
        minReplicas: 2
        maxReplicas: 10
        rules: [
          {
            name: 'http-scaling'
            http: { metadata: { concurrentRequests: '20' } }
          }
        ]
      }
    }
  }
}
```

### Token Budget Manager

```csharp
public class TokenBudgetManager
{
    public async Task<bool> TryAcquireAsync(int estimatedTokens, CancellationToken ct)
    {
        await _semaphore.WaitAsync(ct);
        try
        {
            ResetWindowIfNeeded();
            if (_tokensUsedThisMinute + estimatedTokens > _tokensPerMinute)
                return false;
            _tokensUsedThisMinute += estimatedTokens;
            return true;
        }
        finally { _semaphore.Release(); }
    }
}
```

### CI/CD Pipeline

```yaml
name: Deploy Multi-Agent System
on:
  push:
    branches: [main]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - run: dotnet test --no-build --verbosity normal

  deploy-staging:
    needs: build-and-push
    steps:
      - run: |
          az containerapp update \
            --name aiagent-host-staging \
            --resource-group ${{ env.AZURE_RESOURCE_GROUP }} \
            --image ${{ env.CONTAINER_REGISTRY }}/${{ env.IMAGE_NAME }}:${{ needs.build-and-push.outputs.image-tag }}

  deploy-production:
    needs: [build-and-push, deploy-staging]
    environment: production
    steps:
      - run: |
          az containerapp update \
            --name aiagent-host \
            --image ${{ env.CONTAINER_REGISTRY }}/${{ env.IMAGE_NAME }}:${{ needs.build-and-push.outputs.image-tag }}
```
