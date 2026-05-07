---
title: "2026 Complete Guide: OpenClaw ACP - Bridge Your IDE to AI Agents"
url: "https://dev.to/czmilo/2026-complete-guide-openclaw-acp-bridge-your-ide-to-ai-agents-3hl8"
author: "cz"
category: "a2a-protocols"
---

# OpenClaw ACP: Bridge Your IDE to AI Agents
**Author:** cz
**Published:** March 4, 2026

## Overview
OpenClaw ACP implements the Agent Client Protocol, creating a WebSocket communication bridge between code editors and AI agents with persistent session context.

## Key Concepts

### Quick Setup

```bash
openclaw acp                    # Local gateway
openclaw acp --url wss://gateway-host:18789 --token-file ~/.openclaw/gateway.token  # Remote
openclaw acp client             # Testing
```

### Session Management

```bash
openclaw acp --session agent:main:main
openclaw acp --session agent:main:main --reset-session
```

### Zed Editor Configuration

```json
{
  "agent_servers": {
    "OpenClaw ACP": {
      "type": "custom",
      "command": "openclaw",
      "args": ["acp"],
      "env": {}
    }
  }
}
```

### Core Functions
1. Protocol Translation: ACP (IDE-side) to OpenClaw Gateway protocol
2. Session Management: Maps ACP sessions to Gateway session keys with reconnection
3. Authentication: Token-based and file-based credentials

### Security
- Prefer `--token-file` over inline tokens
- Environment variable: `OPENCLAW_GATEWAY_TOKEN`
- Shell processes set `OPENCLAW_SHELL=acp` for restricted execution
