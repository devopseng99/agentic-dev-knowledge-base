---
title: "I Built an AI Agent Harness in Go"
url: "https://dev.to/lucasnevespereira/i-built-an-ai-agent-harness-in-go-51om"
author: "Lucas Neves Pereira"
category: "ai-agent-go-golang"
---

# I Built an AI Agent Harness in Go

**Author:** Lucas Neves Pereira
**Published:** April 2, 2026

## Overview
Nevinho is a personal AI agent accessible through Discord DMs that executes real-world tasks using an intelligent loop architecture. Built in Go (~4,700 lines, 21 files) with minimal dependencies (just discordgo and godotenv). Features multi-provider LLM support (Claude, GPT, Ollama), 7 tools, safety mechanisms, and context window management.

## Key Concepts

### Why Go
- Single binary deployment without runtime dependencies
- Sufficient standard library for HTTP, JSON, and process execution
- Explicit concurrency handling
- ~4,700 lines across 21 files with minimal external dependencies

### Core Agent Loop
The system calls the LLM provider up to 25 times. If the model requests tool usage, the harness executes those tools and feeds results back into the conversation until a final text response is produced.

### LLM Provider Abstraction
A unified Provider interface accommodates Claude, GPT, and local Ollama models. Anthropic uses single messages with tool_result blocks while OpenAI expects separate messages with a tool role.

### Context Window Management
- System prompts use ~1,000 tokens (vs common 12,000+)
- Tool outputs capped at 4KB
- Conversation history respects 30,000-token budget (not message counts)
- Automatic summary generation when older messages are removed
- Anthropic prompt caching for repeated prompt sections

### Tools (7 total)
- **web_search** -- Brave API with DuckDuckGo fallback
- **web_read** -- DOM-aware HTML text extraction
- **bash** -- Shell commands with 2-minute timeout
- **file_read/write/list/edit** -- Filesystem operations

### Safety Mechanisms
- Dangerous commands (rm, sudo, chmod, kill, piped curl) require user approval
- Sensitive paths (.ssh, .aws, .env) request confirmation
- URL validation prevents SSRF by blocking localhost and private IPs via DNS resolution
- Path approvals remembered for future operations; code approvals one-time only

### Discord Interface
- Single configured owner access
- Message splitting at newline boundaries for Discord's 2,000-character limit
- Immediate accessibility from mobile devices
