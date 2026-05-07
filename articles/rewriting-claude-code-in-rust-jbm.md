---
title: "Rewriting Claude Code in Rust"
url: "https://dev.to/joshmo_dev/rewriting-claude-code-in-rust-jbm"
author: "Josh Mo"
category: "rust-go-java-agents"
---

# Rewriting Claude Code in Rust
**Author:** Josh Mo
**Published:** March 2, 2026

## Overview
Builds a minimal coding agent in Rust using Rig AI framework. Implements ReadFile, WriteFile, and Bash tools with the rig::tool::Tool trait. Features streaming responses, 60-second timeout warnings, 50KB output truncation, and token usage tracking.

## Key Concepts
- Three tools: ReadFile, WriteFile, Bash (with timeout + truncation)
- System prompt defines agent behavior and available tools
- Message history tracking for multi-turn conversations
- Stream processing handles text output, tool invocations, tool results
- Suggests production enhancements: cost calculations, context compaction, MCP integrations
