---
title: "What I Built: The Claude Code of Finance"
url: "https://dev.to/frqsalah/what-i-built-the-claude-code-of-finance-3794"
author: "Salah"
category: "hackathons"
---

# What I Built: The Claude Code of Finance
**Author:** Salah
**Published:** March 2, 2026

## Overview
FinAgent.NET is an autonomous financial research agent submitted to the Google Gemini Writing Challenge. Uses Microsoft Agent Framework and Google Gemini via Microsoft.Extensions.AI with a self-correction loop architecture.

## Key Concepts
- Microsoft Agent Framework for orchestration
- Google Gemini API via Microsoft.Extensions.AI (model-agnostic)
- Self-Correction Loop: AI creates plans, calls tools, reflects, iterates
- Single Agent State Machine outperformed three-agent system
- ChatHistory context management for reliability
- "Switching from cloud LLM to local Ollama became a configuration change, not a code rewrite"
- Gemini pushed for 'Group Chat' multi-agent design but single-loop was superior
- Future: SignalR real-time streaming, vector database for persistent memory
