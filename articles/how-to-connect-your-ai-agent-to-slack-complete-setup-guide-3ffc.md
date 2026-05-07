---
title: "How to Connect Your AI Agent to Slack (Complete Setup Guide)"
url: "https://dev.to/hex_agent/how-to-connect-your-ai-agent-to-slack-complete-setup-guide-3ffc"
author: "Hex"
category: "ai-agents-integrations"
---

# How to Connect Your AI Agent to Slack (Complete Setup Guide)

**Author:** Hex
**Published:** March 29, 2026
**Original Source:** openclawplaybook.ai

## Overview

The article provides a comprehensive guide for integrating an AI agent (specifically OpenClaw) with Slack, enabling the agent to participate in direct messages, channels, and threads like a team member.

## Key Setup Steps

### Step 1: Create a Slack App
Navigate to api.slack.com/apps and select "From a manifest" to streamline app creation. The guide includes a complete JSON manifest with necessary scopes and configurations including chat permissions, file handling, and event subscriptions.

### Step 2: Obtain Required Tokens
- **Bot Token** (xoxb-...): Enables messaging and channel reading
- **App Token** (xapp-...): Establishes WebSocket connection for real-time events

### Step 3: Configure OpenClaw
Add Slack configuration to openclaw.json with tokens, or use environment variables (SLACK_APP_TOKEN, SLACK_BOT_TOKEN).

### Step 4: Launch the Gateway
Execute `openclaw gateway` to establish the connection.

## Connection Modes

**Socket Mode** (Recommended): Uses persistent WebSocket, requires no public URL, works behind firewalls. Ideal for local/home network deployments.

**HTTP Events API**: Alternative requiring publicly accessible webhook endpoint with SSL certificates and proper request URL configuration.

## Access Control Features

### DM Management
Four policy options:
- Pairing (default, requires approval)
- Allowlist (specified users only)
- Open (workspace-wide)
- Disabled (channels only)

### Channel Policies
Configure per-channel settings including:
- Mention requirements
- User restrictions
- Custom system prompts
- Skill limitations

## Advanced Features

- **Threading Support**: Isolates context per channel and thread
- **Native Streaming**: Token-by-token response display using Slack's AI API
- **Reaction Acknowledgments**: Visual feedback via emoji while processing
- **Multi-Account**: Run agent across multiple Slack workspaces simultaneously

## Troubleshooting Resources

The guide includes diagnostic commands: `openclaw channels status --probe`, `openclaw logs --follow`, and `openclaw doctor` for debugging connection issues.
