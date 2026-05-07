---
title: "Why Rig? 5 Compelling Reasons to Use Rig for Your Next LLM Project"
url: "https://dev.to/0thtachi/why-rig-5-compelling-reasons-to-use-rig-for-your-next-llm-project-23hl"
author: "Tachi 0x"
category: "rust-go-java-agents"
---

# Why Rig? 5 Compelling Reasons to Use Rig for Your Next LLM Project
**Author:** Tachi 0x
**Published:** September 5, 2024

## Overview
Five key features of Rig: unified API across providers, streamlined embeddings/vector stores, powerful RAG abstractions, efficient memory management with thread safety, and extensibility for custom implementations.

## Key Concepts

### Thread-Safe Concurrent Requests
```rust
let model = Arc::new(openai_client.model("gpt-3.5-turbo").build());
let mut handles = vec![];
for i in 0..10 {
    let model_clone = Arc::clone(&model);
    let handle = task::spawn(async move {
        let prompt = format!("Generate a random fact about the number {}", i);
        model_clone.prompt(&prompt).await
    });
    handles.push(handle);
}
```

### Custom Tool Implementation
```rust
impl Tool for Adder {
    const NAME: &'static str = "add";
    type Args = AddArgs;
    type Output = i32;
    async fn call(&self, args: Self::Args) -> Result<Self::Output, Self::Error> {
        Ok(args.x + args.y)
    }
}
```
