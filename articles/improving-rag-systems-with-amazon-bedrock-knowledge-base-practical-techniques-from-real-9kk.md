---
title: "Improving RAG Systems with Amazon Bedrock Knowledge Base: Practical Techniques from Real Implementation"
url: "https://dev.to/aws-builders/improving-rag-systems-with-amazon-bedrock-knowledge-base-practical-techniques-from-real-9kk"
author: "Atsushi Suzuki"
category: "aws-agents"
---

# Improving RAG Systems with Amazon Bedrock Knowledge Base: Practical Techniques
**Author:** Atsushi Suzuki
**Published:** March 17, 2025

## Overview
Practical techniques for improving RAG suggestion accuracy with Bedrock Knowledge Base, including Foundation Models as Parser, search optimization, query decomposition, hybrid search, and dynamic prompt engineering. TypeScript examples throughout.

## Key Concepts

### Increase Search Results

```typescript
retrievalConfiguration: {
  vectorSearchConfiguration: {
    numberOfResults: 10, // Default 5 insufficient; 10 reduces failure rate
  }
}
```

### Query Decomposition

```typescript
orchestrationConfiguration: {
  queryTransformationConfiguration: {
    type: 'QUERY_DECOMPOSITION' as const
  }
}
```

Breaks "What's the difference between A and B?" into sub-queries. Adds ~5 seconds latency.

### Hybrid Search (Vector + Keyword)

```typescript
retrievalConfiguration: {
  vectorSearchConfiguration: {
    numberOfResults: 10,
    overrideSearchType: 'HYBRID' as const
  }
}
```

### Full RAG Configuration

```typescript
const ragConfig = {
  type: 'KNOWLEDGE_BASE' as const,
  knowledgeBaseConfiguration: {
    knowledgeBaseId: process.env.BEDROCK_KNOWLEDGE_BASE_ID,
    modelArn: process.env.BEDROCK_KNOWLEDGE_BASE_MODEL_ARN,
    orchestrationConfiguration: {
      queryTransformationConfiguration: { type: 'QUERY_DECOMPOSITION' as const }
    },
    retrievalConfiguration: {
      vectorSearchConfiguration: {
        numberOfResults: 10,
        overrideSearchType: 'HYBRID' as const
      }
    },
    generationConfiguration: {
      promptTemplate: { textPromptTemplate: systemPrompt },
      inferenceConfig: {
        textInferenceConfig: { maxTokens: 500, temperature: 0.2, topP: 0.5 }
      }
    }
  }
}
```

### Caveat
Custom prompt templates overwrite default `$output_format_instructions$`, removing citations from responses. Must choose between custom format and citation information.
