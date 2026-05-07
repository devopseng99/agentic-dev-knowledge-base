---
title: "GCP in Action: Building a Persistent AI Assistant with GCE, Hermes Agent, and Telegram"
url: "https://dev.to/erikqin/gcp-in-action-building-a-persistent-ai-assistant-with-gce-hermes-agent-and-telegram-1h9f"
author: "erikqin"
category: "ai-agent-telegram-bot"
---

# GCP in Action: Building a Persistent AI Assistant with GCE, Hermes Agent, and Telegram

**Author:** erikqin
**Published:** May 3, 2026

## Overview
Building an always-on AI assistant using Google Compute Engine, the Hermes Agent framework, and Telegram. The key insight is deploying agents on persistent VMs rather than stateless API calls to maintain context across sessions.

## Key Concepts

### The Case for Persistence
Existing AI assistants suffer from ephemerality -- sessions lose context when they end. A persistent VM maintains static IPs, persistent storage, and automatic restart capabilities.

### Architecture Stack
1. **Google Compute Engine** - e2 instance with 2 vCPU and 4GB memory
2. **Hermes Agent Framework** - Middleware converting generic LLM calls into autonomous, tool-using agents
3. **Telegram** - Secure, free, developer-friendly bot API

### Implementation Steps
1. Spin up GCE VM (Debian/Ubuntu with static external IP, port 443 access)
2. Install Hermes Agent (git clone + pip install)
3. Define tools like `save_note` and `list_notes` registered with Hermes configuration
4. Hook in Telegram via webhook handler using FastAPI or Flask

### Cost Analysis
- e2-medium instance: ~$20-30/month
- Token costs: minimal
- Total: under $35/month for a custom AI assistant

### Design Philosophy
"We are moving from the 'AI as a service' model to the 'AI as a resident' model. Your assistant is no longer a guest in a cloud service; it is a neighbor on a virtual machine."
