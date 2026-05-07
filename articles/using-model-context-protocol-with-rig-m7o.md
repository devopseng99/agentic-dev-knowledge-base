---
title: "Using Model Context Protocol with Rig"
url: "https://dev.to/joshmo_dev/using-model-context-protocol-with-rig-m7o"
author: "Josh Mo"
category: "rust-go-java-agents"
---

# Using Model Context Protocol with Rig
**Author:** Josh Mo
**Published:** April 2, 2025

## Overview
Demonstrates MCP integration with Rig framework in Rust. Covers building MCP servers with the tool macro, creating SSE transport, and integrating MCP tools into Rig agents for standardized tool interaction.

## Key Concepts

```rust
#[tool(name = "Add", description = "Adds two numbers together.",
    params(a = "The first number", b = "The second number"))]
async fn add_tool(a: f64, b: f64) -> Result<ToolResponseContent> {
    Ok(tool_text_content!((a + b).to_string()))
}

// Agent integration
let agent_builder = tools_list_res.tools.into_iter().fold(agent_builder, |builder, tool| {
    builder.mcp_tool(tool, mcp_client.clone().into())
});
let agent = agent_builder.build();
let response = agent.prompt("Add 10 + 10").await?;
```
