---
title: "Taking Payments with AI Agents and Rig using Stripe's MCP server"
url: "https://dev.to/joshmo_dev/taking-payments-with-ai-agents-and-rig-using-stripes-mcp-server-548d"
author: "Josh Mo"
category: "rust-go-java-agents"
---

# Taking Payments with AI Agents and Rig using Stripe's MCP server
**Author:** Josh Mo
**Published:** April 9, 2025

## Overview
CLI chatbot in Rust using Rig + Stripe MCP server. Shop assistant reads products/prices and creates payment links. Demonstrates MCP server connection via stdio, tool conversion to ToolSet, and agentic loop calling tools until text response.

## Key Concepts

```rust
async fn connect_to_stripe_mcp() -> Result<mcp_core::client::Client<ClientStdioTransport>, Box<dyn std::error::Error>> {
    let stripe_api_key = std::env::var("STRIPE_API_KEY").expect("STRIPE_API_KEY to exist");
    let client_transport = ClientStdioTransport::new("npx", &[
        "-y", "@stripe/mcp",
        "--tools=products.read,prices.read,paymentLinks.create",
        &format!("--api-key={stripe_api_key}"),
    ]).unwrap();
    let mcp_client = ClientBuilder::new(client_transport).build();
    mcp_client.open().await?;
    Ok(mcp_client)
}
```
