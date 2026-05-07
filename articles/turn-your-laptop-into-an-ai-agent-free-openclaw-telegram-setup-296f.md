---
title: "Turn Your Laptop Into an AI Agent (Free OpenClaw + Telegram Setup)"
url: "https://dev.to/javz/turn-your-laptop-into-an-ai-agent-free-openclaw-telegram-setup-296f"
author: "Julien Avezou"
category: "ai-agent-telegram-bot"
---

# Turn Your Laptop Into an AI Agent (Free OpenClaw + Telegram Setup)

**Author:** Julien Avezou
**Published:** April 13, 2026

## Overview
Tutorial for building a local AI agent using OpenClaw connected to Telegram, powered by Mistral running on Ollama. Runs entirely on a MacBook Pro in an Ubuntu VM with no cloud dependencies or API costs.

## Key Concepts

### System Requirements
- VM: 6GB RAM, 50GB disk
- Host: 6-8GB free RAM + 15GB disk space
- Model: Mistral 7B (~5GB in Ollama)

### OpenClaw Setup

```bash
sudo apt update && sudo apt upgrade -y
sudo apt install -y git curl build-essential

curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
export NVM_DIR="$HOME/.nvm"
. "$NVM_DIR/nvm.sh"
nvm install 22
nvm use 22

corepack enable
corepack prepare pnpm@latest --activate

git clone https://github.com/openclaw/openclaw.git
cd ~/openclaw

pnpm install
pnpm build
```

### Telegram Integration

Add the bot token to `~/.openclaw/openclaw.json`:

```json
"channels": {
  "telegram": {
    "enabled": true,
    "botToken": "INSERT_YOUR_BOT_TOKEN"
  }
}
```

### BookBot Agent Configuration

```bash
pnpm openclaw agents add bookbot
pnpm openclaw agents bind --agent bookbot --bind telegram
```

### Scheduling with Cron

```bash
pnpm openclaw cron add \
  --name "Daily reading reminder" \
  --cron "0 9 * * *" \
  --tz "America/Toronto" \
  --message "Daily reminder: ask BookBot for 3 new book recommendations." \
  --announce \
  --channel telegram \
  --to "INSERT_YOUR_CHAT_ID"
```

### Useful Commands

```bash
pnpm openclaw gateway start
pnpm openclaw gateway restart
pnpm openclaw agents add [name]
pnpm openclaw agents bind --agent [name] --bind [channel]
pnpm openclaw agents bindings
pnpm openclaw cron list
pnpm openclaw cron run [JOB_ID]
journalctl --user -u openclaw-gateway.service -f
pnpm openclaw doctor --fix
```

### Persistence

```bash
# macOS host - prevent sleep
caffeinate

# Ubuntu VM - disable sleep targets
sudo systemctl mask sleep.target suspend.target hibernate.target hybrid-sleep.target

# Use tmux for detached processes
tmux new -s openclaw
cd ~/openclaw
openclaw gateway start
# Press Ctrl+B, then D to detach
```
