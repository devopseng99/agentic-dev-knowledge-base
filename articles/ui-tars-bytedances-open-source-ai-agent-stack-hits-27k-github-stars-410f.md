---
title: "UI-TARS: ByteDance's Open-Source AI Agent Stack Hits 27K GitHub Stars"
url: "https://dev.to/serenitiesai/ui-tars-bytedances-open-source-ai-agent-stack-hits-27k-github-stars-410f"
author: "Serenities AI"
category: "full-code-examples"
---

# UI-TARS: ByteDance's Open-Source AI Agent Stack Hits 27K GitHub Stars
**Author:** Serenities AI
**Published:** February 6, 2026

## Overview
ByteDance's UI-TARS multimodal AI agent ecosystem with 27K GitHub stars. Two projects: Agent TARS (CLI/Web UI for browser automation and MCP) and UI-TARS-desktop (native desktop computer control).

## Key Concepts

### GitHub Repository
https://github.com/bytedance/UI-TARS-desktop

### Installation

```bash
# Launch with npx (no install needed)
npx @agent-tars/cli@latest

# Or install globally (requires Node.js >= 22)
npm install @agent-tars/cli@latest -g

# Run with your preferred model provider
agent-tars --provider anthropic --model claude-3-7-sonnet-latest --apiKey your-key
```

### Core Capabilities
- Natural Language Control: plain English instructions like "Book me a flight to NYC"
- Screenshot-Based Visual Recognition: vision models identify UI elements
- Precise Input Control: mouse clicks, keyboard input, scrolling, navigation
- Cross-Platform: Windows, macOS, browsers
- Local Processing: privacy-first, data stays on user machine

### Performance Benchmarks

| Benchmark | Score | Notes |
|-----------|-------|-------|
| OSWorld | 24.6 (50 steps) | Outperforms GPT-4o and Claude |
| AndroidWorld | 46.6 | Strong mobile GUI performance |
| BrowseComp | 29.6 | Long-horizon information seeking |

UI-TARS-2 achieved ~60% human-level performance in game environments.

### Use Cases
- Pure GUI automation across any application
- Privacy-critical deployments requiring local execution
- Research or fine-tuning requirements
