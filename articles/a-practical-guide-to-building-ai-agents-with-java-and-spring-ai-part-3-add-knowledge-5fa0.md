---
title: "A Practical Guide to Building AI Agents with Java and Spring AI - Part 3 - Add Knowledge"
url: "https://dev.to/yuriybezsonov/a-practical-guide-to-building-ai-agents-with-java-and-spring-ai-part-3-add-knowledge-5fa0"
author: "Yuriy Bezsonov"
category: "rust-go-java-agents"
---

# Building AI Agents with Java and Spring AI - Part 3 - Add Knowledge
**Author:** Yuriy Bezsonov
**Published:** November 17, 2025

## Overview
Implements RAG with Spring AI using PGVector, Titan Embeddings, and QuestionAnswerAdvisor. Loads company policy documents into vector store, enabling accurate grounded responses instead of hallucinations.

## Key Concepts

```java
@Service
public class VectorStoreService {
    private final VectorStore vectorStore;
    public void addContent(String content) {
        vectorStore.add(List.of(new Document(content)));
    }
}
```

```java
this.chatClient = chatClientBuilder
    .defaultSystem(SYSTEM_PROMPT)
    .defaultAdvisors(QuestionAnswerAdvisor.builder(vectorStore).build())
    .build();
```

```bash
curl -X POST http://localhost:8080/api/admin/rag-load -H "Content-Type: text/plain" --data-binary @samples/policy-travel.md
curl -X POST http://localhost:8080/api/chat/message -d '{"prompt": "What is the hotel budget for France?", "userId": "alice"}'
# Returns: EUR130 per night (from loaded policy document)
```
