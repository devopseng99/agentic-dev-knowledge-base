---
title: "Building an HR Team-Matching Agent With MongoDB Vector Search, Voyage AI, & Vercel AI SDK"
url: "https://dev.to/mongodb/building-an-hr-team-matching-agent-with-mongodb-vector-search-voyage-ai-vercel-ai-sdk-jgl"
author: "Pash10g"
category: "agent-sdks"
---

# Building an HR Team-Matching Agent With MongoDB Vector Search, Voyage AI, & Vercel AI SDK
**Author:** Pash10g
**Published:** April 22, 2025

## Overview
Combines Vercel AI SDK agentic capabilities with MongoDB Vector Search and Voyage AI embeddings to build an HR team-matching agent that semantically matches employee skills to project requirements.

## Key Concepts

### Embedding Generation
```typescript
import { voyage } from 'voyage-ai-provider';
import { embedMany } from 'ai';

const embeddingModel = voyage.textEmbeddingModel('voyage-3');

export const generateEmbeddings = async (
  value: string,
): Promise<Array<{ embedding: number[]; content: string }>> => {
  const chunks = value.split('\n');
  const { embeddings } = await embedMany({
    model: embeddingModel,
    values: chunks,
  });
  return embeddings.map((e, i) => ({ content: chunks[i], embedding: e }));
};
```

### MongoDB Vector Search Index
```json
{
  "fields": [
    {
      "type": "vector",
      "path": "embedding",
      "numDimensions": 1024,
      "similarity": "cosine"
    }
  ]
}
```

### HR Agent Tools
```typescript
import { tool } from 'ai';
import { z } from 'zod';

export const searchEmployeesBySkill = tool({
  description: 'Searches for employees with specific skills using semantic matching.',
  parameters: z.object({
    skillDescription: z.string(),
    minProficiency: z.number(),
    minAvailability: z.number()
  }),
  execute: async ({ skillDescription, minProficiency = 3, minAvailability = 20 }) => {
    const embeddingResults = await generateEmbeddings(skillDescription);
    const embedding = embeddingResults[0].embedding;
    const matchingEmployees = await employeesCollection.aggregate([
      {
        $vectorSearch: {
          index: "skills_vector_index",
          path: "embedding",
          queryVector: embedding,
          numCandidates: 100,
          limit: 20
        }
      },
      { $match: { "skills.proficiency": { $gte: minProficiency }, "availability": { $gte: minAvailability } } }
    ]).toArray();
    return matchingEmployees;
  },
});
```

### Main Agent with maxSteps
```typescript
import { openai } from '@ai-sdk/openai';
import { generateText } from 'ai';

const { steps, toolCalls } = await generateText({
  model: openai('o3-mini', { structuredOutputs: true }),
  tools: {
    analyzeProjectRequirements,
    searchEmployeesBySkill,
    analyzeTeamComposition,
    saveTeamToDatabase,
    generateTeamRecommendation,
  },
  toolChoice: 'auto',
  maxSteps: 15,
  system: `You are an expert HR assistant that builds optimal teams for projects.`,
  prompt: projectDescription,
});
```
