---
title: "One OpenClaw Gateway Multiple Isolated AI Assistants"
url: "https://dev.to/onin/one-openclaw-gateway-multiple-isolated-ai-assistants-one-telegram-bot-per-worker-3k97"
author: "Nino"
category: "ai-agent-telegram-bot"
---

# One OpenClaw Gateway Multiple Isolated AI Assistants

**Author:** Nino
**Published:** February 22, 2026

## Overview
Running multiple isolated AI assistants on a single machine using OpenClaw and Telegram, each team member gets their own dedicated bot with complete isolation.

## Key Concepts

### Create Agents
```bash
openclaw agents add alice-sales
openclaw agents add bob-support
openclaw agents add carol-finance
```

### Configuration with Multiple Bots

```json
{
  "agents": {
    "list": [
      { "id": "alice-sales", "workspace": "~/.openclaw/agents/alice-sales" },
      { "id": "bob-support", "workspace": "~/.openclaw/agents/bob-support" },
      { "id": "carol-finance", "workspace": "~/.openclaw/agents/carol-finance" }
    ]
  },
  "bindings": [
    { "agentId": "alice-sales", "match": { "channel": "telegram", "accountId": "alice" } },
    { "agentId": "bob-support", "match": { "channel": "telegram", "accountId": "bob" } },
    { "agentId": "carol-finance", "match": { "channel": "telegram", "accountId": "carol" } }
  ],
  "channels": {
    "telegram": {
      "enabled": true,
      "accounts": {
        "alice": {
          "botToken": "7123456789:AAFxxxxxxxxxxxxxxxxxxxxxxxxxxxxx",
          "dmPolicy": "pairing"
        },
        "bob": {
          "botToken": "7987654321:AAFyyyyyyyyyyyyyyyyyyyyyyyyyyyyy",
          "dmPolicy": "pairing"
        },
        "carol": {
          "botToken": "7843210987:AAFzzzzzzzzzzzzzzzzzzzzzzzzzzzzz",
          "dmPolicy": "pairing"
        }
      }
    }
  }
}
```

### Restart and Verify

```bash
openclaw gateway restart
openclaw agents list --bindings
```

### Benefits
- Complete isolation: separate memory, files, tools, and history per agent
- Different models and permissions per person
- Agent inter-communication when needed
