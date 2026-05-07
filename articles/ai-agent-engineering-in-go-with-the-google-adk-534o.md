---
title: "AI Agent Engineering in Go with the Google ADK"
url: "https://dev.to/googleai/ai-agent-engineering-in-go-with-the-google-adk-534o"
author: "Karl Weinmeister"
category: "ai-agent-go-golang"
---

# AI Agent Engineering in Go with the Google ADK

**Author:** Karl Weinmeister
**Published:** January 22, 2026

## Overview
Building production AI agents in Go using Google's Agent Development Kit (ADK). Covers scaffolding with Agent Starter Pack, defining tools with Go structs, the ReAct reasoning pattern, testing (unit + E2E), and deploying to Cloud Run with A2A protocol support.

## Key Concepts

### Getting Started with Agent Starter Pack

```bash
uvx agent-starter-pack create
```

Interactive setup selections:
- Template: Go ADK, Simple ReAct agent
- CI/CD: GitHub Actions
- Region: us-central1

### Launch Local Development UI

```bash
make install && make playground
```

### Tool Definition with Go Structs

```go
type GetWeatherArgs struct {
    City string `json:"city" jsonschema:"City name to get weather for"`
}

type GetWeatherResult struct {
    Weather string `json:"weather"`
}

func GetWeather(_ tool.Context, args GetWeatherArgs) (GetWeatherResult, error) {
    return GetWeatherResult{
        Weather: "It's sunny and 72F in " + args.City,
    }, nil
}
```

### Agent Assembly

```go
func NewRootAgent(ctx context.Context) (agent.Agent, error) {
    model, err := gemini.NewModel(ctx, "gemini-2.5-flash", &genai.ClientConfig{
        Backend: genai.BackendVertexAI,
    })

    weatherTool, err := functiontool.New(functiontool.Config{
        Name:        "get_weather",
        Description: "Get the current weather for a city.",
    }, GetWeather)

    rootAgent, err := llmagent.New(llmagent.Config{
        Name:        "my-first-go-agent",
        Model:       model,
        Description: "A helpful AI assistant.",
        Instruction: "You are a helpful AI assistant designed to provide accurate and useful information.",
        Tools:       []tool.Tool{weatherTool},
    })
```

### Unit Tests

```go
func TestGetWeather(t *testing.T) {
    for _, tt := range tests {
        t.Run(tt.name, func(t *testing.T) {
            result, err := GetWeather(nil, GetWeatherArgs{City: tt.city})
            if err != nil {
                t.Fatalf("GetWeather() error = %v", err)
            }
            if !strings.Contains(result.Weather, tt.wantCity) {
                t.Errorf("GetWeather() = %v, want city %v", result.Weather, tt.wantCity)
            }
        })
    }
}
```

### E2E Tests with A2A Protocol

```go
func TestA2AMessageSend(t *testing.T) {
    if testing.Short() { t.Skip("Skipping E2E test in short mode") }
    t.Log("Starting server process")
    serverProcess := startServer(t)
    defer stopServer(t, serverProcess)
    if !waitForServer(t, 90*time.Second) {
        t.Fatal("Server failed to start")
    }
}
```

### Run Tests

```bash
make test
go test -v ./agent/... ./e2e/...
```

### Deployment to Cloud Run

The `make deploy` command builds with Cloud Buildpacks and deploys with production flags: `--memory "4Gi"`, `--no-cpu-throttling`, `--no-allow-unauthenticated`. With IAP enabled (`make deploy IAP=true`), the deployed Agent Card serves as a standard interface for dynamic discovery by other agents.
