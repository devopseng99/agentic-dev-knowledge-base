---
title: "A Practical Guide to Building AI Agents with Java and Spring AI - Part 2 - Add Memory"
url: "https://dev.to/yuriybezsonov/a-practical-guide-to-building-ai-agents-with-java-and-spring-ai-part-2-add-memory-odn"
author: "Yuriy Bezsonov"
category: "ai-agent-spring-boot-java"
---

# A Practical Guide to Building AI Agents with Java and Spring AI - Part 2 - Add Memory

**Author:** Yuriy Bezsonov
**Published:** November 11, 2025

## Overview

Demonstrates adding persistent three-tier memory to a Spring AI agent using PostgreSQL, enabling conversation continuity across sessions.

## Key Concepts

### Three-Tier Memory Architecture

- **Session Memory**: 20 recent messages (current conversation)
- **Context Memory**: 10 summarized conversations (historical)
- **Preferences Memory**: 1 user profile (static information)

All three tiers store data in PostgreSQL via JDBC.

### Dependencies

```xml
<dependency>
    <groupId>org.springframework.ai</groupId>
    <artifactId>spring-ai-starter-model-chat-memory-jdbc</artifactId>
</dependency>
<dependency>
    <groupId>org.postgresql</groupId>
    <artifactId>postgresql</artifactId>
    <scope>runtime</scope>
</dependency>
<dependency>
    <groupId>org.testcontainers</groupId>
    <artifactId>postgresql</artifactId>
    <scope>test</scope>
</dependency>
```

### ChatMemoryService

```java
@Service
public class ChatMemoryService {

    private final ChatMemory sessionMemory;
    private final ChatMemory contextMemory;
    private final ChatMemory preferencesMemory;

    public ChatMemoryService(JdbcChatMemoryRepository repository) {
        this.sessionMemory = MessageWindowChatMemory.builder()
            .chatMemoryRepository(repository)
            .maxMessages(20)
            .build();
        this.contextMemory = MessageWindowChatMemory.builder()
            .chatMemoryRepository(repository)
            .maxMessages(10)
            .build();
        this.preferencesMemory = MessageWindowChatMemory.builder()
            .chatMemoryRepository(repository)
            .maxMessages(1)
            .build();
    }

    public List<Message> loadContext(String userId) {
        List<Message> context = contextMemory.get(userId + "-context", 10);
        List<Message> prefs = preferencesMemory.get(userId + "-prefs", 1);
        List<Message> combined = new ArrayList<>();
        combined.addAll(prefs);
        combined.addAll(context);
        return combined;
    }
}
```

### ConversationSummaryService

```java
@Service
public class ConversationSummaryService {

    private final ChatClient chatClient;

    public String summarizeConversation(List<Message> messages) {
        String transcript = messages.stream()
            .map(m -> m.getMessageType() + ": " + m.getContent())
            .collect(Collectors.joining("\n"));

        return chatClient.prompt()
            .user("Summarize this conversation:\n" + transcript)
            .call()
            .content();
    }

    public String extractPreferences(List<Message> messages) {
        String transcript = messages.stream()
            .map(m -> m.getContent())
            .collect(Collectors.joining("\n"));

        return chatClient.prompt()
            .user("Extract user preferences from:\n" + transcript)
            .call()
            .content();
    }
}
```

### Testcontainers for Development

```java
@TestConfiguration(proxyBeanMethods = false)
public class TestAiAgentApplication {

    @Bean
    @ServiceConnection
    PostgreSQLContainer<?> postgresContainer() {
        return new PostgreSQLContainer<>("postgres:16-alpine")
            .withReuse(true);
    }
}
```

## Features
- Multi-user conversation isolation
- Automatic context injection from previous conversations
- AI-powered conversation summarization
- Production-ready persistence with easy migration to Amazon Aurora
