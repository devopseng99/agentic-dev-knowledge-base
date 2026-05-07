---
title: "How to Build Your Own Local AI Agent: Setting Up OpenClaw with Ollama and Slack on Ubuntu"
url: "https://dev.to/taukirsheikh/how-to-build-your-own-local-ai-agent-setting-up-openclaw-with-ollama-and-slack-on-ubuntu-17bc"
author: "Mohammed Taukir Sheikh"
category: "ai-agent-slack-bot"
---

# How to Build Your Own Local AI Agent: Setting Up OpenClaw with Ollama and Slack on Ubuntu

**Author:** Mohammed Taukir Sheikh
**Published:** April 2, 2026

## Overview
Build a personal AI assistant that runs locally, respects privacy, costs $0 in subscriptions, and chats through Slack. Uses Ollama for local LLM inference and OpenClaw as the agent framework.

## Key Concepts

- Ollama runs AI models (Llama 3, Qwen) locally so data never leaves your machine
- OpenClaw acts as the agent layer connecting LLM to Slack
- Socket Mode means no public URLs required for Slack integration

## Code Examples

### Step 1: Install Ollama

```bash
curl -fsSL https://ollama.com | sh
ollama pull qwen2.5-coder:7b
```

### Step 2: Install OpenClaw

```bash
curl -fsSL https://openclaw.ai | bash
openclaw onboard --install-daemon
openclaw gateway start
```

### Step 3: Create Slack App
1. Visit Slack API Dashboard, create app "From Scratch"
2. Enable Socket Mode, generate xapp- token
3. Configure OAuth scopes: app_mentions:read, chat:write, im:history, im:read
4. Enable Event Subscriptions for app_mention and message.im

### Step 4: Connect All Components

```bash
openclaw config set channels.slack.enabled true
openclaw config set channels.slack.appToken "YOUR_XAPP_TOKEN"
openclaw config set channels.slack.botToken "YOUR_XOXB_TOKEN"

openclaw config set provider.type "ollama"
openclaw config set provider.model "qwen2.5-coder:7b"

openclaw gateway restart
openclaw pairing approve slack
```
