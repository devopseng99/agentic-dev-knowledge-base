---
title: "I Built an AI Agent Harness in Go"
url: "https://dev.to/lucasnevespereira/i-built-an-ai-agent-harness-in-go-51om"
author: "Lucas Neves Pereira"
category: "rust-go-java-agents"
---

# I Built an AI Agent Harness in Go
**Author:** Lucas Neves Pereira
**Published:** April 2, 2026

## Overview
nevinho: personal AI agent in Go via Discord DMs. Eight modular packages, only two external dependencies (discordgo, godotenv). Abstracts Claude/GPT/Ollama through unified interface. 7 tools (web search, bash, file ops), dangerous operation approval, 30K-token context budget with AI-generated eviction summaries.

## Key Concepts
- System prompt under 1,000 tokens (smaller than competitors)
- Tool outputs truncated at 4KB to prevent context bloat
- 25-iteration max agent loop with 5-minute timeout
- Safety: rm/sudo/chmod/kill require user approval
- SSRF prevention: reject localhost, private IPs, link-local
- ~4,700 lines across 21 files, single Go binary
