---
title: "Building a RAG System with Langchain, LangGraph, Tavily and LangSmith in TypeScript"
url: https://dev.to/vdrosatos/building-a-retrieval-augmented-generation-rag-system-with-langchain-langgraph-tavily-and-langsmith-in-typescript-mef
author: Vasilis Drosatos
category: rag
---

# Building a Retrieval-Augmented Generation (RAG) System with Langchain, LangGraph, Tavily and LangSmith in TypeScript

**Author:** Vasilis Drosatos
**Date Published:** August 26, 2024
**Tags:** #langchain #langgraph #ai #javascript

---

## Overview

This tutorial guides developers through creating a RAG system using TypeScript that combines retrieval-based and generative models. The system integrates Langchain, LangGraph, Tavily, and LangSmith for a complete workflow with debugging capabilities.

## Prerequisites

- Node.js installed
- Familiarity with embeddings, retrieval-based models, and Langchain
- API keys for OpenAI, Tavily, and LangSmith

## Installation

```bash
pnpm add langchain @langchain/core @langchain/langgraph @langchain/openai @langchain/community
pnpm add -D tsx dotenv @types/node
```

## System Architecture

The RAG system consists of five key components:

1. **Vector Store** - Uses MemoryVectorStore with OpenAI embeddings (text-embedding-3-small)
2. **Retrieval Node** - Fetches relevant documents from the vector store
3. **Web Search Node** - Uses Tavily API for internet searches
4. **Generation Node** - Creates responses using GPT-4o-mini
5. **LangSmith Integration** - Provides debugging and monitoring

## Key Code Examples

### Vector Store Setup

```typescript
import { OpenAIEmbeddings } from '@langchain/openai';
import { MemoryVectorStore } from 'langchain/vectorstores/memory';

const embeddings = new OpenAIEmbeddings({
  apiKey: process.env.OPENAI_API_KEY,
  model: 'text-embedding-3-small',
});

const vectorStore = new MemoryVectorStore(embeddings);
await vectorStore.addDocuments(documents);
```

### Graph State Definition

```typescript
import { Annotation } from '@langchain/langgraph';

const GraphState = Annotation.Root({
  documents: Annotation<DocumentInterface[]>({
    reducer: (x, y) => (y ? y.concat(x ?? []) : []),
  }),
  question: Annotation<string>({
    reducer: (x, y) => y ?? x ?? '',
  }),
  generation: Annotation<string>({
    reducer: (x, y) => y ?? x,
  }),
});
```

### Retrieval Node

```typescript
async function retrieve(
  state: typeof GraphState.State,
  config?: RunnableConfig
): Promise<Partial<typeof GraphState.State>> {
  const retriever = ScoreThresholdRetriever.fromVectorStore(vectorStore, {
    minSimilarityScore: 0.3,
    maxK: 1,
    kIncrement: 1,
  });

  const relatedDocuments = await retriever.invoke(state.question, config);
  return { documents: relatedDocuments };
}
```

### Web Search Node

```typescript
import { TavilySearchAPIRetriever } from '@langchain/community/retrievers/tavily_search_api';

async function webSearch(
  state: typeof GraphState.State,
  config?: RunnableConfig
): Promise<Partial<typeof GraphState.State>> {
  const retriever = new TavilySearchAPIRetriever({
    apiKey: process.env.TAVILY_API_KEY,
    k: 1,
  });

  const webDocuments = await retriever.invoke(state.question, config);
  return { documents: webDocuments };
}
```

### Generation Node

```typescript
async function generate(
  state: typeof GraphState.State,
  config?: RunnableConfig
): Promise<Partial<typeof GraphState.State>> {
  const model = new ChatOpenAI({
    apiKey: process.env.OPENAI_API_KEY,
    model: 'gpt-4o-mini',
    temperature: 0,
  });

  const prompt = await pull<ChatPromptTemplate>('rlm/rag-prompt');
  const ragChain = prompt.pipe(model).pipe(new StringOutputParser());

  const generation = await ragChain.invoke({
    context: formatDocumentsAsString(state.documents),
    question: state.question,
  }, config);

  return { generation };
}
```

### Graph Definition

```typescript
import { StateGraph, START, END } from '@langchain/langgraph';

const workflow = new StateGraph(GraphState)
  .addNode('retrieve', retrieve)
  .addNode('webSearch', webSearch)
  .addNode('generate', generate);

workflow.addEdge(START, 'retrieve');
workflow.addConditionalEdges(
  'retrieve',
  (state: typeof GraphState.State) =>
    state.documents.length === 0 ? 'webSearch' : 'generate',
  {
    webSearch: 'webSearch',
    generate: 'generate',
  }
);
workflow.addEdge('webSearch', 'generate');
workflow.addEdge('generate', END);

const app = workflow.compile();
```

## Environment Configuration

```env
OPENAI_API_KEY="your-key"
TAVILY_API_KEY="your-key"
LANGCHAIN_TRACING_V2=true
LANGCHAIN_API_KEY="your-key"
LANGCHAIN_PROJECT="langgraph-rag-demo"
LANGCHAIN_CALLBACKS_BACKGROUND=true
```

## Execution Flow

The graph follows a conditional workflow:

1. Start -> Retrieve documents from vector store
2. If documents found -> Generate response
3. If no documents -> Web search -> Generate response
4. End

## Testing

```bash
pnpm start "What is Langchain?"
pnpm start "What is the capital of Greece?"
```

## Key Takeaways

- RAG systems effectively combine retrieval and generation for context-aware responses
- Conditional edges enable dynamic workflow routing
- LangSmith provides valuable tracing and monitoring for production systems
- The system gracefully falls back to web search when local knowledge is insufficient

## Resources

- [GitHub Repository](https://github.com/astrocodelp/langgraph-rag-example)
- [Langchain Documentation](https://js.langchain.com/v0.2/docs/introduction/)
- [LangGraph Documentation](https://langchain-ai.github.io/langgraphjs/)
- [LangSmith Documentation](https://docs.smith.langchain.com/)
