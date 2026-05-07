---
title: "I Built an AI Agent in Java (No Python. No Hype. Just Code.)"
url: "https://dev.to/ashish_sharda_a540db2e50e/i-built-an-ai-agent-in-java-no-python-no-hype-just-code-1p2l"
author: "Ashish Sharda"
category: "rust-go-java-agents"
---

# I Built an AI Agent in Java (No Python. No Hype. Just Code.)
**Author:** Ashish Sharda
**Published:** May 3, 2026

## Overview
Production AI agent with Spring Boot 3.5, Spring AI 1.1.5, Java 21, Claude Sonnet. Features MCP client/server, RAG via QuestionAnswerAdvisor, conversation memory, zero Python dependencies. Swappable providers (OpenAI, Ollama) via config only.

## Key Concepts

```java
@Bean
public ChatClient researchAgent(ChatClient.Builder builder, ToolCallbackProvider mcpTools, VectorStore vectorStore) {
    return builder
        .defaultToolCallbacks(mcpTools)
        .defaultAdvisors(
            new QuestionAnswerAdvisor(vectorStore),
            new MessageChatMemoryAdvisor(new InMemoryChatMemory()))
        .defaultSystem("You are a research assistant with access to real-time news tools and a curated knowledge base.")
        .build();
}

@Tool(description = "Search for recent news articles on a given topic.")
public List<NewsResult> searchNews(@ToolParam(description = "The topic to search for") String topic,
    @ToolParam(description = "Max results") int maxResults) {
    return List.of(new NewsResult("Java AI Adoption Surges", "Enterprise teams choosing Java..."));
}
```
