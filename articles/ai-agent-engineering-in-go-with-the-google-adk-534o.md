---
title: "AI Agent Engineering in Go with the Google ADK"
url: "https://dev.to/googleai/ai-agent-engineering-in-go-with-the-google-adk-534o"
author: "Karl Weinmeister"
category: "rust-go-java-agents"
---

# AI Agent Engineering in Go with the Google ADK
**Author:** Karl Weinmeister
**Published:** January 22, 2026

## Overview
Official Google guide for ADK-Go. Go's low latency, high concurrency, and type safety make it ideal for serving/orchestrating agents. Covers tool definition, ReAct pattern, Web UI debugging, Cloud Run deployment, and Agent Card for multi-agent discovery.

## Key Concepts

```go
type GetWeatherArgs struct {
    City string `json:"city" jsonschema:"City name to get weather for"`
}
func GetWeather(_ tool.Context, args GetWeatherArgs) (GetWeatherResult, error) {
    return GetWeatherResult{Weather: "Sunny and 72F in " + args.City}, nil
}

rootAgent, err := llmagent.New(llmagent.Config{
    Name: "my-first-go-agent",
    Model: model,
    Tools: []tool.Tool{weatherTool},
})
```

```bash
make install && make playground  # Web UI
make deploy  # Google Cloud Run
```
