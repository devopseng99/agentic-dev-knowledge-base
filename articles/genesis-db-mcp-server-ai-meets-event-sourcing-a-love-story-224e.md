---
title: "Genesis DB MCP Server: AI meets Event Sourcing - a Love Story"
url: "https://dev.to/patriceckhart/genesis-db-mcp-server-ai-meets-event-sourcing-a-love-story-224e"
author: "Patric Eckhart"
category: "immutable-arch-rust-flink"
---
# Genesis DB MCP Server: AI meets Event Sourcing - a Love Story
**Author:** Patric Eckhart  **Published:** October 22, 2025

## Overview
The GenesisDB MCP Server bridges AI clients (like Claude) with event-sourced data systems. Enables AI assistants to query event history using natural conversation. Translates conversational queries into GenesisDB operations and returns results in real time.

## Key Concepts
- Model Context Protocol implementation for event-sourced databases
- Natural language queries against live GenesisDB instance: user counts, weekly order analytics, customer event histories, available event type discovery
- Preview release available on GitHub
- Enables AI models to query event-sourced data without schema knowledge

Use cases:
- "How many users signed up this week?"
- "Show me the event history for customer X"
- "What event types are available?"
