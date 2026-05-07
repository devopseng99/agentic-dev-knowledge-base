---
title: "Part 3 - Agents That Diagnose, Plan, and Query a Distributed Saga"
url: "https://dev.to/pedrop3/part-3-agents-that-diagnose-plan-and-query-a-distributed-saga-51e3"
author: "Pedro Santos"
category: "distributed-agent-decision"
---
# Part 3 - Agents That Diagnose, Plan, and Query a Distributed Saga
**Author:** Pedro Santos  **Published:** April 13, 2026

## Overview
Three distinct AI agents integrated into a distributed saga system — none functioning as chatbots. Open source at github.com/pedrop3/saga-orchestration.

## Key Concepts

### Agent 1: OperationsAgent (Auto-Diagnosis on Failure)
Trigger: Kafka consumer for failed sagas. RAG pipeline for pattern detection.

```java
@KafkaListener(topics = "${spring.kafka.topic.notify-ending}", groupId = "ai-agent-group")
public void onSagaEnded(String payload) {
    Event event = objectMapper.readValue(payload, Event.class);
    String historyText = buildHistoryText(event);
    vectorize(event, historyText);
    if (event.getStatus() == FAIL) diagnose(event, historyText);
}
```

RAG search for similar incidents:
```java
private String findSimilarIncidents(String historyText) {
    var queryEmbedding = embeddingModel.embed(historyText).content();
    var results = embeddingStore.search(EmbeddingSearchRequest.builder()
        .queryEmbedding(queryEmbedding).maxResults(3).minScore(0.75).build());
    return results.matches().stream()
        .map(m -> "--- Similar incident (score=" + String.format("%.2f", m.score()) + ") ---\n" + m.embedded().text())
        .collect(Collectors.joining("\n\n"));
}
```

Structured output format:
```java
public interface OperationsAgent {
    @SystemMessage("""
        ROOT CAUSE: <service and reason>
        AFFECTED SERVICES: <list>
        FINANCIAL IMPACT: <based on totalAmount>
        RECOMMENDATION: <corrective action>
        Rules: Only use provided context, never invent data.
        """)
    String analyze(@UserMessage String context);
}
```

### Agent 2: SagaComposerAgent (Dynamic Saga Planning)
Trigger: Scheduled every 60 seconds. Determines optimal execution order from failure patterns.

```java
@Scheduled(fixedDelayString = "${saga.composer.interval:60000}")
public void recomputePlans() {
    for (String profile : profiles) {
        String ragContext = findHistoricalPatterns(profile);
        String metrics = queryMetrics(dataAnalystAgent);
        String planJson = sagaComposerAgent.compose(buildCompositionPrompt(profile, metrics, ragContext));
        redis.opsForValue().set("saga-plan:" + profile, planJson, 35, MINUTES);
    }
}
```

```java
public interface SagaComposerAgent {
    @SystemMessage("""
        Respond ONLY with raw JSON. First character MUST be '{'.
        Rules:
        1. Place high-failure services earlier to fail fast.
        2. If INVENTORY failure rate > 30%, place before PAYMENT.
        3. Include FRAUD_VALIDATION for new + high-value orders.
        """)
    String compose(@UserMessage String profileContext);
}
```

### Agent 3: DataAnalystAgent (Natural Language Queries)
Trigger: HTTP GET requests to `/api/agent/chat?question=...`. 12+ MCP tools.

```java
public interface DataAnalystAgent {
    @SystemMessage("""
        Workflow for finding failed sagas:
        1. Extract N from the question, default to 5.
        2. Call listRecentEvents(limit = N + 10).
        3. Filter where status=FAIL, take only first N.
        4. For each failed saga: call getOrderById and getFraudRiskScore.
        5. Report only the N requested sagas.
        """)
    String analyze(@UserMessage String question);
}
```

### Key Lessons
1. MCP beats @Tool for microservices — decoupling alone worth it
2. SystemMessage-tool name alignment critical — mismatches cause silent failures
3. JSON responses more reliable than key=value for model parsing
4. Set `maxOutputTokens` to 4096, not 1024
5. Virtual threads eliminate sequential blocking for multiple MCP tool calls
6. "The AI layer should always be additive. Every piece of AI in my system has a fallback."
