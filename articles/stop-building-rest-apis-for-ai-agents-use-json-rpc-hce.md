---
title: "Stop Building REST APIs for AI Agents (Use JSON-RPC)"
url: "https://dev.to/mihokoto/stop-building-rest-apis-for-ai-agents-use-json-rpc-hce"
author: "CallmeMiho"
category: "api-protocols"
---

# Stop Building REST APIs for AI Agents (Use JSON-RPC)

**Author:** CallmeMiho
**Published:** April 27, 2026
**Tags:** #webdev #ai #programming #architecture

---

## Article Summary

The author argues that AI agents should use JSON-RPC 2.0 instead of REST APIs because autonomous agents are action-oriented rather than resource-oriented. The traditional REST paradigm (using HTTP verbs and resource paths) doesn't align with how LLMs execute functions.

## Key Differences: JSON-RPC vs REST vs GraphQL

| Feature | JSON-RPC 2.0 | REST | GraphQL |
|---------|--------------|------|---------|
| **Paradigm** | Action-Oriented (Verbs) | Resource-Oriented (Nouns) | Query-Oriented (Graph) |
| **Overhead** | Extremely Lightweight | High (Headers/Paths) | Very High (AST Parsing) |
| **Ideal for AI** | Perfect (Maps to Tool Calling) | Usable but bloated | Too complex for agents |

## JSON-RPC 2.0 Request Structure

```json
{
  "jsonrpc": "2.0",
  "method": "check_inventory_stability",
  "params": {"sku": "AEC-990-2026", "warehouse_id": "NYC-01"},
  "id": "agent-session-42"
}
```

## Critical Issue: The Parsing Nightmare

The author identifies a major vulnerability: LLMs are probabilistic text generators that can produce malformed JSON (missing commas, unescaped quotes, wrapped in Markdown backticks). This crashes the agent's reasoning loop and wastes API tokens.

## Recommended Solution

Implement strict validation using Zod schemas to guarantee payload structure before sending requests to MCP servers. This prevents malformed JSON from reaching backend infrastructure and protects the agent's execution flow.

## Key Takeaway

The author contends that "in 2026, the oldest protocols are running the newest intelligence." Rather than forcing agents into complex REST architectures, developers should embrace JSON-RPC's simplicity and enforce structural validation at the architecture level.
