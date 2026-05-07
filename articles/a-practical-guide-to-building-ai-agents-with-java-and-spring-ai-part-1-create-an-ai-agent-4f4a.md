---
title: "A Practical Guide to Building AI Agents With Java and Spring AI - Part 1 - Create an AI Agent"
url: "https://dev.to/yuriybezsonov/a-practical-guide-to-building-ai-agents-with-java-and-spring-ai-part-1-create-an-ai-agent-4f4a"
author: "Yuriy Bezsonov"
category: "ai-agent-spring-boot-java"
---

# A Practical Guide to Building AI Agents With Java and Spring AI - Part 1

**Author:** Yuriy Bezsonov
**Published:** November 4, 2025

## Overview

Tutorial demonstrating creation of an AI-powered Java application using Spring AI and Amazon Bedrock with Claude Sonnet, including streaming responses and a modern chat UI.

## Key Concepts

### Spring AI Features
- Unified API across different AI model providers
- Seamless Spring Boot integration
- Support for OpenAI, Azure, Bedrock, Ollama
- Built-in RAG, function calling, and chat memory support

### Configuration (application.yml)

```yaml
spring:
  ai:
    bedrock:
      converse:
        chat:
          options:
            model: us.anthropic.claude-sonnet-4-20250514-v1:0
            temperature: 0.7
            max-tokens: 2048
```

### ChatService

```java
@Service
public class ChatService {

    private final ChatClient chatClient;

    public ChatService(ChatClient.Builder chatClientBuilder) {
        this.chatClient = chatClientBuilder
                .defaultSystem("You are a helpful AI assistant.")
                .build();
    }

    public Flux<String> streamResponse(String prompt) {
        return chatClient.prompt()
                .user(prompt)
                .stream()
                .content();
    }
}
```

### ChatController

```java
@RestController
@RequestMapping("/api/chat")
public class ChatController {

    private final ChatService chatService;

    public ChatController(ChatService chatService) {
        this.chatService = chatService;
    }

    @PostMapping(produces = MediaType.TEXT_EVENT_STREAM_VALUE)
    public Flux<String> chat(@RequestBody ChatRequest request) {
        return chatService.streamResponse(request.prompt());
    }

    public record ChatRequest(String prompt) {}
}
```

### Dependencies (pom.xml)

```xml
<dependency>
    <groupId>org.springframework.ai</groupId>
    <artifactId>spring-ai-starter-model-bedrock-converse</artifactId>
</dependency>
```

### Prerequisites
- Java 21 JDK
- Maven 3.6+
- AWS CLI configured with Bedrock permissions

The tutorial includes complete HTML/JavaScript code for a modern chat UI with Tailwind CSS styling, dark mode support, and real-time message streaming.
