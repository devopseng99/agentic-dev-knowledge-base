---
title: "AI Agent Patterns with Spring AI"
url: "https://dev.to/lucasnscr/ai-agent-patterns-with-spring-ai-43gl"
author: "lucasnscr"
category: "ai-agent-spring-boot-java"
---

# AI Agent Patterns with Spring AI

**Author:** lucasnscr
**Published:** February 24, 2025

## Overview

Examines five design patterns for building AI-driven applications using Spring AI and Large Language Models, distinguishing between structured workflows and dynamic autonomous agents.

## Key Concepts

### Five Core Patterns

1. **Chain Workflow** - Sequential tasks where each output feeds into the next step
2. **Parallelization Workflow** - Simultaneous execution of independent tasks
3. **Routing Workflow** - Dynamic path selection based on input conditions
4. **Orchestrator-Workers** - Central coordinator delegating to specialized agents
5. **Evaluator-Optimizer** - Iterative quality assessment and refinement cycles

### News Retrieval System Implementation

```java
@Service
public class UserPreferencesService {

    private final UserPreferencesRepository repository;

    public List<String> getUserTopics(String userId) {
        return repository.findByUserId(userId)
            .stream()
            .map(UserPreference::getTopic)
            .collect(Collectors.toList());
    }
}
```

### Tool Calling with Spring AI

```java
@Service
public class GetNewsByUserPreferences {

    @Tool(description = "Fetch and analyze news based on user topic preferences")
    public String getNews(String userId) {
        List<String> topics = userPreferencesService.getUserTopics(userId);
        // Fetch news for each topic
        // Use AI to summarize and filter
        return summarizedNews;
    }
}
```

### News Orchestration Service

```java
@Service
public class NewsService {

    private final ChatClient chatClient;
    private final GetNewsByUserPreferences newsFunction;

    public NewsService(ChatClient.Builder builder, GetNewsByUserPreferences newsFunction) {
        this.chatClient = builder
            .defaultTools(newsFunction)
            .build();
    }

    public String getPersonalizedNews(String userId) {
        return chatClient.prompt()
            .user("Get the latest news for user: " + userId)
            .call()
            .content();
    }
}
```

### Technical Requirements
- Java 17+
- Spring Boot 3.x
- OpenAI API credentials
- Alpha Vantage API access
