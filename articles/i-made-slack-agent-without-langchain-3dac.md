---
title: "I made slack agent without langchain"
url: "https://dev.to/kakasoo/i-made-slack-agent-without-langchain-3dac"
author: "Kyungsu Kang"
category: "ai-agent-slack-bot"
---

# I made slack agent without langchain

**Author:** Kyungsu Kang
**Published:** March 24, 2025

## Overview
Build AI-powered Slack bots using Agentica, a TypeScript-based framework that eliminates the need for LangChain. Leverages TypeScript's type system to simplify LLM function calls, and uses Slack threads as conversation storage to eliminate external database infrastructure.

## Key Concepts

### Agentica's Core Advantage
Developers write simple TypeScript classes while the framework handles backend complexities of LLM function calls, authentication, payload management, and response validation.

### Thread-Based Memory
Instead of relying on external databases, uses Slack threads as conversation storage, maintaining full context awareness with zero infrastructure overhead.

### Core Features
- Slack app creation and OAuth configuration
- Event subscription setup with URL verification
- Thread-based conversation history management
- Context-aware response generation
- Duplicate event prevention through lock mechanisms

### Repository
https://github.com/wrtnlabs/agentica.slack.bot
