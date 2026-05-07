---
title: "My first Experience with Google's Agent Development Kit (ADK-Go)"
url: "https://dev.to/aairom/my-first-experience-with-googles-agent-development-kit-adk-go-3f1p"
author: "Alain Airom"
category: "rust-go-java-agents"
---

# My first Experience with Google's Agent Development Kit (ADK-Go)
**Author:** Alain Airom
**Published:** April 7, 2026

## Overview
Hands-on with ADK-Go using Gemini and local Ollama. Includes custom OllamaModel wrapper implementing model.LLMRequest interface. Key discovery: ADK is optimized for Interactive Mode, not standalone CLI. Not all models support function calling (llama3/mistral work, granite4/gemma3 don't).

## Key Concepts

```go
type OllamaModel struct {
    client    openai.Client
    modelName string
}

func (o *OllamaModel) GenerateContent(ctx context.Context, req *model.LLMRequest, stream bool) iter.Seq2[*model.LLMResponse, error] {
    return func(yield func(*model.LLMResponse, error) bool) {
        // Convert ADK request to OpenAI format, call Ollama, yield response
    }
}

agentInstance, err := llmagent.New(llmagent.Config{
    Name: "ollama_assistant",
    Model: ollamaModel,
    Tools: tools,
})
```
