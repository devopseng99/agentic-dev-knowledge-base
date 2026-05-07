---
title: "Building a Mobile AI Assistant with Kiro CLI and the Agent Client Protocol"
url: "https://dev.to/aws-builders/-building-a-mobile-ai-assistant-with-kiro-cli-and-the-agent-client-protocol-258d"
author: "Ajit"
category: "a2a-protocols"
---

# Building a Mobile AI Assistant with Kiro CLI and ACP
**Author:** Ajit
**Published:** March 24, 2026

## Overview
Extending Kiro CLI beyond the terminal to Telegram via ACP (Agent Client Protocol), a JSON-RPC 2.0 protocol over stdio.

## Key Concepts

### ACP Handshake

```javascript
const init = await request("initialize", {
  protocolVersion: 1,
  clientCapabilities: {
    fs: { readTextFile: true, writeTextFile: true },
    terminal: true,
  },
});

const session = await request("session/new", {
  cwd: "/path/to/workspace",
  mcpServers: [],
});
```

### Bidirectional Requests

```javascript
case "fs/readTextFile":
  return { content: fs.readFileSync(msg.params.path, "utf-8") };
case "terminal/execute":
  return { output: execSync(msg.params.command) };
```

### Streaming Responses

```javascript
acp.on("notification", (method, params) => {
  if (params.update?.sessionUpdate === "agent_message_chunk") {
    chunks.push(params.update.content.text);
  }
});
```

### Design Patterns
- Adapter Pattern: Channel logic isolated; core ACP client reusable
- Capability Negotiation: Forward-compatible protocol evolution
- Bidirectional RPC: Both client and server initiate requests
- ~200 lines of code for full mobile AI assistant
