---
title: "How to Control Claude Code from Telegram, Discord, or Slack (Self-Hosted, Open Source)"
url: "https://dev.to/tigergethigher/how-to-control-claude-code-from-telegram-discord-or-slack-self-hosted-open-source-1jk8"
author: "psychomafia.tiger"
category: "ai-agents-integrations"
---

# How to Control Claude Code from Telegram, Discord, or Slack

**Author:** psychomafia.tiger
**Date Published:** April 1, 2026

---

## Overview

OpenACP is a self-hosted, open-source bridge that connects AI coding agents (Claude Code, Gemini CLI, Codex) to messaging platforms (Telegram, Discord, Slack). The tool enables remote control and monitoring of AI agents from your phone or away from your desk.

## The Problem

AI coding agents assume you're physically at your terminal. When you step away, you lose visibility and control. The author experienced this when Claude Code got stuck on a permission prompt while they were at lunch, idling for 15+ minutes waiting for approval.

Existing workarounds—SSH/tmux sessions, VPN access, remote desktop—are fragile or slow. OpenACP solves this by enabling real-time agent monitoring and approval directly from messaging apps.

## Key Features

**Architecture:**
```
You (Telegram / Discord / Slack)
  |
OpenACP (bridge + session manager)
  |
AI Agent (Claude Code, Codex, Gemini CLI, ...)
  |
Your Codebase
```

**Core Capabilities:**
- Stream agent tool calls in real-time (file reads, writes, terminal commands, grep operations)
- Approve/deny agent actions via inline buttons on mobile
- Multiple simultaneous sessions with separate forum topics/threads
- Support for multiple agents and platforms from single installation
- Everything stays self-hosted—no cloud relay or third-party code access

## Getting Started

**Installation:**
```bash
npm install -g @openacp/cli
```

**Setup:**
```bash
openacp
```

The interactive wizard configures your platform choice, bot token, workspace directory, default agent, and daemon mode.

For Telegram, obtain a bot token from @botfather. The wizard validates credentials and auto-detects chat ID.

## Session Features

- Real-time streaming of agent operations
- Inline approval/denial buttons for permission prompts
- Optional token counting and cost tracking per session
- Monthly budget limits with automatic pausing
- Session handoff between terminal and mobile (`/openacp:handoff`)
- Tunnel support for exposing local ports (Cloudflare, ngrok, bore, Tailscale)

## Agent Support

OpenACP works with any agent supporting the Agent Client Protocol (ACP). Available agents include:

- Claude Code
- Gemini CLI
- GitHub Copilot
- Cline
- Cursor
- JetBrains Junie
- Codex CLI
- Qwen Code
- goose

Browse available agents: `openacp agents`

## Daemon Management

```bash
openacp start      # Run as background service
openacp stop       # Stop daemon
openacp status     # Check status
openacp logs       # View logs
openacp doctor     # Diagnose issues
```

## Comparison

**vs. claude-code-telegram:** Original tool is single-agent, Telegram-only, lacks multi-session support.

**vs. Claude Code Channels:** Anthropic's official cloud-based remote access feature; easier but not self-hosted.

## Resources

- **GitHub:** https://github.com/Open-ACP/OpenACP
- **Documentation:** https://openacp.gitbook.io/docs
- **ACP Registry:** https://agentclientprotocol.com/get-started/registry
- **License:** MIT

---

## Key Takeaways

1. OpenACP bridges the gap between stationary AI coding agents and mobile-first workflow management
2. Self-hosted architecture maintains code privacy and control
3. Real-time streaming with approval mechanisms prevents agents from getting stuck waiting for authorization
4. Multi-agent, multi-platform support from a single installation provides flexibility for diverse development teams
