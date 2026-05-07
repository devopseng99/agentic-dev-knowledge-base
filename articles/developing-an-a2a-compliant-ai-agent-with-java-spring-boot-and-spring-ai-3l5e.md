---
title: "Developing an A2A-compliant AI Agent with Java, Spring Boot and Spring AI"
url: "https://dev.to/bituan/developing-an-a2a-compliant-ai-agent-with-java-spring-boot-and-spring-ai-3l5e"
author: "Tobi Awanebi"
category: "ai-agent-spring-boot-java"
---

# Developing an A2A-compliant AI Agent with Java, Spring Boot and Spring AI

**Author:** Tobi Awanebi
**Published:** November 4, 2025

## Overview

Guide for building "Regexplain," an AI agent that explains regex patterns in human-friendly terms, using Java, Spring Boot, and Spring AI compliant with the A2A (Agent-to-Agent) protocol.

## Key Concepts

### A2A Protocol Structure

Requests follow JSON-RPC 2.0 standards:
```json
{
  "jsonrpc": "2.0",
  "method": "tasks/send",
  "id": "unique-id",
  "params": {
    "message": {
      "role": "user",
      "parts": [{"type": "text", "text": "Explain this regex: ^[a-zA-Z0-9]+$"}]
    }
  }
}
```

### Model Classes

```java
public record A2ARequest(
    String jsonrpc,
    String method,
    String id,
    RequestParamsProperty params
) {}

public record A2AResponse(
    String jsonrpc,
    String id,
    Result result
) {}

public record AgentCard(
    String name,
    String description,
    String url,
    String version,
    List<String> capabilities
) {}
```

### Service Layer

```java
@Service
public class RegExPlainService {

    private final ChatClient chatClient;

    public RegExPlainService(ChatClient.Builder builder) {
        this.chatClient = builder
            .defaultSystem("You explain regex patterns in plain English. " +
                "Be straightforward and avoid validation statements.")
            .build();
    }

    public String explain(String regex) {
        return chatClient.prompt()
            .user("Explain this regex: " + regex)
            .call()
            .content();
    }
}
```

### Controller Endpoints

```java
@RestController
public class AgentController {

    private final RegExPlainService service;

    @GetMapping("/.well-known/agent.json")
    public AgentCard getAgentCard() {
        return new AgentCard(
            "Regexplain",
            "An agent that explains regex patterns",
            "http://localhost:8080",
            "1.0.0",
            List.of("text")
        );
    }

    @PostMapping("/")
    public A2AResponse handleRequest(@RequestBody A2ARequest request) {
        try {
            String input = extractText(request);
            String explanation = service.explain(input);
            return buildResponse(request.id(), explanation);
        } catch (Exception e) {
            return buildErrorResponse(request.id(), e.getMessage());
        }
    }
}
```

### Configuration (application.properties)

```properties
spring.ai.openai.api-key=${GEMINI_API_KEY}
spring.ai.openai.base-url=https://generativelanguage.googleapis.com/v1beta/openai/
spring.ai.openai.chat.options.model=gemini-2.0-flash
```
