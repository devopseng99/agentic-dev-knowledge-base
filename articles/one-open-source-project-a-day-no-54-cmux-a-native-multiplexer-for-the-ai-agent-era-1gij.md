---
title: "One Open Source Project a Day (No. 54): cmux - A Native Multiplexer for the AI Agent Era"
url: "https://dev.to/wonderlab/one-open-source-project-a-day-no-54-cmux-a-native-multiplexer-for-the-ai-agent-era-1gij"
author: "WonderLab"
category: "full-code-examples"
---

# cmux - A Native Multiplexer for the AI Agent Era
**Author:** WonderLab
**Published:** May 3, 2026

## Overview
Native macOS application integrating terminal sessions and web browsers into a unified workspace for AI agent workflows. GPU-accelerated terminal via libghostty with Unix Socket API for programmable control.

## Key Concepts

### GitHub Repository
https://github.com/manaflow-ai/cmux

### Programmatic Control via Unix Socket

```python
import socket
import json

command = {
    "jsonrpc": "2.0",
    "method": "v2.workspace.open_url",
    "params": {"url": "http://localhost:3000"},
    "id": 1
}
# Send to socket to control the UI programmatically
```

### Command-Line Usage

```bash
cmux split-pane --horizontal
cmux open-url https://google.com
```

### Key Features
- GPU-accelerated terminal rendering via libghostty
- Unix Socket API for programmable control
- Mixed terminal and browser pane layouts
- Agent sidebar for progress reporting and metadata
- 400+ GitHub stars, MIT license
- "Primitive-first" solution for custom AI agent workflows
