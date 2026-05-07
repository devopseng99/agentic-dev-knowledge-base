---
title: "RAG Made Serverless - Amazon Bedrock Knowledge Base with Spring AI"
url: "https://dev.to/yuriybezsonov/rag-made-serverless-amazon-bedrock-knowledge-base-with-spring-ai-2dn9"
author: "Yuriy Bezsonov"
category: "aws-agents"
---

# RAG Made Serverless - Amazon Bedrock Knowledge Base with Spring AI
**Author:** Yuriy Bezsonov
**Published:** January 27, 2026

## Overview
Building an AI assistant with proprietary data in under 40 lines of Java using Spring AI 2.0.0 M2 with Amazon Bedrock Knowledge Base. Fully managed RAG with no vector database to manage. Uses JBang for zero-config execution.

## Key Concepts

### Java Application (40 lines)

```java
///usr/bin/env jbang "$0" "$@" ; exit $?
//DEPS org.springframework.boot:spring-boot-starter-web:4.0.1
//DEPS org.springframework.ai:spring-ai-starter-model-bedrock-converse:2.0.0-M2
//DEPS org.springframework.ai:spring-ai-starter-vector-store-bedrock-knowledgebase:2.0.0-M2
//DEPS org.springframework.ai:spring-ai-advisors-vector-store:2.0.0-M2

package com.example;

import org.springframework.ai.chat.client.ChatClient;
import org.springframework.ai.chat.client.advisor.vectorstore.QuestionAnswerAdvisor;
import org.springframework.ai.vectorstore.VectorStore;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.web.bind.annotation.*;

@SpringBootApplication
@RestController
public class KbAgent {
    private final ChatClient chatClient;

    public KbAgent(ChatClient.Builder builder, VectorStore vectorStore) {
        this.chatClient = builder
                .defaultAdvisors(QuestionAnswerAdvisor.builder(vectorStore).build())
                .build();
    }

    @PostMapping("/chat")
    public String chat(@RequestBody String prompt) {
        return chatClient.prompt().user(prompt).call().content();
    }

    public static void main(String[] args) {
        SpringApplication.run(KbAgent.class, args);
    }
}
```

### Knowledge Base Setup

```bash
KB_ID=$(aws bedrock-agent create-knowledge-base --name kb-demo \
  --role-arn arn:aws:iam::${ACCOUNT_ID}:role/kb-demo-role \
  --knowledge-base-configuration '{"type":"VECTOR","vectorKnowledgeBaseConfiguration":{"embeddingModelArn":"arn:aws:bedrock:us-east-1::foundation-model/amazon.titan-embed-text-v2:0"}}' \
  --storage-configuration "{\"type\":\"S3_VECTORS\",\"s3VectorsConfiguration\":{\"vectorBucketArn\":\"arn:aws:s3vectors:us-east-1:${ACCOUNT_ID}:bucket/${VECTOR_BUCKET}\",\"indexName\":\"kb-demo-index\"}}" \
  --query 'knowledgeBase.knowledgeBaseId' --output text)
```

### Run and Test

```bash
SPRING_AI_VECTORSTORE_BEDROCK_KNOWLEDGE_BASE_KNOWLEDGE_BASE_ID=${KB_ID} jbang KbAgent.java

curl -s -X POST http://localhost:8080/chat -H "Content-Type: text/plain" \
  -d "What is the accommodation limit for Europe?"
```
