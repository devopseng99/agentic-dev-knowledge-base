---
title: "Building a Rust AI Agent Framework from Scratch -- What I Learned"
url: "https://dev.to/rajmandaliya/building-a-rust-ai-agent-framework-from-scratch-what-i-learned-3o23"
author: "RajMandaliya"
category: "rust-ai-agents"
---

# Building a Rust AI Agent Framework from Scratch -- What I Learned

**Author:** RajMandaliya
**Date Published:** March 6, 2026

---

## Overview

The author created mini-agent, a minimal async-first AI agent framework in Rust supporting OpenAI, Anthropic, OpenRouter, and Ollama. The project served as a practical exploration of Rust's capabilities in the AI tooling space.

## Key Architecture Components

The framework centers on three main abstractions:

**LlmProvider Trait**
```rust
#[async_trait]
pub trait LlmProvider: Send + Sync {
    fn provider_name(&self) -> &str;
    async fn complete(
        &self,
        messages: &[Message],
        tools: &[&dyn Tool],
        model: &str,
    ) -> Result<Completion, AgentError>;
}
```

**Tool Trait**
```rust
#[async_trait]
pub trait Tool: Send + Sync + 'static {
    fn name(&self) -> &'static str;
    fn description(&self) -> &'static str;
    fn parameters_schema(&self) -> Value;
    async fn execute(&self, args: Value) -> Result<String, AgentError>;
}
```

The agent implements a ReAct-style loop: plan -> act -> observe, repeating until reaching a final answer or step limit.

---

## Major Challenges & Solutions

### JSON Response Parsing Across Providers

Different LLM providers return incompatible JSON structures. OpenAI and OpenRouter share similar formats, allowing code reuse:

```rust
pub fn parse_openai_completion(json: &Value) -> Result<Completion, AgentError> {
    let choice = json
        .get("choices")
        .and_then(|v| v.as_array())
        .and_then(|a| a.first())
        .ok_or_else(|| AgentError::invalid("provider", "missing 'choices' array"))?;
    // ...
}
```

Anthropic required separate handling, using `tool_use` blocks within content arrays rather than dedicated tool_call fields.

### Error Handling Evolution

Initial approach used generic string-based errors:

```rust
#[error("Provider error: {0}")]
ProviderError(String),
```

This prevented meaningful pattern matching. The refined structure provides actionable information:

```rust
#[derive(Error, Debug)]
pub enum AgentError {
    #[error("Network error: {0}")]
    Network(#[from] reqwest::Error),

    #[error("Provider '{provider}' error{}: {message}",
        .status.map(|s| format!(" (HTTP {s})")).unwrap_or_default())]
    Provider {
        provider: String,
        message: String,
        status: Option<u16>,
    },
    // ...
}
```

This enabled helper methods like:

```rust
pub fn is_retryable(&self) -> bool {
    matches!(
        self,
        Self::Network(_) | Self::Provider { status: Some(500..=599), .. }
    )
}
```

---

## Rust-Specific Insights

**Borrow Checker Benefits:** Initially frustrating, the borrow checker prevented genuine bugs and naturally pushed toward better designs without explicit planning.

**Async Trait Limitations:** Async methods in traits aren't directly dyn-compatible. The `async-trait` crate macro works around this, though not zero-cost.

**Error Handling Excellence:** The `thiserror` crate dramatically simplified structured error handling through `#[from]` derives and format string syntax.

**Ownership Model Clarity:** The theoretical value of Rust's ownership system became viscerally clear while debugging async code.

---

## Usage Example

```rust
let mut agent = Agent::new(Box::new(provider), model);
agent.add_tool(AddNumbersTool);
let result = agent.run("What is 42 + 58?").await?;
```

---

## Resources

- **crates.io:** https://crates.io/crates/mini-agent
- **GitHub:** https://github.com/RajMandaliya/mini-agent

---

## Key Takeaways

The author emphasizes that "building something real" accelerates Rust learning more effectively than theoretical study. The language's type system and borrow checker, while demanding, naturally guide developers toward robust, maintainable solutions -- particularly valuable in systems-level and concurrent applications like AI agent frameworks.
