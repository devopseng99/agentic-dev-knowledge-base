---
title: "Kowalski: The Rust-native Agentic AI Framework"
url: "https://dev.to/yarenty/kowalski-the-rust-native-agentic-ai-framework-53k4"
author: "Jaroslaw Nowosad"
category: "AI agent Rust"
---

# Kowalski: The Rust-native Agentic AI Framework

**Author:** Jaroslaw Nowosad
**Published:** June 30, 2025

## Overview
Kowalski v0.5.0 is a powerful, modular agentic AI framework built in Rust for local-first, extensible LLM workflows. It features dedicated crates (kowalski-core, kowalski-tools, agent-specific modules), a federation crate for multi-agent orchestration, and zero Python dependencies.

## Key Concepts

### Architecture
- Dedicated crates: kowalski-core, kowalski-tools, and agent-specific modules (academic, code, data, web)
- kowalski-federation crate enabling multi-agent orchestration
- Pluggable tools supporting CSV analysis, multi-language code analysis (Rust, Python, Java), web scraping, and PDF/document parsing

### Getting Started

```bash
git clone https://github.com/yarenty/kowalski.git
cd kowalski
cargo build --release
```

### Running Agents

```bash
ollama serve &
ollama pull llama3.2
./target/release/kowalski-cli chat "Hey Kowalski, what's up?"
./target/release/kowalski-code-agent --file src/main.rs
```

### Rust Embedding

```rust
use kowalski_core::{Config, BaseAgent};
let mut agent = BaseAgent::new(Config::default(), "Demo", "Agent v0.5.0").await?;
let conv = agent.start_conversation("llama3.2");
agent.add_message(&conv, "user", "Summarize this code module").await?;
```

### Why Kowalski Matters
- Full-stack Rust agentic workflows with zero Python dependencies
- Modular, self-documented design lowering contribution barriers
- Streamlined CLI experience across agents
- Federation support for future multi-agent workflows
