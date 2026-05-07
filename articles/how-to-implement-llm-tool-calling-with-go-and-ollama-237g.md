---
title: "How to Implement LLM Tool-calling with Go and Ollama"
url: "https://dev.to/calvinmclean/how-to-implement-llm-tool-calling-with-go-and-ollama-237g"
author: "Calvin McLean"
category: "tool calling LLM"
---

# How to Implement LLM Tool-calling with Go and Ollama

**Author:** Calvin McLean
**Published:** June 16, 2025

## Overview

Tutorial on implementing LLM tool-calling with Go and Ollama. Demonstrates how LLMs generate structured function inputs that a controller program executes, then feeds results back. Includes a real-world application for tour availability queries.

## Key Concepts

### How Tool Calling Works

LLMs generate text exclusively. To use tools, a program interprets the model's output as structured JSON describing which function to call and what parameters to use. The controller parses this, executes the function, and returns results to the LLM.

### ChatRequest with Tools in Go

```go
messages := []api.Message{
    api.Message{
        Role:    "user",
        Content: "What is the weather like in New York City?",
    },
}

req := &api.ChatRequest{
    Model: model,
    Messages: messages,
    Tools: api.Tools{
        api.Tool{
            Type: "function",
            Function: api.ToolFunction{
                Name:        "getCurrentWeather",
                Description: "Get the current weather in a given location",
                Parameters: api.ToolFunctionParameters{
                    Type:     "object",
                    Required: []string{"location"},
                    Properties: map[string]api.ToolFunctionProperty{
                        "location": {
                            Type:        api.PropertyType{"string"},
                            Description: "The city and state, e.g. San Francisco, CA",
                        },
                    },
                },
            },
        },
    },
}
```

### Full Implementation

```go
package main

import (
    "context"
    "encoding/json"
    "fmt"
    "log"
    "github.com/ollama/ollama/api"
)

const model = "llama3.2:3b"

func main() {
    client, err := api.ClientFromEnvironment()
    if err != nil {
        log.Fatal(err)
    }

    messages := []api.Message{
        {Role: "user", Content: "What is the weather like in New York City?"},
    }

    ctx := context.Background()

    handler := func(resp api.ChatResponse) error {
        if len(resp.Message.ToolCalls) == 0 {
            fmt.Print(resp.Message.Content)
            return nil
        }

        tc := resp.Message.ToolCalls[0].Function
        switch tc.Name {
        case "getCurrentWeather":
            output, err := getCurrentWeather(tc.Arguments)
            if err != nil {
                log.Fatal(err)
            }
            messages = append(messages, api.Message{
                Role:    "tool",
                Content: output,
            })
        default:
            log.Fatal(fmt.Errorf("invalid function: %q", tc.Name))
        }
        return nil
    }

    err = client.Chat(ctx, req, handler)
    if err != nil {
        log.Fatal(err)
    }

    req.Messages = messages
    err = client.Chat(ctx, req, handler)
    if err != nil {
        log.Fatal(err)
    }
}

func getCurrentWeather(input map[string]any) (string, error) {
    location, ok := input["location"].(string)
    if !ok {
        log.Fatalf("bad args: %v", input)
    }

    weatherInfo := map[string]any{
        "location":    location,
        "temperature": "80",
        "unit":        "fahrenheit",
        "forecast":    []string{"sunny", "windy"},
    }

    b, err := json.Marshal(weatherInfo)
    if err != nil {
        return "", err
    }
    return string(b), nil
}
```

### Key Insight

"LLMs are still just reading input and generating output. It's the code around them, built by software engineers, that enables them to actually do things."

Tool-calling permits applications to expand functionality on-demand, but requires careful guardrails -- pre-defined SQL queries rather than unrestricted database execution, for example.
