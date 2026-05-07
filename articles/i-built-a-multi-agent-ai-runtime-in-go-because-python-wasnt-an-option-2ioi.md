---
title: "I Built a Multi-Agent AI Runtime in Go Because Python Wasn't an Option"
url: "https://dev.to/clinnet/i-built-a-multi-agent-ai-runtime-in-go-because-python-wasnt-an-option-2ioi"
author: "Clinton Adedeji"
category: "ai-agent-go-golang"
---

# I Built a Multi-Agent AI Runtime in Go Because Python Wasn't an Option

**Author:** Clinton Adedeji
**Published:** April 4, 2026

## Overview
Routex is a YAML-driven multi-agent AI runtime in Go. Describe agents, tools, and LLM providers in YAML, run with a single command. Features topological scheduling, Erlang-inspired supervision trees, parallel tool calls, multi-LLM crews, and MCP support. No Python required.

## Key Concepts

### YAML-Driven Agent Configuration

```yaml
runtime:
  name:         "research-crew"
  llm_provider: "anthropic"
  model:        "claude-haiku-4-5-20251001"
  api_key:      "env:ANTHROPIC_API_KEY"

task:
  input: "Compare the top Go web frameworks in 2026"

agents:
  - id:    "researcher"
    role:  "researcher"
    goal:  "Find detailed information about Go web frameworks"
    tools: ["web_search", "wikipedia"]

  - id:      "writer"
    role:    "writer"
    goal:    "Write a clear, structured report from the research"
    depends: ["researcher"]

tools:
  - name: "web_search"
  - name: "wikipedia"
```

```bash
routex run agents.yaml
```

### Why Go for Agents
An AI agent is fundamentally a concurrent system. Goroutines are cheap (2KB stack), channels provide typed safe communication, the context package gives cancellation/timeout propagation. Single statically compiled binary deploys anywhere.

### Topological Scheduler
Uses Kahn's algorithm to determine execution order from the dependency graph. Independent agents run concurrently in "waves." Each agent is a long-lived goroutine waiting on an Inbox channel.

### Erlang-Inspired Supervision

```yaml
agents:
  - id:      "researcher"
    role:    "researcher"
    restart: "one_for_one"
```

Policies:
- `one_for_one` -- restart only the failed agent
- `one_for_all` -- restart entire crew
- `rest_for_one` -- restart failed agent and all dependents

Restart budget prevents infinite loops burning API tokens.

### FailureReport/Decision Protocol (Deadlock Fix)

```go
type FailureReport struct {
    AgentID string
    Err     error
    Reply   chan<- Decision
}

type Decision struct {
    AgentID string
    Retry   bool
    Err     error
}
```

### Parallel Tool Calls

```go
var wg sync.WaitGroup
results := make([]toolResult, len(toExecute))

for i, tc := range toExecute {
    wg.Add(1)
    go func(i int, tc llm.ToolCallRequest) {
        defer wg.Done()
        out, err := registry.Execute(ctx, tc.ToolName, tc.Input)
        results[i] = toolResult{output: out, err: err}
    }(i, tc)
}

wg.Wait()
```

### Direct HTTP LLM Calls (No SDK)

```go
req, err := http.NewRequestWithContext(ctx, http.MethodPost, c.baseURL+"/v1/messages", body)
req.Header.Set("x-api-key", c.apiKey)
req.Header.Set("anthropic-version", "2023-06-01")
req.Header.Set("content-type", "application/json")
```

### Multi-LLM Crews

```yaml
agents:
  - id:   "researcher"
    llm:
      provider: "anthropic"
      model:    "claude-haiku-4-5-20251001"
  - id:   "writer"
    llm:
      provider: "openai"
      model:    "gpt-4o"
  - id:   "critic"
    llm:
      provider: "ollama"
      model:    "llama3"
```

### MCP Integration

```yaml
tools:
  - name: "mcp"
    extra:
      server_url:           "http://localhost:3000"
      server_name:          "github"
      header_Authorization: "env:GITHUB_TOKEN"
```

### Installation

```bash
go install github.com/Ad3bay0c/routex/cmd/routex@latest
routex init my-crew
cd my-crew
routex run agents.yaml
```
