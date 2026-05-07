---
title: "Build a RAG System with Rig in Under 100 Lines of Code"
url: "https://dev.to/0thtachi/build-a-rag-system-with-rig-in-under-100-lines-of-code-4422"
author: "Tachi 0x"
category: "rust-go-java-agents"
---

# Build a RAG System with Rig in Under 100 Lines of Code
**Author:** Tachi 0x
**Published:** September 7, 2024

## Overview
Comprehensive guide to building a Retrieval-Augmented Generation system in Rust using the Rig library. Extracts text from PDFs, generates embeddings, and enables LLM-powered Q&A over document content.

## Key Concepts

```rust
#[derive(Embed, Clone, Debug, Serialize, Deserialize, Eq, PartialEq)]
struct Document {
    id: String,
    #[embed]
    content: String,
}

#[tokio::main]
async fn main() -> Result<()> {
    let openai_client = openai::Client::from_env();
    let model = openai_client.embedding_model(TEXT_EMBEDDING_ADA_002);
    let mut builder = EmbeddingsBuilder::new(model.clone());
    // Add documents, build embeddings
    let embeddings = builder.build().await?;
    let vector_store = InMemoryVectorStore::from_documents(embeddings);
    let index = vector_store.index(model);
    let rag_agent = openai_client
        .agent("gpt-4")
        .preamble("You are a helpful assistant that answers questions based on the provided document context.")
        .dynamic_context(4, index)
        .build();
    rig::cli_chatbot::cli_chatbot(rag_agent).await?;
    Ok(())
}
```
