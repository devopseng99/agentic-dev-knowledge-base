---
title: "Building Multi-Agent Workflows using Mastra AI and Couchbase"
url: "https://dev.to/couchbase/building-multi-agent-workflows-using-mastra-ai-and-couchbase-198n"
author: "Shivay Lamba"
category: "agent-sdks"
---

# Building Multi-Agent Workflows using Mastra AI and Couchbase
**Author:** Shivay Lamba
**Published:** May 18, 2025

## Overview
Production-ready multi-agent RAG blog-writing assistant using Mastra AI with Couchbase Vector Search for document retrieval and content generation.

## Key Concepts

### Couchbase Vector Store Setup
```typescript
const couchbaseStore = new CouchbaseVector({
  connectionString: process.env.CB_CONNECTION_STRING,
  username: process.env.CB_USERNAME,
  password: process.env.CB_PASSWORD,
  bucket: process.env.CB_BUCKET,
  scope: process.env.CB_SCOPE,
  collection: process.env.CB_COLLECTION
});

await couchbaseStore.createIndex({
  indexName: "research_embeddings",
  dimension: 1536,
  similarity: "cosine"
});
```

### Research Agent with Vector Search
```typescript
const researchAgent = new Agent({
  name: 'Research Agent',
  instructions: `You are a research assistant that analyzes academic papers.`,
  model: openai('gpt-4o-mini'),
  tools: {
    vectorQueryTool: createVectorQueryTool({
      vectorStoreName: 'couchbaseStore',
      indexName: 'research_embeddings',
      model: openai.embedding('text-embedding-3-small'),
    }),
  },
});
```

### Writer Agent
```typescript
export const writerAgent = new Agent({
  name: "Writer Assistant",
  instructions: `You are a professional blog writer that creates engaging content.`,
  model: openai("gpt-4o-mini"),
});
```

### Workflow Orchestration
```typescript
const researchStep = new Step({
  id: "researchStep",
  execute: async ({ context }) => {
    const result = await researchAgent.generate(
      `Research information for a blog post about: ${context.triggerData.query}`
    );
    return { research: result.text };
  },
});

const writingStep = new Step({
  id: "writingStep",
  execute: async ({ context }) => {
    const research = context?.getStepResult<{ research: string }>("researchStep")?.research;
    const result = await writerAgent.generate(`Write a blog post using this research: ${research}`);
    return { blogPost: result.text, research };
  },
});

export const blogWorkflow = new Workflow({
  name: "blog-workflow",
  triggerSchema: z.object({
    query: z.string().describe("The topic to research and write about"),
  }),
});
blogWorkflow.step(researchStep).then(writingStep).commit();
```
