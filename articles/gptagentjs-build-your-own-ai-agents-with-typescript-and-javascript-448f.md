---
title: "GPTAgent.js: Build your own AI Agents with TypeScript and JavaScript!"
url: "https://dev.to/lgrammel/gptagentjs-build-your-own-ai-agents-with-typescript-and-javascript-448f"
author: "Lars Grammel"
category: "AI agent TypeScript"
---

# GPTAgent.js: Build your own AI Agents with TypeScript and JavaScript!

**Author:** Lars Grammel
**Published:** April 10, 2023

## Overview

Introduces GPTAgent.js, a composable and extensible framework for building AI agents using TypeScript and JavaScript. The framework was in early stages (v0.0.4) at time of writing.

## Key Concepts

### Use Cases

- **JavaScript/TypeScript Developer Agent** - Operates in Docker containers, can read/write files and execute commands, autonomously writes, runs, and fixes unit tests
- **Wikipedia Question-Answering Agent** - Searches Wikipedia and reads articles to provide factual answers

### Wikipedia QA Agent - Full Code Example

```javascript
import $, { ActionRegistry, Agent, runCLIAgent } from "@gptagent/agent";

const textGenerator = new $.ai.openai.Gpt4ChatTextGenerator({
  apiKey: process.env.OPENAI_API_KEY,
});

const searchWikipediaAction =
  new $.action.tool.ProgrammableGoogleSearchEngineAction({
    type: "tool.search-wikipedia",
    description:
      "Search wikipedia using a search term. Returns a list of pages.",
    executor: new $.action.tool.ProgrammableGoogleSearchEngineExecutor({
      key: process.env.WIKIPEDIA_SEARCH_KEY,
      cx: process.env.WIKIPEDIA_SEARCH_CX,
    }),
  });

const summarizeWebpageAction = new $.action.tool.SummarizeWebpageAction({
  type: "tool.read-wikipedia-article",
  description:
    "Read a wikipedia article and summarize it considering the query.",
  inputExample: {
    url: "https://en.wikipedia.org/wiki/Artificial_intelligence",
    topic: "{query that you are answering}",
  },
  executor: new $.action.tool.SummarizeWebpageExecutor({
    webpageTextExtractor:
      new $.component.webpageTextExtractor.BasicWebpageTextExtractor(),
    summarizer: new $.component.textSummarizer.SingleLevelSplitSummarizer({
      splitter: new $.component.splitter.RecursiveCharacterSplitter({
        maxCharactersByChunk: 4096 * 4,
      }),
      summarizer: new $.component.textSummarizer.ChatTextSummarizer({
        chatTextGenerator: textGenerator,
      }),
    }),
  }),
});

runCLIAgent({
  agent: new Agent({
    name: "Wikipedia QA",
    rootStep: new $.step.DynamicCompositeStep({
      nextStepGenerator: new $.step.BasicNextStepGenerator({
        role: `You are an knowledge worker that answers questions using Wikipedia content.`,
        constraints: `Make sure all facts for your answer are from Wikipedia articles that you have read.`,
        actionRegistry: new ActionRegistry({
          actions: [searchWikipediaAction, summarizeWebpageAction],
          format: new $.action.format.JsonActionFormat(),
        }),
        textGenerator,
      }),
    }),
  }),
});
```
