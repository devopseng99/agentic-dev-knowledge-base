---
title: "Run Claude Code in Any Sandbox with One API: AgentBox SDK"
url: "https://dev.to/gentic_news/run-claude-code-in-any-sandbox-with-one-api-agentbox-sdk-3ibb"
author: "gentic news"
category: "agent-sandbox"
---

# Run Claude Code in Any Sandbox with One API: AgentBox SDK

**Author:** gentic news
**Published:** April 24, 2026

## Overview
AgentBox SDK abstracts the runtime for coding agents, supporting claude-code, opencode, and codex across local-docker, e2b, modal, daytona, and vercel sandboxes. Preserves full interactive capabilities including approval flows and streaming.

## Key Concepts

One API for any agent + any sandbox provider. Unlike `claude --print` (non-interactive), AgentBox launches agents as server processes inside sandboxes communicating over WebSocket/HTTP, preserving approval flows and tool-use control.

## Code Examples

### Basic Usage

```javascript
import { Agent, Sandbox } from "agentbox-sdk";

const sandbox = new Sandbox("local-docker", {
  workingDir: "/workspace",
  image: process.env.IMAGE_ID,
  env: { ANTHROPIC_API_KEY: process.env.ANTHROPIC_API_KEY },
});

const agent = new Agent("claude-code", {
  sandbox,
  cwd: "/workspace",
  approvalMode: "auto",
});

const result = await agent.run({
  model: "sonnet",
  input: "Create a hello world Express server in /workspace/server.ts",
});

await sandbox.delete();
```

### Build a Sandbox Image

```bash
npx agentbox image build --provider local-docker --preset browser-agent
```

### Stream Events

```javascript
const run = agent.stream({
  model: "sonnet",
  input: "Write a fizzbuzz in Python",
});

for await (const event of run) {
  if (event.type === "text.delta") {
    process.stdout.write(event.delta);
  }
}

const result = await run.finished;
```

### Supported Agents and Sandboxes
- Agents: claude-code, opencode, codex
- Sandboxes: local-docker, e2b, modal, daytona, vercel
- Swap either without changing app code
