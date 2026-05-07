---
title: "Build a Flight Search AI Agent with Rust using Rig: A Hands-On Practical Guide"
url: "https://dev.to/0thtachi/build-a-flight-search-ai-agent-with-rust-using-rig-a-hands-on-practical-guide-54dm"
author: "Tachi 0x"
category: "rust-go-java-agents"
---

# Build a Flight Search AI Agent with Rust using Rig: A Hands-On Practical Guide
**Author:** Tachi 0x
**Published:** September 24, 2024

## Overview
Step-by-step guide to building a Flight Search AI Assistant using Rust and the Rig library, covering agent/tool architecture, API integration with TripAdvisor via RapidAPI, and OpenAI-powered natural language interaction.

## Key Concepts

### Project Setup
```shell
cargo new flight_search_assistant
cd flight_search_assistant
```

```toml
[dependencies]
rig-core = "0.1.0"
tokio = { version = "1.34.0", features = ["full"] }
serde = { version = "1.0", features = ["derive"] }
serde_json = "1.0"
reqwest = { version = "0.11", features = ["json", "tls"] }
dotenv = "0.15"
thiserror = "1.0"
chrono = { version = "0.4", features = ["serde"] }
```

### Tool Definition
```rust
#[derive(Deserialize)]
pub struct FlightSearchArgs {
    source: String,
    destination: String,
    date: Option<String>,
}

pub struct FlightSearchTool;

impl Tool for FlightSearchTool {
    const NAME: &'static str = "search_flights";
    type Args = FlightSearchArgs;
    type Output = String;
    type Error = FlightSearchError;

    async fn definition(&self, _prompt: String) -> ToolDefinition {
        ToolDefinition {
            name: Self::NAME.to_string(),
            description: "Search for flights between two airports".to_string(),
            parameters: json!({
                "type": "object",
                "properties": {
                    "source": { "type": "string", "description": "Source airport code" },
                    "destination": { "type": "string", "description": "Destination airport code" },
                    "date": { "type": "string", "description": "Flight date YYYY-MM-DD" }
                },
                "required": ["source", "destination"]
            }),
        }
    }

    async fn call(&self, args: Self::Args) -> Result<Self::Output, Self::Error> {
        Ok("Flight search results".to_string())
    }
}
```

### Agent Creation
```rust
#[tokio::main]
async fn main() -> Result<(), Box<dyn Error>> {
    dotenv().ok();
    let openai_client = openai::Client::from_env();
    let agent = openai_client
        .agent("gpt-4")
        .preamble("You are a helpful assistant that can find flights for users.")
        .tool(FlightSearchTool)
        .build();
    let response = agent
        .prompt("Find me flights from SAT to ATL on November 15th 2024.")
        .await?;
    println!("Agent response:\n{}", response);
    Ok(())
}
```
