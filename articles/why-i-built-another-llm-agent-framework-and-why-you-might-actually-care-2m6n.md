---
title: "Helios-Engine: Why I Built Another LLM Agent Framework (And Why You Might Actually Care)"
url: "https://dev.to/ammar-alnagar/why-i-built-another-llm-agent-framework-and-why-you-might-actually-care-2m6n"
author: "Ammar"
category: "immutable-arch-rust-flink"
---
# Helios-Engine: Why I Built Another LLM Agent Framework (And Why You Might Actually Care)
**Author:** Ammar  **Published:** November 3, 2025

## Overview
helios-engine: Rust-based LLM agent framework addressing vendor lock-in, broken local model support, complex syntax, weak multi-agent capabilities, and Python performance overhead. Supports OpenAI, OpenAI-compatible APIs, and true local GGUF models via llama.cpp. First run downloads from HuggingFace; after that, fully offline.

## Key Concepts

Provider switching:
```rust
let client = LLMClient::new(LLMProviderType::OpenAI(config)).await?;
let client = LLMClient::new(LLMProviderType::Custom(config)).await?;
let client = LLMClient::new(LLMProviderType::Local(config)).await?;
```

Agent creation:
```rust
let agent = AgentBuilder::new()
    .name("Assistant")
    .goal("Help the user")
    .instruction("You are helpful and concise")
    .tool(calculator)
    .tool(web_search)
    .build()?;

agent.run("What's 147 * 923?").await?;
```

Tool registration:
```rust
async fn get_weather(location: String) -> Result<String> {
    // Implementation
}

let tool = Tool::new(
    "get_weather",
    "Gets current weather for a location",
    get_weather
);

agent.register_tool(tool);
```

Rust advantages: async runtime efficiency, compile-time error prevention, proper Result type error handling, zero-cost abstractions, feature-flag efficiency.

**Crate:** crates.io/crates/helios-engine  
**Source:** github.com/Ammar-Alnagar/Helios-Engine
