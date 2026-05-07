---
title: "I Built a Multi-Agent AI Runtime in Go Because Python Wasn't an Option"
url: "https://dev.to/clinnet/i-built-a-multi-agent-ai-runtime-in-go-because-python-wasnt-an-option-2ioi"
author: "Clinton Adedeji"
category: "rust-go-java-agents"
---

# I Built a Multi-Agent AI Runtime in Go Because Python Wasn't an Option
**Author:** Clinton Adedeji
**Published:** April 4, 2026

## Overview
Routex: multi-agent runtime in Go with YAML-driven agent definitions. Erlang-inspired supervision trees (one_for_one, one_for_all, rest_for_one). Kahn's algorithm for topological scheduling. Parallel tool execution via sync.WaitGroup. Direct HTTP LLM calls without SDK dependencies. MCP auto-discovery.

## Key Concepts

```yaml
agents:
  - id: "researcher"
    role: "researcher"
    goal: "Find information about Go web frameworks"
    tools: ["web_search", "wikipedia"]
  - id: "writer"
    role: "writer"
    goal: "Write a clear report from the research"
    depends: ["researcher"]
```

```bash
routex run agents.yaml
```

- Different agents can use different LLM providers (Anthropic, OpenAI, Ollama)
- MCP auto-discovery via server_url configuration
- Deadlock fix: FailureReport/Decision protocol between scheduler and supervisor
