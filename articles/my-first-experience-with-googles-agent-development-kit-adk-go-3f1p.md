---
title: "My first Experience with Google's Agent Development Kit (ADK-Go)"
url: "https://dev.to/aairom/my-first-experience-with-googles-agent-development-kit-adk-go-3f1p"
author: "Alain Airom"
category: "ai-agent-go-golang"
---

# My first Experience with Google's Agent Development Kit (ADK-Go)

**Author:** Alain Airom
**Published:** April 7, 2026

## Overview
Hands-on experience with Google's ADK-Go framework, including running the basic sample with Gemini, then implementing a local agent using Ollama. Covers console mode, web UI mode, and lessons learned about model compatibility with function calling.

## Key Concepts

### Basic Agent with Gemini

```go
package main

import (
    "context"
    "log"
    "os"

    "google.golang.org/adk/agent"
    "google.golang.org/adk/agent/llmagent"
    "google.golang.org/adk/cmd/launcher"
    "google.golang.org/adk/cmd/launcher/full"
    "google.golang.org/adk/model/gemini"
    "google.golang.org/adk/tool"
    "google.golang.org/adk/tool/geminitool"
    "google.golang.org/genai"
)

func main() {
    ctx := context.Background()
    model, err := gemini.NewModel(ctx, "gemini-2.5-flash", &genai.ClientConfig{
        APIKey: os.Getenv("GOOGLE_API_KEY"),
    })
    if err != nil {
        log.Fatalf("Failed to create model: %v", err)
    }

    timeAgent, err := llmagent.New(llmagent.Config{
        Name:        "hello_time_agent",
        Model:       model,
        Description: "Tells the current time in a specified city.",
        Instruction: "You are a helpful assistant that tells the current time.",
        Tools:       []tool.Tool{geminitool.GoogleSearch{}},
    })
    if err != nil {
        log.Fatalf("Failed to create agent: %v", err)
    }

    config := &launcher.Config{
        AgentLoader: agent.NewSingleLoader(timeAgent),
    }
    l := full.NewLauncher()
    if err = l.Execute(ctx, config, os.Args[1:]); err != nil {
        log.Fatalf("Run failed: %v", err)
    }
}
```

### Running

```bash
go mod init my-agent/main
go mod tidy

# Console mode
go run agent.go

# Web UI mode
go run agent.go web api webui
```

### Ollama Integration (Custom LLM Interface)

Key implementation wraps Ollama's OpenAI-compatible API to satisfy ADK's `model.LLM` interface:

```go
type OllamaModel struct {
    client    openai.Client
    modelName string
}

func NewOllamaModel(modelName string, baseURL string) (*OllamaModel, error) {
    if baseURL == "" {
        baseURL = "http://localhost:11434/v1"
    }
    client := openai.NewClient(
        option.WithBaseURL(baseURL),
        option.WithAPIKey("ollama"),
    )
    return &OllamaModel{client: client, modelName: modelName}, nil
}
```

### Lessons Learned

1. **ADK is modular middleware** -- not designed as standalone CLI. Built for Interactive Mode, Web Mode, or orchestrated by other applications.
2. **Not all models support function calling** -- Models like ibm/granite4:3b and gemma3:4b lack tool support. Models that work: llama3.2, llama3, mistral:7b, deepseek-r1.
3. **Zero-tool agents are possible** but lack real-time grounding provided by ADK's orchestration layer.
