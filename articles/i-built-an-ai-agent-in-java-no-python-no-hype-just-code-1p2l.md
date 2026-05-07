---
title: "I Built an AI Agent in Java (No Python. No Hype. Just Code.)"
url: "https://dev.to/ashish_sharda_a540db2e50e/i-built-an-ai-agent-in-java-no-python-no-hype-just-code-1p2l"
author: "Ashish Sharda"
category: "ai-agent-spring-boot-java"
---

# I Built an AI Agent in Java (No Python. No Hype. Just Code.)

**Author:** Ashish Sharda
**Published:** May 3, 2026

## Overview

Builds a fully functional AI agent with tool use, RAG, and MCP support on the JVM using Spring Boot 3.5 and Spring AI 1.1.5. Demonstrates that Java is production-grade for AI without Python sidecars.

## Key Concepts

### Dependencies (pom.xml)

```xml
<dependencyManagement>
  <dependencies>
    <dependency>
      <groupId>org.springframework.ai</groupId>
      <artifactId>spring-ai-bom</artifactId>
      <version>1.1.5</version>
      <type>pom</type>
      <scope>import</scope>
    </dependency>
  </dependencies>
</dependencyManagement>

<dependencies>
  <dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-web</artifactId>
  </dependency>
  <dependency>
    <groupId>org.springframework.ai</groupId>
    <artifactId>spring-ai-starter-model-anthropic</artifactId>
  </dependency>
  <dependency>
    <groupId>org.springframework.ai</groupId>
    <artifactId>spring-ai-starter-mcp-client</artifactId>
  </dependency>
  <dependency>
    <groupId>org.springframework.ai</groupId>
    <artifactId>spring-ai-starter-vector-store-simple</artifactId>
  </dependency>
</dependencies>
```

### Configuration (application.yml)

```yaml
spring:
  ai:
    anthropic:
      api-key: ${ANTHROPIC_API_KEY}
      chat:
        options:
          model: claude-sonnet-4-20250514
    mcp:
      client:
        name: research-agent-client
        version: 1.0.0
        tool-callbacks-enabled: true
        streamable:
          http:
            connections:
              news-server:
                url: http://localhost:8090
```

### MCP Tool Server

```java
@SpringBootApplication
public class NewsToolServer {
    public static void main(String[] args) {
        SpringApplication.run(NewsToolServer.class, args);
    }
}

@Service
public class NewsSearchTool {
    @Tool(description = "Search for recent news articles on a given topic. " +
                         "Returns a list of relevant headlines and summaries.")
    public List<NewsResult> searchNews(
            @ToolParam(description = "The topic or keyword to search for") String topic,
            @ToolParam(description = "Max number of results to return") int maxResults) {
        return List.of(
            new NewsResult(
                "Java Sees Surge in AI Workloads in 2026",
                "Enterprise teams are increasingly choosing Java for AI..."
            ),
            new NewsResult(
                "Spring AI 1.1.5 Ships with Security Fixes",
                "JVM developers can now build AI agents without Python sidecars..."
            )
        ).stream().limit(maxResults).toList();
    }
}

public record NewsResult(String headline, String summary) {}
```

### Agent Configuration

```java
@Configuration
public class AgentConfig {
    @Bean
    public ChatClient researchAgent(
            ChatClient.Builder builder,
            ToolCallbackProvider mcpTools,
            VectorStore vectorStore) {
        return builder
            .defaultToolCallbacks(mcpTools)
            .defaultAdvisors(
                new QuestionAnswerAdvisor(vectorStore),
                new MessageChatMemoryAdvisor(new InMemoryChatMemory())
            )
            .defaultSystem("""
                You are a research assistant with access to real-time news tools
                and a curated knowledge base. Always cite your sources.
                When answering questions, first check your knowledge base,
                then use available tools to find current information.
                Be concise, accurate, and honest about what you don't know.
                """)
            .build();
    }
}
```

### REST Endpoint

```java
@RestController
@RequestMapping("/agent")
public class ResearchAgentController {
    private final ChatClient researchAgent;

    public ResearchAgentController(ChatClient researchAgent) {
        this.researchAgent = researchAgent;
    }

    @GetMapping("/ask")
    public AgentResponse ask(@RequestParam String question,
                             @RequestParam(defaultValue = "session-1") String sessionId) {
        String answer = researchAgent.prompt()
            .user(question)
            .advisors(advisor -> advisor.param(
                MessageChatMemoryAdvisor.CHAT_MEMORY_CONVERSATION_ID_KEY, sessionId))
            .call()
            .content();
        return new AgentResponse(question, answer);
    }

    @PostMapping("/knowledge")
    public void addKnowledge(@RequestBody KnowledgeRequest req,
                             VectorStore vectorStore) {
        vectorStore.add(List.of(
            new Document(req.content(), Map.of("source", req.source()))
        ));
    }

    public record AgentResponse(String question, String answer) {}
    public record KnowledgeRequest(String content, String source) {}
}
```

### Usage

```bash
# Seed knowledge
curl -X POST http://localhost:8080/agent/knowledge \
  -H "Content-Type: application/json" \
  -d '{"content": "Spring AI 1.1.5 supports 20+ AI model providers...", "source": "Spring AI release notes"}'

# Query the agent
curl "http://localhost:8080/agent/ask?question=What+AI+models+does+Spring+AI+support?"
```

### Provider Switching

Switching to GPT-4o requires only a Maven dependency swap and configuration change. The ChatClient code remains unchanged. Spring AI 1.1.5 supports 20+ providers including OpenAI, Anthropic, Ollama, Google Gemini, and Azure OpenAI.
