---
title: "Hermes agent: Introduction"
url: "https://dev.to/lkp/hermes-agent-introduction-c38"
author: "Phu"
category: "ai-agent-telegram-bot"
---

# Hermes agent: Introduction

**Author:** Phu
**Published:** April 26, 2026

## Overview
Introduction to Hermes Agent, an open-source AI agent by Nous Research that runs continuously on your server with long-term memory, learning capabilities, multi-platform chat integration, and browser automation under MIT license.

## Key Concepts

### Installation

```bash
curl -fsSL https://raw.githubusercontent.com/NousResearch/hermes-agent/main/scripts/install.sh | bash
source ~/.bashrc
```

### SOUL.md System Prompt
Located at `~/.hermes/SOUL.md`, standardizes AI behavior across sessions:

```plaintext
You are an expert in PHP
```

### Session Management
Extended conversations degrade model behavior. Create new sessions with `/new` command. Context windows (204.8k tokens) trigger compression when full.

### Gateway Setup for Telegram

```
hermes gateway setup
```

Configuration requires Telegram bot token from BotFather, user ID from @userinfobot, access mode selection, and deployment mode choice.
