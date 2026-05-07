---
title: "How to Build Agentic RAG in Rust"
url: "https://dev.to/skeptrune/how-to-build-agentic-rag-in-rust-44o0"
author: "Nick K"
category: "agentic-rag"
---

# How to Build Agentic RAG in Rust

**Author:** Nick K
**Published:** May 31, 2025

## Overview
Shows how to build agentic RAG in Rust where the LLM decides when to search via tools. The implementation gives the AI a search tool and a chunk selection tool, achieving 60% reduction in unnecessary searches and 40% faster responses.

## Key Concepts

### Two Main Tools
1. **Search tool:** "I need information about X"
2. **Chunk selection tool:** "I will use these specific documents"

The AI determines when it needs additional information before accessing the search tool, rather than searching indiscriminately.

## Code Examples

### API: Create a Chat Topic

```shell
curl -X POST "https://api.trieve.ai/api/topic" \
  -H "Authorization: Bearer YOUR_API_KEY" \
  -H "TR-Dataset: YOUR_DATASET_ID" \
  -H "Content-Type: application/json" \
  -d '{
    "owner_id": "user_123",
    "name": "My Chat Session"
  }'
```

### API: Send Message with Agentic Search

```shell
curl -X POST "https://api.trieve.ai/api/message" \
  -H "Authorization: Bearer YOUR_API_KEY" \
  -H "TR-Dataset: YOUR_DATASET_ID" \
  -H "Content-Type: application/json" \
  -d '{
    "topic_id": "TOPIC_ID_FROM_STEP_1",
    "new_message_content": "How do I configure authentication?",
    "use_agentic_search": true
  }'
```

### Rust: Setting Up the Conversation

```rust
let mut openai_messages: Vec<ChatMessage> = messages
    .iter()
    .map(|message| ChatMessage::from(message.clone()))
    .collect();

openai_messages.push(ChatMessage::User {
    content: ChatMessageContent::Text(user_message_query.clone()),
    name: None,
});
```

### Rust: Creating the Toolbox

```rust
let tools = vec![
    ChatCompletionTool {
        function: ChatCompletionFunction {
            name: "search".to_string(),
            description: "Search for relevant information in the knowledge base",
            parameters: json!({
                "type": "object",
                "properties": {
                    "query": {
                        "type": "string",
                        "description": "The search query to find relevant information"
                    }
                }
            }),
        },
    },
    ChatCompletionTool {
        function: ChatCompletionFunction {
            name: "chunks_used".to_string(),
            description: "Tell the user which chunks you plan to use",
            parameters: json!({
                "type": "object",
                "properties": {
                    "chunks": {
                        "type": "array",
                        "items": {"type": "string"}
                    }
                }
            }),
        },
    }
];
```

### Rust: Main Conversation Loop

```rust
loop {
    let response = client.chat().create(parameters.clone()).await?;
    conversation_messages.push(response.message.clone());

    if let Some(tool_calls) = response.tool_calls {
        for tool_call in tool_calls {
            match tool_call.function.name.as_str() {
                "search" => {
                    let (results, formatted_results) = handle_search_tool_call(
                        tool_call, dataset, pool, redis_pool, dataset_config, event_queue,
                    ).await?;
                    conversation_messages.push(ChatMessage::Tool {
                        content: formatted_results,
                        tool_call_id: tool_call.id,
                    });
                    searched_chunks.extend(results);
                }
                "chunks_used" => {
                    let chunks_to_use: Vec<String> = parse_chunks_used(&tool_call)?;
                    searched_chunks.retain(|chunk| {
                        chunks_to_use.contains(&chunk.id.to_string())
                    });
                }
                _ => {}
            }
        }
        continue;
    } else {
        break;
    }
}
```

### Rust: Real-Time Streaming with Tool Support

```rust
while let Some(response_chunk) = stream.next().await {
    match response_chunk {
        Ok(chunk) => {
            if let Some(content) = chunk.content {
                tx.send(content).await;
            }
            if chunk.finish_reason == Some("tool_calls") {
                tx.send("[Searching...]").await;
                handle_tool_calls(&chunk.tool_calls).await;
                continue;
            }
        }
        Err(e) => break,
    }
}
```

### Performance Results
- 60% reduction in unnecessary searches
- 40% faster responses on queries not requiring retrieval
- Higher accuracy from more relevant context
