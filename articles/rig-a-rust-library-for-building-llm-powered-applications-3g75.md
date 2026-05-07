---
title: "Rig: A Rust Library for Building LLM-Powered Applications"
url: "https://dev.to/0thtachi/rig-a-rust-library-for-building-llm-powered-applications-3g75"
author: "Tachi 0x"
category: "rust-go-java-agents"
---

# Rig: A Rust Library for Building LLM-Powered Applications
**Author:** Tachi 0x
**Published:** September 1, 2024

## Overview
Introduction to Rig, an open-source Rust library providing unified API across LLM providers, type-safe development, RAG system abstractions, and extensible architecture for AI applications.

## Key Concepts

```rust
use rig::{completion::Prompt, providers::openai};

#[tokio::main]
async fn main() -> Result<(), anyhow::Error> {
    let openai_client = openai::Client::from_env();
    let gpt4 = openai_client.model("gpt-4").build();
    let response = gpt4.prompt("Explain quantum computing in one sentence.").await?;
    println!("GPT-4: {}", response);
    Ok(())
}
```

### Type-Safe Extraction
```rust
#[derive(serde::Deserialize, JsonSchema)]
struct Person { name: String, age: u8 }

let extractor = openai_client.extractor::<Person>("gpt-4").build();
let person: Person = extractor.extract("John Doe is 30 years old").await?;
```
