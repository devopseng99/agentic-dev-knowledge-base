---
title: "Can You Build AI Agents in Rust? Yep, and Here's How I Did it"
url: "https://dev.to/composiodev/can-you-build-ai-agents-in-rust-yep-and-heres-how-i-did-it-2b5i"
author: "Rohith Singh"
category: "rust-ai-agents"
---

# Can You Build AI Agents in Rust? Yep, and Here's How I Did it

**Author:** Rohith Singh
**Published:** August 19, 2025
**Organization:** Composio

## Overview

This article explores building a multi-agent system in Rust called **Codepilot**, which orchestrates specialized agents for GitHub, Linear, and Supabase tasks through MCP (Model Context Protocol) integration.

## Key Arguments

The author challenges the Python-dominated AI agent landscape by demonstrating Rust's viability. Three core benefits are highlighted:

1. **Performance**: "Zero-cost abstractions and memory safety mean your agent runs fast without eating resources"
2. **Type Safety**: Compile-time error detection prevents runtime failures
3. **Ecosystem Potential**: Rust's async/await model excels at managing multiple concurrent tools and APIs

## Architecture Overview

The system employs three core principles:

- **Specialized Agents**: Domain-expert agents (Linear, GitHub, Supabase) operate independently
- **MCP Integration**: Agents connect to Composio's authenticated API servers
- **Intelligent Orchestration**: Central coordinator routes queries to appropriate agents

## Dynamic Tool Discovery

A standout feature: agents automatically discover tools from MCP servers without hardcoding operations. The system fetches available tools and generates dynamic system prompts instructing the LLM which tools exist and how to use them.

## Tool Selection Mechanism

The approach uses LLM-based guidance rather than function calling:

1. LLM analyzes user queries and mentions specific tool names
2. System parses LLM response to extract tool selection
3. If no tools match, returns clear error listing available options

**Constraints ensure safety:**
- Single-loop execution (prevents tool chaining)
- Low temperature settings (focused responses)
- Explicit system prompts restricting tool usage to MCP-provided options

## Code Structure

```rust
pub struct MultiAgentOrchestrator {
    linear_agent: LinearAgent,
    github_agent: GitHubAgent,
    supabase_agent: SupabaseAgent,
}
```

Dependencies include `swarms-rs`, `tokio`, `reqwest`, and `ratatui` for terminal UI.

## Setup Steps

1. Create Rust project: `cargo new codepilot`
2. Configure MCP servers via Composio dashboard
3. Paste MCP URLs into `.env` file
4. Initialize agents with API keys and configuration

## Key Takeaway

"Rust isn't traditionally the go-to for AI workflows, but it's surprisingly effective at handling real-world agent logic once you move past initial obstacles." The project demonstrates feasibility as a weekend exploration rather than production-ready software. [Source code available](https://github.com/rohittcodes/codepilot).
