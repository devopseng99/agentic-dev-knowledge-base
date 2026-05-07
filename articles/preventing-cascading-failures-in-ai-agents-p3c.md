---
title: "Preventing Cascading Failures in AI Agents"
url: "https://dev.to/willvelida/preventing-cascading-failures-in-ai-agents-p3c"
author: "Will Velida"
category: "agent-fault-tolerance"
---
# Preventing Cascading Failures in AI Agents
**Author:** Will Velida  **Published:** March 13, 2026

## Overview
OWASP ASI08 (Cascading Failures). When Claude API rate-limits trigger retry loops, each retry consumes LLM tokens exponentially. Implementation using Biotrackr health-data chat agent.

## Key Concepts

### Strategy 1: Zero-Trust Fault Tolerance
```csharp
builder.Services.AddHttpClient("BiotrackrApi", (sp, client) =>
{
    client.BaseAddress = new Uri(settings.ApiBaseUrl);
})
.AddHttpMessageHandler<ApiKeyDelegatingHandler>()
.AddStandardResilienceHandler();  // Rate limiting, timeouts, retries, circuit breaking
```

Structured error responses (not exceptions):
```csharp
if (!DateOnly.TryParse(date, out _))
    return """{"error": "Invalid date format. Use YYYY-MM-DD."}""";
```

### Strategy 2: Isolation and Trust Boundaries
```csharp
// Agent Identity with Entra Agent ID
_credential.Options.WithAgentIdentity(_settings.AgentIdentityId);
_credential.Options.RequestAppToken = true;
```

Container constraints:
```bicep
resources: {
  cpu: json('0.25')
  memory: '0.5Gi'
}
```

### Strategy 3: JIT, One-Time Tool Access
Input validation caps:
```csharp
if ((endDate.ToDateTime(TimeOnly.MinValue) - startDate.ToDateTime(TimeOnly.MinValue)).Days > 365)
    return """{"error": "Date range cannot exceed 365 days."}""";
```

### Strategy 4: Independent Policy Enforcement
```xml
<rate-limit-by-key calls="100" renewal-period="60" counter-key="@(context.Subscription.Id)" />
```

### Strategy 5: Blast-Radius Guardrails
```csharp
public int PageSize { get; set; } = 20;  // Max: 100
```

### Strategy 6: OpenTelemetry Logging
```csharp
builder.Services.AddOpenTelemetry()
    .WithTracing(tracing => tracing
        .AddAspNetCoreInstrumentation()
        .AddHttpClientInstrumentation()
        .AddOtlpExporter())
    .WithMetrics(metrics => metrics
        .AddAspNetCoreInstrumentation()
        .AddOtlpExporter());
```

### Before vs After
**Without safeguards:** 429 error triggers 50 tool calls, full context sent repeatedly. Cost: ~$2 in tokens.
**With safeguards:** Circuit breaker opens after 3 failures, clean error message returned. Cost: ~$0.01.

### Critical Takeaway
"AddStandardResilienceHandler() is the single highest-value line of code for your agent's resilience."
