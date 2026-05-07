---
title: "Building an AI Agent with Gemini and TypeScript"
url: "https://dev.to/gsk007/building-an-ai-agent-with-google-gemini-a-modular-approach-inspired-by-agent-from-scratch-29ef"
author: "gsk-007"
category: "gemini-api-agent"
---

# Building an AI Agent with Gemini and TypeScript

**Author:** gsk-007
**Published:** May 27, 2025

## Overview
A modular, extensible AI agent built with Google's Gemini API and TypeScript/Node.js. The agent takes a user-defined goal, reasons through steps using Gemini 2.0 Flash, executes actions via pluggable tools, stores memory between steps, and loops until the goal is completed autonomously.

## Key Concepts

### Agent Architecture

The agent follows a cognitive loop:

```
Goal -> Plan -> Reason -> Execute -> Remember -> Repeat
```

Each component is modular:
- `agent.ts`: The main reasoning loop
- `ai.ts`: Interacts with Gemini
- `toolRunner.ts`: Delegates tool use
- `memory.ts`: Stores past tasks
- `systemPrompt.ts`: Shapes Gemini's behavior
- `ui.ts`: Command-line interface

### Tech Stack

- **TypeScript** -- Strictly typed and modular
- **Node.js** (via Volta) -- Runtime (v20.17.0)
- **Google Gemini Pro** -- Language + image generation
- **LowDB** -- Lightweight JSON-based memory system
- **dotenv** -- Secure environment variables
- **Ora + Colors** -- Friendly CLI feedback
- **TSX** -- Seamless TypeScript execution during development

### Tool Integrations

The agent supports extensible tooling:

1. **Reddit Reader** -- Fetches trending posts from `https://www.reddit.com/.json?limit=5`
2. **Dad Joke Fetcher** -- Uses the `https://icanhazdadjoke.com/` API
3. **Gemini Image Generator** -- Converts text prompts into images using Gemini's multimodal API

Tools are dynamically selected by the agent based on task needs.

### Challenges and Lessons

- **Prompt engineering for Gemini**: Getting reliable tool selection and reasoning took trial and error
- **Streaming support**: Gemini doesn't stream easily via Node yet -- feedback handling needed tweaks
- **Image generation**: The multimodal API is powerful but requires slightly different prompting strategies
