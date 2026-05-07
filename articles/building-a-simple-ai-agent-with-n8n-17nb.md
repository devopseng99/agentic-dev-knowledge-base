---
title: "Building a Simple AI Agent with n8n"
url: https://dev.to/jesulayomi/building-a-simple-ai-agent-with-n8n-17nb
author: Adetola Jesulayomi
category: n8n-agents
---

# Building a Simple AI Agent with n8n

**Author:** Adetola Jesulayomi
**Published:** April 24, 2025

## Overview

This article demonstrates how to create a no-code AI agent using n8n that retrieves Gmail messages and delivers them via Telegram. The workflow combines multiple integrations--Telegram, Gmail, and Anthropic Claude--into a functional automation without writing code.

## What You're Building

The workflow accomplishes three primary goals:

1. Trigger execution when a Telegram message arrives
2. Retrieve recent emails from Gmail inbox
3. Send email content back through Telegram

## Required Tools

- **n8n**: Workflow automation platform (drag-and-drop interface)
- **Gmail account**: Email source for retrieving messages
- **Telegram Bot**: Message delivery channel
- **Google OAuth2**: Secure Gmail authentication
- **Anthropic API**: Claude model for intelligent processing

## Step-by-Step Implementation

### Step 1: Telegram Trigger Setup

Create a new Telegram trigger node by:
- Accessing Telegram BotFather to generate a bot token
- Pasting credentials into the n8n trigger node
- Testing message reception to verify the connection

### Step 2: Switch Node for Routing

Implement conditional logic to evaluate incoming messages and route them appropriately based on defined rules.

### Step 3: Set Node for Data Formatting

Configure manual mapping to structure data flowing into subsequent steps, ensuring clean payload formatting.

### Step 4: AI Agent Node Configuration

Connect the AI Agent node with a system prompt instructing it to "read and get emails from your Gmail account tool." This directs Claude's behavior.

### Step 5: Anthropic Integration

Link the Claude chat model to handle message processing. The integration accepts Telegram input and generates contextual responses.

### Step 6: Gmail Message Retrieval

Configure the Gmail node with:
- OAuth credentials linking your account
- Resource type: "Message"
- Operation: "Get Many"
- Optional filters and message limits

### Step 7: Telegram Response Output

Complete the workflow by sending processed results back through Telegram's send message operation.

## Key Insight

"This might seem like a simple automation, but it actually demonstrates how powerful AI agents and n8n can be. Plus, you didn't need to write a single line of code."

The author provides supplementary video documentation available on YouTube for visual learners.
