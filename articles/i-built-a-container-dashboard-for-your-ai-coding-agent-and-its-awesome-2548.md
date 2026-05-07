---
title: "I Built a Container Dashboard for Your AI Coding Agent"
url: "https://dev.to/k1lgor/i-built-a-container-dashboard-for-your-ai-coding-agent-and-its-awesome-2548"
author: "k1lgor"
category: "llm-agent-docker"
---

# I Built a Container Dashboard for Your AI Coding Agent

**Author:** k1lgor
**Published:** May 4, 2026

## Overview
A container dashboard extension for AI coding agents that provides Docker, Podman, and Nerdctl management directly within the LLM interface. Features safety guardrails preventing destructive operations without confirmation, 14 slash commands, and 13 LLM tools. ~800 lines of TypeScript.

## Key Concepts

### Safety Confirmations
Dangerous patterns are caught before execution, requiring explicit user confirmation.

### Architecture
- runtime.ts: Runtime detection and CLI abstraction
- commands.ts: Slash command implementations
- tools.ts: LLM tool definitions (TypeBox schemas)
- widget.ts: TUI sidebar widget

## Code Examples

### Safety Pattern Detection

```typescript
const dangerousPatterns = [
  /(?:docker|podman|nerdctl)\s+(?:rm|container\s+rm)\s+-f/i,
  /(?:docker|podman|nerdctl)\s+system\s+prune\s+-a/i,
  /(?:docker|podman|nerdctl)\s+stop\s+\$\(docker\s+ps\s+-aq\)/i,
];
```

### Runtime Detection

```typescript
const RUNTIMES = ["docker", "podman", "nerdctl"] as const;

export async function detectRuntime(pi: ExtensionAPI): Promise<RuntimeState> {
  for (const runtime of RUNTIMES) {
    try {
      const result = await pi.exec(runtime, ["--version"], { timeout: 3000 });
      if (result.code === 0 && result.stdout) {
        return { runtime, version: result.stdout.trim(), available: true };
      }
    } catch {
      continue;
    }
  }
  return { runtime: null, version: "", available: false };
}
```

### Live TUI Widget

```
Docker v24.0.7  |  3 running  |  8 total
```

### Container List Output

```
CONTAINER ID   NAME                IMAGE                    STATUS      PORTS
a1b2c3d4e5f6   my-postgres         postgres:16              running     5432->5432
b2c3d4e5f6a7   redis-cache         redis:7-alpine           running     6379->6379
c3d4e5f6a7b8   old-test-container  node:18                  exited      -
```

### Installation

```bash
pi install npm:container-dashboard
# Or from GitHub
pi install git:github.com/k1lgor/pi-container-dashboard
```

### Available Slash Commands
`/docker:ps`, `/docker:logs`, `/docker:stats`, `/docker:inspect`, `/docker:top`, `/docker:images`, `/docker:prune`, `/docker:stop`, `/docker:start`, `/docker:restart`, `/docker:rm`
