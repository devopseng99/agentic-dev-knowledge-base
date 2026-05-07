---
title: "Agentic RAG: How AI Agents That Search, Reason, and Act Are Replacing Traditional Retrieval Pipelines"
url: "https://dev.to/pockit_tools/agentic-rag-how-ai-agents-that-search-reason-and-act-are-replacing-traditional-retrieval-2jn7"
author: "HK Lee"
category: "agentic-rag"
---

# Agentic RAG: How AI Agents That Search, Reason, and Act Are Replacing Traditional Retrieval Pipelines

**Author:** HK Lee
**Published:** March 20, 2026

## Overview
Deep technical guide on three agentic RAG architecture patterns (Router Agent, Iterative Retrieval Agent, Multi-Agent RAG) with full LangGraph/TypeScript implementations. Includes production considerations for latency, cost control, evaluation, guardrails, and observability.

## Key Concepts

Traditional RAG treats retrieval as a black-box preprocessing step. Agentic RAG makes the LLM the orchestrator of its own information gathering through iterative, multi-source research following a ReAct (Reason + Act) pattern.

### Why Traditional RAG Fails
1. Multi-Hop Questions requiring correlation across document sections
2. Comparative Analysis needing information from separate systems
3. Queries Requiring Computation beyond document retrieval
4. Ambiguous Queries requiring clarification or exploration

## Code Examples

### Pattern 1: Router Agent

```javascript
import { ChatOpenAI } from '@langchain/openai';
import { tool } from '@langchain/core/tools';
import { createReactAgent } from '@langchain/langgraph/prebuilt';
import { z } from 'zod';

const searchDocs = tool(
  async ({ query }) => {
    const results = await vectorStore.similaritySearch(query, 5);
    return results.map(r => r.pageContent).join('\n\n');
  },
  {
    name: 'search_documentation',
    description: 'Search internal documentation and knowledge base articles.',
    schema: z.object({ query: z.string().describe('Search query') }),
  }
);

const queryMetrics = tool(
  async ({ sql }) => {
    const result = await metricsDb.query(sql);
    return JSON.stringify(result.rows);
  },
  {
    name: 'query_metrics',
    description: 'Run SQL queries against the metrics database.',
    schema: z.object({ sql: z.string().describe('PostgreSQL query') }),
  }
);

const agent = createReactAgent({
  llm: new ChatOpenAI({ model: 'gpt-4o', temperature: 0 }),
  tools: [searchDocs, queryMetrics],
  messageModifier: `You are a helpful assistant with access to multiple data sources.
    Analyze each question carefully and use the most appropriate tool(s).`,
});
```

### Pattern 2: Iterative Retrieval Agent

```javascript
import { StateGraph, Annotation, END } from '@langchain/langgraph';
import { ChatOpenAI } from '@langchain/openai';

const AgentState = Annotation.Root({
  question: Annotation<string>,
  retrievedDocs: Annotation<string[]>({ reducer: (a, b) => [...a, ...b], default: () => [] }),
  searchQueries: Annotation<string[]>({ reducer: (a, b) => [...a, ...b], default: () => [] }),
  evaluation: Annotation<string>,
  finalAnswer: Annotation<string>,
  iterations: Annotation<number>({ reducer: (_, b) => b, default: () => 0 }),
});

async function planRetrieval(state) {
  const response = await llm.invoke([{
    role: 'system',
    content: `Analyze this question and generate 1-3 specific search queries.
    Return JSON: { "queries": ["query1", "query2"], "reasoning": "..." }`,
  }, {
    role: 'user',
    content: `Question: ${state.question}\n\nAlready retrieved:\n${state.retrievedDocs.join('\n---\n') || 'Nothing yet'}`,
  }]);
  const plan = JSON.parse(response.content);
  return { searchQueries: plan.queries };
}

function shouldContinue(state) {
  if (state.iterations >= 5) return 'synthesize';
  try {
    const eval_ = JSON.parse(state.evaluation);
    if (eval_.sufficient && eval_.confidence >= 70) return 'synthesize';
    return 'plan';
  } catch { return 'synthesize'; }
}

const graph = new StateGraph(AgentState)
  .addNode('plan', planRetrieval)
  .addNode('retrieve', retrieve)
  .addNode('evaluate', evaluate)
  .addNode('synthesize', synthesize)
  .addEdge('__start__', 'plan')
  .addEdge('plan', 'retrieve')
  .addEdge('retrieve', 'evaluate')
  .addConditionalEdges('evaluate', shouldContinue, {
    plan: 'plan',
    synthesize: 'synthesize',
  })
  .addEdge('synthesize', '__end__')
  .compile();
```

### Cost Control

```javascript
const MAX_INPUT_TOKENS = 50_000;
let totalInputTokens = 0;

async function trackedLlmCall(messages) {
  const tokenEstimate = messages.reduce(
    (sum, m) => sum + (typeof m.content === 'string' ? m.content.length / 4 : 0), 0
  );
  if (totalInputTokens + tokenEstimate > MAX_INPUT_TOKENS) {
    return { action: 'force_synthesize' };
  }
  const response = await llm.invoke(messages);
  totalInputTokens += response.usage?.input_tokens || 0;
  return response;
}
```

### Guardrails

```javascript
const querySql = tool(
  async ({ sql }) => {
    const forbidden = ['DROP', 'DELETE', 'UPDATE', 'INSERT', 'ALTER', 'TRUNCATE'];
    const upperSql = sql.toUpperCase();
    for (const keyword of forbidden) {
      if (upperSql.includes(keyword)) {
        return `Error: ${keyword} operations are not allowed.`;
      }
    }
    const safeSql = `${sql} LIMIT 1000`;
    const result = await db.query(safeSql, { timeout: 5000 });
    return JSON.stringify(result.rows);
  },
  {
    name: 'query_database',
    description: 'Run read-only SQL queries. Only SELECT statements allowed.',
    schema: z.object({ sql: z.string() }),
  }
);
```
