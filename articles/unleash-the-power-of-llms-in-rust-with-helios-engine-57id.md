---
title: "Unleash the Power of LLMs in Rust with Helios Engine"
url: "https://dev.to/ammar-alnagar/unleash-the-power-of-llms-in-rust-with-helios-engine-57id"
author: "Ammar Alnagar"
category: "immutable-arch-rust-flink"
---
# Unleash the Power of LLMs in Rust with Helios Engine
**Author:** Ammar Alnagar  **Published:** 2025

## Overview
Helios Engine provides a powerful agent system in Rust where multiple agents can be created with unique personalities, capabilities, and contexts. Offers real token-by-token streaming for both remote and local models — watching the thinking process unfold in real-time. Supports OpenAI, OpenAI-compatible APIs (Groq, Together), and true local GGUF models through llama.cpp.

## Key Concepts
- Multi-agent architecture with distinct personalities, tools, and contexts
- Real-time token streaming for remote and local models
- Provider flexibility: OpenAI, custom endpoints, local GGUF via llama.cpp
- First run downloads model from HuggingFace; after that, fully offline
- Zero-cost abstractions via Rust's type system

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

**Crate:** crates.io/crates/helios-engine  
**Source:** github.com/Ammar-Alnagar/Helios-Engine
