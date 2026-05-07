---
title: "Hermes Agent: A Self-Improving AI Agent That Runs Anywhere"
url: "https://dev.to/arshtechpro/hermes-agent-a-self-improving-ai-agent-that-runs-anywhere-2b7d"
author: "ArshTechPro"
category: "llm-agent-docker"
---

# Hermes Agent: A Self-Improving AI Agent That Runs Anywhere

**Author:** ArshTechPro
**Published:** March 30, 2026

## Overview
Hermes Agent is an MIT-licensed AI agent framework from Nous Research with persistent memory, reusable skills auto-created from completed tasks, and multi-provider LLM support. Runs on VPS, Docker, SSH, or serverless. Accessible via Telegram, Discord, Slack, WhatsApp, Signal, or terminal. ~8,700 GitHub stars.

## Key Concepts

### The Agent Loop
Central AIAgent class handles provider selection, prompt construction, tool execution, retries, compression, and persistence through synchronous orchestration.

### Skills System
Stored in `~/.hermes/skills/` with progressive disclosure:
- Level 0: Skill names and descriptions (~3,000 tokens)
- Level 1: Full skill content when needed
- Level 2: Specific reference files within skills

### Memory Management
Bounded MEMORY.md (2,200 chars) and USER.md (1,375 chars) with SQLite full-text search. Agent autonomously adds entries, replaces outdated info, consolidates when full. Security scanning prevents prompt injection.

### Terminal Backends
Six options: local, Docker, SSH, Daytona, Singularity, Modal. Docker and SSH provide sandboxing; Daytona and Modal offer serverless persistence.

## Code Examples

### Install

```bash
curl -fsSL https://raw.githubusercontent.com/NousResearch/hermes-agent/main/scripts/install.sh | bash
source ~/.bashrc
```

### Configure Provider

```bash
hermes model
```

### Start Chatting

```bash
hermes
```

### Sandboxed Execution

```bash
hermes config set terminal.backend docker    # Docker isolation
hermes config set terminal.backend ssh       # Remote server
```

### Messaging Gateway

```bash
hermes gateway setup    # Interactive configuration
hermes gateway start    # Start the gateway process
```

### MCP Server Configuration

```yaml
mcp_servers:
  github:
    command: npx
    args: ["-y", "@modelcontextprotocol/server-github"]
    env:
      GITHUB_PERSONAL_ACCESS_TOKEN: "ghp_xxx"
```

### Key Commands

```bash
hermes              # Start conversation
hermes -c           # Resume last session
hermes model        # Switch LLM provider
hermes tools        # Configure enabled tools
hermes doctor       # Diagnose issues
hermes update       # Update to latest version
hermes skills search <query>   # Find skills
```

### In-Conversation Commands

```bash
/model              # Switch models mid-conversation
/tools              # List available tools
/skills             # Browse and manage skills
/compress           # Compress context
```

### Development Setup

```bash
git clone https://github.com/NousResearch/hermes-agent.git
cd hermes-agent
git submodule update --init mini-swe-agent
curl -LsSf https://astral.sh/uv/install.sh | sh
uv venv .venv --python 3.11
source .venv/bin/activate
uv pip install -e ".[all,dev]"
python -m pytest tests/ -q
```
