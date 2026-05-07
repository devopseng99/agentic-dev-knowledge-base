---
title: "I Built a Personal AI Assistant with a Telegram Bot Using OpenClaw"
url: "https://dev.to/btechnik/i-built-a-personal-ai-assistant-with-a-telegram-bot-using-openclaw-heres-how-2am3"
author: "Nikhil Bhan"
category: "ai-agent-telegram-bot"
---

# I Built a Personal AI Assistant with a Telegram Bot Using OpenClaw

**Author:** Nikhil Bhan
**Published:** April 3, 2026

## Overview
Creating a secured, autonomous AI assistant using OpenClaw integrated with Telegram and Claude Sonnet 4.5 model.

## Key Concepts

### Installation (Windows)

```powershell
iwr -useb https://openclaw.ai/install.ps1 | iex
openclaw gateway status
```

### Control UI
Runs at `http://127.0.0.1:18789` with `/status` command for monitoring token usage and API costs.

### Telegram Integration
1. Create bot via @BotFather
2. Add bot token through Control UI
3. Generate and approve pairing code
4. Restrict access using allowlists with Telegram User IDs

### Cron Job Automation
Schedule autonomous AI actions: "Set up a cron job that runs every 10 minutes and sends me a Telegram message with motivational quotes, fun facts, and trivia."
