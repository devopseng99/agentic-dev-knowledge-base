---
title: "Semantic Kernel and AI Agent Architecture: Orchestrating Enterprise LLMs in .NET 9"
url: "https://dev.to/topuzas/semantic-kernel-and-ai-agent-architecture-orchestrating-enterprise-llms-in-net-9-4n4p"
author: "Ali Suleyman TOPUZ"
category: "cloud-agents"
---

# Semantic Kernel and AI Agent Architecture: Orchestrating Enterprise LLMs in .NET 9
**Author:** Ali Suleyman TOPUZ
**Published:** March 21, 2026

## Overview
Staff engineer deep-dive into Semantic Kernel for production AI agents in .NET 9. Covers two-layer architecture (Microsoft.Extensions.AI + Semantic Kernel), plugin patterns, auto-invocation loops, guardrail filters, stateful conversation management, semantic caching, and plan validation.

## Key Concepts

### Bootstrap Configuration

```csharp
public static IServiceCollection AddEnterpriseAIServices(
    this IServiceCollection services, IConfiguration config)
{
    services.AddChatClient(builder => builder
        .UseFunctionCalling()
        .UseOpenTelemetry()
        .Use(new AzureOpenAIChatClient(...)));

    var builder = Kernel.CreateBuilder();
    builder.Plugins.AddFromType<InventoryPlugin>();
    services.AddTransient<Kernel>(sp => builder.Build());
    return services;
}
```

### Plugin Pattern

```csharp
public class InventoryPlugin
{
    [KernelFunction]
    [Description("Returns current stock levels for a product SKU.")]
    public async Task<int> GetStockLevelAsync(string sku) => 4;
}
```

### Auto-Invocation Loop

```csharp
var settings = new OpenAIPromptExecutionSettings
{
    ToolCallBehavior = ToolCallBehavior.AutoInvokeKernelFunctions
};
var result = await kernel.InvokePromptAsync(userPrompt, new(settings));
```

### Guardrail Filter

```csharp
public class SafetyFilter : IFunctionInvocationFilter
{
    public async Task OnFunctionInvocationAsync(
        FunctionInvocationContext context,
        Func<FunctionInvocationContext, Task> next)
    {
        if (context.Function.Name == "GetStockLevelAsync") { /* Check */ }
        await next(context);
    }
}
```

### Stateful Conversation Management

```csharp
public async Task ExecuteStatefulConversationAsync(
    Kernel kernel, string userId, string input)
{
    var history = await _sessionRepository.GetHistoryAsync(userId);
    history.AddUserMessage(input);
    var chatService = kernel.GetRequiredService<IChatCompletionService>();
    var response = await chatService.GetChatMessageContentAsync(history, kernel: kernel);
    history.AddAssistantMessage(response.Content!);
    await _sessionRepository.SaveHistoryAsync(userId, history);
}
```

### Semantic Caching

```csharp
public async Task<string> GetOptimizedResponseAsync(Kernel kernel, string userPrompt)
{
    var cachedResponse = await _vectorCache.GetSimilarResultAsync(userPrompt, threshold: 0.95);
    if (cachedResponse != null) return cachedResponse;
    var result = await kernel.InvokePromptAsync(userPrompt);
    await _vectorCache.StoreResultAsync(userPrompt, result.ToString());
    return result.ToString();
}
```

### Plan Validation Filter

```csharp
public class PlanValidationFilter : IAutoFunctionInvocationFilter
{
    public async Task OnAutoFunctionInvocationAsync(
        AutoFunctionInvocationContext context,
        Func<AutoFunctionInvocationContext, Task> next)
    {
        if (context.Function.Name.Contains("Delete", StringComparison.OrdinalIgnoreCase))
        {
            if (!IsUserAdmin(context.Kernel.Arguments["userId"]?.ToString()))
                throw new UnauthorizedAccessException();
        }
        await next(context);
    }
}
```
