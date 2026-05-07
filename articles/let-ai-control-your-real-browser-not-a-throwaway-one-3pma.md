---
title: "Let AI Control Your Real Browser -- Not a Throwaway One"
url: "https://dev.to/stevez/let-ai-control-your-real-browser-not-a-throwaway-one-3pma"
author: "Steve Zhang"
category: "browser-automation-ai-agent"
---

# Let AI Control Your Real Browser -- Not a Throwaway One

**Author:** Steve Zhang
**Published:** March 19, 2026

## Overview
Introduces Dramaturg, a Chrome extension paired with `@playwright-repl/mcp`, enabling AI to control your actual browser session rather than launching a separate instance, preserving authentication states, localStorage, and cookies.

## Key Concepts

### Architecture
Claude -> MCP (stdio) -> playwright-repl MCP server -> WebSocket -> Dramaturg Chrome extension -> CDP/chrome.debugger -> your actual Chrome tabs

Uses playwright-crx to execute Playwright directly within Chrome's service worker, eliminating external Node.js relays.

### Two-Tool Interface
Instead of ~70 tools like Playwright's official MCP:
- `run_command`: Execute single commands
- `run_script`: Run multi-line scripts

Supports keyword syntax (`.pw` format) like `click "Sign in"` or full JavaScript Playwright API calls with `expect()` assertions.

### Four AI Agents
1. **Planner**: Maps page structure and creates step-by-step workflows
2. **Generator**: Produces working scripts that execute and iterate until passing
3. **Healer**: Diagnoses and fixes broken scripts with snapshot analysis
4. **Converter**: Translates between `.pw` syntax and idiomatic JavaScript

### Setup
Install via npm, add the Chrome extension, configure Claude Desktop's `claude_desktop_config.json`, optionally copy agent files.

### Resources
- Chrome Web Store: Dramaturg extension
- GitHub: https://github.com/stevez/playwright-repl
- npm: @playwright-repl/mcp
