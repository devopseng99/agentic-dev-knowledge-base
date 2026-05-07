---
title: "Deploying Agent Framework to Production: Azure AI Foundry, Observability, and Scaling"
url: "https://dev.to/bspann/deploying-agent-framework-to-production-azure-ai-foundry-observability-and-scaling-2h1l"
author: "Brian Spann"
category: "cloud-agents"
---

# Deploying Agent Framework to Production: Azure AI Foundry, Observability, and Scaling
**Author:** Brian Spann
**Published:** February 24, 2026

## Overview
Comprehensive guide covering the production deployment gap for AI agents: ASP.NET Core integration with Agent Framework, OpenTelemetry observability, session persistence with Azure Table Storage, autoscaling, rate limiting, security (Managed Identity, VNet, input validation), cost management with token budgets, and full Bicep/GitHub Actions deployment pipelines.

## Key Concepts

### ASP.NET Core Service Registration

```csharp
var builder = WebApplication.CreateBuilder(args);

builder.Services.AddSingleton<IChatClient>(sp =>
{
    var config = sp.GetRequiredService<IConfiguration>();
    return new ChatCompletionsClient(
        new Uri(config["AzureOpenAI:Endpoint"]!),
        new DefaultAzureCredential()
    ).AsChatClient(config["AzureOpenAI:DeploymentName"]!);
});

builder.Services.AddSingleton<CustomerSupportAgent>();
builder.Services.AddAgentRuntime(options =>
{
    options.DefaultAgent = "CustomerSupport";
    options.SessionTimeout = TimeSpan.FromMinutes(30);
});
```

### Production Agent with Tools

```csharp
public class CustomerSupportAgent : ChatClientAgent
{
    public CustomerSupportAgent(
        IChatClient chatClient,
        IOrderService orderService,
        ILogger<CustomerSupportAgent> logger)
        : base(chatClient, new ChatClientAgentOptions
        {
            Name = "CustomerSupport",
            Instructions = "You are a helpful customer support agent..."
        })
    {
        AddTools(this);
    }

    [AgentTool, Description("Look up an order by order ID or customer email")]
    public async Task<OrderInfo> LookupOrder(
        [Description("Order ID")] string? orderId = null,
        [Description("Customer email")] string? email = null)
    {
        if (orderId != null) return await _orderService.GetByIdAsync(orderId);
        if (email != null) return await _orderService.GetLatestByEmailAsync(email);
        throw new ArgumentException("Either orderId or email must be provided");
    }
}
```

### OpenTelemetry Configuration

```csharp
builder.Services.AddOpenTelemetry()
    .ConfigureResource(resource => resource
        .AddService("AgentService", serviceVersion: "1.0.0"))
    .WithTracing(tracing => tracing
        .AddSource("Microsoft.Agents.AI")
        .AddAspNetCoreInstrumentation()
        .AddAzureMonitorTraceExporter())
    .WithMetrics(metrics => metrics
        .AddMeter("Microsoft.Agents.AI")
        .AddAspNetCoreInstrumentation()
        .AddAzureMonitorMetricExporter());
```

### Token Budget Enforcement Middleware

```csharp
public class BudgetEnforcementMiddleware : IAgentMiddleware
{
    public async Task<AgentResponse> InvokeAsync(AgentRequest request, AgentDelegate next)
    {
        var session = request.Session;
        if (session != null && session.TotalTokensUsed >= _maxTokensPerSession)
        {
            return new AgentResponse
            {
                Content = "This conversation has reached its limit.",
                Status = AgentResponseStatus.BudgetExceeded
            };
        }
        var response = await next(request);
        if (session != null && response.Usage != null)
        {
            session.TotalTokensUsed += response.Usage.TotalTokens;
            await _sessionStore.SaveAsync(session);
        }
        return response;
    }
}
```

### Rate Limiting

```csharp
builder.Services.AddRateLimiter(options =>
{
    options.AddPolicy("user-limit", context =>
    {
        var userId = context.User?.Identity?.Name ?? "anonymous";
        return RateLimitPartition.GetTokenBucketLimiter(userId, _ =>
            new TokenBucketRateLimiterOptions
            {
                TokenLimit = 20,
                TokensPerPeriod = 10,
                ReplenishmentPeriod = TimeSpan.FromMinutes(1),
                QueueLimit = 5
            });
    });
});
```

### Bicep Deployment

```bicep
resource appService 'Microsoft.Web/sites@2023-01-01' = {
  name: appName
  location: location
  identity: { type: 'SystemAssigned' }
  properties: {
    serverFarmId: appServicePlan.id
    siteConfig: {
      linuxFxVersion: 'DOTNETCORE|8.0'
      alwaysOn: true
      healthCheckPath: '/health'
    }
    virtualNetworkSubnetId: appSubnet.id
  }
}
```
