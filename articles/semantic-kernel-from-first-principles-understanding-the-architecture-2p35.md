---
title: "Semantic Kernel from First Principles: Understanding the Architecture"
url: "https://dev.to/bspann/semantic-kernel-from-first-principles-understanding-the-architecture-2p35"
author: "Brian Spann"
category: "cloud-agents"
---

# Semantic Kernel from First Principles: Understanding the Architecture
**Author:** Brian Spann
**Published:** February 26, 2026

## Overview
Part 1 of a 5-part series on Microsoft's Semantic Kernel. Covers the Kernel as central orchestrator, service abstraction (Azure OpenAI, OpenAI, Ollama), KernelFunction as the building block, native C# plugins with function calling, prompt template engines (SK, Handlebars, Liquid), execution settings, request flow with filters, and DI integration.

## Key Concepts

### Building a Kernel

```csharp
using Microsoft.SemanticKernel;
using Azure.Identity;

var builder = Kernel.CreateBuilder();

builder.AddAzureOpenAIChatCompletion(
    deploymentName: "gpt-4o",
    endpoint: Environment.GetEnvironmentVariable("AZURE_OPENAI_ENDPOINT")!,
    credential: new DefaultAzureCredential());

builder.AddAzureOpenAITextEmbeddingGeneration(
    deploymentName: "text-embedding-3-large",
    endpoint: Environment.GetEnvironmentVariable("AZURE_OPENAI_ENDPOINT")!,
    credential: new DefaultAzureCredential());

var kernel = builder.Build();
```

### Prompt Functions

```csharp
var summarizeFunction = kernel.CreateFunctionFromPrompt(
    promptTemplate: """
        Summarize the following text in {{$style}} style.
        Keep the summary under {{$maxWords}} words.
        Text to summarize: {{$input}}
        """,
    functionName: "Summarize",
    description: "Summarizes text in a specified style");

var result = await kernel.InvokeAsync(summarizeFunction, new KernelArguments
{
    ["input"] = longArticleText,
    ["style"] = "bullet points",
    ["maxWords"] = "100"
});
```

### Native Functions as AI Tools

```csharp
public class TextAnalysisPlugin
{
    [KernelFunction("count_words")]
    [Description("Counts the number of words in the provided text")]
    public int CountWords([Description("The text to analyze")] string text)
    {
        return text.Split(' ', StringSplitOptions.RemoveEmptyEntries).Length;
    }

    [KernelFunction("extract_emails")]
    [Description("Extracts all email addresses from the provided text")]
    public string[] ExtractEmails([Description("The text to search")] string text)
    {
        var emailPattern = @"[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}";
        return Regex.Matches(text, emailPattern)
            .Select(m => m.Value).Distinct().ToArray();
    }
}

kernel.Plugins.AddFromType<TextAnalysisPlugin>();
```

### Handlebars Templates

```csharp
var handlebarsTemplate = """
    {{#if context}}
    Use this context to answer: {{context}}
    {{/if}}
    {{#each examples}}
    Example: {{this}}
    {{/each}}
    Question: {{question}}
    """;

var function = kernel.CreateFunctionFromPrompt(
    new PromptTemplateConfig
    {
        Template = handlebarsTemplate,
        TemplateFormat = "handlebars",
        Name = "AnswerWithContext"
    },
    new HandlebarsPromptTemplateFactory());
```

### Execution Settings

```csharp
var settings = new AzureOpenAIPromptExecutionSettings
{
    MaxTokens = 1000,
    Temperature = 0.7,
    TopP = 0.95,
    ResponseFormat = "json_object",
    Seed = 42
};
```

### Filters for Observability

```csharp
public class LoggingFilter : IPromptRenderFilter
{
    public async Task OnPromptRenderAsync(
        PromptRenderContext context,
        Func<PromptRenderContext, Task> next)
    {
        _logger.LogDebug("Rendering prompt for {Function}", context.Function.Name);
        await next(context);
        _logger.LogDebug("Rendered prompt: {Prompt}", context.RenderedPrompt);
    }
}
```

### DI Integration

```csharp
builder.Services.AddKernel()
    .AddAzureOpenAIChatCompletion(
        deploymentName: "gpt-4o",
        endpoint: config["AzureOpenAI:Endpoint"]!,
        credential: new DefaultAzureCredential());
```
